# GSD Slash Commands

Kiro-specific slash commands for GSD framework.

## Overview

These commands provide Kiro-native access to GSD workflows with:
- Argument hints for autocomplete
- Bash pre-execution for context
- File references with @ syntax
- Tool restrictions for safety

## Command Categories

### Core Workflow (6)
- `/new-project` - Initialize new GSD project
- `/map` - Analyze codebase
- `/plan [N]` - Create execution plans
- `/execute [N]` - Implement phase
- `/verify [N]` - Validate implementation
- `/progress` - Show current status

### Phase Management (6)
Commands in `phase/` subdirectory:
- `/d