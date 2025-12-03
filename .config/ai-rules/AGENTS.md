# Repository Guidelines

## Project Overview

A Go CLI tool that manages AI coding assistant rules across multiple platforms (Cursor, Claude, Windsurf, Qoder). It enables centralized rule authoring in a dotfiles-style location, then builds and distributes platform-specific outputs via templates and symlinks.

### Core Concepts

- **Rules**: Markdown files with YAML frontmatter defining behavior (`always-on` vs `on-demand`)
- **Templates**: Go templates that transform rules into platform-specific formats
- **Symlinks**: Links created in target repositories pointing to built rules

## Project Structure

```
cmd/               CLI commands (build, create-symlinks, generate-cursor-symlinks, mirror-claude)
internal/
  gitwalk/         Finds git repositories under a path
  mirror/          Creates CLAUDE.md mirrors for AGENTS.md files
  rules/           Parses rules and renders templates
  symlinks/        Creates and cleans up symlinks in target repos
rules/             Source rule files with YAML frontmatter
  templates/       Go templates for each platform (embedded via go:embed)
commands/          Command markdown files copied to build output
build/             Generated platform-specific outputs (gitignored)
```

## Build & Development

```bash
go run . build                           # Build rules for all platforms
go run . build --platform cursor         # Build for specific platform
go run . create-symlinks cursor --repo-dir /path/to/repo  # Create symlinks in repo
go test ./...                            # Run all tests
just build-rules                         # Build CLI then build rules
just install                             # Install CLI globally
```

## Coding Conventions

- Standard Go formatting (`gofmt`)
- Exported types and functions require doc comments
- Internal packages under `internal/` are not importable externally
- Templates use Go's `text/template` syntax
- YAML frontmatter uses `gopkg.in/yaml.v3`

## Testing

Tests use the standard `testing` package. Run with `go test ./...`.

- Unit tests live alongside source files (`*_test.go`)
- Integration tests in `cmd/integration_test.go` verify build-to-symlink workflows
- Tests create temp directories and clean up automatically
- Symlink tests skip on Windows (`runtime.GOOS == "windows"`)

## Rule Format

Rules in `rules/*.md` require YAML frontmatter:

```yaml
---
description: Optional description for the rule
type: always-on | on-demand
---
```

The `type` field controls platform-specific behavior (see README.md for mapping details).

## Commit Style

Follow conventional commit format based on project history. Keep commits atomic and focused on single changes.

