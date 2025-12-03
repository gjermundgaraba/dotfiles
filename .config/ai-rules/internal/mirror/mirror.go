package mirror

import (
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
)

const (
	agentsFile    = "AGENTS.md"
	claudeFile    = "CLAUDE.md"
	claudeContent = "@AGENTS.md\n"
)

type Options struct {
	Root   string
	Stdout io.Writer
	Stderr io.Writer
}

func CreateClaudeMirrors(opts Options) error {
	agentsPaths, err := findAgentsFiles(opts.Root)
	if err != nil {
		return err
	}

	for _, agentsPath := range agentsPaths {
		claudePath := filepath.Join(filepath.Dir(agentsPath), claudeFile)
		if err := os.WriteFile(claudePath, []byte(claudeContent), 0644); err != nil {
			fmt.Fprintf(opts.Stderr, "  ❌ Error creating %s: %v\n", claudePath, err)
			continue
		}
		fmt.Fprintf(opts.Stdout, "  ✓ Created %s\n", claudePath)
	}

	return nil
}

func findAgentsFiles(root string) ([]string, error) {
	var paths []string
	walkFn := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}
		if d.Name() == agentsFile {
			paths = append(paths, path)
		}
		return nil
	}

	if err := filepath.WalkDir(root, walkFn); err != nil {
		return nil, fmt.Errorf("walking %s: %w", root, err)
	}
	return paths, nil
}

