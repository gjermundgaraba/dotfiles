package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type SyncOptions struct {
	ConfigPath        string
	SkillsSourceDir   string
	CommandsSourceDir string
	AgentsSourceDir   string
}

func GetRootDir() string {
	// Get the executable path
	exe, err := os.Executable()
	if err != nil {
		// Fall back to home config dir
		home, _ := os.UserHomeDir()
		return filepath.Join(home, ".config", "ai-sync")
	}

	// Resolve symlinks to get the real path
	exe, err = filepath.EvalSymlinks(exe)
	if err != nil {
		home, _ := os.UserHomeDir()
		return filepath.Join(home, ".config", "ai-sync")
	}

	// If running via 'go run', the executable is in a temp dir
	// Check if we're in a typical go build cache location
	if strings.Contains(exe, "go-build") || strings.Contains(exe, "/tmp/") || strings.Contains(exe, "/var/") {
		// Development mode: use home config dir
		home, _ := os.UserHomeDir()
		return filepath.Join(home, ".config", "ai-sync")
	}

	// Get the directory containing the executable
	exeDir := filepath.Dir(exe)

	// Check if we're in cmd/sync (source location) or root (installed location)
	// If parent dir is "cmd", go two levels up; otherwise, we're in root
	if filepath.Base(filepath.Dir(exeDir)) == "cmd" {
		return filepath.Dir(filepath.Dir(exeDir))
	}

	// Binary is in the root directory
	return exeDir
}

func cleanupOrphanedSymlinks(items []string, targetDir, sourceDir, subPath, extension string) {
	itemsTargetDir := filepath.Join(targetDir, subPath)

	entries, err := os.ReadDir(itemsTargetDir)
	if err != nil {
		return // Directory doesn't exist, nothing to clean
	}

	itemSet := make(map[string]bool)
	for _, item := range items {
		itemSet[item] = true
	}

	for _, entry := range entries {
		entryPath := filepath.Join(itemsTargetDir, entry.Name())

		// Get file info without following symlinks
		info, err := os.Lstat(entryPath)
		if err != nil {
			continue
		}

		// Only process symlinks
		if info.Mode()&os.ModeSymlink == 0 {
			continue
		}

		// Check if this symlink points to our source directory
		linkTarget, err := os.Readlink(entryPath)
		if err != nil {
			continue
		}

		if !strings.HasPrefix(linkTarget, sourceDir) {
			continue
		}

		// For items with extensions, strip the extension to compare
		itemName := entry.Name()
		if extension != "" && strings.HasSuffix(itemName, extension) {
			itemName = strings.TrimSuffix(itemName, extension)
		}

		// Remove if item is no longer in the config
		if !itemSet[itemName] {
			os.Remove(entryPath)
			fmt.Printf("    [cleanup] %s (removed from config)\n", entry.Name())
		}
	}
}

func syncItemsForHarness(items []string, targetDir, sourceDir string, harness Harness, pathMap map[Harness]string, extension string, itemType string) error {
	itemsTargetDir := filepath.Join(targetDir, pathMap[harness])

	if err := os.MkdirAll(itemsTargetDir, 0755); err != nil {
		return fmt.Errorf("creating target directory: %w", err)
	}

	// Clean up orphaned symlinks
	cleanupOrphanedSymlinks(items, targetDir, sourceDir, pathMap[harness], extension)

	for _, item := range items {
		sourceName := item
		targetName := item
		if extension != "" {
			sourceName = item + extension
			targetName = item + extension
		}

		source := filepath.Join(sourceDir, sourceName)
		target := filepath.Join(itemsTargetDir, targetName)

		// Check if source exists
		if _, err := os.Stat(source); os.IsNotExist(err) {
			return fmt.Errorf("%s source not found: %s", itemType, source)
		}

		// Check if target already exists
		info, err := os.Lstat(target)
		if err == nil {
			// Target exists
			if info.Mode()&os.ModeSymlink != 0 {
				// It's a symlink, check if it points to the right place
				currentTarget, err := os.Readlink(target)
				if err == nil && currentTarget == source {
					fmt.Printf("    [skip] %s (already linked)\n", item)
					continue
				}
				// Points elsewhere, remove it
				os.Remove(target)
			} else {
				// Not a symlink, warn and skip
				fmt.Printf("    [warn] %s exists but is not a symlink, skipping\n", item)
				continue
			}
		}

		// Create the symlink
		if err := os.Symlink(source, target); err != nil {
			return fmt.Errorf("creating symlink for %s: %w", item, err)
		}
		fmt.Printf("    [link] %s\n", item)
	}

	return nil
}

func Sync(opts SyncOptions) error {
	rootDir := GetRootDir()

	// Set defaults
	if opts.SkillsSourceDir == "" {
		opts.SkillsSourceDir = filepath.Join(rootDir, "build", "skills")
	}
	if opts.CommandsSourceDir == "" {
		opts.CommandsSourceDir = filepath.Join(rootDir, "build", "commands")
	}
	if opts.AgentsSourceDir == "" {
		opts.AgentsSourceDir = filepath.Join(rootDir, "build", "agents")
	}
	if opts.ConfigPath == "" {
		opts.ConfigPath = filepath.Join(rootDir, "sync-config.yaml")
	}

	// Check config exists
	if _, err := os.Stat(opts.ConfigPath); os.IsNotExist(err) {
		return fmt.Errorf("config not found: %s\nRun 'ai-sync generate-example' to see an example configuration", opts.ConfigPath)
	}

	config, err := LoadConfig(opts.ConfigPath)
	if err != nil {
		return err
	}

	if len(config.Projects) == 0 {
		fmt.Println("No projects configured. Use 'add-project' to add one.")
		return nil
	}

	for _, project := range config.Projects {
		fmt.Printf("\nSyncing: %s\n", project.Path)

		// Check if project path exists
		if _, err := os.Stat(project.Path); os.IsNotExist(err) {
			fmt.Println("  [warn] Project path does not exist, skipping")
			continue
		}

		if err := ValidateHarnesses(project.Harnesses, project.Path); err != nil {
			return err
		}

		aiStuff := project.AiStuff
		hasSkills := aiStuff != nil && len(aiStuff.Skills) > 0
		hasCommands := aiStuff != nil && len(aiStuff.Commands) > 0
		hasCustomAgents := aiStuff != nil && len(aiStuff.CustomAgents) > 0

		if !hasSkills && !hasCommands && !hasCustomAgents {
			fmt.Println("  No skills, commands, or agents configured")
			continue
		}

		for _, harness := range project.Harnesses {
			fmt.Printf("  [%s]\n", harness)

			if hasSkills {
				if err := syncItemsForHarness(aiStuff.Skills, project.Path, opts.SkillsSourceDir, harness, HarnessSkillPaths, "", "Skill"); err != nil {
					return err
				}
			}

			if hasCommands {
				if err := syncItemsForHarness(aiStuff.Commands, project.Path, opts.CommandsSourceDir, harness, HarnessCommandPaths, ".md", "Command"); err != nil {
					return err
				}
			}

			if hasCustomAgents {
				if err := syncItemsForHarness(aiStuff.CustomAgents, project.Path, opts.AgentsSourceDir, harness, HarnessAgentPaths, ".md", "Agent"); err != nil {
					return err
				}
			}
		}
	}

	fmt.Println("\nDone")
	return nil
}
