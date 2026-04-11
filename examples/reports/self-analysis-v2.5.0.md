# Agent Smith Analysis

**Project:** claude-code-agent-smith
**Type:** Claude Code Plugin (no runtime manifest detected)
**Score:** 7.8/10 (↑ from 6.4 — last analyzed 2026-03-23)
**Date:** 2026-04-11

---

## Summary

Significant improvement since the v2.1.2 self-analysis. Security posture is now solid with complete deny rules, and .claudeignore covers all expected patterns including binaries. Remaining issues are minor: hardcoded personal paths in `settings.local.json` (gitignored, so low risk), a Context Efficiency description mismatch between README.md and CLAUDE.md, and intentional but previously undocumented divergence between dev and plugin command files.

---

## Pillar Scores

| Pillar | Score | Notes |
|--------|:-----:|-------|
| Security Posture | 8/10 | Complete deny rules; settings.local.json has hardcoded personal paths (mitigated by .gitignore) |
| Instruction Clarity | 8/10 | CLAUDE.md well-structured at ~2,170 tokens (good); AGENT_SMITH.md excellent reference doc |
| Configuration Quality | 8/10 | Clean settings.json; settings.local.json is specific and well-scoped |
| Context Efficiency | 7/10 | Good .claudeignore; dev/plugin command duplication is by design (~12K tokens overlap) |
| Command & Extension Design | 8/10 | Well-structured commands; dev/plugin divergence now documented |
| Hook Safety | N/A | No hooks configured |
| MCP Integration | N/A | No MCP servers configured |

---

## Findings

### Critical (breaks functionality or security risk)

- None

### Important (affects efficiency or maintainability)

- **Hardcoded personal paths in settings.local.json** — Line 31: `Read(//Users/mam/.claude/**)`, Line 32: `Read(//opt/homebrew/bin/**)`. These break portability if the file were shared. Mitigated: `.claude/settings.local.json` is gitignored, so this only affects local dev.

- **Dev/plugin analyze-agent.md divergence undocumented** — `.claude/commands/analyze-agent.md` and `commands/analyze-agent.md` differ in rule loading and version loading paths. The divergence is intentional but was not documented, making it look like drift.

### Suggestions (improvements, not problems)

- **Dev analyze-agent.md loading path** — `.claude/commands/analyze-agent.md` line 9 uses the pre-plugin `~/.claude/agent-smith-repo` loading mechanism. This is intentional for local dev (documented in CLAUDE.md), but could confuse contributors unfamiliar with the history.

---

## Action Plan

### Option A: Quick Wins (Low Effort)

| # | Action |
|---|--------|
| A1 | ~~Replace `self-analysis-v2.1.2.md` with a current v2.5.0 example report~~ ✓ Done |
| A2 | ~~Align Context Efficiency description in README.md to match CLAUDE.md~~ ✓ Done |
| A3 | ~~Update IMPROVEMENTS.md v2.2.0 entry to reference the new example report filename~~ ✓ Done |

### Option B: Recommended (Medium Effort)

| # | Action |
|---|--------|
| B1 | ~~Document dev vs plugin command divergence in CLAUDE.md (why loading paths differ)~~ ✓ Done |

### Option C: Advanced (High Effort)

| # | Action |
|---|--------|
| C1 | Replace hardcoded personal paths in settings.local.json with portable patterns (requires rethinking which user-level paths are needed for dev) |

---

## .claudeignore Status

| Check | Status |
|-------|:------:|
| File exists | ✓ |
| `.git/` included | ✓ |
| Covers .gitignore patterns | ✓ |
| Large binaries excluded | ✓ |

All expected patterns present: `.git/`, IDE files, OS files, logs, temp files, and binary formats (`.zip`, `.tar.gz`, `.gz`, `.mp4`, `.png`, `.jpg`, `.pdf`).

---

## Optional Components

No hooks, MCP servers, extensions, or auto-memory conflicts detected.

### Memory Status

| Check | Status | Details |
|-------|:------:|---------|
| Memory directory found | ✓ | `~/.claude/projects/-Users-mam-WebstormProjects-claude-code-agent-smith/memory/` |
| Memory files count | — | 8 files indexed in MEMORY.md |
| Conflicts with config | ✓ | No conflicts detected |
| Stale references | ✓ | All references valid |

> **Note:** Memory files are personal (not committed to the repo). These findings are suggestions to help you keep your local memory aligned with the project configuration.

---

## Wiring Status

No agents, skills, or contexts configured — wiring checks not applicable.

---

## Content Overview

### File Inventory

| File | Lines | Characters | Est. Tokens |
|------|------:|----------:|-----------:|
| CLAUDE.md | 233 | 8,668 | ~2,167 |
| AGENT_SMITH.md | 436 | 15,294 | ~3,824 |
| .claude/settings.json | 20 | 524 | ~131 |
| .claude/settings.local.json | 35 | 861 | ~215 |
| .claudeignore | 28 | 168 | ~42 |
| .claude/commands/analyze-agent.md | 706 | 26,002 | ~6,501 |
| .claude/commands/create-agent.md | 210 | 4,324 | ~1,081 |
| .claude/commands/release.md | 129 | 3,523 | ~881 |
| commands/analyze-agent.md | 704 | 25,646 | ~6,412 |
| commands/create-agent.md | 210 | 4,324 | ~1,081 |

### Totals

| Category | Files | Est. Tokens | % of User Content |
|----------|------:|------------:|------------------:|
| Instructions | 2 | ~5,991 | 27% |
| Configuration | 3 | ~388 | 2% |
| Dev Commands | 3 | ~8,463 | 38% |
| Plugin Commands | 2 | ~7,493 | 33% |
| **Total user content** | **10** | **~22,335** | 100% |

Note: Dev commands (`.claude/commands/`) and plugin commands (`commands/`) are largely duplicated content (~12K tokens overlap). This is by design (dev mirror + plugin distribution).

---

## Cache Efficiency

### Token Budget

| File | Est. Tokens | Loaded | Cache Impact |
|------|------------:|--------|--------------|
| CLAUDE.md | ~2,167 | Always | High — in prefix every turn |
| AGENT_SMITH.md | ~3,824 | On-demand | Low — loaded by commands only |
| .claude/settings.json | ~131 | Always | High — in prefix every turn |
| .claude/settings.local.json | ~215 | Always | High — in prefix every turn |
| .claudeignore | ~42 | Always | High — in prefix every turn |
| .claude/commands/*.md | ~8,463 | On-demand | Low — only when invoked |
| commands/*.md | ~7,493 | On-demand | Low — only when invoked |

**Always-loaded total:** ~2,555 tokens (cache prefix impact)
**On-demand total:** ~19,780 tokens (no cache impact when unused)

### Volatile Content

| File | Volatile Markers | Position | Verdict |
|------|:----------------:|----------|---------|
| CLAUDE.md | 0 | — | Clean |
| AGENT_SMITH.md | 0 | — | Clean |

No `TODO`, `FIXME`, `WIP`, `HACK`, or hardcoded dates found in instruction files.

### CLAUDE.md Size

| Metric | Value | Verdict |
|--------|------:|---------|
| Estimated tokens | ~2,167 | Good (<5K) |

### Duplication Analysis

| Source | Target | Shared Phrases | Verdict |
|--------|--------|:--------------:|---------|
| commands/analyze-agent.md | .claude/commands/analyze-agent.md | ~95% | By design (dev mirror) |
| commands/create-agent.md | .claude/commands/create-agent.md | 100% | By design (dev mirror) |

No unintentional cross-file duplication detected. The dev/plugin command overlap is a deliberate architecture choice.

---

## Instruction Quality Detail

| File | Clarity | Structure | Completeness | Efficiency | Usefulness | Overall |
|------|:-------:|:---------:|:------------:|:----------:|:----------:|:-------:|
| CLAUDE.md | 8/10 | 9/10 | 8/10 | 8/10 | 8/10 | 8.2/10 |
| AGENT_SMITH.md | 9/10 | 9/10 | 9/10 | 8/10 | 9/10 | 8.8/10 |

**CLAUDE.md** — Well-organized with clear sections for design principles, pillars, versioning, repo structure, and dev tasks. Good use of tables. Dev vs plugin parity now documented. Compact at ~2,170 tokens.

**AGENT_SMITH.md** — Excellent reference document with comprehensive pillar definitions, scoring rubrics, reference patterns, and honest scope limitations. Clear separation between what can and cannot be measured.

---

## Extension Quality Detail

### Commands

| Command | Naming | Input | Structure | Output | Scope | Efficiency | Overall |
|---------|:------:|:-----:|:---------:|:------:|:-----:|:----------:|:-------:|
| analyze-agent | 9/10 | 8/10 | 9/10 | 9/10 | 9/10 | 8/10 | 8.7/10 |
| create-agent | 8/10 | 8/10 | 8/10 | 8/10 | 8/10 | 8/10 | 8.0/10 |
| release (dev-only) | 8/10 | 8/10 | 9/10 | 8/10 | 8/10 | 8/10 | 8.2/10 |

**analyze-agent** — Comprehensive 7-phase workflow with parallel execution, progress indicators, and safety rules. Well-structured with clear report template.

**create-agent** — Clean scaffolding command. Identical between dev and plugin versions.

**release** — Good step-by-step structure with pre-flight checks, wiki update, and post-release verification. Uses relative wiki path (`../claude-code-agent-smith-wiki/`).

---

## Progress History

| Date | Score | Delta | Critical | Important | Suggestions |
|------|:-----:|:-----:|:--------:|:---------:|:-----------:|
| 2026-04-11 | 7.8 | ↑ +1.4 | 0 | 3 | 2 |
| 2026-03-23 | 6.4 | — | 3 | 5 | 3 |

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.

---

*Report generated by [Agent Smith](https://github.com/maxencemeloni/claude-code-agent-smith)*
*More plugins at https://agent-smith.mmapi.fr/*
