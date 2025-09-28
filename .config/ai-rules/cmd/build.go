package cmd

import (
	"github.com/gjermundgaraba/ai-rules/internal/rules"
	"github.com/spf13/cobra"
)

func newBuildCommand() *cobra.Command {
	var (
		buildPlatforms  []string
		buildProjectDir string
		buildOutputDir  string
	)

	cmd := &cobra.Command{
		Use:   "build",
		Short: "Render rule templates for supported platforms",
		Long: "Render the Markdown rule sources under rules/ into platform-specific outputs using " +
			"embedded Go templates. By default all platforms are built.",
		RunE: func(cmd *cobra.Command, args []string) error {
			opts := rules.BuildOptions{
				ProjectDir: buildProjectDir,
				Platforms:  buildPlatforms,
				BuildDir:   buildOutputDir,
				Stdout:     cmd.OutOrStdout(),
				Stderr:     cmd.ErrOrStderr(),
			}
			return rules.Build(cmd.Context(), opts)
		},
	}

	cmd.Flags().StringSliceVar(&buildPlatforms, "platform", nil, "Limit build to specific platform(s)")
	cmd.Flags().StringVar(&buildProjectDir, "project-dir", ".", "Path to the ai-rules project root")
	cmd.Flags().StringVar(&buildOutputDir, "output-dir", "", "Directory to write build artifacts (default: <project-dir>/build)")

	return cmd
}
