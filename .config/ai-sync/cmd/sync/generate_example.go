package main

import (
	"fmt"
	"path/filepath"

	"gopkg.in/yaml.v3"
)

func GenerateExample() error {
	rootDir := GetRootDir()
	skillsSourceDir := filepath.Join(rootDir, "build", "skills")

	availableSkills := getAvailableSkills(skillsSourceDir)

	exampleSkills := availableSkills
	if len(exampleSkills) == 0 {
		exampleSkills = []string{"skill-creator"}
	}

	exampleConfig := Config{
		Projects: []ProjectConfig{
			{
				Path: "/path/to/your/project",
				AiStuff: &AiStuff{
					Skills: exampleSkills,
				},
				Harnesses: SupportedHarnesses,
			},
		},
	}

	output, err := yaml.Marshal(&exampleConfig)
	if err != nil {
		return fmt.Errorf("marshaling example: %w", err)
	}

	fmt.Println("Example sync-config.yaml:")
	fmt.Println()
	fmt.Println(string(output))
	fmt.Println("---")
	if len(availableSkills) > 0 {
		fmt.Printf("Available skills: %v\n", availableSkills)
	} else {
		fmt.Println("Available skills: none found")
	}
	fmt.Printf("Available harnesses: %v\n", SupportedHarnesses)
	fmt.Println("\nTo use: save this to sync-config.yaml and update the project path")

	return nil
}
