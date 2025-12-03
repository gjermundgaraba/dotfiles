package cmd_test

import (
	"bytes"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"testing"

	"github.com/gjermundgaraba/ai-rules/cmd"
)

func TestBuildAndSymlinkIntegration(t *testing.T) {
	if runtime.GOOS == "windows" {
		t.Skip("integration symlink test not supported on Windows")
	}

	temp := t.TempDir()
	projectDir := filepath.Join(temp, "project")
	airulesDir := filepath.Join(temp, "ai-rules")
	buildDir := filepath.Join(airulesDir, "build")
	repoDir := filepath.Join(temp, "repo")

	rulesDir := filepath.Join(projectDir, "rules")
	if err := os.MkdirAll(rulesDir, 0o755); err != nil {
		t.Fatalf("creating rules dir: %v", err)
	}

	ruleContent := strings.Join([]string{
		"---",
		"description: Integration",
		"type: always-on",
		"---",
		"Integration body",
		"",
	}, "\n")
	rulePath := filepath.Join(rulesDir, "integration.md")
	if err := os.WriteFile(rulePath, []byte(ruleContent), 0o644); err != nil {
		t.Fatalf("writing rule: %v", err)
	}

	buildArgs := []string{
		"build",
		"--project-dir", projectDir,
		"--output-dir", buildDir,
		"--platform", "cursor",
	}
	buildStdout, buildStderr, err := executeCommand(buildArgs...)
	if err != nil {
		t.Fatalf("build command failed: %v\nstdout: %s\nstderr: %s", err, buildStdout, buildStderr)
	}

	outputFile := filepath.Join(buildDir, "cursor", "rules", "integration.mdc")
	data, err := os.ReadFile(outputFile)
	if err != nil {
		t.Fatalf("expected build output at %s: %v", outputFile, err)
	}
	if !strings.Contains(string(data), "Integration body") {
		t.Fatalf("expected rule body in output, got: %s", string(data))
	}

	symlinkArgs := []string{
		"create-symlinks", "cursor",
		"--repo-dir", repoDir,
		"--ai-rules-dir", airulesDir,
	}
	symlinkStdout, symlinkStderr, err := executeCommand(symlinkArgs...)
	if err != nil {
		t.Fatalf("create-symlinks failed: %v\nstdout: %s\nstderr: %s", err, symlinkStdout, symlinkStderr)
	}

	symlinkPath := filepath.Join(repoDir, ".cursor", "rules", "integration.mdc")
	target, err := os.Readlink(symlinkPath)
	if err != nil {
		t.Fatalf("reading symlink: %v", err)
	}
	if target != outputFile {
		t.Fatalf("unexpected symlink target: %s", target)
	}
}

func executeCommand(args ...string) (string, string, error) {
	command := cmd.NewRootCommand()
	var stdout, stderr bytes.Buffer
	command.SetOut(&stdout)
	command.SetErr(&stderr)
	command.SetArgs(args)
	err := command.Execute()
	return stdout.String(), stderr.String(), err
}
