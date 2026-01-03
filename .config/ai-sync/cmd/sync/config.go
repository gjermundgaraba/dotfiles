package main

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v3"
)

type Harness string

const (
	HarnessClaude   Harness = "claude"
	HarnessOpencode Harness = "opencode"
)

var SupportedHarnesses = []Harness{HarnessClaude, HarnessOpencode}

var HarnessSkillPaths = map[Harness]string{
	HarnessClaude:   ".claude/skills",
	HarnessOpencode: ".opencode/skill",
}

var HarnessCommandPaths = map[Harness]string{
	HarnessClaude:   ".claude/commands",
	HarnessOpencode: ".opencode/command",
}

var HarnessAgentPaths = map[Harness]string{
	HarnessClaude:   ".claude/agents",
	HarnessOpencode: ".opencode/agent",
}

type AiStuff struct {
	Skills       []string `yaml:"skills,omitempty"`
	Commands     []string `yaml:"commands,omitempty"`
	CustomAgents []string `yaml:"customAgents,omitempty"`
}

type ProjectConfig struct {
	Path      string    `yaml:"path"`
	AiStuff   *AiStuff  `yaml:"ai-stuff,omitempty"`
	Harnesses []Harness `yaml:"harnesses"`
}

type Config struct {
	Projects []ProjectConfig `yaml:"projects"`
}

func LoadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("reading config: %w", err)
	}

	var config Config
	if err := yaml.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("parsing config: %w", err)
	}

	return &config, nil
}

func SaveConfig(path string, config *Config) error {
	data, err := yaml.Marshal(config)
	if err != nil {
		return fmt.Errorf("marshaling config: %w", err)
	}

	if err := os.WriteFile(path, data, 0644); err != nil {
		return fmt.Errorf("writing config: %w", err)
	}

	return nil
}

func ValidateHarnesses(harnesses []Harness, projectPath string) error {
	if len(harnesses) == 0 {
		return fmt.Errorf("project %q has no harnesses configured (supported: %v)", projectPath, SupportedHarnesses)
	}

	for _, h := range harnesses {
		valid := false
		for _, s := range SupportedHarnesses {
			if h == s {
				valid = true
				break
			}
		}
		if !valid {
			return fmt.Errorf("project %q has unsupported harness %q (supported: %v)", projectPath, h, SupportedHarnesses)
		}
	}

	return nil
}
