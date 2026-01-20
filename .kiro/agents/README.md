# GSD Subagents

Specialized AI subagents for high-context GSD operations with context fork pattern.

## Overview

Subagents are specialized AI assistants that handle specific types of tasks in isolated context windows. They help preserve your main conversation context by keeping high-volume operations (codebase exploration, research, verification) in separate contexts.

**Key Benefits:**
- **Context Savings**: Operations stay in forked context, only summaries return
- **Parallel Execution**: Multiple subagents can work simultaneously
- **Specialized Behavior**: Each subagent has focused system prompt and tool access
- **Cost Efficiency**: Use faster, cheaper models (Haiku) for appropriate tasks

## Context Fork Pattern

The `context: fork` configuration creates a separate context window for the subagent:

```
Main Conversation (your context)
    ↓ delegates task
Forked Context (subagent's context)
    [reads 50 files, analyzes patterns]
    ↓ returns summary
Main Conversation (receives 200 tokens instead of 50,000)
```

**Without context:fork**: All file reads and searches appear in your main conversation
**With context:fork**: Only the final summary returns, fork is destroyed after completion

## Available Subagents

### map-explorer
**Purpose**: Codebase architecture analysis for `/map` command
**Model**: Haiku (fast, cheap exploration)
**Tools**: Read, Grep, Glob, Bash (read-only)
**Permission**: plan (read-only mode)

Use when:
- Running `/map` command
- Exploring unfamiliar codebases
- Analyzing tech stack and architecture
- Identifying technical debt

### research-agent
**Purpose**: Technical research for `/research-phase` command
**Model**: Sonnet (needs reasoning)
**Tools**: Read, Grep, WebSearch, WebFetch
**Permission**: default

Use when:
- Running `/research-phase N`
- Researching libraries and APIs
- Comparing technical alternatives
- Gathering implementation information

### verify-agent
**Purpose**: Verification checks for `/verify` command
**Model**: Haiku (fast verification)
**Tools**: Read, Bash
**Permission**: dontAsk (auto-deny prompts, run autonomously)

Use when:
- Running `/verify N`
- Executing test suites
- Running linters and validators
- Parallel verification of multiple components

## When to Use Subagents

### Use Subagents When:
- Operation produces verbose output you don't need in main context
- Task is self-contained and can return a summary
- You want to enforce specific tool restrictions
- Running parallel independent investigations
- High-volume file reading or searching

### Use Main Conversation When:
- Task needs frequent back-and-forth
- Multiple phases share significant context
- Making quick, targeted changes
- Latency matters (subagents start fresh)

## Integration with GSD Workflows

### /map Command
```
/map
```
Automatically uses `map-explorer` subagent to analyze codebase in forked context.

### /research-phase Command
```
/research-phase 2
```
Uses `research-agent` subagent to conduct technical research with web access.

### /verify Command
```
/verify 1
```
Uses `verify-agent` subagent to run verification checks autonomously.

## Context Usage Comparison

**Before (inline analysis)**:
- Main conversation: 50,000 tokens (file reads, searches, analysis)
- Result: Context window fills quickly

**After (with subagent)**:
- Main conversation: 200 tokens (just the summary)
- Subagent context: 50,000 tokens (destroyed after completion)
- Result: 99.6% context savings

## Creating Custom Subagents

Use the template in `AGENT_TEMPLATE.md` or create manually:

```yaml
---
name: my-agent
description: When to use this subagent
tools: Read, Grep, Glob
disallowedTools: Write, Edit
model: haiku | sonnet | opus | inherit
permissionMode: default | plan | dontAsk
context: fork
---

# Subagent Name

System prompt explaining what this subagent does and how to do it.

## Process
1. Step 1
2. Step 2

## Output Format
Return concise summary with key findings.
```

## Troubleshooting

### Subagent Not Being Used
- Check description field is clear about when to use
- Explicitly request: "Use map-explorer subagent to analyze this"
- Verify subagent file exists and has correct frontmatter

### Context Still Growing
- Verify `context: fork` is set in frontmatter
- Check subagent is returning concise summaries
- Consider if task is appropriate for subagent

### Permission Errors
- Check `permissionMode` setting
- Verify tools list includes necessary tools
- Use `dontAsk` mode for autonomous operations

## References

- Kiro Subagents Documentation: `resarch/subagents.md`
- Context Fork Pattern: `.kiro/agents/CONTEXT_FORK.md`
- GSD System: `.gsd/SYSTEM.md`
