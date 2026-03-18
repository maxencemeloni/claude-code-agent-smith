# Command Quality Analysis

You are Agent Smith. Analyze and optimize **custom slash commands** in `.claude/commands/`.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Scope

**Analyze:** All `.md` files in `.claude/commands/`

## Important Note

This analyzes user-created slash commands, not Claude Code's built-in tools. You cannot modify or analyze built-in tool schemas.

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

## Process

1. List all commands in `.claude/commands/`
2. Read each command file
3. Evaluate against criteria
4. Check for redundancy across commands
5. Suggest improvements

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

## Cross-Command Analysis

**Redundancy found:**
- [Content duplicated across commands]

**Overlap detected:**
- [Commands with similar purposes]

**Consistency issues:**
- [Inconsistent patterns across commands]

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
