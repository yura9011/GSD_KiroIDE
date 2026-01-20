---
phase: 2
plan: 4
wave: 3
---

# Plan 2.4: Commit Helper Skill

## Objective

Create skill for generating atomic commit messages following GSD conventions, ensuring clear git history.

## Context

- ROADMAP.md (Phase 2: Skill para commits atómicos)
- .gsd/phases/2/RESEARCH.md (Bash command execution in skills)
- GSD-STYLE.md (commit message conventions)

## Tasks

<task type="auto">
  <name>Create commit helper skill</name>
  <files>.kiro/skills/commit-helper/SKILL.md</files>
  <action>
    Create commit-helper skill with bash integration:
    
    ```yaml
    ---
    name: commit-helper
    description: Generates atomic commit messages following GSD conventions. Use when committing code, after completing tasks, or when user mentions "commit", "git commit", or "atomic commits".
    allowed-tools: Bash(git:*)
    ---
    
    # Commit Helper
    
    ## Overview
    Generates clear, atomic commit messages following GSD format.
    
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
    
    1. Review staged changes
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
    ```
    
    WHY bash integration: Needs git context to generate good messages
    AVOID: Committing without user approval
  </action>
  <verify>type .kiro\skills\commit-helper\SKILL.md</verify>
  <done>Skill file exists with complete structure</done>
</task>

<task type="auto">
  <name>Update GSD workflows to reference skills</name>
  <files>
    .gsd/workflows/new-project.md
    .gsd/workflows/plan.md
    .gsd/workflows/execute.md
  </files>
  <action>
    Update GSD workflow files to mention skills:
    
    **new-project.md**: Add note about spec-writer skill
    ```markdown
    ## 2. Create SPEC.md
    
    Use the spec-writer skill to create SPEC.md with validation.
    The skill will guide you through all required sections.
    ```
    
    **plan.md**: Add note about roadmap-builder skill
    ```markdown
    ## 3. Validate Phase
    
    The roadmap-builder skill can validate ROADMAP.md structure.
    ```
    
    **execute.md**: Add note about commit-helper skill
    ```markdown
    ## 6b. Commit per task
    
    Use the commit-helper skill to generate atomic commit messages.
    ```
    
    WHY update workflows: Guides users to use skills
    AVOID: Rewriting entire workflows - just add skill references
  </action>
  <verify>findstr /C:"skill" .gsd\workflows\new-project.md</verify>
  <done>Workflows reference skills appropriately</done>
</task>

<task type="auto">
  <name>Create skills documentation</name>
  <files>.kiro/skills/README.md</files>
  <action>
    Update skills README with complete documentation:
    
    **Sections**:
    1. Overview - What skills are and how they work
    2. Available Skills - List of all GSD skills
    3. Auto-Invocation - How Claude discovers skills
    4. Creating New Skills - Guide for extending
    5. Validation Scripts - How validators work
    6. Integration with Hooks - How skills and hooks work together
    7. Troubleshooting - Common issues
    
    **Include**:
    - Examples of each skill
    - Trigger keywords for auto-invocation
    - Validation script usage
    - Links to Kiro documentation
    
    WHY comprehensive docs: Skills are new concept for GSD users
    AVOID: Duplicating Kiro's skill docs - link to them
  </action>
  <verify>type .kiro\skills\README.md</verify>
  <done>README.md exists with complete documentation</done>
</task>

## Success Criteria

- [ ] commit-helper skill exists with bash integration
- [ ] Skill generates proper commit messages
- [ ] GSD workflows reference skills
- [ ] Skills README.md is comprehensive
- [ ] All skills documented with examples
- [ ] Changes committed to git

## Notes

Phase 2 complete! Templates are now "living" - they validate themselves and guide creation actively.
