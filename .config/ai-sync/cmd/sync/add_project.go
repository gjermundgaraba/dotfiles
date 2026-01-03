package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func getAvailableSkills(skillsDir string) []string {
	entries, err := os.ReadDir(skillsDir)
	if err != nil {
		return nil
	}

	var skills []string
	for _, entry := range entries {
		if entry.IsDir() {
			skills = append(skills, entry.Name())
		}
	}
	return skills
}

func AddProject() error {
	rootDir := GetRootDir()
	skillsSourceDir := filepath.Join(rootDir, "build", "skills")
	configPath := filepath.Join(rootDir, "sync-config.yaml")

	cwd, err := os.Getwd()
	if err != nil {
		return fmt.Errorf("getting current directory: %w", err)
	}

	// Load existing config or create new one
	var config *Config
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		config = &Config{Projects: []ProjectConfig{}}
	} else {
		config, err = LoadConfig(configPath)
		if err != nil {
			return err
		}
	}

	// Check if project already exists
	for _, p := range config.Projects {
		absPath, _ := filepath.Abs(p.Path)
		absCwd, _ := filepath.Abs(cwd)
		if absPath == absCwd {
			fmt.Printf("Project already exists: %s\n", cwd)
			if p.AiStuff != nil && len(p.AiStuff.Skills) > 0 {
				fmt.Printf("Skills: %v\n", p.AiStuff.Skills)
			} else {
				fmt.Println("Skills: none")
			}
			if len(p.Harnesses) > 0 {
				fmt.Printf("Harnesses: %v\n", p.Harnesses)
			} else {
				fmt.Println("Harnesses: none")
			}
			return nil
		}
	}

	availableSkills := getAvailableSkills(skillsSourceDir)
	if len(availableSkills) == 0 {
		fmt.Printf("Warning: No skills found in: %s\n", skillsSourceDir)
	}

	newProject := ProjectConfig{
		Path: cwd,
		AiStuff: &AiStuff{
			Skills: availableSkills,
		},
		Harnesses: SupportedHarnesses,
	}

	config.Projects = append(config.Projects, newProject)

	if err := SaveConfig(configPath, config); err != nil {
		return err
	}

	fmt.Printf("Added project: %s\n", cwd)
	if len(availableSkills) > 0 {
		fmt.Printf("Skills: %v\n", availableSkills)
	} else {
		fmt.Println("Skills: none")
	}
	fmt.Printf("Harnesses: %v\n", SupportedHarnesses)

	return nil
}
