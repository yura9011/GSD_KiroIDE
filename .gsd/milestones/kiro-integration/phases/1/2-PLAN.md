---
phase: 1
plan: 2
wave: 2
---

# Plan 1.2: Planning Lock Hook

## Objective

Implement PreToolUse hook that enforces GSD's Planning Lock rule - preventing code writes during planning phase.

## Context

- ROADMAP.md (Phase 1: Planning Lock enforcement)
- .gsd/phases/1/RESEARCH.md (Planning Lock implementation)
- .kiro/settings/hooks.json (created in Plan 1.1)
- .kiro/scripts/utils/ (utilities from Plan 1.1)

## Tasks

<task type="auto">
  <name>Create Planning Lock validation script</name>
  <files>.kiro/scripts/check_planning_lock.py</files>
  <action>
    Create Python script that enforces Planning Lock:
    
    **Logic**:
    1. Import utilities from .kiro/scripts/utils/
    2. Read hook input from stdin
    3. Check if tool is Write or Edit
    4. Read STATE.md using state_reader utility
    5. Check if status contains "planning" or "DRAFT"
    6. If in planning phase: exit(2) with error message
    7. Otherwise: exit(0) to allow operation
    
    **Error message format**:
    ```
    Planning Lock: Cannot write code during planning phase.
    Current status: [status from STATE.md]
    Complete SPEC.md and run /plan first.
    ```
    
    **Make executable**: Add shebang `#!/usr/bin/env python3`
    
    WHY exit(2): Kiro interprets this as blocking error, feeds message to Claude
    AVOID: Complex parsing - use simple string matching
  </action>
  <verify>python .kiro\scripts\check_planning_lock.py < test_input.json</verify>
  <done>Script exists, is executable, handles test input correctly</done>
</task>

<task type="auto">
  <name>Register Planning Lock hook</name>
  <files>.kiro/settings/hooks.json</files>
  <action>
    Update hooks.json to register the Planning Lock hook:
    
    Add to PreToolUse array:
    ```json
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "python .kiro/scripts/check_planning_lock.py",
          "timeout": 5
        }
      ]
    }
    ```
    
    **Why PreToolUse**: Runs BEFORE tool executes, can block it
    **Why matcher**: Only check Write/Edit, not Read operations
    **Why timeout 5**: Planning lock check should be instant
  </action>
  <verify>type .kiro\settings\hooks.json</verify>
  <done>hooks.json contains PreToolUse hook with correct configuration</done>
</task>

<task type="checkpoint:human-verify">
  <name>Test Planning Lock enforcement</name>
  <files>test_file.txt</files>
  <action>
    Manual test of Planning Lock:
    
    1. Ensure STATE.md shows planning status
    2. Ask Claude to create/edit a code file
    3. Verify hook blocks the operation
    4. Verify Claude receives error message
    5. Update STATE.md to execution status
    6. Verify operation now succeeds
    
    This validates the hook works end-to-end.
  </action>
  <verify>User confirms hook blocks during planning, allows during execution</verify>
  <done>Planning Lock successfully enforces GSD rule</done>
</task>

## Success Criteria

- [ ] check_planning_lock.py script exists and is functional
- [ ] Hook registered in hooks.json
- [ ] Hook blocks Write/Edit during planning phase
- [ ] Hook allows Write/Edit during execution phase
- [ ] Error messages are clear and actionable
- [ ] Changes committed to git

## Notes

This is the "policía GSD" - enforces the most critical rule of the framework.
