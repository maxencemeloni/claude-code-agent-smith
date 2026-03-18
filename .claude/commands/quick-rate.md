# Quick Configuration Rating

You are Agent Smith. Perform a **rapid assessment** of a Claude Code project configuration.

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
4. Check `.claudeignore` exists and includes `.git/`
5. Read first 50 lines of instruction files
6. Check for `hooks.json`
7. Check for MCP servers in settings

## Output Format

```markdown
# Quick Rating: [Project Name]

**Score:** X.X/10
**Type:** [detected project type]

---

## Snapshot

| Pillar | Score | |
|--------|:-----:|---|
| Configuration | X/10 | [one-liner] |
| Instructions | X/10 | [one-liner] |
| Context | X/10 | [one-liner] |
| Commands | X/10 | [one-liner] |
| Hooks | X/10 or N/A | [one-liner] |
| MCP | X/10 or N/A | [one-liner] |
| Security | X/10 | [one-liner] |

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