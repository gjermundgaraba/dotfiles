# AI Rules

The goal of AI Rules is to have a single, dotfiles-enabled location for all my AI Rules that are not project specific.

The rules are meant to be linked or symlinked, depending on the agent setup needs.

## Cursor
Since Cursor global rules are normally configured directly in the editor and does not have any files we can cleverly symlink over, we use a script (`scripts/create_cursor_symlinks.sh`) to generate symlinks into a repo's `.cursor/rules` folder instead. Those files will be named `global_rule_FILE_NAME`.

(Those files should probably be gitignored. One way is to use a global gitignore file (e.g. `../.gitignore_global`) with `./cursor/rules/global_rule_*`)

To recursively generate cursor symlinks for all git projects under a folder:
```bash
just generate-cursor-symlink /path/to/top/level/projects/folder
```

## Claude

While you can always just reference any file in here directly from your `CLAUDE.md` files (project or global), we also provide a convenient `claude-the-engineer.md` that you can reference directly.

To rebuild the "Claude, the engineer", run:
```bash
just build-claude-the-engineer
```