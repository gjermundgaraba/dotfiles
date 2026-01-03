package main

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

type testEnv struct {
	tempDir           string
	skillsSourceDir   string
	commandsSourceDir string
	agentsSourceDir   string
	projectDir        string
	configPath        string
}

func setupTestEnv(t *testing.T) *testEnv {
	t.Helper()

	tempDir := t.TempDir()

	env := &testEnv{
		tempDir:           tempDir,
		skillsSourceDir:   filepath.Join(tempDir, "skills"),
		commandsSourceDir: filepath.Join(tempDir, "commands"),
		agentsSourceDir:   filepath.Join(tempDir, "agents"),
		projectDir:        filepath.Join(tempDir, "test-project"),
		configPath:        filepath.Join(tempDir, "config.yaml"),
	}

	require.NoError(t, os.MkdirAll(env.skillsSourceDir, 0755))
	require.NoError(t, os.MkdirAll(env.commandsSourceDir, 0755))
	require.NoError(t, os.MkdirAll(env.agentsSourceDir, 0755))
	require.NoError(t, os.MkdirAll(env.projectDir, 0755))

	return env
}

func (e *testEnv) writeConfig(t *testing.T, config *Config) {
	t.Helper()
	data, err := yaml.Marshal(config)
	require.NoError(t, err)
	require.NoError(t, os.WriteFile(e.configPath, data, 0644))
}

func (e *testEnv) createSkill(t *testing.T, name string) {
	t.Helper()
	skillDir := filepath.Join(e.skillsSourceDir, name)
	require.NoError(t, os.MkdirAll(skillDir, 0755))
	require.NoError(t, os.WriteFile(filepath.Join(skillDir, "SKILL.md"), []byte("# "+name), 0644))
}

func (e *testEnv) createCommand(t *testing.T, name string) {
	t.Helper()
	require.NoError(t, os.WriteFile(filepath.Join(e.commandsSourceDir, name+".md"), []byte("# "+name), 0644))
}

func (e *testEnv) createAgent(t *testing.T, name string) {
	t.Helper()
	require.NoError(t, os.WriteFile(filepath.Join(e.agentsSourceDir, name+".md"), []byte("# "+name), 0644))
}

func (e *testEnv) syncOpts() SyncOptions {
	return SyncOptions{
		ConfigPath:        e.configPath,
		SkillsSourceDir:   e.skillsSourceDir,
		CommandsSourceDir: e.commandsSourceDir,
		AgentsSourceDir:   e.agentsSourceDir,
	}
}

func TestSyncSkillsCommandsAgents(t *testing.T) {
	env := setupTestEnv(t)

	// Create test items
	env.createSkill(t, "test-skill")
	env.createCommand(t, "test-command")
	env.createAgent(t, "test-agent")

	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path: env.projectDir,
				AiStuff: &AiStuff{
					Skills:       []string{"test-skill"},
					Commands:     []string{"test-command"},
					CustomAgents: []string{"test-agent"},
				},
				Harnesses: []Harness{HarnessClaude, HarnessOpencode},
			},
		},
	})

	require.NoError(t, Sync(env.syncOpts()))

	// Verify symlinks for both harnesses
	for _, harness := range []Harness{HarnessClaude, HarnessOpencode} {
		// Check skill symlink
		skillPath := filepath.Join(env.projectDir, HarnessSkillPaths[harness], "test-skill")
		info, err := os.Lstat(skillPath)
		require.NoError(t, err, "skill symlink should exist for %s", harness)
		require.True(t, info.Mode()&os.ModeSymlink != 0, "should be a symlink")

		target, err := os.Readlink(skillPath)
		require.NoError(t, err)
		require.Equal(t, filepath.Join(env.skillsSourceDir, "test-skill"), target)

		// Check command symlink
		cmdPath := filepath.Join(env.projectDir, HarnessCommandPaths[harness], "test-command.md")
		info, err = os.Lstat(cmdPath)
		require.NoError(t, err, "command symlink should exist for %s", harness)
		require.True(t, info.Mode()&os.ModeSymlink != 0, "should be a symlink")

		// Check agent symlink
		agentPath := filepath.Join(env.projectDir, HarnessAgentPaths[harness], "test-agent.md")
		info, err = os.Lstat(agentPath)
		require.NoError(t, err, "agent symlink should exist for %s", harness)
		require.True(t, info.Mode()&os.ModeSymlink != 0, "should be a symlink")
	}
}

func TestSyncCreatesDirectories(t *testing.T) {
	env := setupTestEnv(t)
	env.createSkill(t, "my-skill")

	// Verify target directories don't exist yet
	skillTargetDir := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessClaude])
	_, err := os.Stat(skillTargetDir)
	require.True(t, os.IsNotExist(err), "directory should not exist before sync")

	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   &AiStuff{Skills: []string{"my-skill"}},
				Harnesses: []Harness{HarnessClaude},
			},
		},
	})

	require.NoError(t, Sync(env.syncOpts()))

	// Verify directory was created
	info, err := os.Stat(skillTargetDir)
	require.NoError(t, err)
	require.True(t, info.IsDir())
}

func TestSyncErrorsOnMissingSource(t *testing.T) {
	env := setupTestEnv(t)

	tests := []struct {
		name    string
		config  *Config
		errPart string
	}{
		{
			name: "missing skill",
			config: &Config{
				Projects: []ProjectConfig{
					{
						Path:      env.projectDir,
						AiStuff:   &AiStuff{Skills: []string{"nonexistent-skill"}},
						Harnesses: []Harness{HarnessClaude},
					},
				},
			},
			errPart: "Skill source not found",
		},
		{
			name: "missing command",
			config: &Config{
				Projects: []ProjectConfig{
					{
						Path:      env.projectDir,
						AiStuff:   &AiStuff{Commands: []string{"nonexistent-cmd"}},
						Harnesses: []Harness{HarnessClaude},
					},
				},
			},
			errPart: "Command source not found",
		},
		{
			name: "missing agent",
			config: &Config{
				Projects: []ProjectConfig{
					{
						Path:      env.projectDir,
						AiStuff:   &AiStuff{CustomAgents: []string{"nonexistent-agent"}},
						Harnesses: []Harness{HarnessClaude},
					},
				},
			},
			errPart: "Agent source not found",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			env.writeConfig(t, tt.config)
			err := Sync(env.syncOpts())
			require.Error(t, err)
			require.Contains(t, err.Error(), tt.errPart)
		})
	}
}

func TestSyncIdempotent(t *testing.T) {
	env := setupTestEnv(t)
	env.createSkill(t, "idem-skill")
	env.createCommand(t, "idem-cmd")

	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path: env.projectDir,
				AiStuff: &AiStuff{
					Skills:   []string{"idem-skill"},
					Commands: []string{"idem-cmd"},
				},
				Harnesses: []Harness{HarnessOpencode},
			},
		},
	})

	// Run sync twice
	require.NoError(t, Sync(env.syncOpts()))
	require.NoError(t, Sync(env.syncOpts()))

	// Verify symlinks still work
	skillPath := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessOpencode], "idem-skill")
	info, err := os.Lstat(skillPath)
	require.NoError(t, err)
	require.True(t, info.Mode()&os.ModeSymlink != 0)

	cmdPath := filepath.Join(env.projectDir, HarnessCommandPaths[HarnessOpencode], "idem-cmd.md")
	info, err = os.Lstat(cmdPath)
	require.NoError(t, err)
	require.True(t, info.Mode()&os.ModeSymlink != 0)
}

func TestSyncCleansUpOrphans(t *testing.T) {
	env := setupTestEnv(t)

	// Create skills
	env.createSkill(t, "keep-skill")
	env.createSkill(t, "remove-skill")

	// Initial sync with both skills
	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   &AiStuff{Skills: []string{"keep-skill", "remove-skill"}},
				Harnesses: []Harness{HarnessClaude},
			},
		},
	})
	require.NoError(t, Sync(env.syncOpts()))

	keepPath := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessClaude], "keep-skill")
	removePath := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessClaude], "remove-skill")

	// Both should exist
	require.FileExists(t, keepPath)
	require.FileExists(t, removePath)

	// Update config to only include one skill
	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   &AiStuff{Skills: []string{"keep-skill"}},
				Harnesses: []Harness{HarnessClaude},
			},
		},
	})
	require.NoError(t, Sync(env.syncOpts()))

	// keep-skill should still exist
	require.FileExists(t, keepPath)

	// remove-skill should be cleaned up
	_, err := os.Lstat(removePath)
	require.True(t, os.IsNotExist(err), "orphaned symlink should be removed")

	// Test: external symlinks are NOT removed
	skillsTargetDir := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessClaude])
	externalDir := filepath.Join(env.tempDir, "external")
	require.NoError(t, os.MkdirAll(externalDir, 0755))

	externalSymlink := filepath.Join(skillsTargetDir, "external-skill")
	require.NoError(t, os.Symlink(externalDir, externalSymlink))

	// Run sync again
	require.NoError(t, Sync(env.syncOpts()))

	// External symlink should still exist
	info, err := os.Lstat(externalSymlink)
	require.NoError(t, err, "external symlink should not be removed")
	require.True(t, info.Mode()&os.ModeSymlink != 0)

	// Test: regular files are NOT removed
	regularFile := filepath.Join(skillsTargetDir, "regular-file.txt")
	require.NoError(t, os.WriteFile(regularFile, []byte("content"), 0644))

	require.NoError(t, Sync(env.syncOpts()))

	info, err = os.Stat(regularFile)
	require.NoError(t, err, "regular file should not be removed")
	require.True(t, info.Mode().IsRegular())
}

func TestSyncMultipleProjects(t *testing.T) {
	env := setupTestEnv(t)

	secondProjectDir := filepath.Join(env.tempDir, "second-project")
	require.NoError(t, os.MkdirAll(secondProjectDir, 0755))

	env.createSkill(t, "shared-skill")

	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   &AiStuff{Skills: []string{"shared-skill"}},
				Harnesses: []Harness{HarnessClaude},
			},
			{
				Path:      secondProjectDir,
				AiStuff:   &AiStuff{Skills: []string{"shared-skill"}},
				Harnesses: []Harness{HarnessOpencode},
			},
		},
	})

	require.NoError(t, Sync(env.syncOpts()))

	// Verify first project (claude harness)
	path1 := filepath.Join(env.projectDir, HarnessSkillPaths[HarnessClaude], "shared-skill")
	info, err := os.Lstat(path1)
	require.NoError(t, err)
	require.True(t, info.Mode()&os.ModeSymlink != 0)

	// Verify second project (opencode harness)
	path2 := filepath.Join(secondProjectDir, HarnessSkillPaths[HarnessOpencode], "shared-skill")
	info, err = os.Lstat(path2)
	require.NoError(t, err)
	require.True(t, info.Mode()&os.ModeSymlink != 0)
}

func TestSyncEmptyConfig(t *testing.T) {
	env := setupTestEnv(t)

	// No projects
	env.writeConfig(t, &Config{Projects: []ProjectConfig{}})
	require.NoError(t, Sync(env.syncOpts()))

	// Project with no ai-stuff
	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   nil,
				Harnesses: []Harness{HarnessClaude},
			},
		},
	})
	require.NoError(t, Sync(env.syncOpts()))

	// Project with empty lists
	env.writeConfig(t, &Config{
		Projects: []ProjectConfig{
			{
				Path:      env.projectDir,
				AiStuff:   &AiStuff{Skills: []string{}, Commands: []string{}, CustomAgents: []string{}},
				Harnesses: []Harness{HarnessClaude},
			},
		},
	})
	require.NoError(t, Sync(env.syncOpts()))
}

func TestValidateHarnesses(t *testing.T) {
	// Empty harnesses
	err := ValidateHarnesses([]Harness{}, "/some/path")
	require.Error(t, err)
	require.Contains(t, err.Error(), "no harnesses configured")

	// Invalid harness
	err = ValidateHarnesses([]Harness{"invalid"}, "/some/path")
	require.Error(t, err)
	require.Contains(t, err.Error(), "unsupported harness")

	// Valid harnesses
	require.NoError(t, ValidateHarnesses([]Harness{HarnessClaude}, "/some/path"))
	require.NoError(t, ValidateHarnesses([]Harness{HarnessClaude, HarnessOpencode}, "/some/path"))
}
