---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: Syntax Validation Hook

## Objective

Implement PostToolUse hook that automatically validates code syntax after file edits, creating the "auto-correction loop" for zero syntax errors.

## Context

- ROADMAP.md (Phase 1: PostToolUse hooks for validation)
- .gsd/phases/1/RESEARCH.md (Validation tools by language)
- .kiro/settings/hooks.json (existing hooks)
- .kiro/scripts/utils/ (shared utilities)

## Tasks

<task type="auto">
  <name>Create syntax validation script</name>
  <files>.kiro/scripts/validate_syntax.py</files>
  <action>
    Create Python script that validates code syntax:
    
    **Logic**:
    1. Import utilities from .kiro/scripts/utils/
    2. Read hook input from stdin
    3. Extract file_path from tool_input
    4. Detect language from file extension
    5. Run appropriate validator:
       - .py → python -m py_compile
       - .js/.ts → node --check (if node available)
       - .json → python -m json.tool
       - .md → basic structure check
    6. If validation fails: exit(2) with error details
    7. If validation passes: exit(0)
    
    **Error message format**:
    ```
    Syntax Error in [file]:
    [validator output]
    
    Fix the syntax error and try again.
    ```
    
    **Graceful degradation**: If validator not installed, skip with warning
    
    WHY PostToolUse: Runs AFTER file is written, validates result
    AVOID: Installing validators - check if available first
  </action>
  <verify>python .kiro\scripts\validate_syntax.py < test_input.json</verify>
  <done>Script validates Python, JSON, and handles missing validators</done>
</task>

<task type="auto">
  <name>Register syntax validation hook</name>
  <files>.kiro/settings/hooks.json</files>
  <action>
    Update hooks.json to register syntax validation:
    
    Add to PostToolUse array:
    ```json
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "python .kiro/scripts/validate_syntax.py",
          "timeout": 10
        }
      ]
    }
    ```
    
    **Why PostToolUse**: Validates AFTER file is written
    **Why timeout 10**: Syntax checks can take a few seconds
    **Why same matcher**: Validate all code writes/edits
  </action>
  <verify>type .kiro\settings\hooks.json</verify>
  <done>hooks.json contains PostToolUse hook with correct configuration</done>
</task>

<task type="checkpoint:human-verify">
  <name>Test auto-correction loop</name>
  <files>test_syntax.py</files>
  <action>
    Manual test of auto-correction:
    
    1. Ask Claude to create a Python file with intentional syntax error
    2. Verify hook catches the error
    3. Verify Claude receives error message
    4. Verify Claude automatically fixes the error
    5. Verify hook passes on corrected version
    
    This validates the "auto-correction loop" works.
  </action>
  <verify>User confirms Claude auto-corrects syntax errors</verify>
  <done>Auto-correction loop successfully prevents syntax errors</done>
</task>

## Success Criteria

- [ ] validate_syntax.py script exists and is functional
- [ ] Hook registered in hooks.json
- [ ] Hook validates Python syntax correctly
- [ ] Hook validates JSON syntax correctly
- [ ] Hook handles missing validators gracefully
- [ ] Claude auto-corrects when validation fails
- [ ] Changes committed to git

## Notes

This creates the "zero syntax errors" guarantee - Claude cannot proceed with broken code.
