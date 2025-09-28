package symlinks

import (
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

type platformConfig struct {
	BuildSubdir  string
	DestRelative string
	SourceGlob   string
	SymlinkExt   string
	SkipMessage  string
}

var platforms = map[string]platformConfig{
	"cursor": {
		BuildSubdir:  "cursor",
		DestRelative: ".cursor/rules",
		SourceGlob:   "*.mdc",
		SymlinkExt:   "mdc",
	},
	"windsurf": {
		BuildSubdir:  "windsurf",
		DestRelative: ".windsurf/rules",
		SourceGlob:   "*.mdc",
		SymlinkExt:   "md",
	},
	"qoder": {
		BuildSubdir:  "qoder",
		DestRelative: ".qoder/rules",
		SourceGlob:   "*.mdc",
		SymlinkExt:   "mdc",
	},
	"claude": {
		BuildSubdir: "claude",
		SkipMessage: "No symlink destination is defined for 'claude'. Skipping.",
	},
}

// Options controls symlink creation.
type Options struct {
	Platform   string
	RepoDir    string
	AIRulesDir string
	Stdout     io.Writer
	Stderr     io.Writer
}

// Create establishes symlinks for the requested platform within the target repository.
func Create(opts Options) error {
	if opts.Stdout == nil {
		opts.Stdout = os.Stdout
	}
	if opts.Stderr == nil {
		opts.Stderr = os.Stderr
	}
	if opts.RepoDir == "" {
		opts.RepoDir = "."
	}

	platformKey := strings.ToLower(strings.TrimSpace(opts.Platform))
	config, ok := platforms[platformKey]
	if !ok {
		return fmt.Errorf("unknown platform: %s", opts.Platform)
	}
	if config.SkipMessage != "" {
		fmt.Fprintln(opts.Stdout, config.SkipMessage)
		return nil
	}

	aiRulesDir := opts.AIRulesDir
	if aiRulesDir == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			return fmt.Errorf("determining home directory: %w", err)
		}
		aiRulesDir = filepath.Join(home, ".config", "ai-rules")
	}

	globalsDir := filepath.Join(aiRulesDir, "build", config.BuildSubdir)
	sourcePattern := filepath.Join(globalsDir, config.SourceGlob)

	matches, err := filepath.Glob(sourcePattern)
	if err != nil {
		return fmt.Errorf("finding built %s rules: %w", platformKey, err)
	}
	if len(matches) == 0 {
		return fmt.Errorf("no built %s rule files found in %s. Run 'builder build --platform %s' first", platformKey, globalsDir, platformKey)
	}

	destDir := filepath.Join(opts.RepoDir, config.DestRelative)
	if err := os.MkdirAll(destDir, 0o755); err != nil {
		return fmt.Errorf("creating destination directory %s: %w", destDir, err)
	}

	fmt.Fprintf(opts.Stdout, "Cleaning up existing global rule symlinks in %s...\n", destDir)
	if err := cleanupExisting(destDir, opts.Stdout); err != nil {
		return err
	}

	fmt.Fprintf(opts.Stdout, "Creating symlinks to global rules in %s...\n", destDir)
	for _, source := range matches {
		base := strings.TrimSuffix(filepath.Base(source), filepath.Ext(source))
		symlinkName := fmt.Sprintf("global_rule_%s.%s", base, config.SymlinkExt)
		symlinkPath := filepath.Join(destDir, symlinkName)
		fmt.Fprintf(opts.Stdout, "Creating symlink: %s -> %s\n", symlinkPath, source)
		if err := os.Symlink(source, symlinkPath); err != nil {
			return fmt.Errorf("creating symlink %s: %w", symlinkPath, err)
		}
	}

	fmt.Fprintf(opts.Stdout, "Done! Global rule symlinks created in %s\n", destDir)
	return nil
}

func cleanupExisting(destDir string, out io.Writer) error {
	entries, err := os.ReadDir(destDir)
	if err != nil {
		return fmt.Errorf("reading destination directory %s: %w", destDir, err)
	}

	for _, entry := range entries {
		name := entry.Name()
		if !strings.HasPrefix(name, "global_rule_") {
			continue
		}
		fullPath := filepath.Join(destDir, name)
		info, err := os.Lstat(fullPath)
		if err != nil {
			return fmt.Errorf("stat %s: %w", fullPath, err)
		}
		if info.Mode()&fs.ModeSymlink == 0 {
			continue
		}
		fmt.Fprintf(out, "Removing existing symlink: %s\n", name)
		if err := os.Remove(fullPath); err != nil {
			return fmt.Errorf("removing %s: %w", fullPath, err)
		}
	}

	return nil
}
