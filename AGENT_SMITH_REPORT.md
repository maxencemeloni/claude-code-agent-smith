# Agent Smith Analysis

**Project:** claude-code-agent-smith
**Type:** Generic (Documentation / Claude Code Plugin)
**Score:** 8.2/10
**Date:** 2026-03-23

---

## Summary

Strong configuration with comprehensive security deny rules, well-structured instruction files, and high-quality commands. The main areas for improvement are hardcoded personal paths in committed files (CLAUDE.md) and minor `.claudeignore` drift from `.gitignore`. The new wiring integrity checks are not applicable here — no agents, skills, or contexts are configured.

---

## Pillar Scores

| Pillar | Score | Notes |
|--------|:-----:|-------|
| Security Posture | 7/10 | Comprehensive deny rules; hardcoded personal path in committed CLAUDE.md |
| Instruction Clarity | 9/10 | Excellent structure and project-specific content in both CLAUDE.md and AGENT_SMITH.md |
| Configuration Quality | 9/10 | Valid JSON, specific allow rules, well-organized permissions |
| Context Efficiency | 8/10 | Good .claudeignore coverage; missing `tmp/` directory pattern from .gitignore |
| Command & Extension Design | 8/10 | Well-structured commands; create-agent template has deny rule drift |
| Hook Safety | N/A | No hooks configured |
| MCP Integration | N/A | No MCP servers configured |

---

## Findings

### Critical (breaks functionality or security risk)

None.

### Important (affects efficiency or maintainability)

- **Hardcoded personal path in CLAUDE.md** — Line 185: `/Users/mam/WebstormProjects/claude-code-agent-smith-wiki/`. This is a committed file — if the repo were forked, this path would break. The `release.md` dev command already uses `../claude-code-agent-smith-wiki/` (relative), so CLAUDE.md should match.
- **Hardcoded personal path in settings.local.json** — Line 31: `Read(//Users/mam/.claude/**)`. While this file is gitignored (mitigated for shared use), it leaks the username and is not portable. Line 32: `Read(//opt/homebrew/bin/**)` is also system-specific.
- **Create-agent template deny rule drift** — `.claude/commands/create-agent.md` (dev, line 77-85) and `commands/create-agent.md` (plugin, line 77-85) scaffold settings.json with only 8 deny rules, but the project's own `settings.json` and `AGENT_SMITH.md` reference patterns include 13 rules (missing `.p12`, `.pfx`, `credentials*`, `*token*`, `*password*`). Users who scaffold with `/create-agent` get weaker defaults than Agent Smith recommends.

### Suggestions (improvements, not problems)

- **`.claudeignore` missing `tmp/` directory** — `.gitignore` includes `tmp/` but `.claudeignore` does not. The `tmp/` directory contains test reports and scratch files that should be excluded from Claude's context.
- **No modular rules** — CLAUDE.md is 241 lines. Not yet at the 500-line threshold for splitting, but as the project grows, consider extracting wiki-related instructions and version management into `.claude/rules/`.

---

## .claudeignore Status

| Check | Status |
|-------|:------:|
| File exists | ✓ |
| `.git/` included | ✓ |
| Covers .gitignore patterns | ⚠ |
| Large binaries excluded | ✓ |

Missing from .claudeignore (present in .gitignore): `tmp/`

---

## Hooks Status

No hooks configured (not required).

---

## MCP Status

No MCP servers configured (not required).

---

## Wiring Status

No agents, skills, or contexts configured — wiring checks not applicable.

---

## Content Overview

### File Inventory

| File | Lines | Characters | Est. Tokens |
|------|------:|----------:|-----------:|
| CLAUDE.md | 241 | 9,140 | ~2,285 |
| AGENT_SMITH.md | 423 | 13,599 | ~3,400 |
| .claude/settings.json | 20 | 524 | ~131 |
| .claude/settings.local.json | 35 | 861 | ~215 |
| .claude/commands/analyze-agent.md | 617 | 20,581 | ~5,145 |
| .claude/commands/create-agent.md | 205 | 4,180 | ~1,045 |
| .claude/commands/release.md | 129 | 3,523 | ~881 |
| commands/analyze-agent.md | 615 | 20,225 | ~5,056 |
| commands/create-agent.md | 205 | 4,180 | ~1,045 |
| .claudeignore | 28 | 168 | ~42 |

### Totals

| Category | Files | Est. Tokens | % of User Content |
|----------|------:|------------:|------------------:|
| Instructions | 2 | ~5,685 | 30% |
| Dev Commands | 3 | ~7,071 | 37% |
| Plugin Commands | 2 | ~6,101 | 32% |
| Config | 3 | ~388 | 2% |
| **Total user content** | **10** | **~19,245** | 100% |

---

## Instruction Quality Detail

| File | Clarity | Structure | Completeness | Efficiency | Usefulness | Overall |
|------|:-------:|:---------:|:------------:|:----------:|:----------:|:-------:|
| CLAUDE.md | 9/10 | 10/10 | 9/10 | 8/10 | 9/10 | 9/10 |
| AGENT_SMITH.md | 9/10 | 10/10 | 10/10 | 8/10 | 10/10 | 9/10 |

- **CLAUDE.md** — Excellent table-driven structure, clear design principles, comprehensive repo layout. Contains one hardcoded personal path. Could reference AGENT_SMITH.md for pillar details to avoid slight overlap.
- **AGENT_SMITH.md** — Thorough pillar definitions with scoring rubrics, reference patterns, and project-type detection. Serves as the canonical rules file loaded by all commands.

---

## Extension Quality Detail

### Commands

| Command | Naming | Input | Structure | Output | Scope | Efficiency | Overall |
|---------|:------:|:-----:|:---------:|:------:|:-----:|:----------:|:-------:|
| analyze-agent (dev) | 9/10 | 9/10 | 10/10 | 10/10 | 9/10 | 7/10 | 9/10 |
| create-agent (dev) | 9/10 | 9/10 | 9/10 | 9/10 | 9/10 | 8/10 | 9/10 |
| release (dev) | 9/10 | 9/10 | 10/10 | 8/10 | 9/10 | 9/10 | 9/10 |
| analyze-agent (plugin) | 9/10 | 9/10 | 10/10 | 10/10 | 9/10 | 7/10 | 9/10 |
| create-agent (plugin) | 9/10 | 9/10 | 9/10 | 9/10 | 9/10 | 8/10 | 9/10 |

- **analyze-agent** — Efficiency scored 7/10 due to its large size (~5K tokens each). The 7-phase interactive workflow is comprehensive but heavy. Consider whether report template examples in the command could be shortened.
- **create-agent** — Template deny rules are incomplete vs. project's own recommendations (8 vs. 13 patterns).
- **release** — Well-designed step-by-step process with pre-flight checks and verification.

---

## Action Plan

### Option A: Quick Wins (Low Effort)

| # | Action |
|---|--------|
| A1 | Add `tmp/` to `.claudeignore` to match `.gitignore` |
| A2 | Update create-agent deny rule templates (both dev and plugin) to include all 13 patterns from AGENT_SMITH.md |

### Option B: Recommended (Medium Effort)

| # | Action |
|---|--------|
| B1 | Replace hardcoded wiki path in CLAUDE.md line 185 with relative `../claude-code-agent-smith-wiki/` |

### Option C: Advanced (High Effort)

| # | Action |
|---|--------|
| C1 | Audit analyze-agent command size (~5K tokens each) — consider extracting report template into a separate referenced file to reduce command weight |

---

## Progress History

First analysis with wiring checks — run again after making changes to track progress.

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.

---

*Report generated by [Agent Smith](https://github.com/maxencemeloni/claude-code-agent-smith)*
*Find more AI tools at https://hub.mmapi.fr/tools?origin=claudecode*
