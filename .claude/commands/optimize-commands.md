---
description: "[Agent Smith] Command & Extension Quality Analysis"
---

# Command & Extension Quality Analysis

You are Agent Smith. Analyze and optimize **custom slash commands, agents, and skills**.

Refer to `AGENT_SMITH.md` for command and extension design criteria.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Scope

**Analyze:**
- All `.md` files in `.claude/commands/`
- All `.md` files in `.claude/agents/` (if present)
- All `SKILL.md` files in `.claude/skills/*/` (if present)

## Important Note

This analyzes user-created extensions, not Claude Code's built-in tools. You cannot modify or analyze built-in tool schemas.

## Evaluation Criteria

### 1. Naming (0-10)

- Descriptive, clear purpose
- Follows conventions (verb-noun or clear noun)
- Not too long, not too cryptic
- Consistent with other commands

**Good names:**
- `analyze-agent`, `create-config`, `validate-setup`

**Poor names:**
- `do-stuff`, `cmd1`, `process`

### 2. Input Handling (0-10)

- `$ARGUMENTS` documented clearly
- Default behavior defined
- Input validation described
- Examples provided

**Good:**
```markdown
## Input
$ARGUMENTS - Repository path (defaults to current directory)
```

**Poor:**
```markdown
## Input
$ARGUMENTS
```

### 3. Structure (0-10)

- Clear sections (Input, Process, Output)
- Logical flow
- Appropriate length
- Easy to follow

### 4. Output Definition (0-10)

- Expected output format defined
- Examples of output shown
- Consistent with other commands

### 5. Scope (0-10)

- Does one thing well
- Not trying to do too much
- Clear boundaries
- No overlap with other commands

### 6. Efficiency (0-10)

- Concise instructions
- No redundant content
- No copied content that should be referenced
- Appropriate level of detail

## Agent Evaluation Criteria (if agents exist)

### 1. Model Choice (0-10)
- Appropriate model for the agent's role (haiku for workers, sonnet for main tasks, opus for complex reasoning)
- Not using opus for simple tasks (cost waste)

### 2. Tool Scoping (0-10)
- `tools` field present and specific
- Not granting all tools when only a few are needed
- Bash tool justified if included

### 3. Role Clarity (0-10)
- Clear description of what the agent does
- Single responsibility
- No overlap with other agents

## Skill Evaluation Criteria (if skills exist)

### 1. Structure (0-10)
- Frontmatter with `name` and `description`
- "When to Activate" section present
- Concrete examples (GOOD/BAD patterns preferred)

### 2. Security (0-10)
- No external URLs without guardrail comments
- No hardcoded personal paths

### 3. Scope (0-10)
- Doesn't duplicate content from CLAUDE.md or rules
- Focused on a specific domain or workflow

## Process

1. List all commands in `.claude/commands/`
2. List all agents in `.claude/agents/` (if present)
3. List all skills in `.claude/skills/` (if present)
4. Read each file
5. Evaluate against respective criteria
6. Check for redundancy across all extensions
7. Suggest improvements

## Output Format

```markdown
# Command Analysis: [Project Name]

---

## Commands Found

| Command | Lines | Rating | Purpose |
|---------|------:|:------:|---------|
| [name] | X | X/10 | [brief description] |

---

## Per-Command Analysis

### /[command-name]

**File:** `.claude/commands/[name].md`
**Rating:** X/10

| Criterion | Score |
|-----------|:-----:|
| Naming | X/10 |
| Input Handling | X/10 |
| Structure | X/10 |
| Output | X/10 |
| Scope | X/10 |
| Efficiency | X/10 |

**Purpose:** [What this command does]

**Issues:**
- [Specific problem with evidence]

**Suggestions:**
- [How to improve]

---

## Agent Analysis (if present)

| Agent | Model | Tools | Role Clarity | Rating |
|-------|:-----:|:-----:|:------------:|:------:|
| [name] | ✓/⚠ | ✓/⚠ | ✓/⚠ | X/10 |

**Issues:**
- [Specific problems]

---

## Skill Analysis (if present)

| Skill | Structure | Security | Scope | Rating |
|-------|:---------:|:--------:|:-----:|:------:|
| [name] | ✓/⚠ | ✓/⚠ | ✓/⚠ | X/10 |

**Issues:**
- [Specific problems]

---

## Cross-Extension Analysis

**Redundancy found:**
- [Content duplicated across commands, agents, or skills]

**Overlap detected:**
- [Extensions with similar purposes]

**Consistency issues:**
- [Inconsistent patterns across extensions]

---

## Recommendations

### High Priority
1. [Most important fix]

### Medium Priority
1. [Secondary improvement]

### Consider
1. [Optional changes]

---

## Command Design Tips

Good commands:
- Have a single, clear purpose
- Handle `$ARGUMENTS` with defaults
- Define expected output format
- Are concise but complete

Avoid:
- Swiss-army-knife commands that do everything
- Vague instructions like "handle appropriately"
- Duplicating content that could be in AGENT_SMITH.md
```

Begin analysis now.
