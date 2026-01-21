# Universal File Structure Protocol

## Overview

This protocol defines a universal directory structure that works identically in any environment with any AI assistant, eliminating all IDE-specific dependencies while maintaining full GSD functionality.

## Core Principles

1. **IDE Independence**: Zero dependencies on .kiro/, .claude/, .cursor/, or any IDE-specific directories
2. **Universal Compatibility**: Works identically in terminal, any IDE, or web-based environments
3. **Git-Based State**: All state management through git and standard files
4. **Graceful Degradation**: Clear fallbacks for restricted environments

## Universal Directory Structure

### Root Level (Project Files)
```
project-root/
├── README.md                 # Project documentation
├── CHANGELOG.md              # Version history
├── LICENSE                   # Project license
├── .gitignore               # Git ignore patterns
├── SPEC.md                  # Project specification (GSD)
├── ROADMAP.md               # Phase and milestone definitions (GSD)
├── STATE.md                 # Current project state (GSD)
├── ARCHITECTURE.md          # System design documentation (GSD)
├── DECISIONS.md             # Architecture Decision Records (GSD)
├── JOURNAL.md               # Session log (GSD)
└── TODO.md                  # Quick capture list (GSD)
```

### GSD System Directory (.gsd/)
```
.gsd/
├── SYSTEM.md                # GSD system documentation
├── COMMANDS.md              # Available GSD commands
├── UNIVERSAL-SETUP.md       # Universal setup guide
├── protocols/               # Universal protocols
│   ├── validation.md        # Universal validation protocol
│   ├── parallel.md          # Universal parallel processing
│   └── file-structure.md    # This file
├── lib/                     # Universal libraries and templates
│   ├── task-queue.md        # Task coordination templates
│   └── task-status.md       # Status tracking templates
├── workflows/               # GSD workflow definitions (25 files)
│   ├── new-project.md
│   ├── execute.md
│   ├── verify.md
│   └── ...
├── templates/               # Document templates
│   ├── SPEC.md
│   ├── ROADMAP.md
│   └── ...
├── milestones/              # Milestone-specific work
│   └── {milestone-name}/
│       ├── MILESTONE.md
│       └── phases/
│           └── {N}/
│               ├── {N}-PLAN.md
│               ├── {N}-SUMMARY.md
│               └── RESEARCH.md
└── examples/                # Usage examples and guides
    ├── quick-reference.md
    └── workflow-example.md
```

### Working Directories (Created as Needed)
```
.planning/                   # Phase planning work
├── phase-{N}-CONTEXT.md
├── phase-{N}-RESEARCH.md
└── phase-{N}-PLAN.md

.summaries/                  # Phase completion summaries
└── phase-{N}-SUMMARY.md

.todos/                      # Captured ideas and tasks
└── {topic}.md

.tasks/                      # Universal task coordination (when used)
├── queue.md
├── in-progress.md
├── completed.md
├── failed.md
└── status.md
```

## State Management Patterns

### Git-Based State Persistence
All GSD state is managed through git commits and standard files:

```bash
# State tracking through git
git log --oneline --grep="feat(phase-" --grep="docs(phase-"

# Current state in STATE.md
cat STATE.md

# Session history in JOURNAL.md
cat JOURNAL.md

# Decisions in DECISIONS.md
cat DECISIONS.md
```

### Configuration Storage
No IDE-specific configuration directories. All configuration in standard files:

```markdown
## Configuration Locations

| Type | Location | Format |
|------|----------|--------|
| Project settings | SPEC.md | Markdown |
| Phase definitions | ROADMAP.md | Markdown |
| Current state | STATE.md | Markdown |
| Tool preferences | .gsd/SYSTEM.md | Markdown |
| Validation rules | .gsd/protocols/validation.md | Markdown |
```

### Temporary Files
Use standard temporary patterns:

```bash
# Cross-platform temporary directory
TEMP_DIR="${TMPDIR:-/tmp}/gsd-$$"
mkdir -p "$TEMP_DIR"

# Cleanup on exit
trap "rm -rf '$TEMP_DIR'" EXIT
```

## Migration from IDE-Specific Structures

### From Kiro (.kiro/ directory)
```bash
# Migrate Kiro-specific files to universal structure
mkdir -p .gsd/legacy/kiro/

# Move Kiro configurations to legacy
mv .kiro/ .gsd/legacy/kiro/ 2>/dev/null || true

# Extract universal patterns from Kiro configs
# (Manual process - review and adapt to universal protocols)
```

### From Claude Code (.claude/ directory)
```bash
# Migrate Claude Code files to universal structure
mkdir -p .gsd/legacy/claude/

# Move Claude configurations to legacy
mv .claude/ .gsd/legacy/claude/ 2>/dev/null || true

# Extract universal patterns from Claude configs
# (Manual process - review and adapt to universal protocols)
```

### From Other IDEs
```bash
# General migration pattern
mkdir -p .gsd/legacy/{ide-name}/

# Move IDE-specific directories to legacy
mv .{ide-name}/ .gsd/legacy/{ide-name}/ 2>/dev/null || true

# Review and extract universal patterns
```

## Environment-Specific Adaptations

### Terminal + AI Chat
```markdown
## Terminal Environment

**File Operations**: Standard shell commands
- `ls`, `cat`, `mkdir`, `cp`, `mv`, `rm`
- `git add`, `git commit`, `git status`
- Text editors: `nano`, `vim`, `code`, or any available

**State Management**: Manual file updates
- Edit STATE.md after significant changes
- Update JOURNAL.md for session notes
- Commit changes with descriptive messages

**Task Coordination**: Manual task tracking
- Use .tasks/ directory for complex workflows
- Update task status manually
- Follow task queue templates from .gsd/lib/
```

### IDE Environments
```markdown
## IDE Environment (Any IDE)

**File Operations**: IDE file explorer and editor
- Use IDE's built-in file management
- Leverage IDE's git integration
- Use IDE's search and replace features

**State Management**: IDE-assisted editing
- Use IDE's markdown preview for documentation
- Leverage IDE's git integration for commits
- Use IDE's terminal for shell commands

**Task Coordination**: IDE + universal patterns
- Use IDE's task/todo features alongside GSD tasks
- Leverage IDE's multi-file editing for task updates
- Use IDE's integrated terminal for validation
```

### Web-Based Environments
```markdown
## Web-Based Environment

**File Operations**: Limited file system access
- Use web-based file managers when available
- Rely on git web interfaces for version control
- Use web-based editors for file modifications

**State Management**: Git-centric approach
- Commit frequently to preserve state
- Use git history as primary state tracking
- Leverage web git interfaces for file management

**Task Coordination**: Simplified patterns
- Use single-file task tracking when multi-file unavailable
- Embed task status in main documentation files
- Use git commits as task completion markers
```

## Fallback Patterns

### Restricted File System Access
When file system is limited:

```markdown
## Single-File Fallback

If multiple files unavailable, embed GSD structure in single files:

### README.md with embedded GSD
```markdown
# Project Name

## GSD State
- **Phase**: 1
- **Status**: In Progress
- **Last Updated**: 2026-01-21

## GSD Roadmap
### Phase 1: Foundation
- [ ] Task 1
- [x] Task 2

## GSD Journal
- 2026-01-21: Started Phase 1
```

### No Git Access
When git unavailable:

```markdown
## Manual Versioning

Use file-based versioning:
- STATE-20260121.md (timestamped state files)
- ROADMAP-v1.md, ROADMAP-v2.md (versioned roadmaps)
- Manual backup of important files
- Clear naming conventions for file versions
```

### No Shell Access
When shell commands unavailable:

```markdown
## Manual Operations

Replace shell commands with manual processes:
- Manual file validation using checklists
- Manual task coordination using templates
- Manual progress tracking in documentation
- Clear step-by-step instructions for all operations
```

## Validation and Verification

### Structure Validation
```bash
# Verify universal structure exists
test -d .gsd && echo "✓ GSD system directory exists"
test -f SPEC.md && echo "✓ Project specification exists"
test -f ROADMAP.md && echo "✓ Roadmap exists"
test -f STATE.md && echo "✓ State tracking exists"

# Check for IDE-specific directories (should not exist in universal setup)
! test -d .kiro && echo "✓ No Kiro dependencies"
! test -d .claude && echo "✓ No Claude Code dependencies"
! test -d .cursor && echo "✓ No Cursor dependencies"
```

### Cross-Platform Compatibility
```bash
# Test file operations work on current platform
echo "test" > .gsd/test.tmp && rm .gsd/test.tmp && echo "✓ File operations work"

# Test git operations work
git status >/dev/null 2>&1 && echo "✓ Git operations work"

# Test shell commands work
command -v ls >/dev/null 2>&1 && echo "✓ Shell commands available"
```

## Integration with Universal Protocols

### Validation Integration
```markdown
## Using Universal Validation

The universal validation protocol (.gsd/protocols/validation.md) works with this file structure:
- Validates files in standard project directories
- No dependencies on IDE-specific validation tools
- Clear fallbacks when advanced tools unavailable
```

### Parallel Processing Integration
```markdown
## Using Universal Parallel Processing

The universal parallel processing protocol (.gsd/protocols/parallel.md) uses:
- .tasks/ directory for task coordination
- Standard file operations for status tracking
- Git commits for task completion markers
```

## Success Criteria

This file structure protocol succeeds when:
- Works identically in any environment (terminal, IDE, web)
- Eliminates all IDE-specific directory dependencies
- Provides clear migration paths from existing setups
- Supports both automated and manual file operations
- Maintains full GSD functionality without tool dependencies
- Enables confident project management anywhere