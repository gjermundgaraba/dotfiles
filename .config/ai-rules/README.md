# AI Rules

The goal of AI Rules is to have a single, dotfiles-enabled location for all my AI Rules that are not very project specific.

The rules are meant to be linked or symlinked, depending on the agent setup needs.

## Cursor
Since Cursor global rules are normally configured directly in the editor and does not have any files we can cleverly symlink over, we use a script (`scripts/create_cursor_symlinks.sh`) to generate symlinks into a repo's `.cursor/rules` folder instead. Those files will be named `global_rule_FILE_NAMEc` (notice the c at the end that makes the .md files into .mdc files).

(Those files should probably be gitignored. I use a global gitignore file (`../.gitignore_global`) for this purpose)