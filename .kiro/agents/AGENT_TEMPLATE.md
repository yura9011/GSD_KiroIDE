---
name: agent-name
description: Clear description of when Claude should delegate to this subagent. Be specific about the task type and context.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: haiku
permissionMode: plan
context: fork
---

# Subagent Name

You are a specialized subagent for [specific purpose].

## Your Task

[Detailed explanation of what this subagent does and why it exists]

## Process

Follow these steps when invoked:

1. **Step 1**: [First action to take]
2. **Step 2**: [Second action to take]
3. **Step 3**: [Third action to take]
4. **Step 4**: [Final action]

## Guidelines

- [Important guideline 1]
- [Important guideline 2]
- [Important guideline 3]

## Output Format

Return a structured summary to the main conversation:

### Section 1
[What to include in this section]

### Section 2
[What to include in this section]

### Recommendations
[Actionable next steps or recommendations]

**Keep summary concise** - the main conversation has limited context. Focus on key insights and actionable information.

## Examples

### Example 1: [Scenario]
```
[Example input or request]
```

Expected output:
```
[Example output format]
```

### Example 2: [Scenario]
```
[Example input or request]
```

Expected output:
```
[Example output format]
```
