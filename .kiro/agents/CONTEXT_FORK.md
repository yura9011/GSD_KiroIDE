# Context Fork Pattern

Understanding how `context: fork` saves context in GSD subagents.

## The Problem

High-volume operations consume massive context:

```
Main Conversation:
├── Your question (50 tokens)
├── Read file 1 (2,000 tokens)
├── Read file 2 (3,000 tokens)
├── Read file 3 (1,500 tokens)
├── Grep search results (5,000 tokens)
├── Read file 4 (2,500 tokens)
├── ... (20 more files)
├── Analysis (1,000 tokens)
└── Total: 50,000+ tokens consumed
```

**Result**: Context window fills quickly, limiting what you can do next.

## The Solution: Context Fork

The `context: fork` configuration creates a separate context window:

```
Main Conversation (your context):
├── Your question (50 tokens)
├── [Subagent delegated]
└── Summary received (200 tokens)
    Total: 250 tokens

Forked Context (subagent's context):
├── Subagent system prompt (500 tokens)
├── Read file 1 (2,000 tokens)
├── Read file 2 (3,000 tokens)
├── ... (all the heavy operations)
├── Analysis (1,000 tokens)
└── Summary generated (200 tokens)
    Total: 50,000 tokens
    [Context destroyed after completion]
```

**Result**: 99.5% context savings in main conversation.

## How It Works

### 1. Delegation
```
User: "Analyze this codebase"
Claude: [Recognizes this matches map-explorer description]
Claude: [Delegates to map-explorer subagent]
```

### 2. Fork Creation
```
New Context Window Created:
- Fresh conversation history
- Subagent's system prompt loaded
- Tools configured per subagent spec
- Permissions inherited from parent
```

### 3. Execution
```
Subagent in Forked Context:
- Reads 50 files
- Runs grep searches
- Analyzes patterns
- Identifies tech stack
- All operations stay in fork
```

### 4. Summary Return
```
Subagent: [Generates concise summary]
Main Conversation: [Receives only the summary]
Fork: [Destroyed, all context released]
```

## Context Usage Comparison

### Example: Codebase Analysis

**Without Context Fork** (inline):
```
Main conversation tokens used:
- package.json read: 500 tokens
- 20 source files read: 30,000 tokens
- grep searches: 5,000 tokens
- directory listings: 2,000 tokens
- analysis: 1,000 tokens
Total: 38,500 tokens in main conversation
```

**With Context Fork** (subagent):
```
Main conversation tokens used:
- Delegation: 50 tokens
- Summary received: 300 tokens
Total: 350 tokens in main conversation

Forked context (destroyed):
- All file reads: 30,000 tokens
- All searches: 5,000 tokens
- Analysis: 3,500 tokens
Total: 38,500 tokens (released after completion)
```

**Savings**: 38,150 tokens (99.1% reduction)

## Lifecycle Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ Main Conversation                                           │
│                                                             │
│ User: "Analyze this codebase"                               │
│   ↓                                                         │
│ Claude: [Delegates to map-explorer]                         │
│   ↓                                                         │
│ ┌─────────────────────────────────────────────────────┐   │
│ │ Forked Context (map-explorer)                       │   │
│ │                                                     │   │
│ │ System Prompt: "You are a codebase analyst..."     │   │
│ │   ↓                                                 │   │
│ │ Read package.json                                   │   │
│ │ Read src/index.ts                                   │   │
│ │ Read src/utils.ts                                   │   │
│ │ ... (50 more files)                                 │   │
│ │ Grep for "import"                                   │   │
│ │ Analyze patterns                                    │   │
│ │   ↓                                                 │   │
│ │ Generate Summary:                                   │   │
│ │ "Tech Stack: TypeScript, React, Node.js            │   │
│ │  Architecture: MVC pattern                          │   │
│ │  Entry Point: src/index.ts                          │   │
│ │  Technical Debt: 3 TODO comments found"             │   │
│ └─────────────────────────────────────────────────────┘   │
│   ↓                                                         │
│ Claude: [Receives summary, fork destroyed]                  │
│   ↓                                                         │
│ Claude: "Based on the analysis, this is a TypeScript..."   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Benefits

### 1. Context Preservation
Main conversation stays clean for:
- Iterative refinement
- Follow-up questions
- Additional tasks
- Long-running sessions

### 2. Cost Efficiency
- Forked context uses cheaper models (Haiku)
- Main conversation uses appropriate model
- No wasted tokens on verbose output

### 3. Parallel Execution
Multiple subagents can run simultaneously:
```
Main: "Research auth, database, and API modules"
  ↓
Fork 1: [Analyzes auth module]
Fork 2: [Analyzes database module]
Fork 3: [Analyzes API module]
  ↓
Main: [Receives 3 summaries, synthesizes findings]
```

### 4. Focused Behavior
Each subagent has:
- Specialized system prompt
- Limited tool access
- Specific permission mode
- Clear output format

## When to Use Context Fork

### ✅ Use Context Fork When:
- Reading many files (>10)
- Running extensive searches
- Analyzing large codebases
- Fetching external documentation
- Running test suites with verbose output
- Parallel independent investigations

### ❌ Don't Use Context Fork When:
- Task needs frequent back-and-forth
- Multiple steps share significant context
- Making quick, targeted changes
- Latency is critical (fork startup overhead)

## Configuration

Enable context fork in subagent frontmatter:

```yaml
---
name: my-subagent
description: When to use this subagent
context: fork  # ← This enables context fork
---
```

Without `context: fork`, subagent shares main conversation context.

## Resuming Forked Subagents

Forked contexts can be resumed:

```
User: "Use map-explorer to analyze auth module"
[Subagent completes, fork destroyed]

User: "Continue that analysis for payment module"
[Claude resumes same subagent, fork recreated with full history]
```

Transcripts stored in: `~/.claude/projects/{project}/{session}/subagents/agent-{id}.jsonl`

## Best Practices

1. **Design for Summaries**: Subagent should return concise, actionable summaries
2. **Limit Tool Access**: Only grant necessary tools to subagent
3. **Use Appropriate Models**: Haiku for exploration, Sonnet for reasoning
4. **Clear Descriptions**: Help Claude know when to delegate
5. **Test Context Savings**: Verify fork is actually saving context

## Troubleshooting

### Context Still Growing
- Verify `context: fork` is set in frontmatter
- Check subagent is returning concise summaries (not full file contents)
- Consider if task is appropriate for subagent

### Subagent Not Being Used
- Make description more specific about when to use
- Explicitly request: "Use [subagent-name] to..."
- Check subagent file exists and has valid frontmatter

### Missing Context in Subagent
- Subagents start fresh - they don't inherit main conversation
- Pass necessary context in delegation message
- Consider if task needs main conversation context

## References

- Kiro Subagents Documentation: `resarch/subagents.md`
- GSD Subagents: `.kiro/agents/README.md`
- Subagent Template: `.kiro/agents/AGENT_TEMPLATE.md`
