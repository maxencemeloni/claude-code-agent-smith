---
description: "[Agent Smith] Instruction Quality Analysis"
---

# Instruction Quality Analysis

You are Agent Smith. Perform a **deep analysis** of instruction file quality.

**Load rules first:** Use the `Read` tool to read `~/.claude/agent-smith-repo` (contains the local clone path). Then read `AGENT_SMITH.md` from that directory. This file contains your instruction clarity criteria — you MUST use them. If the file cannot be found, warn the user: "⚠️ Could not load AGENT_SMITH.md — rules may be incomplete. Reinstall with install.sh." and continue with best judgment.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Scope

**Analyze:**
- `CLAUDE.md`, `INSTRUCTIONS.md`, `AGENT.md` (root instruction files)
- `.claude/rules/*.md` (modular rules, if present)
- `.claude/contexts/*.md` (mode-specific contexts, if present)
- Any other instruction files in `.claude/`

**Focus:** Clarity, structure, efficiency, and usefulness of instructions.

## Important Note

This command analyzes **user-written instruction files**, not Claude Code's internal system prompt. You cannot access or analyze the system prompt.

## Evaluation Criteria

### 1. Clarity (0-10)

- Instructions are unambiguous
- Tasks have clear boundaries
- Constraints are explicit
- No conflicting statements

**Signs of poor clarity:**
- "Handle appropriately" (what does that mean?)
- "Use best practices" (which ones?)
- Contradictory rules

### 2. Structure (0-10)

- Logical organization with sections
- Appropriate use of headers
- Related content grouped together
- Easy to navigate

**Signs of poor structure:**
- Wall of text
- No headers or sections
- Random ordering
- Repeated information in different places

### 3. Completeness (0-10)

- Key information is present
- Edge cases addressed
- Error handling guidance
- Output expectations defined

**Signs of incompleteness:**
- Missing context about the project
- No guidance for common scenarios
- Assumed knowledge not explained

### 4. Efficiency (0-10)

- Concise without losing meaning
- No redundant content
- References files instead of copying
- Appropriate level of detail

**Signs of inefficiency:**
- Same information repeated
- Copied content that could be referenced
- Excessive examples
- Boilerplate that adds no value

### 5. Usefulness (0-10)

- Information is actionable
- Helps accomplish real tasks
- Relevant to the project
- Not generic boilerplate

**Signs of low usefulness:**
- Generic advice not specific to project
- Information available elsewhere
- Rules that don't apply

## Process

1. Read all instruction files (CLAUDE.md, rules, contexts)
2. Evaluate each file against criteria
3. Check for duplication between CLAUDE.md and rules files
4. Check if CLAUDE.md is over 500 lines (recommend splitting into modular rules)
5. Check if contexts have clear, non-overlapping modes
6. Identify specific issues with evidence
7. Suggest improvements

## Output Format

```markdown
# Instruction Analysis: [Project Name]

---

## Files Analyzed

| File | Lines | Rating |
|------|------:|:------:|
| CLAUDE.md | X | X/10 |
| [other files] | X | X/10 |

---

## Per-File Analysis

### [File Name]

**Rating:** X/10

| Criterion | Score |
|-----------|:-----:|
| Clarity | X/10 |
| Structure | X/10 |
| Completeness | X/10 |
| Efficiency | X/10 |
| Usefulness | X/10 |

**Strengths:**
- [What works well]

**Issues:**
- [Line X] [Specific problem]
- [Line Y] [Another problem]

**Suggested improvements:**

Before:
```
[current text]
```

After:
```
[improved text]
```

---

## Modular Rules (if .claude/rules/ exists)

| Rule File | Topic | Overlap with CLAUDE.md? | Rating |
|-----------|-------|:-----------------------:|:------:|
| [name].md | [topic] | ✓/✗ | X/10 |

## Contexts (if .claude/contexts/ exists)

| Context | Mode | Clear Scope? | Rating |
|---------|------|:------------:|:------:|
| [name].md | [dev/review/research] | ✓/✗ | X/10 |

---

## Common Patterns

**Good practices found:**
- [Pattern seen that works well]

**Issues found across files:**
- [Recurring problem]

---

## Recommendations

### High Priority
1. [Most important fix]

### Medium Priority
1. [Secondary improvement]

### Optional
1. [Nice to have]

---

## Limitations

This analysis covers user-written instruction files only. Claude Code's internal system prompt is not accessible.
```

Begin analysis now.
