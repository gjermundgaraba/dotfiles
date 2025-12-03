# Init

Generate AGENTS.md files that serve as contributor guides for this repository.

Before generating any files, deeply analyze the repository to understand its purpose, architecture, and structure. Your goal is to produce clear, concise, and well-structured documentation with descriptive headings and actionable guidance.

## Phase 1: Repository Analysis

Thoroughly explore the codebase to understand:

- What the project does and its primary purpose
- The tech stack(s) used across the repository
- Build systems, package managers, and tooling
- Directory structure and module boundaries
- Testing frameworks and conventions
- Any existing documentation or configuration files

## Phase 2: Plan the AGENTS.md Structure

Determine whether nested AGENTS.md files are needed. Agents read the nearest file in the directory tree—closest takes precedence—so subfolder files override parent guidance.

Use nested files when:

- Multiple packages/modules exist in a monorepo
- Different tech stacks live in subdirectories (e.g., `frontend/` vs `backend/`)
- Specialized testing or tooling requirements per component
- Rules should override or extend global guidance

Create a plan that maps out:

1. Root `AGENTS.md` — global guidance applicable everywhere
2. Nested `<subdir>/AGENTS.md` — specialized guidance for that subtree

Critical rule: Never repeat information a parent file already covers. Nested files should only contain guidance specific to that subtree, referencing the parent implicitly.

## Phase 3: Generate the Files

### Document Requirements

- Title root documents "Repository Guidelines"; title nested documents by their scope (e.g., "Frontend Guidelines")
- Use Markdown headings for structure
- Keep each file concise: 200-400 words for root, 100-200 words for nested
- Keep explanations short, direct, and specific
- Provide examples where helpful (commands, paths, patterns)
- Maintain a professional, instructional tone

### Root AGENTS.md Sections

Include sections that apply globally. Adapt as needed—add relevant sections, omit those that don't apply.

Project Overview

- Brief description of what the project does
- High-level architecture or component summary

Project Structure

- Outline key directories and their purposes
- Note where source code, tests, and assets live

Build & Development Commands

- List commands for building, testing, and running locally
- Briefly explain what each command does

Coding Style & Conventions

- Indentation, formatting, and naming patterns
- Linting and formatting tools used

Testing Guidelines

- Testing frameworks and how to run tests
- Coverage requirements and test naming conventions

Commit & PR Guidelines

- Commit message conventions from project history
- Pull request requirements

### Nested AGENTS.md Sections

Only include what differs from or extends the parent. Typical sections:

- Scope-specific build/test commands
- Tech stack details unique to this subtree
- Local conventions that override global rules
- Dependencies or tooling specific to this module

## Output Format

Present your plan first, showing which files you'll create and why. Then generate each file in order from root to nested.
