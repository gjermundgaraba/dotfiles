# AGENT GUIDE: Ghostty Config

My config is at ./config

## Documentation
- Verify all configuration changes (keys and values) with the docs at https://ghostty.org/docs

## Build, Lint & Test
- No build, lint or test - the user needs to verify that config changes work as expected

## Code Style
- Keep entries `key = value` with single spaces around equals.
- Add new options near related sections, keeping comment hierarchy.
- Use `#` headers for sections and `##` for subsections to mirror existing style.
- Avoid trailing whitespace; align multi-line blocks for readability.
- Validate fonts/themes against installed assets before making changes related to those.
- Prefer explicit numeric values; document non-obvious choices inline via comments.
- Remove deprecated keys instead of commenting them out unless needed for context.
- Favor descriptive command invocations; ensure shell commands are login-shell safe.

