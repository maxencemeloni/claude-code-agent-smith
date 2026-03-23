# Agent Smith Analysis

**Project:** claude-code-agent-smith
**Type:** Claude Code Plugin (no runtime manifest detected)
**Score:** 6.4/10
**Date:** 2026-03-23

---

## Summary

Strong security foundation with comprehensive deny rules and well-structured instruction files. However, `settings.local.json` contains hardcoded personal paths, stale references to deleted install scripts, and overly broad allow rules (`Bash(curl:*)`, `Bash(git:*)`). The dev-time commands have drifted from the plugin commands in rule loading paths, and CLAUDE.md has several stale references.

---

## Pillar Scores

| Pillar | Score | Notes |
|--------|:-----:|-------|
| Security Posture | 6/10 | Good deny rules but incomplete; overly broad allows in settings.local.json |
| Instruction Clarity | 7/10 | CLAUDE.md is well-structured but has stale references (wiki "8 commands", missing release.md in repo structure) |
| Configuration Quality | 5/10 | settings.json is clean, but settings.local.json has stale/broad rules and hardcoded paths |
| Context Efficiency | 7/10 | .claudeignore covers basics but missing binary patterns; no large binaries in repo |
| Command & Extension Design | 7/10 | Commands are well-structured; dev create-agent uses old loading path |
| Hook Safety | N/A | No hooks configured |
| MCP Integration | N/A | No MCP servers configured |

---

## Findings

### Critical (breaks functionality or security risk)

- **Hardcoded personal paths in settings.local.json** — Lines 22, 35-36: `Read(//Users/mam/.claude/**)`, `Bash(cp /Users/mam/...)`. These break portability and leak the username. Move to `.claude/settings.local.json` is gitignored, so this is mitigated for shared use, but still a hygiene issue.

- **Hardcoded personal paths in release.md** — `.claude/commands/release.md` lines 59, 85: `/Users/mam/WebstormProjects/claude-code-agent-smith-wiki/`. This command is dev-only (not in `commands/`), but if the repo were forked, it would break.

- **Dev create-agent.md uses old loading path** — `.claude/commands/create-agent.md` line 9: reads `~/.claude/agent-smith-repo` (pre-v2.0.0 method). Plugin `commands/create-agent.md` correctly uses `${CLAUDE_PLUGIN_ROOT}`. The dev command should match.

### Important (affects efficiency or maintainability)

- **Incomplete deny rules** — `settings.json` is missing patterns from AGENT_SMITH.md reference: `Read(./**/*.p12)`, `Read(./**/*.pfx)`, `Read(./**/credentials*)`, `Read(./**/*token*)`, `Read(./**/*password*)`.

- **Stale allow rules in settings.local.json** — Line 18: `Bash(./install.sh:*)` and line 23: `Bash(bash install.sh)` — install scripts were deleted in v2.0.3.

- **Overly broad allow rules** — `Bash(curl:*)` (line 30) allows any curl command including data exfiltration. `Bash(git:*)` (line 34) makes all the specific git allows above it redundant.

- **Wiki Structure table says "All 8 commands documented"** — CLAUDE.md line 187. There are only 2 commands since v1.5.0.

- **Repo structure in CLAUDE.md is incomplete** — Missing `release.md` in `.claude/commands/` listing. Also still says `# Changelog and roadmap` for IMPROVEMENTS.md when it's now changelog-only.

### Suggestions (improvements, not problems)

- **Add binary patterns to .claudeignore** — Missing: `*.zip`, `*.tar.gz`, `*.gz`, `*.mp4`, `*.png` (assets/ has images), `*.jpg`, `*.pdf`.

- **AGENT_SMITH.md update command reference** — Line 396: `claude plugin update agent-smith` should be `claude plugin marketplace update agent-smith-marketplace && claude plugin update agent-smith@agent-smith-marketplace`.

- **create-agent.md "Next Steps"** — Dev version (line 197) still references `/validate-agent` which was removed in v1.5.0. Plugin version already fixed this.

---

## .claudeignore Status

| Check | Status |
|-------|:------:|
| File exists | ✓ |
| `.git/` included | ✓ |
| Covers .gitignore patterns | ✓ |
| Large binaries excluded | ✗ |

Missing patterns: `*.zip`, `*.tar.gz`, `*.gz`, `*.mp4`, `*.png`, `*.jpg`, `*.pdf`

---

## Hooks Status

No hooks configured (not required)

---

## MCP Status

No MCP servers configured (not required)

---

## Content Overview

### File Inventory

| File | Lines | Characters | Est. Tokens |
|------|------:|----------:|-----------:|
| CLAUDE.md | 237 | 8,943 | ~2,240 |
| AGENT_SMITH.md | 417 | 13,037 | ~3,260 |
| .claude/settings.json | 15 | 380 | ~95 |
| .claude/settings.local.json | 45 | 1,816 | ~454 |
| .claudeignore | 19 | 112 | ~28 |
| .claude/commands/analyze-agent.md | 515 | 15,479 | ~3,870 |
| .claude/commands/create-agent.md | 206 | 4,357 | ~1,090 |
| .claude/commands/release.md | 129 | 3,573 | ~893 |
| commands/analyze-agent.md | 513 | 15,123 | ~3,781 |
| commands/create-agent.md | 205 | 4,180 | ~1,045 |

### Totals

| Category | Files | Est. Tokens | % of User Content |
|----------|------:|------------:|------------------:|
| Instructions | 2 | ~5,500 | 34% |
| Configuration | 3 | ~577 | 4% |
| Dev Commands | 3 | ~5,853 | 36% |
| Plugin Commands | 2 | ~4,826 | 30% |
| **Total user content** | **10** | **~16,756** | 100% |

Note: Dev commands (`.claude/commands/`) and plugin commands (`commands/`) are largely duplicated content (~8,700 tokens overlap). This is by design (dev mirror + plugin distribution).

---

## Instruction Quality Detail

| File | Clarity | Structure | Completeness | Efficiency | Usefulness | Overall |
|------|:-------:|:---------:|:------------:|:----------:|:----------:|:-------:|
| CLAUDE.md | 8/10 | 8/10 | 7/10 | 7/10 | 8/10 | 7.6/10 |
| AGENT_SMITH.md | 9/10 | 9/10 | 9/10 | 8/10 | 9/10 | 8.8/10 |

**CLAUDE.md** — Well-organized with clear sections. Stale references (wiki "8 commands", missing release.md in structure, IMPROVEMENTS.md description outdated). Good use of tables for version management.

**AGENT_SMITH.md** — Excellent reference document. Clear pillar definitions, comprehensive patterns, honest about limitations. Minor: update command on line 396 is outdated.

---

## Extension Quality Detail

### Commands

| Command | Naming | Input | Structure | Output | Scope | Efficiency | Overall |
|---------|:------:|:-----:|:---------:|:------:|:-----:|:----------:|:-------:|
| analyze-agent | 9/10 | 8/10 | 9/10 | 9/10 | 9/10 | 8/10 | 8.7/10 |
| create-agent | 8/10 | 8/10 | 8/10 | 8/10 | 8/10 | 8/10 | 8.0/10 |
| release (dev-only) | 8/10 | 8/10 | 9/10 | 7/10 | 8/10 | 7/10 | 7.8/10 |

**analyze-agent** — Comprehensive 7-phase workflow with parallel execution. Well-structured with clear safety rules.

**create-agent** — Dev version uses old `~/.claude/agent-smith-repo` loading path (diverged from plugin version). Dev version still references `/validate-agent`.

**release** — Hardcoded wiki path. Good step-by-step structure with verification.

---

## Action Plan

### Option A: Quick Wins (Low Effort)

| # | Action |
|---|--------|
| A1 | Remove stale allow rules from settings.local.json (`install.sh` references) | yes
| A2 | Add missing deny patterns to settings.json (`.p12`, `.pfx`, `credentials*`, `token*`, `password*`) | yes
| A3 | Add binary patterns to .claudeignore (`*.zip`, `*.tar.gz`, `*.mp4`, `*.png`, `*.jpg`) | yes
| A4 | Fix CLAUDE.md wiki table: "All 8 commands" → "All 2 commands" | yes
| A5 | Fix AGENT_SMITH.md update command (line 396) | yes

### Option B: Recommended (Medium Effort)

| # | Action |
|---|--------|
| B1 | Clean up settings.local.json: remove `Bash(git:*)` (makes specific git allows redundant), narrow `Bash(curl:*)` | yes
| B2 | Fix dev create-agent.md loading path to match plugin version (`${CLAUDE_PLUGIN_ROOT}`) | yes
| B3 | Update CLAUDE.md repo structure to include release.md and fix IMPROVEMENTS.md description | yes
| B4 | Fix dev create-agent.md "Next Steps" — remove `/validate-agent` reference | yes

### Option C: Advanced (High Effort)

| # | Action |
|---|--------|
| C1 | Replace hardcoded paths in release.md with a discoverable mechanism (e.g., read wiki path from a config or convention) | yes
| C2 | Audit all hardcoded paths in settings.local.json and replace with relative patterns where possible | yes

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.

---

*Report generated by [Agent Smith](https://github.com/maxencemeloni/claude-code-agent-smith)*
*Find more AI tools at https://hub.mmapi.fr/tools?origin=claudecode*
