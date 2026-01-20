---
name: commit-helper
description: Generates atomic commit messages following GSD conventions. Use when committing code, after completing tasks, or when user mentions "commit", "git commit", or "atomic commits".
allowed-tools: Bash(git:*)
---

# Commit Helper

## Overview

Generates clear, atomic commit messages following GSD format with git context.

## Context

Current git status: !`git status --short`
Staged files: !`git diff --cached --name-only`
Recent commits: !`git log --oneline -5`

## Commit Format

```
<type>(phase-N): <description>
```

**Types**:
- `feat`: New feature or functionality
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Phase**: Current phase number (e.g., `phase-1`, `phase-2`)

**Description**: 
- Present tense ("add feature" not "added feature")
- Lowercase
- No period at end
- Specific and concise
- Max 72 characters

## Process

1. Review staged changes from git status
2. Identify what was done (one thing per commit)
3. Determine commit type
4. Identify current phase from STATE.md
5. Generate commit message
6. Show message to user for approval
7. Execute: `git commit -m "message"`

## Examples

```
feat(phase-1): create hook infrastructure
feat(phase-1): implement planning lock hook
docs(phase-2): create skills documentation
fix(phase-3): correct subagent configuration
refactor(phase-4): simplify command parsing
```

## Rules

- One commit per task
- Each commit should be independently revertable
- Commit message explains WHAT, not HOW
- Reference phase number for traceability
- Get user approval before committing

## Notes

- Use git context to understand changes
- Keep messages concise but descriptive
- Follow GSD atomic commit convention
- Never commit without user approval
