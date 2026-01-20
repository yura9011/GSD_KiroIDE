---
name: roadmap-builder
description: Creates and validates ROADMAP.md files with phase definitions. Use when planning project phases, creating milestones, or when user mentions "roadmap", "phases", or "milestone".
allowed-tools: Read, Write
---

# ROADMAP Builder

## Overview

Guides creation of ROADMAP.md with proper phase structure and validation.

## Required Structure

1. **Current Milestone** header with name and goal
2. **Must-Haves** section with checklist
3. **Phases** section with:
   - Phase number and name
   - Status indicator (⬜ Not Started, 🔄 In Progress, ✅ Complete)
   - Objective
   - Key deliverables

## Process

1. Identify milestone name and goal
2. List must-have deliverables (checkboxes)
3. Break work into 3-7 phases
4. For each phase:
   - Define clear objective (one sentence)
   - List 3-5 key deliverables
   - Set status to ⬜ Not Started
5. Create ROADMAP.md
6. Run validation script
7. If validation fails: fix issues automatically

## Validation

Run validation script:

```bash
python .kiro/skills/roadmap-builder/scripts/validate_roadmap.py ROADMAP.md
```

The validator checks:
- [ ] Current Milestone header present
- [ ] Must-Haves section exists
- [ ] Phases section exists
- [ ] At least one phase defined
- [ ] Each phase has Status and Objective fields

## ROADMAP.md Structure

```markdown
# ROADMAP.md

> **Current Milestone**: {name}
> **Goal**: {what this milestone achieves}

## Must-Haves

- [ ] {Must-have 1}
- [ ] {Must-have 2}
- [ ] {Must-have 3}

## Phases

### Phase 1: {name}
**Status**: ⬜ Not Started
**Objective**: {what this phase delivers}

**Key Deliverables:**
- Deliverable 1
- Deliverable 2
- Deliverable 3

### Phase 2: {name}
**Status**: ⬜ Not Started
**Objective**: {what this phase delivers}

**Key Deliverables:**
- Deliverable 1
- Deliverable 2
```

## Examples

### Example 1: New Milestone

```
User: "Create a roadmap for v1.0"
Claude: [Uses roadmap-builder skill]
- Asks about milestone goal
- Identifies must-haves
- Breaks into phases
- Creates ROADMAP.md
- Validates structure
```

### Example 2: Validation

```
User: "Validate my roadmap"
Claude: [Runs validation script]
- Checks structure
- Reports any issues
- Fixes automatically if needed
```

## Phase Guidelines

- **3-7 phases**: Not too few (too big), not too many (too granular)
- **Clear objectives**: One sentence, specific deliverable
- **Logical order**: Dependencies flow naturally
- **Balanced size**: Each phase roughly equal effort

## Status Indicators

- ⬜ **Not Started**: Phase not begun
- 🔄 **In Progress**: Currently executing
- ✅ **Complete**: Verified and done

## Notes

- Start all phases as ⬜ Not Started
- Update status as work progresses
- Must-haves drive phase breakdown
- Each phase should be independently verifiable
