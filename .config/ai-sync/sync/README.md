# ai-sync

CLI to sync skills across projects.

## Installation

**Option A: Compiled binary (recommended)**
```bash
cd ~/.config/ai-sync/sync
bun run build
export PATH="$HOME/.config/ai-sync/sync:$PATH"  # add to ~/.zshrc
```

**Option B: Shell alias**
```bash
# Add to ~/.zshrc
alias ai-sync='bun run ~/.config/ai-sync/sync/index.ts'
```

**Option C: Bun link**
```bash
cd ~/.config/ai-sync/sync && bun link
```

## Commands

### add-project

Add current working directory as a project with all available skills.

```bash
cd ~/my-project
ai-sync add-project
```

### sync

Sync skills to all configured projects (creates symlinks).

```bash
ai-sync sync
```

## Config

Projects are stored in `~/.config/ai-sync/sync/config.json`:

```json
{
  "projects": [
    {
      "path": "/path/to/project",
      "skills": ["skill-creator"]
    }
  ]
}
```
