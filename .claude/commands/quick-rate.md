---
description: "[Agent Smith] Quick Configuration Rating"
---

# Quick Configuration Rating

You are Agent Smith. Perform a **rapid assessment** of a Claude Code project configuration.

Refer to `AGENT_SMITH.md` for pillar definitions and scoring criteria.

This is a surface-level scan for quick feedback. Use `/analyze-agent` for comprehensive analysis.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Scope

**Scan:** `.claude/` directory, `.claudeignore`, root instruction files.

**Skip:** Deep content analysis, line-by-line review.

## Process

1. Check `.claude/` exists
2. Read `settings.json` (check for deny rules)
3. Count commands in `.claude/commands/`
4. Count agents in `.claude/agents/` (if present)
5. Count skills in `.claude/skills/` (if present)
6. Count rules in `.claude/rules/` (if present)
7. Check `.claudeignore` exists and includes `.git/`
8. Read first 50 lines of instruction files
9. Check for `hooks.json`
10. Check for MCP servers in settings (count active servers)

## Output Format

```markdown
# Quick Rating: [Project Name]

**Score:** X.X/10
**Type:** [detected project type]

---

## Snapshot

| Pillar | Score | |
|--------|:-----:|---|
| Security | X/10 | [one-liner] |
| Instructions | X/10 | [one-liner] |
| Configuration | X/10 | [one-liner] |
| Context | X/10 | [one-liner] |
| Commands & Extensions | X/10 | [one-liner] |
| Hooks | X/10 or N/A | [one-liner] |
| MCP | X/10 or N/A | [one-liner] |

---

## Quick Checks

| Check | Status |
|-------|:------:|
| `.claude/` exists | ✓/✗ |
| `settings.json` valid | ✓/✗ |
| Deny rules present | ✓/✗ |
| `.claudeignore` exists | ✓/✗ |
| `.git/` ignored | ✓/✗ |
| Instruction file exists | ✓/✗ |
| Agents have frontmatter | ✓/✗/N/A |
| Skills have SKILL.md | ✓/✗/N/A |
| MCP count ≤10 | ✓/⚠/N/A |

---

## Strengths
- [What's working]

## Concerns
- [What needs attention]

---

## Quick Wins
- [ ] [Easy fix 1]
- [ ] [Easy fix 2]
- [ ] [Easy fix 3]

---

**Verdict:** [One sentence summary]

*This is a rapid scan. Run `/analyze-agent` for detailed analysis with evidence.*
```

Begin quick rating now.