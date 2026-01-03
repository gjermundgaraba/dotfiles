package main

import (
	"fmt"
	"os"
)

func printUsage() {
	fmt.Println("Usage: ai-sync <command>")
	fmt.Println()
	fmt.Println("Commands:")
	fmt.Println("  add-project       Add current directory as a project with all available skills")
	fmt.Println("  generate-example  Generate an example config.yaml with all skills and agents")
	fmt.Println("  sync              Sync skills to all configured projects (default)")
}

func main() {
	args := os.Args[1:]

	command := "sync"
	if len(args) > 0 {
		command = args[0]
	}

	var err error
	switch command {
	case "--help", "-h":
		printUsage()
		return
	case "sync":
		err = Sync(SyncOptions{})
	case "add-project":
		err = AddProject()
	case "generate-example":
		err = GenerateExample()
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", command)
		printUsage()
		os.Exit(1)
	}

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
