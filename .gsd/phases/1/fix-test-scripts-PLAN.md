---
phase: 1
plan: fix-test-scripts
wave: 1
gap_closure: true
---

# Fix Plan: Missing Test Scripts

## Problem
test-ralph.sh and test-ralph.ps1 are missing, preventing validation of the complete Ralph Loop system before first autonomous run.

## Tasks

<task type="auto">
  <name>Create test-ralph.sh for Linux/Mac validation</name>
  <files>test-ralph.sh</files>
  <action>
    Create bash test script that validates the complete Ralph Loop system:
    - Test loop.sh help functionality
    - Verify all required files exist (AGENTS.md, PROMPT_*.md, specs/, IMPLEMENTATION_PLAN.md)
    - Test mode switching (plan/build)
    - Validate integration with existing GSD validation scripts
    - Test error handling and exit codes
    - Create dry-run mode that doesn't call AI but validates file structure
    - Provide clear pass/fail output with specific error messages
    
    Focus on file structure and basic functionality, not actual AI execution.
  </action>
  <verify>chmod +x test-ralph.sh && ./test-ralph.sh --dry-run</verify>
  <done>test-ralph.sh exists, is executable, and validates complete Ralph Loop system setup</done>
</task>

<task type="auto">
  <name>Create test-ralph.ps1 for Windows validation</name>
  <files>test-ralph.ps1</files>
  <action>
    Create PowerShell test script equivalent to bash version:
    - Test loop.ps1 help functionality
    - Verify all required files exist with same checks as bash version
    - Test mode switching and parameter validation
    - Cross-platform compatibility verification
    - Same dry-run functionality as bash version
    - Consistent output format and error reporting
    
    Maintain identical functionality to bash version for cross-platform consistency.
  </action>
  <verify>powershell -ExecutionPolicy Bypass -File test-ralph.ps1 -DryRun</verify>
  <done>test-ralph.ps1 exists and provides identical validation functionality to bash version</done>
</task>

## Success Criteria
- [ ] test-ralph.sh validates complete Ralph Loop system configuration
- [ ] test-ralph.ps1 provides identical functionality on Windows
- [ ] Both scripts provide clear pass/fail output with specific error messages
- [ ] Dry-run mode works without requiring AI CLI
- [ ] Cross-platform compatibility verified through testing