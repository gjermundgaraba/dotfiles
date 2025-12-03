package cmd

import "github.com/spf13/cobra"

// NewRootCommand constructs the root CLI command with all subcommands.
func NewRootCommand() *cobra.Command {
	root := &cobra.Command{
		Use:          "ai-rules",
		Short:        "Build AI rules and manage symlinks",
		Long:         "ai-rules is the canonical CLI for building global rule bundles and managing symlinks across supported platforms.",
		SilenceUsage: true,
	}

	root.AddCommand(newBuildCommand())
	root.AddCommand(newSymlinksCommand())
	root.AddCommand(newGenerateCursorSymlinksCommand())
	root.AddCommand(newMirrorClaudeCommand())

	return root
}

// Execute runs the root command.
func Execute() error {
	return NewRootCommand().Execute()
}
