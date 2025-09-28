package cmd

import (
	"strings"

	"github.com/gjermundgaraba/ai-rules/internal/symlinks"
	"github.com/spf13/cobra"
)

func newSymlinksCommand() *cobra.Command {
	var (
		symlinkRepoDir    string
		symlinkAIRulesDir string
	)

	cmd := &cobra.Command{
		Use:       "create-symlinks {cursor|windsurf|qoder|claude|all}",
		ValidArgs: []string{"cursor", "windsurf", "qoder", "claude", "all"},
		Args:      cobra.ExactArgs(1),
		Short:     "Create global rule symlinks for a target project",
		Long: "Create or refresh global rule symlinks for supported platforms inside the target repository. " +
			"The command mirrors scripts/create-symlinks.sh.",
		RunE: func(cmd *cobra.Command, args []string) error {
			target := strings.ToLower(args[0])
			platforms := []string{target}
			if target == "all" {
				platforms = []string{"cursor", "windsurf", "qoder", "claude"}
			}

			for _, platform := range platforms {
				if err := symlinks.Create(symlinks.Options{
					Platform:   platform,
					RepoDir:    symlinkRepoDir,
					AIRulesDir: symlinkAIRulesDir,
					Stdout:     cmd.OutOrStdout(),
					Stderr:     cmd.ErrOrStderr(),
				}); err != nil {
					return err
				}
			}
			return nil
		},
	}

	cmd.Flags().StringVar(&symlinkRepoDir, "repo-dir", ".", "Repository where symlinks should be created")
	cmd.Flags().StringVar(&symlinkAIRulesDir, "ai-rules-dir", "", "Path to the ai-rules build directory (default: $HOME/.config/ai-rules)")

	return cmd
}
