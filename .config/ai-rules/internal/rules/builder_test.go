package rules

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestNormalizePlatforms(t *testing.T) {
	t.Run("defaults to all", func(t *testing.T) {
		platforms, err := normalizePlatforms(nil)
		if err != nil {
			t.Fatalf("normalizePlatforms returned error: %v", err)
		}
		if got, want := platforms, append([]string(nil), supportedPlatforms...); !equalStrings(got, want) {
			t.Fatalf("expected %v, got %v", want, got)
		}
	})

	t.Run("rejects unknown", func(t *testing.T) {
		if _, err := normalizePlatforms([]string{"unknown"}); err == nil {
			t.Fatalf("expected error for unknown platform")
		}
	})

	t.Run("deduplicates and normalizes", func(t *testing.T) {
		platforms, err := normalizePlatforms([]string{"Cursor", "cursor", "windsurf"})
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if got, want := platforms, []string{"cursor", "windsurf"}; !equalStrings(got, want) {
			t.Fatalf("expected %v, got %v", want, got)
		}
	})
}

func TestParseRule(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "sample.md")
	content := strings.Join([]string{
		"---",
		"description: Sample rule",
		"type: on-demand",
		"---",
		"Body content",
		"",
	}, "\n")

	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatalf("writing rule: %v", err)
	}

	rule, err := parseRule(path)
	if err != nil {
		t.Fatalf("parseRule returned error: %v", err)
	}

	if rule.Name != "sample" {
		t.Fatalf("expected name 'sample', got %q", rule.Name)
	}
	if rule.Meta.Description != "Sample rule" {
		t.Fatalf("unexpected description: %q", rule.Meta.Description)
	}
	if rule.Meta.Type != "on-demand" {
		t.Fatalf("unexpected type: %q", rule.Meta.Type)
	}
	if !strings.Contains(string(rule.Body), "Body content") {
		t.Fatalf("missing body content")
	}
}

func TestBuildHonorsOutputDir(t *testing.T) {
	projectDir := filepath.Join(t.TempDir(), "project")
	rulesDir := filepath.Join(projectDir, "rules")
	if err := os.MkdirAll(rulesDir, 0o755); err != nil {
		t.Fatalf("creating directories: %v", err)
	}

	rulePath := filepath.Join(rulesDir, "sample.md")
	ruleContent := strings.Join([]string{
		"---",
		"description: Sample",
		"type: always-on",
		"---",
		"Body",
		"",
	}, "\n")
	if err := os.WriteFile(rulePath, []byte(ruleContent), 0o644); err != nil {
		t.Fatalf("writing rule: %v", err)
	}

	outputRoot := filepath.Join(projectDir, "artifacts")
	if err := Build(context.Background(), BuildOptions{
		ProjectDir: projectDir,
		BuildDir:   filepath.Join(outputRoot, "build"),
		Platforms:  []string{"cursor"},
	}); err != nil {
		t.Fatalf("Build returned error: %v", err)
	}

	outputFile := filepath.Join(outputRoot, "build", "cursor", "sample.mdc")
	data, err := os.ReadFile(outputFile)
	if err != nil {
		t.Fatalf("expected build output at %s: %v", outputFile, err)
	}
	if !strings.Contains(string(data), "alwaysApply: true") {
		t.Fatalf("expected alwaysApply header, got %s", string(data))
	}

	if _, err := os.Stat(filepath.Join(projectDir, "build")); !errors.Is(err, os.ErrNotExist) {
		t.Fatalf("expected default build directory to be absent, got err=%v", err)
	}
}

func equalStrings(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
