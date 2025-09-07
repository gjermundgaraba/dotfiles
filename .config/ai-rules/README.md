# AI Rules

The goal of AI Rules is to have a single, dotfiles-enabled location for all my AI Rules that are not project specific.

The rules are meant to be linked or symlinked, depending on the agent setup needs.

## Requirements

To run all the just recipes, you need the following installed:

- **just** - Task runner
- **bash** - Shell interpreter
- **gomplate** - Template engine for building rules
- **yq** - YAML processor for extracting frontmatter
- Standard Unix utilities (find, sed, ln, mkdir, etc.)

## Rules Format

Rules use YAML frontmatter with the following structure:

```yaml
---
description: Rule description
type: always-on | on-demand
---
```

### Fields

- **description**: Description used by all platforms
- **type**: Rule activation behavior
  - `always-on`: Rule is always active/applied
  - `on-demand`: Rule is manually triggered

### Type Mapping

The `type` field maps directly to platform-specific behaviors:

| Type | Cursor | Windsurf | Claude | Qoder |
|------|---------|----------|------------|-------|
| always-on | alwaysApply: true | trigger: always_on | included | trigger: always_on; alwaysApply: true |
| on-demand | alwaysApply: false | trigger: manual | not built | no description: trigger: manual; alwaysApply: false. With description: trigger: model_decision |

### Examples

**Always-On Rule:**
```yaml
---
description: Core engineering rules for code quality and consistency
type: always-on
---
```

**On-Demand Rule:**
```yaml
---
description: One-shot implementation agent that executes plans from planning agents
type: on-demand
---
```

## Building Rules

Build platform-specific rule files for all platforms using:

```bash
just build-rules
```

Built rules are output to `build/{platform}/` directories.

## Platform Integration

### Cursor

Since Cursor global rules are normally configured directly in the editor and does not have any files we can cleverly symlink over, we use a script (`scripts/create-symlinks.sh`) to generate symlinks into a repo's `.cursor/rules` folder instead. Those files will be named `global_rule_FILE_NAME`.

Usage (argument required; no argument will error):
```bash
# For the current repo
./scripts/create-symlinks.sh cursor

# Create symlinks for all supported platforms
./scripts/create-symlinks.sh all
```

(Those files should probably be gitignored. One way is to use a global gitignore file (e.g. `../.gitignore_global`) with `./cursor/rules/global_rule_*`)

To recursively generate cursor symlinks for all git projects under a folder:
```bash
just generate-cursor-symlink /path/to/top/level/projects/folder
```

### Claude

While you can always just reference any file in here directly from your `CLAUDE.md` files (project or global), we also provide a convenient `claude-the-engineer.md` that you can reference directly.

### Qoder

Qoder output encodes rule behavior as follows:

- **always-on**: `trigger: always_on`, `alwaysApply: true`
- **on-demand (no description)**: `trigger: manual`, `alwaysApply: false`
- **on-demand (with description)**: `trigger: model_decision` (no `alwaysApply` field)