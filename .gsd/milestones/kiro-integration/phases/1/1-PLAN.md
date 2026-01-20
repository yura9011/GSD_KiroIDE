---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Hook Infrastructure Setup

## Objective

Create the foundational directory structure and configuration files for Kiro hooks, establishing the framework for auto-validation and rule enforcement.

## Context

- ROADMAP.md (Phase 1 objectives)
- .gsd/phases/1/RESEARCH.md (Hook implementation strategy)
- resarch/hooks.md (Kiro hooks documentation)

## Tasks

<task type="auto">
  <name>Create Kiro directory structure</name>
  <files>
    .kiro/settings/hooks.json
    .kiro/scripts/utils/__init__.py
  </files>
  <action>
    Create the `.kiro/` directory structure for hooks:
    
    1. Create `.kiro/settings/` directory
    2. Create `.kiro/scripts/` directory for validation scripts
    3. Create `.kiro/scripts/utils/` for shared utilities
    4. Create empty `__init__.py` to make utils a Python package
    
    This establishes the foundation for all hook-related files.
    
    AVOID: Creating hooks.json yet (next task handles that)
  </action>
  <verify>dir .kiro /s /b</verify>
  <done>Directories exist: .kiro/settings/, .kiro/scripts/, .kiro/scripts/utils/</done>
</task>

<task type="auto">
  <name>Create base hooks configuration</name>
  <files>.kiro/settings/hooks.json</files>
  <action>
    Create `.kiro/settings/hooks.json` with placeholder structure:
    
    ```json
    {
      "hooks": {
        "PreToolUse": [],
        "PostToolUse": [],
        "SessionStart": []
      }
    }
    ```
    
    This file will be populated with actual hooks in subsequent plans.
    
    WHY empty arrays: We build incrementally, testing each hook individually.
  </action>
  <verify>type .kiro\settings\hooks.json</verify>
  <done>hooks.json exists with valid JSON structure</done>
</task>

<task type="auto">
  <name>Create Python utility modules</name>
  <files>
    .kiro/scripts/utils/hook_input.py
    .kiro/scripts/utils/state_reader.py
  </files>
  <action>
    Create shared Python utilities for hook scripts:
    
    **hook_input.py**: Parse JSON from stdin
    - Function: `read_hook_input()` returns dict
    - Handles JSON parsing errors gracefully
    - Extracts common fields (tool_name, tool_input, file_path)
    
    **state_reader.py**: Read and parse STATE.md
    - Function: `read_state()` returns dict with status, phase
    - Function: `is_planning_phase()` returns boolean
    - Handles missing STATE.md gracefully
    
    These utilities will be imported by all validation scripts.
    
    AVOID: Complex logic - keep utilities simple and focused
  </action>
  <verify>python -c "from .kiro.scripts.utils import hook_input, state_reader; print('OK')"</verify>
  <done>Both utility modules exist and are importable</done>
</task>

## Success Criteria

- [ ] `.kiro/settings/hooks.json` exists with valid JSON
- [ ] `.kiro/scripts/utils/` contains hook_input.py and state_reader.py
- [ ] Python utilities are importable and functional
- [ ] Directory structure matches Kiro conventions
- [ ] All files committed to git

## Notes

This plan creates the skeleton. Actual hook implementations come in Plans 1.2 and 1.3.
