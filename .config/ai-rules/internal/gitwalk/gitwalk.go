package gitwalk

import (
	"fmt"
	"io/fs"
	"path/filepath"
)

// FindRepositories returns all git repositories under root by locating .git directories.
func FindRepositories(root string) ([]string, error) {
	repos := []string{}
	walkFn := func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() {
			return nil
		}
		if d.Name() == ".git" {
			repo := filepath.Dir(path)
			repos = append(repos, repo)
			return filepath.SkipDir
		}
		return nil
	}

	if err := filepath.WalkDir(root, walkFn); err != nil {
		return nil, fmt.Errorf("walking %s: %w", root, err)
	}
	return repos, nil
}
