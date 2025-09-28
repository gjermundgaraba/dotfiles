package rules

import (
	"bufio"
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"text/template"

	ruletmpl "github.com/gjermundgaraba/ai-rules/rules/templates"
	"gopkg.in/yaml.v3"
)

var supportedPlatforms = []string{"cursor", "windsurf", "qoder", "claude", "agents"}

var platformTemplateFiles = map[string]string{
	"cursor":   "cursor.mdc.tmpl",
	"windsurf": "windsurf.mdc.tmpl",
	"qoder":    "qoder.mdc.tmpl",
	"claude":   "claude.md.tmpl",
	"agents":   "agents.md.tmpl",
}

var templateFuncs = template.FuncMap{
	"quote": strconv.Quote,
}

// BuildOptions controls the rule build process.
type BuildOptions struct {
	ProjectDir string
	BuildDir   string
	Platforms  []string
	Stdout     io.Writer
	Stderr     io.Writer
}

// Build renders the rule templates for the requested platforms.
func Build(ctx context.Context, opts BuildOptions) error {
	if opts.ProjectDir == "" {
		opts.ProjectDir = "."
	}
	if opts.Stdout == nil {
		opts.Stdout = os.Stdout
	}
	if opts.Stderr == nil {
		opts.Stderr = os.Stderr
	}

	platforms, err := normalizePlatforms(opts.Platforms)
	if err != nil {
		return err
	}

	rulesDir := filepath.Join(opts.ProjectDir, "rules")
	ruleFiles, err := filepath.Glob(filepath.Join(rulesDir, "*.md"))
	if err != nil {
		return fmt.Errorf("locating rule files: %w", err)
	}
	sort.Strings(ruleFiles)

	rules := make([]*rule, 0, len(ruleFiles))
	for _, file := range ruleFiles {
		r, err := parseRule(file)
		if err != nil {
			return err
		}
		rules = append(rules, r)
	}

	buildDir := opts.BuildDir
	if buildDir == "" {
		buildDir = filepath.Join(opts.ProjectDir, "build")
	}

	for _, platform := range platforms {
		fmt.Fprintf(opts.Stdout, "Building %s rules...\n", platform)

		templateName, ok := platformTemplateFiles[platform]
		if !ok {
			return fmt.Errorf("no template defined for platform %s", platform)
		}

		tmpl, err := loadTemplate(templateName)
		if err != nil {
			return fmt.Errorf("loading template for %s: %w", platform, err)
		}

		platformDir := filepath.Join(buildDir, platform)
		if err := os.MkdirAll(platformDir, 0o755); err != nil {
			return fmt.Errorf("creating build directory %s: %w", platformDir, err)
		}

		for _, rule := range rules {
			if err := ctx.Err(); err != nil {
				return err
			}
			if err := buildRule(buildRuleParams{
				Platform: platform,
				Rule:     rule,
				Template: tmpl,
				BuildDir: platformDir,
				Stdout:   opts.Stdout,
				Stderr:   opts.Stderr,
			}); err != nil {
				return err
			}
		}
	}

	fmt.Fprintln(opts.Stdout, "Build complete!")
	return nil
}

type rule struct {
	Path string
	Name string
	Meta frontMatter
	Body []byte
}

type frontMatter struct {
	Description string `yaml:"description"`
	Type        string `yaml:"type"`
}

type buildRuleParams struct {
	Platform string
	Rule     *rule
	Template *template.Template
	BuildDir string
	Stdout   io.Writer
	Stderr   io.Writer
}

type templateData struct {
	Description string
	Trigger     string
	AlwaysApply string
	Body        string
}

func buildRule(params buildRuleParams) error {
	data := templateData{Body: string(params.Rule.Body)}

	switch params.Platform {
	case "cursor":
		data.Description = params.Rule.Meta.Description
		data.AlwaysApply = "true"
		if params.Rule.Meta.Type == "on-demand" {
			data.AlwaysApply = "false"
		}
		output := filepath.Join(params.BuildDir, params.Rule.Name+".mdc")
		return renderTemplate(params.Template, output, data)
	case "windsurf":
		data.Description = params.Rule.Meta.Description
		data.Trigger = "manual"
		if params.Rule.Meta.Type == "always-on" {
			data.Trigger = "always_on"
		}
		output := filepath.Join(params.BuildDir, params.Rule.Name+".mdc")
		return renderTemplate(params.Template, output, data)
	case "qoder":
		data.Description = params.Rule.Meta.Description
		data.Trigger = "manual"
		if params.Rule.Meta.Type == "always-on" {
			data.Trigger = "always_on"
			data.AlwaysApply = "true"
		} else {
			if data.Description == "" {
				data.AlwaysApply = "false"
			} else {
				data.Trigger = "model_decision"
			}
		}
		output := filepath.Join(params.BuildDir, params.Rule.Name+".mdc")
		return renderTemplate(params.Template, output, data)
	case "claude":
		if params.Rule.Meta.Type != "always-on" {
			return nil
		}
		output := filepath.Join(params.BuildDir, "claude.md")
		return renderTemplate(params.Template, output, data)
	case "agents":
		if params.Rule.Meta.Type != "always-on" {
			return nil
		}
		output := filepath.Join(params.BuildDir, "agents.md")
		return renderTemplate(params.Template, output, data)
	default:
		return fmt.Errorf("unsupported platform: %s", params.Platform)
	}
}

func renderTemplate(tmpl *template.Template, outputPath string, data templateData) error {
	if err := os.MkdirAll(filepath.Dir(outputPath), 0o755); err != nil {
		return fmt.Errorf("ensuring output directory: %w", err)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return fmt.Errorf("executing template %s: %w", tmpl.Name(), err)
	}

	if err := os.WriteFile(outputPath, buf.Bytes(), 0o644); err != nil {
		return fmt.Errorf("writing %s: %w", outputPath, err)
	}

	return nil
}

func loadTemplate(name string) (*template.Template, error) {
	data, err := ruletmpl.Files.ReadFile(name)
	if err != nil {
		return nil, fmt.Errorf("reading template %s: %w", name, err)
	}
	return template.New(name).Funcs(templateFuncs).Parse(string(data))
}

func normalizePlatforms(platforms []string) ([]string, error) {
	if len(platforms) == 0 {
		return append([]string(nil), supportedPlatforms...), nil
	}

	valid := make(map[string]struct{}, len(supportedPlatforms))
	for _, p := range supportedPlatforms {
		valid[p] = struct{}{}
	}

	normalized := make([]string, 0, len(platforms))
	seen := make(map[string]struct{}, len(platforms))
	for _, p := range platforms {
		p = strings.ToLower(strings.TrimSpace(p))
		if p == "all" {
			return append([]string(nil), supportedPlatforms...), nil
		}
		if _, ok := valid[p]; !ok {
			return nil, fmt.Errorf("unknown platform: %s", p)
		}
		if _, dup := seen[p]; dup {
			continue
		}
		seen[p] = struct{}{}
		normalized = append(normalized, p)
	}
	return normalized, nil
}

func parseRule(path string) (*rule, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("reading rule %s: %w", path, err)
	}

	reader := bufio.NewReader(bytes.NewReader(data))
	firstLine, err := reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("parsing rule %s: %w", path, err)
	}

	if strings.TrimSpace(firstLine) != "---" {
		return nil, fmt.Errorf("rule %s missing YAML frontmatter", path)
	}

	var frontBuffer bytes.Buffer
	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			if errors.Is(err, io.EOF) {
				return nil, fmt.Errorf("rule %s frontmatter not closed", path)
			}
			return nil, fmt.Errorf("parsing frontmatter in %s: %w", path, err)
		}
		if strings.TrimSpace(line) == "---" {
			break
		}
		frontBuffer.WriteString(line)
	}

	var front frontMatter
	if err := yaml.Unmarshal(frontBuffer.Bytes(), &front); err != nil {
		return nil, fmt.Errorf("parsing YAML frontmatter in %s: %w", path, err)
	}
	front.Type = strings.TrimSpace(front.Type)
	if front.Type == "" {
		front.Type = "unknown"
	}

	body, err := io.ReadAll(reader)
	if err != nil {
		return nil, fmt.Errorf("reading rule body in %s: %w", path, err)
	}

	name := strings.TrimSuffix(filepath.Base(path), filepath.Ext(path))

	return &rule{
		Path: path,
		Name: name,
		Meta: front,
		Body: body,
	}, nil
}
