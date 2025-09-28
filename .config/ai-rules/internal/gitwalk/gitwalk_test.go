package gitwalk

import (
	"os"
	"path/filepath"
	"sort"
	"testing"
)

func TestFindRepositories(t *testing.T) {
	root := t.TempDir()

	repoOne := filepath.Join(root, "one", ".git")
	repoTwo := filepath.Join(root, "two", "nested", ".git")
	nonRepo := filepath.Join(root, "three")

	for _, dir := range []string{repoOne, repoTwo, nonRepo} {
		if err := os.MkdirAll(dir, 0o755); err != nil {
			t.Fatalf("creating %s: %v", dir, err)
		}
	}

	repos, err := FindRepositories(root)
	if err != nil {
		t.Fatalf("FindRepositories returned error: %v", err)
	}

	sort.Strings(repos)
	expected := []string{filepath.Join(root, "one"), filepath.Join(root, "two", "nested")}

	if len(repos) != len(expected) {
		t.Fatalf("expected %d repos, got %d", len(expected), len(repos))
	}
	for i, repo := range repos {
		if repo != expected[i] {
			t.Fatalf("expected repo %s, got %s", expected[i], repo)
		}
	}
}
