# Changelog & Roadmap

---

## v1.3.2 — Context Management Advice & Developer Clarity

*Released: March 2026*

### Changes

- **`/compact` session management tip** — `/audit-context` now includes a "Session Management" section in recommendations, advising users to run `/compact` early for better context coherence. Advice scales with config footprint size (warning if >5K tokens, green light if ≤2K tokens).
- **Suggestion intent clarity** — Added "Understanding Suggestions" section in `CLAUDE.md` to ensure contributors distinguish between "for the users" (recommendations in reports) vs "for the tool" (internal changes).

### Files Updated
- `.claude/commands/audit-context.md` — Added Session Management subsection in Recommendations
- `CLAUDE.md` — Added Understanding Suggestions section

---

## v1.3.1 — Interactive Report Save Prompt

*Released: March 2026*

### Changes

- **Interactive save prompt** — `/analyze-agent` now uses `AskUserQuestion` to present an arrow-selectable Yes/No prompt when asking to save the report, instead of requiring the user to type a response.

### Files Updated
- `.claude/commands/analyze-agent.md` — Replaced plain text question with `AskUserQuestion` tool usage

---

## v1.3.0 — Security-First Rebalancing

*Released: March 2026*

### Changes

- **Pillar Weight Rebalancing** — Security is now weighted appropriately:

  | Pillar | Old | New |
  |--------|:---:|:---:|
  | Security Posture | 5% | **20%** |
  | Instruction Clarity | 25% | 20% |
  | Configuration Quality | 15% | 15% |
  | Context Efficiency | 20% | 15% |
  | Command Design | 15% | 15% |
  | Hook Safety | 10% | 10% |
  | MCP Integration | 10% | 5% |

- **Reduced Redundancy** — All commands now reference `AGENT_SMITH.md` for pillar definitions instead of duplicating criteria. This reduces token usage while keeping results identical.

- **Fixed Overpromising** — `fix-agent.md` now correctly states that fixes are performed by editing files, not by automated tools.

### Files Updated
- `AGENT_SMITH.md` — New pillar order and weights
- All 8 command files — Added reference to `AGENT_SMITH.md`
- `fix-agent.md` — Clarified that fixes are manual edits

---

## v1.2.0 — Update Notifications

*Released: March 2026*

### New Features

- **Version Checking** — `/analyze-agent` now checks for updates before analysis:
  - Reads local version from `~/.claude/agent-smith-version`
  - Fetches latest version from GitHub
  - Shows changelog between installed and latest version
  - Provides update command

- **VERSION file** — Track installed version for update checking

### Files Updated
- `VERSION` — New file containing current version
- `install.sh` — Saves version to `~/.claude/agent-smith-version`
- `install.ps1` — Same for Windows
- `/analyze-agent` — Added Phase 0: Version Check

---

## v1.1.0 — Action Plan & Attribution

*Released: March 2026*

### New Features

- **Interactive Action Plan** — Reports now include a decision checklist organized by effort level:
  - Option A: Quick Wins (Low Effort)
  - Option B: Recommended (Medium Effort)
  - Option C: Advanced (High Effort)

  Each optimization has Accept/Reject/Defer checkboxes for easy decision tracking.

- **Report Attribution** — Footer now includes:
  - Link to Agent Smith GitHub repository
  - Link to AI tools hub for discovering more tools

### Files Updated
- `/analyze-agent` — Added Action Plan section and footer
- `/audit-context` — Added footer

---

## v1.0.0 — Honesty Refactor

*Released: March 2026*

A complete rewrite focused on **accuracy and honesty**. The tool now only claims to measure what it can actually measure.

### What Changed

#### Commands Removed
- `/model-routing` — Model routing is not user-configurable in Claude Code
- `/optimize-tools` — Users cannot modify built-in tool schemas

#### Commands Renamed
| Old | New | Reason |
|-----|-----|--------|
| `/audit-tokens` | `/audit-context` | We measure user content, not total tokens |
| `/rate-prompts` | `/rate-instructions` | We analyze instructions, not system prompts |

#### Pillar System Redesigned

From 8 pillars to 7, removing unmeasurable dimensions:

| Removed | Reason |
|---------|--------|
| Memory & State | Not configurable in Claude Code |
| Control Flow | Not configurable in Claude Code |

| Added | Purpose |
|-------|---------|
| Hook Safety | Dedicated hooks.json analysis |
| MCP Integration | Dedicated MCP server analysis |

| Renamed | New Name |
|---------|----------|
| Architecture | Configuration Quality |
| Prompt Engineering | Instruction Clarity |
| Token Optimization | Context Efficiency |
| Tool Design | Command Design |

### New Features

- **Measurable token estimates** — `/audit-context` provides real file measurements
- **Content inventory** — Line counts, character counts, estimated tokens
- **Duplication detection** — Find repeated content across files
- **Optimization opportunities** — Specific savings with before/after estimates
- **Context budget perspective** — Shows what you control vs. what's fixed
- **MCP server analysis** — Validates MCP configuration
- **Hook safety checks** — Detects dangerous commands in hooks
- **Honest disclaimers** — Every report explains its limitations

### Fixed

- Removed false claims about total context measurement
- Removed model routing recommendations (not a feature)
- Removed tool schema optimization (not configurable)
- Fixed outdated paths in settings files
- Cleaned up install script to remove old commands

---

## Current Commands

| Command | Purpose |
|---------|---------|
| `/analyze-agent` | Full 7-pillar analysis with content overview |
| `/audit-context` | Detailed token measurement and optimization |
| `/quick-rate` | Rapid assessment |
| `/validate-agent` | Syntax and structure validation |
| `/fix-agent` | Auto-repair common issues |
| `/create-agent` | Scaffold new configuration |
| `/rate-instructions` | Instruction file quality |
| `/optimize-commands` | Command quality analysis |

---

## Roadmap

### Next Up

| Feature | Description |
|---------|-------------|
| Examples directory | Sample reports and configurations |
| Self-analysis | Run Agent Smith on itself as a test |
| Windows installer update | Update install.ps1 with new commands |

### Recently Completed

| Feature | Version |
|---------|---------|
| Update notifications | v1.2.0 |
| Action plan checkboxes | v1.1.0 |

### Future Ideas

| Feature | Notes |
|---------|-------|
| Compare mode | `/compare-configs before/ after/` |
| Progress tracking | Score history over time |
| CI/CD integration | GitHub Action for validation |
| Community commands | User-contributed analysis commands |

---

## Design Principles

1. **Honesty over hype** — Only claim what we can measure
2. **Scope clarity** — Always explain what's analyzed vs. not
3. **Evidence required** — Every finding needs file paths
4. **Conservative fixes** — When uncertain, flag for manual review
5. **Developer respect** — No dumbed-down language

---

## Out of Scope

These are explicitly **not** goals of this tool:

| Not Supported | Why |
|---------------|-----|
| Total context measurement | System prompt is internal |
| Model routing | Not configurable in Claude Code |
| Tool schema changes | Built-in tools are fixed |
| Runtime analysis | We examine static files only |
| System prompt access | Internal to Claude Code |

Being clear about limitations builds trust.
