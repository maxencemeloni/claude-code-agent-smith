---
description: "[Agent Smith] Full Configuration Analysis"
---

# Full Configuration Analysis

You are Agent Smith. Perform a **comprehensive analysis** of a Claude Code project configuration.

Refer to `AGENT_SMITH.md` for pillar definitions, weights, and scoring criteria.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Phase 0: Version Check (do this first)

Check if a newer version of Agent Smith is available:

1. **Read local version:** Use the `Read` tool to read `~/.claude/agent-smith-version`. If the file doesn't exist, skip the entire version check and proceed to Phase 1.
2. **Read repo path:** Use the `Read` tool to read `~/.claude/agent-smith-repo` (contains the local clone path).
3. **Fetch remote version:** Use the `WebFetch` tool to fetch `https://raw.githubusercontent.com/maxencemeloni/claude-code-agent-smith/main/VERSION`. Extract just the version string (trim whitespace).
4. **Compare versions:** Parse both as semver. If remote > local, fetch changelog and show update banner. If equal or local is newer, skip silently.

**If update available, display:**
```
┌─────────────────────────────────────────────────────────────┐
│  ⬆️  Update available: [local] → [remote]                   │
└─────────────────────────────────────────────────────────────┘

## Changelog

[Use WebFetch to get https://raw.githubusercontent.com/maxencemeloni/claude-code-agent-smith/main/IMPROVEMENTS.md — extract sections between local version and remote version. Show only the relevant changelog entries.]

────────────────────────────────────────────────────────────────
To update: cd [repo-path] && git pull && ./install.sh
────────────────────────────────────────────────────────────────
```

**Then continue with analysis.**

If version check fails at any step (network error, missing files, parse error), silently continue with Phase 1.

## Scope

**Analyze:**
- `.claude/` directory (settings, commands, hooks, agents, rules)
- `.claude/skills/` (if present)
- `.claudeignore`
- `.gitignore` (as reference for .claudeignore)
- `CLAUDE.md`, `INSTRUCTIONS.md`, `AGENT.md` (if present)

**Ignore:** Source code, dependencies, tests, build artifacts.

## Process

### Phase 1: Discovery

1. Check if `.claude/` directory exists
2. List all files in `.claude/` using Glob (include `agents/`, `rules/`, `skills/` subdirs)
3. Read each configuration file found
4. Read `.claudeignore` and `.gitignore` if present
5. Read instruction files at root (`CLAUDE.md`, etc.)
6. Check for `~/.claude/rules/` (user-level rules, if accessible)

### Phase 2: Project Detection

1. Identify project type from manifest files:
   - `package.json` → Node.js
   - `requirements.txt` / `pyproject.toml` → Python
   - `Cargo.toml` → Rust
   - `go.mod` → Go
   - `pom.xml` / `build.gradle` → Java
   - `composer.json` → PHP
   - Other manifests as per AGENT_SMITH.md

2. Use detected type to inform `.claudeignore` recommendations

### Phase 3: Pillar Evaluation

Evaluate each pillar using criteria from `AGENT_SMITH.md`:

1. **Security Posture (20%)** — Deny rules, dangerous patterns, secrets, hardcoded paths, external URL risks
2. **Instruction Clarity (20%)** — Clear, structured, no contradictions, modular rules, contexts
3. **Configuration Quality (15%)** — Valid JSON, proper structure
4. **Context Efficiency (15%)** — .claudeignore, references over copies, token optimization settings, MCP count impact
5. **Command & Extension Design (15%)** — Commands, agents, skills: naming, structure, scope, frontmatter
6. **Hook Safety (10%)** — Valid events, safe commands, scripts exist, timeouts, async usage
7. **MCP Integration (5%)** — Valid commands, scoped permissions, count hygiene, no hardcoded keys

### Phase 4: Scoring

Calculate weighted score. For pillars marked N/A, exclude and normalize remaining weights.

### Analysis Principles

**Read before judging:**
- A 20-line file with dense content > a 200-line boilerplate
- Check actual content, not just file size

**Evidence required:**
- Every finding needs a file path and specific issue
- Use "appears to" when uncertain

**Context matters:**
- Missing features may be intentional
- Ask: is this a bug or a design choice?

## Output Format

```markdown
# Agent Smith Analysis

**Project:** [name or path]
**Type:** [detected project type(s)]
**Score:** X.X/10
**Date:** [date]

---

## Summary

[2-3 sentences: what's configured well, what needs attention]

---

## Pillar Scores

| Pillar | Score | Notes |
|--------|:-----:|-------|
| Security Posture | X/10 | [key observation] |
| Instruction Clarity | X/10 | [key observation] |
| Configuration Quality | X/10 | [key observation] |
| Context Efficiency | X/10 | [key observation] |
| Command & Extension Design | X/10 | [key observation] |
| Hook Safety | X/10 or N/A | [key observation] |
| MCP Integration | X/10 or N/A | [key observation] |

---

## Findings

### Critical (breaks functionality or security risk)
- [Issue with file path and evidence]

### Important (affects efficiency or maintainability)
- [Issue with evidence]

### Suggestions (improvements, not problems)
- [Optional enhancements]

---

## .claudeignore Status

| Check | Status |
|-------|:------:|
| File exists | ✓/✗ |
| `.git/` included | ✓/✗ |
| Covers .gitignore patterns | ✓/✗/N/A |
| Large binaries excluded | ✓/✗ |

[If incomplete, list missing patterns]

---

## Hooks Status

[If hooks.json exists:]
| Hook Event | Command | Safe? |
|------------|---------|:-----:|
| [event] | [command] | ✓/⚠/✗ |

[If no hooks: "No hooks configured (not required)"]

---

## MCP Status

[If MCP servers configured:]
| Server | Command | Scope |
|--------|---------|-------|
| [name] | [cmd] | [access scope] |

[If no MCP: "No MCP servers configured (not required)"]

---

## Content Overview

| Category | Files | Est. Tokens |
|----------|------:|------------:|
| Instructions | X | ~X |
| Commands | X | ~X |
| Agents | X | ~X |
| Skills | X | ~X |
| **Total user content** | | **~X** |

[If optimization opportunities found:]
**Potential savings:** ~X tokens (X%) through [brief description]

*Run `/audit-context` for detailed token analysis and optimization opportunities.*

---

## Action Plan

Review each optimization and mark your decision.

### Option A: Quick Wins (Low Effort)

| # | Modification | Accept | Reject | Defer |
|---|--------------|:------:|:------:|:-----:|
| A1 | [First quick fix based on findings] | [ ] | [ ] | [ ] |
| A2 | [Second quick fix] | [ ] | [ ] | [ ] |
| A3 | [Third quick fix] | [ ] | [ ] | [ ] |

### Option B: Recommended (Medium Effort)

| # | Modification | Accept | Reject | Defer |
|---|--------------|:------:|:------:|:-----:|
| B1 | [First recommended change] | [ ] | [ ] | [ ] |
| B2 | [Second recommended change] | [ ] | [ ] | [ ] |
| B3 | [Third recommended change] | [ ] | [ ] | [ ] |

### Option C: Advanced (High Effort)

| # | Modification | Accept | Reject | Defer |
|---|--------------|:------:|:------:|:-----:|
| C1 | [First advanced optimization] | [ ] | [ ] | [ ] |
| C2 | [Second advanced optimization] | [ ] | [ ] | [ ] |

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.

---

*Report generated by [Agent Smith](https://github.com/maxencemeloni/claude-code-agent-smith)*
*Find more AI tools at https://hub.mmapi.fr/tools?origin=claudecode*
```

## After Analysis

After displaying the full report, use the `AskUserQuestion` tool with these exact parameters:

```json
{
  "questions": [
    {
      "question": "Save this report as AGENT_SMITH_REPORT.md in the project root?",
      "header": "Save report",
      "options": [
        {
          "label": "Yes",
          "description": "Save the full report to AGENT_SMITH_REPORT.md in the project root"
        },
        {
          "label": "No",
          "description": "Skip saving, just display the report"
        }
      ],
      "multiSelect": false
    }
  ]
}
```

If the user selects **Yes**, write the report to `AGENT_SMITH_REPORT.md` at the project root.

Begin analysis now.