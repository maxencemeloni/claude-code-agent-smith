# Changelog & Roadmap

---

## v2.1.2 — Self-Analysis & Config Cleanup

*Released: March 2026*

### Changes

- **Dogfooded `/analyze-agent` on itself** — Ran a full 7-pillar self-analysis, identified 11 findings across all severity levels, and applied all fixes. Report saved as `AGENT_SMITH_REPORT.md`.

- **Completed deny rules** — Added missing patterns from AGENT_SMITH.md reference: `.p12`, `.pfx`, `credentials*`, `*token*`, `*password*`.

- **Cleaned settings.local.json** — Removed stale `install.sh` allow rules (deleted in v2.0.3), removed overly broad `Bash(curl:*)` and redundant `Bash(git:*)`, removed hardcoded `cp` commands with absolute paths.

- **Added binary patterns to .claudeignore** — Added `*.zip`, `*.tar.gz`, `*.gz`, `*.mp4`, `*.png`, `*.jpg`, `*.pdf`.

- **Fixed dev/plugin command drift** — Dev `create-agent.md` now uses `${CLAUDE_PLUGIN_ROOT}` loading path (was using old `~/.claude/agent-smith-repo`), removed stale `/validate-agent` reference.

- **Fixed stale CLAUDE.md references** — Wiki table "All 8 commands" → "All 2 commands", added `release.md` to repo structure, fixed IMPROVEMENTS.md description.

- **Fixed AGENT_SMITH.md update command** — Now includes marketplace refresh step.

- **Portable release command** — Replaced hardcoded wiki path with relative `../claude-code-agent-smith-wiki/`.

---

## v2.1.1 — Documentation Cleanup & Plugin Update Fix

*Released: March 2026*

### Changes

- **Fixed plugin update instructions** — Update commands now use the full qualified name (`agent-smith@agent-smith-marketplace`) and include the required `claude plugin marketplace update` step before `claude plugin update`. Without the marketplace refresh, updates were not detected.

- **Added version to marketplace.json** — Plugin entry now includes a `version` field alongside `plugin.json` for consistent version resolution.

- **Cleaned IMPROVEMENTS.md** — Removed stale sections (outdated 8-command list, old roadmap, duplicated design principles). File is now changelog-only; the [wiki Roadmap](https://github.com/maxencemeloni/claude-code-agent-smith/wiki/Roadmap) is the single source of truth for planned features.

- **Updated release command** — `/release` now includes `marketplace.json` in the version bump checklist and a post-release verification step with marketplace refresh.

- **Updated CLAUDE.md** — Added `marketplace.json` to files-to-update table, repo structure, and post-release verification instructions.

---

## v2.1.0 — Parallel Execution Phases

*Released: March 2026*

### Changes

- **Parallel execution phases in Phase 7** — After users confirm their fix selections, the execution engine now analyzes file dependencies, groups independent fixes into parallel phases, and executes them concurrently using the Agent tool. Fixes targeting different files run simultaneously; fixes targeting the same file run sequentially in order. This significantly reduces wall-clock time when applying multiple fixes.

- **Phased execution plan display** — Before executing, users now see a phased breakdown showing which fixes run in parallel vs. sequentially, with dependency information.

- **Failure propagation** — If a fix fails, dependent fixes (same file, later phase) are automatically skipped with a clear explanation.

- **New safety rules** — Added "Phase isolation" (no phase starts until the previous completes) and "Fail-safe propagation" rules to the execution phase.

### Files Updated
- `commands/analyze-agent.md` — Rewrote Phase 7 with parallel execution phases
- `.claude/commands/analyze-agent.md` — Same changes (dev mirror)
- `VERSION` — Bumped to 2.1.0
- `.claude-plugin/plugin.json` — Bumped to 2.1.0
- `README.md` — Version badge to 2.1.0
- `IMPROVEMENTS.md` — Added changelog entry

---

## v2.0.3 — Remove Legacy Install Scripts

*Released: March 2026*

### Changes

- **Deleted legacy install/uninstall scripts** — Removed `install.sh`, `install.ps1`, `uninstall.sh`, and `uninstall.ps1` from the repository. These were obsolete since v2.0.0 (plugin distribution).

- **Cleaned up dev commands** — Updated `.claude/commands/analyze-agent.md` and `.claude/commands/create-agent.md` to reference plugin install method instead of `install.sh`. Simplified Phase 0 version check to match plugin version.

### Files Updated
- `install.sh`, `install.ps1`, `uninstall.sh`, `uninstall.ps1` — Deleted
- `.claude/commands/analyze-agent.md` — Removed install.sh references, simplified Phase 0
- `.claude/commands/create-agent.md` — Removed install.sh reference
- `VERSION` — Bumped to 2.0.3
- `.claude-plugin/plugin.json` — Bumped to 2.0.3
- `README.md` — Version badge to 2.0.3
- `IMPROVEMENTS.md` — Added changelog entry

---

## v2.0.2 — Remove Legacy Install Scripts

*Released: March 2026*

### Changes

- **Removed legacy install references** — All references to `install.sh`, `install.ps1`, `uninstall.sh`, and `uninstall.ps1` removed from README, CLAUDE.md, and wiki. Plugin system is the only install method.

- **Simplified documentation** — README Install section no longer has a legacy collapsible; CLAUDE.md dev tasks updated for plugin workflow.

### Files Updated
- `README.md` — Removed legacy install section, version badge to 2.0.2
- `CLAUDE.md` — Updated repo structure, dev tasks, and testing instructions
- `VERSION` — Bumped to 2.0.2
- `.claude-plugin/plugin.json` — Bumped to 2.0.2
- `IMPROVEMENTS.md` — Added changelog entry

---

## v2.0.1 — Marketplace Discovery

*Released: March 2026*

### Changes

- **Added `marketplace.json`** — The plugin system requires a marketplace manifest for remote installation. Added `.claude-plugin/marketplace.json` so users can add the repo as a marketplace and install via `claude plugin install agent-smith`.

- **Updated install instructions** — README, wiki Installation, and wiki Roadmap now show the correct two-step flow: add marketplace first, then install plugin.

### Files Added
- `.claude-plugin/marketplace.json` — Marketplace manifest

### Files Updated
- `README.md` — Two-step install in Quick Start and Install sections, version badge to 2.0.1
- `VERSION` — Bumped to 2.0.1
- `IMPROVEMENTS.md` — Added changelog entry

---

## v2.0.0 — Plugin Distribution

*Released: March 2026*

### Changes

- **Claude Code plugin format** — Agent Smith is now distributed as a native Claude Code plugin. Install with `claude plugin install agent-smith` instead of running `install.sh`.

- **New plugin structure** — Added `.claude-plugin/plugin.json` manifest and root-level `commands/` directory for plugin discovery.

- **Simplified rule loading** — Commands now use `${CLAUDE_PLUGIN_ROOT}/AGENT_SMITH.md` instead of reading a repo path from `~/.claude/agent-smith-repo`. No more two-step file resolution.

- **Automatic updates** — Version checking (Phase 0) simplified to a version display. Updates are handled by the plugin system (`claude plugin update agent-smith`).

- **Legacy install preserved** — `install.sh` and `install.ps1` still work for users who prefer manual installation, but the plugin method is now primary.

### Files Added
- `.claude-plugin/plugin.json` — Plugin manifest
- `commands/analyze-agent.md` — Plugin version of the command (uses `${CLAUDE_PLUGIN_ROOT}`)
- `commands/create-agent.md` — Plugin version of the command (uses `${CLAUDE_PLUGIN_ROOT}`)

### Files Updated
- `README.md` — Plugin install as primary method, legacy collapsed
- `AGENT_SMITH.md` — Added plugin update note
- `CLAUDE.md` — Updated repository structure
- `IMPROVEMENTS.md` — Added changelog entry
- `VERSION` — Bumped to 2.0.0

---

## v1.5.0 — Unified Interactive Workflow

*Released: March 2026*

### Changes

- **Consolidated 9 commands into 2** — `/analyze-agent` now absorbs validation, context audit, instruction rating, command optimization, and auto-fix into a single interactive workflow. `/create-agent` remains separate for scaffolding.

- **New 5-step interactive flow** — After analysis, users walk through an interactive triage:
  1. **Analyze** — Full 7-pillar evaluation with validation, token metrics, instruction quality, and extension ratings
  2. **Save Report** — Automatically saves to `AGENT_SMITH_REPORT.md`
  3. **Triage** — Pick a category: Quick Wins, Recommended, or Advanced
  4. **Decide** — For each finding: Yes (apply) / No (skip) / Custom instruction
  5. **Execute** — Review the execution plan, confirm, and apply all changes

- **Richer report** — Now includes Instruction Quality Detail (per-file clarity/structure/completeness/efficiency/usefulness scores), Extension Quality Detail (per-command/agent/skill ratings), and full Content Overview with token estimates — all in one report.

- **Execution Plan** — Consolidated summary of all user decisions before any changes are made. Users review the full picture, then confirm.

### Commands Removed (absorbed into `/analyze-agent`)
- `/quick-rate` → Pillar Scores table
- `/audit-context` → Content Overview section
- `/validate-agent` → Phase 1: Discovery & Validation
- `/rate-instructions` → Instruction Clarity pillar detail
- `/optimize-commands` → Extension Quality Detail section
- `/fix-agent` → Execution phase
- `/agent-smith-version` → Phase 0: Version Check

### Files Updated
- `.claude/commands/analyze-agent.md` — Complete rewrite with 7-phase interactive workflow
- `install.sh` / `install.ps1` — Reduced to 2 commands, old commands added to cleanup list
- `AGENT_SMITH.md` — Updated commands table
- `CLAUDE.md` — Updated commands overview, repository structure
- `README.md` — Updated commands, sample output, version badge
- `VERSION` — Bumped to 1.5.0
- Wiki: `Commands.md`, `Installation.md`, `Best-Practices.md` — Updated for 2-command structure

---

## v1.4.2 — Fix AGENT_SMITH.md Loading in User Projects

*Released: March 2026*

### Changes

- **Fixed critical bug: rules not loading outside repo** — All commands referenced `AGENT_SMITH.md` as a local file, but it only existed in the Agent Smith repo. When users ran commands in their own projects, Claude had no access to the pillar definitions, weights, or scoring criteria and would improvise its own rules. Commands now read the repo path from `~/.claude/agent-smith-repo` (already saved by `install.sh`) and load `AGENT_SMITH.md` from there. If the file can't be found, users see a clear warning.

### Files Updated
- All 8 command files — Replaced `Refer to AGENT_SMITH.md` with explicit load-from-repo-path instructions
- `README.md` — Updated version badge
- `IMPROVEMENTS.md` — Added changelog entry

---

## v1.4.1 — Version Command & Fixes

*Released: March 2026*

### Changes

- **New `/agent-smith-version` command** — Dedicated command to check installed version, fetch latest from GitHub, show changelog diff, and offer interactive update via `AskUserQuestion`.
- **Fixed `/analyze-agent` version check** — Made tool usage explicit (`Read` for local files, `WebFetch` for remote), added repo path step, clarified semver comparison logic.
- **Fixed `/analyze-agent` save prompt** — `AskUserQuestion` now uses exact JSON parameters instead of vague description, ensuring the interactive Yes/No prompt renders correctly.
- **Fixed uninstall scripts** — `uninstall.sh` and `uninstall.ps1` were outdated (still referenced pre-v1.0.0 commands only). Now include all 9 current commands, old commands for cleanup, and remove version/repo tracking files.
- **Install script branding** — Post-install command list now shows `[Agent Smith]` prefix matching YAML frontmatter descriptions.

### Files Updated
- `.claude/commands/agent-smith-version.md` — New command
- `.claude/commands/analyze-agent.md` — Fixed version check and save prompt
- `install.sh` / `install.ps1` — Added new command, branded output
- `uninstall.sh` / `uninstall.ps1` — Full rewrite with all current commands
- `README.md` — Updated version badge, added command to table
- `CLAUDE.md` — Added command to overview table

---

## v1.4.0 — Extended Scope & CLI Branding

*Released: March 2026*

### Changes

- **Expanded analysis scope** — Agent Smith now analyzes agents (`.claude/agents/`), skills (`.claude/skills/`), modular rules (`.claude/rules/`), and contexts (`.claude/contexts/`) in addition to the existing commands, settings, hooks, and instructions.

- **Pillar rename** — "Command Design" → **"Command & Extension Design"** (15%) — now evaluates commands, agent definitions (frontmatter, model choice, tool scoping), and skill quality (structure, activation triggers, security).

- **Deeper security checks** — New checks for hardcoded personal paths, `--no-verify` flag bypasses, external URLs without guardrails (transitive prompt injection), zero-width Unicode characters, and overly broad agent tool permissions.

- **Richer Instruction Clarity** — Now checks modular rules for duplication with CLAUDE.md, flags large CLAUDE.md files (500+ lines) for splitting, and evaluates context file quality.

- **MCP hygiene** — Warns when >10 MCP servers are active (context window impact), flags hardcoded API keys, recommends `disabledMcpServers` over removal.

- **Token optimization settings** — `/audit-context` now checks for `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`, `MAX_THINKING_TOKENS`, and `CLAUDE_CODE_SUBAGENT_MODEL` settings with recommendations.

- **Hook event expansion** — Validates against full event set including `SessionStart`, `SessionEnd`, `PreCompact`, `UserPromptSubmit`. Checks for timeout values and async usage.

- **CLI branding** — All 8 commands now show `[Agent Smith]` prefix in the Claude Code command picker via YAML frontmatter descriptions.

- **`/validate-agent` expansion** — New validation sections for agents (frontmatter, model, tools), skills (SKILL.md existence, frontmatter), and rules (content, duplication).

- **`/optimize-commands` expansion** — Now evaluates agents (model choice, tool scoping, role clarity) and skills (structure, security, scope) alongside commands.

- **`/rate-instructions` expansion** — Now covers modular rules and context files with overlap detection.

### Files Updated
- `AGENT_SMITH.md` — Expanded scope table, pillar definitions, reference patterns
- All 8 command files — Added `[Agent Smith]` frontmatter, expanded checks
- `README.md` — Updated version, pillar table, issues table, commands table
- `CLAUDE.md` — Updated pillar table

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

*For the roadmap and planned features, see the [wiki](https://github.com/maxencemeloni/claude-code-agent-smith/wiki/Roadmap).*
