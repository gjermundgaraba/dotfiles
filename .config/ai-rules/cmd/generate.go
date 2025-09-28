package cmd

import (
	"fmt"

	"github.com/gjermundgaraba/ai-rules/internal/gitwalk"
	"github.com/gjermundgaraba/ai-rules/internal/symlinks"
	"github.com/spf13/cobra"
)

func newGenerateCursorSymlinksCommand() *cobra.Command {
	var generateAIRulesDir string

	cmd := &cobra.Command{
		Use:   "generate-cursor-symlinks <path>",
		Short: "Generate cursor symlinks across multiple repositories",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			root := args[0]
			fmt.Fprintf(cmd.OutOrStdout(), "Finding git projects under %s...\n", root)

			repos, err := gitwalk.FindRepositories(root)
			if err != nil {
				return err
			}

			for _, repo := range repos {
				fmt.Fprintf(cmd.OutOrStdout(), "Processing git project: %s\n", repo)
				if err := symlinks.Create(symlinks.Options{
					Platform:   "cursor",
					RepoDir:    repo,
					AIRulesDir: generateAIRulesDir,
					Stdout:     cmd.OutOrStdout(),
					Stderr:     cmd.ErrOrStderr(),
				}); err != nil {
					fmt.Fprintf(cmd.ErrOrStderr(), "  ❌ Error in %s: %v\n", repo, err)
				}
			}

			return nil
		},
	}

	cmd.Flags().StringVar(&generateAIRulesDir, "ai-rules-dir", "", "Path to the ai-rules build directory (default: $HOME/.config/ai-rules)")

	return cmd
}
