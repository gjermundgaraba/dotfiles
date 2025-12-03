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
	cursorRulesDir := filepath.Join(aiRulesDir, "build", "cursor", "rules")
	if err := os.MkdirAll(cursorRulesDir, 0o755); err != nil {
		t.Fatalf("creating cursor rules dir: %v", err)
	}

	source := filepath.Join(cursorRulesDir, "alpha.mdc")
	if err := os.WriteFile(source, []byte("content"), 0o644); err != nil {
		t.Fatalf("writing source: %v", err)
	}

	staleSource := filepath.Join(cursorRulesDir, "stale.mdc")
	if err := os.WriteFile(staleSource, []byte("stale"), 0o644); err != nil {
		t.Fatalf("writing stale source: %v", err)
	}

	repoDir := filepath.Join(temp, "repo")
	destDir := filepath.Join(repoDir, ".cursor", "rules")
	if err := os.MkdirAll(destDir, 0o755); err != nil {
		t.Fatalf("creating dest dir: %v", err)
	}

	stale := filepath.Join(destDir, "stale.mdc")
	if err := os.Symlink(staleSource, stale); err != nil {
		t.Fatalf("creating stale symlink: %v", err)
	}
	if err := os.Remove(staleSource); err != nil {
		t.Fatalf("removing stale source: %v", err)
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

	expectedSymlink := filepath.Join(destDir, "alpha.mdc")
	target, err := os.Readlink(expectedSymlink)
	if err != nil {
		t.Fatalf("reading symlink: %v", err)
	}
	if target != source {
		t.Fatalf("expected symlink target %s, got %s", source, target)
	}
}

func TestCreateCursorCommandsSymlinks(t *testing.T) {
	if runtime.GOOS == "windows" {
		t.Skip("symlink creation differs on Windows")
	}

	temp := t.TempDir()
	aiRulesDir := filepath.Join(temp, "ai-rules")
	cursorRulesDir := filepath.Join(aiRulesDir, "build", "cursor", "rules")
	cursorCommandsDir := filepath.Join(aiRulesDir, "build", "cursor", "commands")
	if err := os.MkdirAll(cursorRulesDir, 0o755); err != nil {
		t.Fatalf("creating cursor rules dir: %v", err)
	}
	if err := os.MkdirAll(cursorCommandsDir, 0o755); err != nil {
		t.Fatalf("creating cursor commands dir: %v", err)
	}

	ruleSource := filepath.Join(cursorRulesDir, "engineering.mdc")
	if err := os.WriteFile(ruleSource, []byte("rule content"), 0o644); err != nil {
		t.Fatalf("writing rule source: %v", err)
	}

	commandSource := filepath.Join(cursorCommandsDir, "init.md")
	if err := os.WriteFile(commandSource, []byte("command content"), 0o644); err != nil {
		t.Fatalf("writing command source: %v", err)
	}

	staleCommandSource := filepath.Join(cursorCommandsDir, "stale.md")
	if err := os.WriteFile(staleCommandSource, []byte("stale command"), 0o644); err != nil {
		t.Fatalf("writing stale command source: %v", err)
	}

	repoDir := filepath.Join(temp, "repo")
	rulesDestDir := filepath.Join(repoDir, ".cursor", "rules")
	commandsDestDir := filepath.Join(repoDir, ".cursor", "commands")
	if err := os.MkdirAll(rulesDestDir, 0o755); err != nil {
		t.Fatalf("creating rules dest dir: %v", err)
	}

	staleCommand := filepath.Join(commandsDestDir, "stale.md")
	if err := os.MkdirAll(commandsDestDir, 0o755); err != nil {
		t.Fatalf("creating commands dest dir: %v", err)
	}
	if err := os.Symlink(staleCommandSource, staleCommand); err != nil {
		t.Fatalf("creating stale command symlink: %v", err)
	}
	if err := os.Remove(staleCommandSource); err != nil {
		t.Fatalf("removing stale command source: %v", err)
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

	if _, err := os.Lstat(staleCommand); !os.IsNotExist(err) {
		t.Fatalf("expected stale command symlink removed, got err=%v", err)
	}

	expectedRuleSymlink := filepath.Join(rulesDestDir, "engineering.mdc")
	target, err := os.Readlink(expectedRuleSymlink)
	if err != nil {
		t.Fatalf("reading rule symlink: %v", err)
	}
	if target != ruleSource {
		t.Fatalf("expected rule symlink target %s, got %s", ruleSource, target)
	}

	expectedCommandSymlink := filepath.Join(commandsDestDir, "init.md")
	target, err = os.Readlink(expectedCommandSymlink)
	if err != nil {
		t.Fatalf("reading command symlink: %v", err)
	}
	if target != commandSource {
		t.Fatalf("expected command symlink target %s, got %s", commandSource, target)
	}
}

func TestCreateRejectsUnknownPlatform(t *testing.T) {
	if err := Create(Options{Platform: "unknown", RepoDir: t.TempDir()}); err == nil {
		t.Fatalf("expected error for unknown platform")
	}
}
