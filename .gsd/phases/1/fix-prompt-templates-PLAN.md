---
phase: 1
plan: fix-prompt-templates
wave: 1
gap_closure: true
---

# Fix Plan: Missing Prompt Templates

## Problem
PROMPT_build.md and PROMPT_plan.md are missing, preventing Ralph Loop from functioning. These templates are the "DNA" of Ralph - they define how the AI behaves autonomously.

## Tasks

<task type="auto">
  <name>Create PROMPT_build.md with Geoffrey Huntley's exact template</name>
  <files>PROMPT_build.md</files>
  <action>
    Create the build mode prompt following Geoffrey Huntley's exact template structure from research:
    - Phase 0 (0a, 0b, 0c): Orient by studying specs, IMPLEMENTATION_PLAN.md, source code
    - Phase 1-4: Main instructions for implementation, validation, commit
    - 999... numbering system for guardrails (higher number = more critical)
    - Exact subagent patterns: up to 500 Sonnet for searches, 1 for build/tests, Opus for reasoning
    - Integration with GSD validation scripts in guardrails
    - Atomic commit instructions with proper git workflow
    
    Use exact template from .gsd/phases/1/RESEARCH.md with GSD-specific adaptations:
    - Reference specs/roadmap.md instead of generic specs
    - Use ./scripts/validate-all.sh for validation
    - Maintain exact 999... guardrail numbering system
  </action>
  <verify>grep -q "0a\. Study" PROMPT_build.md && grep -q "999999999999" PROMPT_build.md</verify>
  <done>PROMPT_build.md exists with exact Geoffrey Huntley template structure and GSD integration</done>
</task>

<task type="auto">
  <name>Create PROMPT_plan.md for autonomous task planning</name>
  <files>PROMPT_plan.md</files>
  <action>
    Create the planning mode prompt for generating/updating IMPLEMENTATION_PLAN.md:
    - Study specs/ to understand requirements
    - Analyze current IMPLEMENTATION_PLAN.md state
    - Generate new tasks or update existing ones
    - Prioritize tasks by dependencies and importance
    - Update IMPLEMENTATION_PLAN.md with findings
    - Commit changes with descriptive message
    
    Planning mode is simpler than build mode - focused on task generation and prioritization.
  </action>
  <verify>grep -q "IMPLEMENTATION_PLAN.md" PROMPT_plan.md && grep -q "specs" PROMPT_plan.md</verify>
  <done>PROMPT_plan.md exists and focuses on task planning and IMPLEMENTATION_PLAN.md updates</done>
</task>

## Success Criteria
- [ ] PROMPT_build.md follows exact Geoffrey Huntley template with GSD integration
- [ ] PROMPT_plan.md enables autonomous task planning and updates
- [ ] Both templates use proper file references and validation integration