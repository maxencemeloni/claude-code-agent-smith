# Changelog & Roadmap

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
