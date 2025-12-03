package cmd

import (
	"fmt"

	"github.com/gjermundgaraba/ai-rules/internal/mirror"
	"github.com/spf13/cobra"
)

func newMirrorClaudeCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "mirror-claude <path>",
		Short: "Mirror nested AGENTS.md files with CLAUDE.md references",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			root := args[0]
			fmt.Fprintf(cmd.OutOrStdout(), "Mirroring AGENTS.md files under %s...\n", root)

			return mirror.CreateClaudeMirrors(mirror.Options{
				Root:   root,
				Stdout: cmd.OutOrStdout(),
				Stderr: cmd.ErrOrStderr(),
			})
		},
	}

	return cmd
}

