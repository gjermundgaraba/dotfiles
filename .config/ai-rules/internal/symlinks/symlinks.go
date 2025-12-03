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
	BuildSubdir      string
	RulesDestRelative string
	RulesSourceGlob   string
	RulesSymlinkExt   string
	CommandsDestRelative string
	CommandsSourceGlob   string
	SkipMessage          string
}

var platforms = map[string]platformConfig{
	"cursor": {
		BuildSubdir:          "cursor",
		RulesDestRelative:    ".cursor/rules",
		RulesSourceGlob:      "*.mdc",
		RulesSymlinkExt:      "mdc",
		CommandsDestRelative: ".cursor/commands",
		CommandsSourceGlob:   "*.md",
	},
	"windsurf": {
		BuildSubdir:       "windsurf",
		RulesDestRelative: ".windsurf/rules",
		RulesSourceGlob:   "*.mdc",
		RulesSymlinkExt:   "md",
	},
	"qoder": {
		BuildSubdir:       "qoder",
		RulesDestRelative: ".qoder/rules",
		RulesSourceGlob:   "*.mdc",
		RulesSymlinkExt:   "mdc",
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

	if err := createRulesSymlinks(config, aiRulesDir, opts.RepoDir, platformKey, opts.Stdout); err != nil {
		return err
	}

	if config.CommandsDestRelative != "" {
		if err := createCommandsSymlinks(config, aiRulesDir, opts.RepoDir, platformKey, opts.Stdout); err != nil {
			return err
		}
	}

	return nil
}

func createRulesSymlinks(config platformConfig, aiRulesDir, repoDir, platformKey string, stdout io.Writer) error {
	rulesDir := filepath.Join(aiRulesDir, "build", config.BuildSubdir, "rules")
	sourcePattern := filepath.Join(rulesDir, config.RulesSourceGlob)

	matches, err := filepath.Glob(sourcePattern)
	if err != nil {
		return fmt.Errorf("finding built %s rules: %w", platformKey, err)
	}
	if len(matches) == 0 {
		return fmt.Errorf("no built %s rule files found in %s. Run 'ai-rules build --platform %s' first", platformKey, rulesDir, platformKey)
	}

	destDir := filepath.Join(repoDir, config.RulesDestRelative)
	if err := os.MkdirAll(destDir, 0o755); err != nil {
		return fmt.Errorf("creating destination directory %s: %w", destDir, err)
	}

	fmt.Fprintf(stdout, "Cleaning up existing ai-rules symlinks in %s...\n", destDir)
	if err := cleanupExisting(destDir, rulesDir, stdout); err != nil {
		return err
	}

	fmt.Fprintf(stdout, "Creating symlinks to global rules in %s...\n", destDir)
	for _, source := range matches {
		base := strings.TrimSuffix(filepath.Base(source), filepath.Ext(source))
		symlinkName := fmt.Sprintf("%s.%s", base, config.RulesSymlinkExt)
		symlinkPath := filepath.Join(destDir, symlinkName)
		fmt.Fprintf(stdout, "Creating symlink: %s -> %s\n", symlinkPath, source)
		if err := os.Symlink(source, symlinkPath); err != nil {
			return fmt.Errorf("creating symlink %s: %w", symlinkPath, err)
		}
	}

	fmt.Fprintf(stdout, "Done! Global rule symlinks created in %s\n", destDir)
	return nil
}

func createCommandsSymlinks(config platformConfig, aiRulesDir, repoDir, platformKey string, stdout io.Writer) error {
	commandsDir := filepath.Join(aiRulesDir, "build", config.BuildSubdir, "commands")
	sourcePattern := filepath.Join(commandsDir, config.CommandsSourceGlob)

	matches, err := filepath.Glob(sourcePattern)
	if err != nil {
		return fmt.Errorf("finding built %s commands: %w", platformKey, err)
	}
	if len(matches) == 0 {
		fmt.Fprintf(stdout, "No command files found in %s, skipping commands symlinks\n", commandsDir)
		return nil
	}

	destDir := filepath.Join(repoDir, config.CommandsDestRelative)
	if err := os.MkdirAll(destDir, 0o755); err != nil {
		return fmt.Errorf("creating commands destination directory %s: %w", destDir, err)
	}

	fmt.Fprintf(stdout, "Cleaning up existing ai-rules command symlinks in %s...\n", destDir)
	if err := cleanupExisting(destDir, commandsDir, stdout); err != nil {
		return err
	}

	fmt.Fprintf(stdout, "Creating symlinks to global commands in %s...\n", destDir)
	for _, source := range matches {
		symlinkName := filepath.Base(source)
		symlinkPath := filepath.Join(destDir, symlinkName)
		fmt.Fprintf(stdout, "Creating symlink: %s -> %s\n", symlinkPath, source)
		if err := os.Symlink(source, symlinkPath); err != nil {
			return fmt.Errorf("creating symlink %s: %w", symlinkPath, err)
		}
	}

	fmt.Fprintf(stdout, "Done! Global command symlinks created in %s\n", destDir)
	return nil
}

func cleanupExisting(destDir, sourceDir string, out io.Writer) error {
	entries, err := os.ReadDir(destDir)
	if err != nil {
		return fmt.Errorf("reading destination directory %s: %w", destDir, err)
	}

	for _, entry := range entries {
		name := entry.Name()
		fullPath := filepath.Join(destDir, name)
		info, err := os.Lstat(fullPath)
		if err != nil {
			return fmt.Errorf("stat %s: %w", fullPath, err)
		}
		if info.Mode()&fs.ModeSymlink == 0 {
			continue
		}
		target, err := os.Readlink(fullPath)
		if err != nil {
			return fmt.Errorf("readlink %s: %w", fullPath, err)
		}
		if !strings.HasPrefix(target, sourceDir+string(filepath.Separator)) && filepath.Dir(target) != sourceDir {
			continue
		}
		fmt.Fprintf(out, "Removing existing symlink: %s\n", name)
		if err := os.Remove(fullPath); err != nil {
			return fmt.Errorf("removing %s: %w", fullPath, err)
		}
	}

	return nil
}
