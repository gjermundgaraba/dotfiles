package symlinks

import (
	"bytes"
	"os"
	"path/filepath"
	"runtime"
	"testing"
)

func TestCreateCursorSymlinks(t *testing.T) {
	if runtime.GOOS == "windows" {
		t.Skip("symlink creation differs on Windows")
	}

	temp := t.TempDir()
	aiRulesDir := filepath.Join(temp, "ai-rules")
	cursorDir := filepath.Join(aiRulesDir, "build", "cursor")
	if err := os.MkdirAll(cursorDir, 0o755); err != nil {
		t.Fatalf("creating cursor dir: %v", err)
	}

	source := filepath.Join(cursorDir, "alpha.mdc")
	if err := os.WriteFile(source, []byte("content"), 0o644); err != nil {
		t.Fatalf("writing source: %v", err)
	}

	repoDir := filepath.Join(temp, "repo")
	destDir := filepath.Join(repoDir, ".cursor", "rules")
	if err := os.MkdirAll(destDir, 0o755); err != nil {
		t.Fatalf("creating dest dir: %v", err)
	}

	stale := filepath.Join(destDir, "global_rule_stale.mdc")
	if err := os.Symlink(source, stale); err != nil {
		t.Fatalf("creating stale symlink: %v", err)
	}

	var stdout bytes.Buffer
	if err := Create(Options{
		Platform:   "cursor",
		RepoDir:    repoDir,
		AIRulesDir: aiRulesDir,
		Stdout:     &stdout,
	}); err != nil {
		t.Fatalf("Create returned error: %v", err)
	}

	if _, err := os.Lstat(stale); !os.IsNotExist(err) {
		t.Fatalf("expected stale symlink removed, got err=%v", err)
	}

	expectedSymlink := filepath.Join(destDir, "global_rule_alpha.mdc")
	target, err := os.Readlink(expectedSymlink)
	if err != nil {
		t.Fatalf("reading symlink: %v", err)
	}
	if target != source {
		t.Fatalf("expected symlink target %s, got %s", source, target)
	}
}

func TestCreateRejectsUnknownPlatform(t *testing.T) {
	if err := Create(Options{Platform: "unknown", RepoDir: t.TempDir()}); err == nil {
		t.Fatalf("expected error for unknown platform")
	}
}
