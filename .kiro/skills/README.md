# GSD Skills for Kiro

Executable documentation that validates itself and guides creation actively.

## Overview

Skills are "living templates" - active Markdown files that:
- Auto-invoke when relevant (based on description)
- Include embedded validation scripts
- Provide progressive disclosure (essential + detailed docs)
- Integrate with hooks for complete automation

## Available Skills

### spec-writer
Creates and validates SPEC.md files for project specifications.

**Triggers**: "spec", "specification", "requirements"

**Validation**: Checks for required sections (Vision, Goals, Success Criteria, etc.)

### roadmap-builder
Creates and validates ROADMAP.md files with phase definitions.

**Triggers**: "roadmap", "phases", "milestone"

**Validation**: Checks milestone header, phase structure, required fields

### commit-helper
Generates atomic commit messages following GSD conventions.

**Triggers**: "commit", "git commit", "atomic commits"

**Features**: Uses git context (status, diff, log) to generate messages

## How Skills Work

### Auto-Invocation

Claude automatically uses skills when your request matches their description:

1. You ask: "Create a spec for my project"
2. Claude sees "spec" matches `spec-writer` description
3. Claude asks to use the skill
4. Skill guides creation with structure
5. Skill runs validation script
6. If validation fails: Claude fixes automatically

### Progressive Disclosure

Skills keep context focused:

- **SKILL.md**: Essential instructions (< 500 lines)
- **reference.md**: Detailed documentation (loaded when needed)
- **scripts/**: Validation scripts (executed, not loaded)

### Validation Scripts

Each skill includes Python validators:

```bash
# Validate SPEC.md
python .kiro/skills/spec-writer/scripts/validate_spec.py SPEC.md

# Validate ROADMAP.md
python .kiro/skills/roadmap-builder/scripts/validate_roadmap.py ROADMAP.md
```

Scripts check:
- File exists
- Required sections present
- Structure is correct
- Content is not empty

## Integration with Hooks

Skills and Hooks work together:

| Component | Purpose | When |
|-----------|---------|------|
| **Skills** | Guide creation | During creation |
| **Hooks** | Enforce rules | Before/after operations |

**Example flow**:
1. User asks to create SPEC.md
2. `spec-writer` skill guides creation
3. Skill runs validation script
4. If valid: file is written
5. `PostToolUse` hook validates syntax
6. If syntax error: Claude fixes
7. Result: Valid, well-structured SPEC.md

## Creating New Skills

### 1. Create Skill Directory

```bash
mkdir -p .kiro/skills/my-skill/scripts
```

### 2. Create SKILL.md

Use the template:

```yaml
---
name: my-skill
description: What this skill does and when to use it. Include trigger keywords.
allowed-tools: Read, Write, Bash
---

# My Skill

## Overview
Brief description.

## When to Use
- Scenario 1
- Scenario 2

## Instructions
Step-by-step guidance for Claude.

## Validation
Run: `python .kiro/skills/my-skill/scripts/validate.py`

## Examples
Concrete examples.
```

### 3. Create Validation Script

```python
#!/usr/bin/env python3
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'utils'))
from validator_base import SkillValidator

class MyValidator(SkillValidator):
    def validate(self, file_path):
        # Your validation logic
        return True

if __name__ == "__main__":
    validator = MyValidator()
    if validator.validate(sys.argv[1]):
        print("✓ Validation passed")
        sys.exit(0)
    sys.exit(1)
```

### 4. Test

```bash
# Test validation
python .kiro/skills/my-skill/scripts/validate.py test_file.md

# Test auto-invocation
# Ask Claude something that matches your description
```

## Troubleshooting

### Skill not auto-invoking

1. Check description includes trigger keywords
2. Make description specific about when to use
3. Test by explicitly mentioning trigger words

### Validation failing incorrectly

1. Test validator directly on file
2. Check file path is correct
3. Review error message for details
4. Verify validator logic is correct

### Skill not found

1. Verify directory structure: `.kiro/skills/skill-name/SKILL.md`
2. Check SKILL.md has valid YAML frontmatter
3. Restart Kiro session to reload skills

## Directory Structure

```
.kiro/skills/
├── README.md                    # This file
├── SKILL_TEMPLATE.md            # Template for new skills
├── utils/
│   ├── __init__.py
│   └── validator_base.py        # Base class for validators
├── spec-writer/
│   ├── SKILL.md
│   ├── reference.md
│   └── scripts/
│       └── validate_spec.py
├── roadmap-builder/
│   ├── SKILL.md
│   ├── reference.md
│   └── scripts/
│       └── validate_roadmap.py
└── commit-helper/
    └── SKILL.md
```

## References

- [Kiro Skills Documentation](https://code.claude.com/docs/skills)
- [GSD System Documentation](../../.gsd/SYSTEM.md)
- [Hooks Documentation](../.kiro/README.md)

## Version

Current version: 1.0.0 (Phase 2 - Skills Migration)
