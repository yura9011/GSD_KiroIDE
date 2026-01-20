# Phase 1 Research: Hooks Foundation

**Phase**: 1 - Hooks Foundation
**Created**: 2026-01-20
**Research Level**: 2 (Standard Research)

---

## Research Question

How to implement Kiro hooks for auto-validation and GSD rule enforcement in a cross-platform way?

---

## Findings

### 1. Hook Types Needed for GSD

Based on research in `resarch/hooks.md`:

**PostToolUse Hooks** (Auto-validation)
- Trigger: After Edit or Write tools
- Purpose: Validate syntax, run linters, check code quality
- Exit code 2 blocks and feeds error back to Claude
- Perfect for "auto-correction loop"

**PreToolUse Hooks** (Planning Lock Enforcement)
- Trigger: Before Edit or Write tools
- Purpose: Block code writing if STATE.md shows PLANNING status
- Exit code 2 prevents tool execution
- Enforces GSD's "no code until SPEC finalized" rule

**SessionStart Hooks** (Environment Setup)
- Trigger: When session starts
- Purpose: Load project context, set environment variables
- Can use CLAUDE_ENV_FILE to persist env vars

### 2. Hook Configuration Location

Kiro uses `.kiro/settings/hooks.json` (not `.kiro/hooks/`)

Structure:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "script-path",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### 3. Cross-Platform Script Strategy

**Challenge**: Windows (PowerShell/cmd) vs Unix (bash)

**Solution**: Python scripts
- Cross-platform by default
- Can read JSON from stdin (hook input)
- Easy to parse STATE.md, run linters
- Exit codes work identically

**Alternative**: Dual scripts
- `.sh` for Unix
- `.ps1` for Windows
- Hook config detects platform

### 4. Hook Input Schema

Hooks receive JSON via stdin:
```json
{
  "session_id": "...",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file",
    "content": "..."
  },
  "hook_event_name": "PostToolUse"
}
```

Scripts must:
1. Read stdin
2. Parse JSON
3. Perform validation
4. Exit with appropriate code

### 5. Validation Tools by Language

**Python**:
- `flake8` - style checker
- `black --check` - formatter check
- `mypy` - type checker

**JavaScript/TypeScript**:
- `eslint` - linter
- `prettier --check` - formatter
- `tsc --noEmit` - type check

**Markdown**:
- `markdownlint` - style checker

**Cross-language**:
- File existence checks
- Basic syntax validation

### 6. Planning Lock Implementation

Script logic:
```python
# Read STATE.md
state = read_file("STATE.md")

# Check if in planning phase
if "Status**: Planning" in state or "DRAFT" in state:
    # Block write operations
    print("Planning Lock: Cannot write code during planning phase", file=sys.stderr)
    sys.exit(2)

# Allow operation
sys.exit(0)
```

### 7. Hook Execution Flow

1. Claude attempts Edit/Write
2. PreToolUse hook runs → checks Planning Lock
3. If blocked: Claude sees error, cannot proceed
4. If allowed: Tool executes
5. PostToolUse hook runs → validates result
6. If validation fails: Claude sees error, must fix
7. Loop continues until validation passes

---

## Recommendations

### Phase 1 Implementation Strategy

**Wave 1: Foundation**
- Create `.kiro/settings/` directory structure
- Create basic hooks.json configuration
- Create Python validation framework

**Wave 2: Core Hooks**
- Implement Planning Lock (PreToolUse)
- Implement syntax validation (PostToolUse)
- Test with simple file edits

**Wave 3: Advanced Validation**
- Add language-specific linters
- Add multi-file validation
- Add error reporting improvements

### Script Organization

```
.kiro/
├── settings/
│   └── hooks.json
└── scripts/
    ├── validate_syntax.py
    ├── check_planning_lock.py
    └── utils/
        ├── hook_input.py
        └── state_reader.py
```

### Testing Strategy

1. Create test files with intentional errors
2. Trigger hooks manually
3. Verify error messages appear
4. Verify Claude receives feedback
5. Test cross-platform (if possible)

---

## Open Questions

1. Should hooks be project-level or user-level?
   - **Recommendation**: Project-level (`.kiro/settings/hooks.json`)
   - Reason: Team shares same validation rules

2. What happens if validation tools aren't installed?
   - **Recommendation**: Graceful degradation
   - Check if tool exists, skip if not, log warning

3. How verbose should error messages be?
   - **Recommendation**: Concise but actionable
   - Format: `[file:line] error: description`

---

## References

- `resarch/hooks.md` - Complete Kiro hooks documentation
- `resarch/ideas.md` - Integration concepts
- Kiro docs: https://code.claude.com/docs/hooks

---

## Next Steps

Proceed to planning with this research as foundation.
