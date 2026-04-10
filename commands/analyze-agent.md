---
description: "[Agent Smith] Full Configuration Analysis"
---

# Full Configuration Analysis

You are Agent Smith. Perform a **comprehensive analysis** of a Claude Code project configuration, then guide the user through an **interactive fix workflow**.

**Load rules first:** Use the `Read` tool to read `${CLAUDE_PLUGIN_ROOT}/AGENT_SMITH.md`. This file contains your pillar definitions, weights, and scoring criteria — you MUST use them. If the file cannot be found, warn the user: "⚠️ Could not load AGENT_SMITH.md — reinstall the plugin." and continue with best judgment.

## Input

$ARGUMENTS - Options:
- A local path to analyze (defaults to current directory)
- `--quick` — Score + Findings + Action Plan only. Skips Instruction Quality Detail, Extension Quality Detail, Content Overview file inventory, and interactive triage. Saves the report and stops.

## Overview

This command runs a **6-step workflow**:

1. **Analyze** — Full 7-pillar evaluation (includes validation, context audit, instruction quality, command quality)
2. **Save Report** — Write report to `AGENT_SMITH_REPORT.md`
3. **Interactive Triage** — User picks which category to address
4. **Item-by-Item Decisions** — User decides on each finding: Yes / No / Custom
5. **Execution Plan** — Show consolidated plan with parallel phases, confirm
6. **Phased Execution** — Execute fixes in parallel phases, report results

---

## Phase 0: Version Display

Read the version from `${CLAUDE_PLUGIN_ROOT}/VERSION` and display it briefly:

```
Agent Smith v[version]
```

Updates are handled automatically by the Claude Code plugin system (`claude plugin update agent-smith`).

**Progress:** At the start of each phase, print a one-line status: `[Phase X/7] Phase name...` (e.g., `[Phase 1/7] Discovery & Validation...`). This keeps users informed during the analysis.

---

## Phase 1: Discovery & Validation

### 1a. Discovery

1. Check if `.claude/` directory exists
2. List all files in `.claude/` using Glob (include `agents/`, `rules/`, `skills/` subdirs)
3. Read each configuration file found
4. Read `.claudeignore` and `.gitignore` if present
5. Read instruction files at root (`CLAUDE.md`, etc.)
6. Check for `~/.claude/rules/` (user-level rules, if accessible)
7. Read `.claude/agent-smith-history.json` if it exists (for progress tracking)
8. **Discover auto-memory files:** Derive the memory directory path from the project path (`~/.claude/projects/<path-with-slashes-replaced-by-dashes>/memory/`). If it exists, read `MEMORY.md` (the index) and all referenced memory files (`.md` files in that directory)

### 1b. Validation (absorbed from /validate-agent)

Run these validation checks and flag failures as findings:

**Structure checks:**
- `.claude/` directory exists
- `settings.json` exists
- At least one instruction file exists

**JSON syntax checks:**
- `.claude/settings.json` parses as valid JSON
- `.claude/settings.local.json` parses as valid JSON (if exists)
- `.claude/hooks.json` parses as valid JSON (if exists)

**Settings checks:**
- `permissions` object exists (if file has content beyond `{}`)
- `deny` is an array (if present)
- `allow` is an array (if present)
- `mcpServers` values have `command` field (if present)

**Extension checks:**
- Commands in `.claude/commands/` are readable and have content
- Agents in `.claude/agents/` have YAML frontmatter with `model` and `tools` (if present)
- Skills in `.claude/skills/` have `SKILL.md` with frontmatter (if present)
- Rules in `.claude/rules/` are not empty and don't duplicate CLAUDE.md (if present)

**File reference checks:**
- References to files in instructions/commands actually exist
- No hardcoded personal paths (`/Users/`, `/home/`)

**Memory conflict checks (if memory files were discovered in 1a step 8):**
- Feedback memories that contradict CLAUDE.md instructions or `.claude/rules/` (e.g., memory says "never mock DB" but a rule says "use mocks for tests")
- Project memories with outdated information that conflicts with current configuration (e.g., memory references a removed command or deprecated workflow)
- Memory files referencing agents, commands, skills, or file paths that no longer exist
- User memories with assumptions that don't match the project setup (e.g., memory says "Python project" but it's now Node.js)

Note: Memory files are **personal** (user-level, not committed to the repo). Frame findings as: "Your local memory may conflict with..." — these are suggestions, never critical severity.

Any validation failure becomes a **Critical** or **Important** finding in the report (except memory conflicts, which are always **Suggestions**).

### 1c. Project Detection

1. Identify project type from manifest files:
   - `package.json` → Node.js
   - `requirements.txt` / `pyproject.toml` → Python
   - `Cargo.toml` → Rust
   - `go.mod` → Go
   - `pom.xml` / `build.gradle` → Java
   - `composer.json` → PHP
   - Other manifests as per the loaded AGENT_SMITH.md rules

2. Use detected type to inform `.claudeignore` recommendations

### 1d. Configuration Wiring Integrity

After discovery, build a **reference graph** across all `.claude/` configuration files and check for wiring issues. This catches broken dispatches, dead config, and stale references that individual file validation misses.

**How to build the graph:**
1. For every agent, command, skill, rule, and context file discovered in 1a, scan its content for references to other agents, commands, skills, or contexts (look for file names like `qa-orchestrator`, command names like `/commit`, skill references, agent dispatch tables, and `Active Agents` / `Active Skills` lists)
2. Build two maps:
   - **defines**: what each file defines (e.g., `.claude/agents/qa-orchestrator.md` defines agent `qa-orchestrator`)
   - **references**: what each file references (e.g., a context file listing `qa-orchestrator` in its Active Agents)

**Checks to run:**

| # | Check | Severity | What to look for |
|---|-------|----------|------------------|
| W1 | **Cross-reference completeness** | Critical | Every agent name referenced in routing tables, dispatch lists, or context files exists as a file in `.claude/agents/`. Every command referenced (e.g., `/commit`, `/build-fix`) exists in `.claude/commands/` or `.claude/skills/` |
| W2 | **Stale references** | Critical | Any context, rule, agent, or skill that references a non-existent agent, command, skill, or file path. Check both explicit paths and name-based references |
| W3 | **Orphan detection** | Suggestion | Agents, commands, or skills that exist on disk but are never referenced by any context, rule, or other agent. These may be intentional standalone items — flag as suggestion, not error |
| W4 | **Context conflict detection** | Important | If multiple contexts exist (e.g., `dev`, `testing`, `qa`), check for contradictory agent/skill lists — e.g., two contexts activating agents with overlapping responsibilities, or a context disabling something another context requires |
| W5 | **Bidirectional consistency** | Suggestion | If agent A references agent B in a routing table, and a context activates A but not B, flag that B may not be discoverable when the context is active |

**Output:** Each wiring issue becomes a finding with:
- The source file (where the reference is)
- The target (what's referenced)
- Whether the target exists or not
- Severity level per the table above

If no `.claude/agents/`, `.claude/contexts/`, or `.claude/skills/` directories exist, skip this phase — wiring checks only apply to configurations with extensions.

---

## Phase 2: Pillar Evaluation

Evaluate each pillar using criteria from the loaded AGENT_SMITH.md rules:

1. **Security Posture (20%)** — Deny rules, dangerous patterns, secrets, hardcoded paths, hardcoded dates (`YYYY-MM-DD` in instruction/rule files — acceptable in changelogs only), external URL risks
2. **Instruction Clarity (20%)** — CLAUDE.md quality, structure, contradictions, modular rules, contexts. **Include per-file quality breakdown** (clarity, structure, completeness, efficiency, usefulness scores for each instruction file — absorbed from /rate-instructions). **Cache efficiency checks:** CLAUDE.md token threshold (<5K good, 5-8K warning, >8K critical), volatile content markers (`TODO`, `FIXME`, `WIP`, `HACK`, hardcoded dates, "last updated" lines), cache-friendly ordering (stable content first, volatile content last — flag volatile markers in top half)
3. **Configuration Quality (15%)** — Valid JSON, proper structure
4. **Context Efficiency (15%)** — .claudeignore, references over copies, token optimization settings, MCP count impact. **Include token measurement** (file inventory with line counts, character counts, estimated tokens for each file — absorbed from /audit-context). **Cache budget:** Distinguish always-loaded files (CLAUDE.md, rules — cache prefix impact) from on-demand files (skills, commands — no cache impact when unused). **Cross-file duplication:** Extract key phrases from instruction files, rules, skills, agents — flag files with 3+ shared phrases as likely duplication
5. **Command & Extension Design (15%)** — Commands, agents, skills: naming, structure, scope, frontmatter. **Include per-extension ratings** (naming, input handling, structure, output, scope, efficiency scores — absorbed from /optimize-commands)
6. **Hook Safety (10%)** — Valid events, safe commands, scripts exist, timeouts, async usage. **Cache impact:** Flag hooks on `PreToolUse`/`UserPromptSubmit` that output dynamic content (timestamps, `git status`, `git diff`) — these destroy cache continuity. Flag hooks that modify CLAUDE.md dynamically
7. **MCP Integration (5%)** — Valid commands, scoped permissions, count hygiene, no hardcoded keys

---

## Phase 3: Scoring

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

---

## Phase 4: Generate Report

Build the report in the following format, then **save it to `AGENT_SMITH_REPORT.md` in the project root**.

After saving:

1. **Update progress history** — Append a new entry to `.claude/agent-smith-history.json`:
   ```json
   {
     "history": [
       {
         "date": "2026-03-23",
         "agentSmithVersion": "2.3.0",
         "score": 7.8,
         "pillars": {
           "security": 7,
           "instructions": 8,
           "configuration": 8,
           "context": 6,
           "extensions": 9,
           "hooks": null,
           "mcp": 7
         },
         "findings": {
           "critical": 1,
           "important": 3,
           "suggestions": 2
         }
       }
     ]
   }
   ```
   - If the file already exists, read it and append the new entry to the `history` array
   - If it doesn't exist, create it with the first entry
   - Use `null` for N/A pillars
   - Tell the user: `"📄 Report saved to AGENT_SMITH_REPORT.md"`
   - Tell the user: `"📊 Score history updated in .claude/agent-smith-history.json"`

2. Display the full report.

**If `--quick` was passed:** After saving the report, display only the Summary, Pillar Scores, Findings, and Action Plan sections. Skip Phases 5-7 entirely and end with: "Quick analysis complete. Run `/analyze-agent` without `--quick` for interactive triage."

### Report Format

```markdown
# Agent Smith Analysis

**Project:** [name or path]
**Type:** [detected project type(s)]
**Score:** X.X/10 [trend indicator if history exists]
**Date:** [date]

### Trend indicator format (only if history exists):
- Score improved: `7.8/10 (↑ from 6.4 — last analyzed 2026-03-15)`
- Score dropped: `7.5/10 (↓ from 8.2 — last analyzed 2026-03-15)`
- Score unchanged: `7.8/10 (— unchanged since 2026-03-15)`

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

## Action Plan

### Option A: Quick Wins (Low Effort)

| # | Action |
|---|--------|
| A1 | [First quick fix based on findings] |
| A2 | [Second quick fix] |
| A3 | [Third quick fix] |

### Option B: Recommended (Medium Effort)

| # | Action |
|---|--------|
| B1 | [First recommended change] |
| B2 | [Second recommended change] |
| B3 | [Third recommended change] |

### Option C: Advanced (High Effort)

| # | Action |
|---|--------|
| C1 | [First advanced optimization] |
| C2 | [Second advanced optimization] |

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

## Wiring Status

[If extensions (agents, skills, contexts) exist:]

| Check | Status | Details |
|-------|:------:|---------|
| Cross-references valid | ✓/✗ | [X references checked, Y broken] |
| No stale references | ✓/✗ | [list any stale refs] |
| No orphaned extensions | ✓/⚠ | [list any orphans] |
| No context conflicts | ✓/⚠/N/A | [list any conflicts] |
| Bidirectional consistency | ✓/⚠/N/A | [list any gaps] |

[If issues found, list each:]
- **[W1] Broken reference:** `contexts/qa.md` references agent `qa-orchestrator` → not found in `.claude/agents/`
- **[W3] Orphan:** `agents/old-worker.md` is not referenced by any context or rule

[If no extensions: "No agents, skills, or contexts configured — wiring checks not applicable."]

---

## Memory Status

[If memory files were discovered:]

| Check | Status | Details |
|-------|:------:|---------|
| Memory directory found | ✓/✗ | [path] |
| Memory files count | — | [X files indexed in MEMORY.md] |
| Conflicts with config | ✓/⚠ | [X potential conflicts found] |
| Stale references | ✓/⚠ | [X memories reference non-existent files/commands] |

[If conflicts found, list each:]
- **Conflict:** Memory `feedback_testing.md` says "never mock the database" — but `.claude/rules/testing.md` recommends mock-based tests
- **Stale:** Memory `project_api_migration.md` references command `/migrate-api` — command no longer exists

[If no memory directory: "No auto-memory found for this project."]

> **Note:** Memory files are personal (not committed to the repo). These findings are suggestions to help you keep your local memory aligned with the project configuration.

**Collapsing empty sections:** If ALL of the following are N/A or empty (Hooks Status, MCP Status, Wiring Status, Memory Status), replace all four sections with a single line:

```
## Optional Components

No hooks, MCP servers, extensions, or auto-memory configured.
```

Only show individual sections when at least one has actual findings or configuration to display.

---

## Content Overview

### File Inventory

| File | Lines | Characters | Est. Tokens |
|------|------:|----------:|-----------:|
| [each instruction file] | X | X | ~X |
| [each command] | X | X | ~X |
| [each agent] | X | X | ~X |
| [each skill] | X | X | ~X |

### Totals

| Category | Files | Est. Tokens | % of User Content |
|----------|------:|------------:|------------------:|
| Instructions | X | ~X | X% |
| Commands | X | ~X | X% |
| Agents | X | ~X | X% |
| Skills | X | ~X | X% |
| **Total user content** | | **~X** | 100% |

[If optimization opportunities found:]
**Potential savings:** ~X tokens (X%) through [brief description]

---

## Cache Efficiency

### Token Budget

| File | Est. Tokens | Loaded | Cache Impact |
|------|------------:|--------|--------------|
| [each always-loaded file] | ~X | Always | High — in prefix every turn |
| [each on-demand file] | ~X | On-demand | Low — only when invoked |

**Always-loaded total:** ~X tokens (cache prefix impact)
**On-demand total:** ~X tokens (no cache impact when unused)

### Volatile Content

| File | Volatile Markers | Position | Verdict |
|------|:----------------:|----------|---------|
| [each instruction/rule file] | X | [Top/Bottom half] | [Clean / Move to bottom] |

Volatile markers: `TODO`, `FIXME`, `WIP`, `HACK`, hardcoded dates (`YYYY-MM-DD`), "last updated" lines

### CLAUDE.md Size

| Metric | Value | Verdict |
|--------|------:|---------|
| Estimated tokens | ~X | [Good (<5K) / Warning (5-8K) / Critical (>8K)] |

[If >5K tokens: recommend splitting stable reference content into `.claude/rules/` or `.claude/skills/`]

### Duplication Analysis

| Source | Target | Shared Phrases | Verdict |
|--------|--------|:--------------:|---------|
| [file A] | [file B] | X | [Clean / Likely duplication] |

[If no duplication found: "No significant cross-file duplication detected."]

---

## Instruction Quality Detail

| File | Clarity | Structure | Completeness | Efficiency | Usefulness | Overall |
|------|:-------:|:---------:|:------------:|:----------:|:----------:|:-------:|
| [each instruction file] | X/10 | X/10 | X/10 | X/10 | X/10 | X/10 |

[Key observations per file]

---

## Extension Quality Detail

### Commands

| Command | Naming | Input | Structure | Output | Scope | Efficiency | Overall |
|---------|:------:|:-----:|:---------:|:------:|:-----:|:----------:|:-------:|
| [each command] | X/10 | X/10 | X/10 | X/10 | X/10 | X/10 | X/10 |

### Agents (if present)

| Agent | Model | Tools | Role Clarity | Overall |
|-------|:-----:|:-----:|:------------:|:-------:|
| [each agent] | ✓/⚠ | ✓/⚠ | ✓/⚠ | X/10 |

### Skills (if present)

| Skill | Structure | Security | Scope | Overall |
|-------|:---------:|:--------:|:-----:|:-------:|
| [each skill] | ✓/⚠ | ✓/⚠ | ✓/⚠ | X/10 |

---

## Progress History

[If history exists with 2+ entries, show a table of past analyses:]

| Date | Score | Delta | Critical | Important | Suggestions |
|------|:-----:|:-----:|:--------:|:---------:|:-----------:|
| 2026-03-23 | 7.8 | ↑ +1.4 | 1 | 3 | 2 |
| 2026-03-15 | 6.4 | — | 3 | 5 | 3 |

[If this is the first analysis: "First analysis — run again after making changes to track progress."]

[If score dropped, add a regression warning:]
`⚠ Regression detected: Score dropped from X.X to X.X. Check findings above for new issues.`

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.

---

*Report generated by [Agent Smith](https://github.com/maxencemeloni/claude-code-agent-smith)*
*Find more AI tools at https://hub.mmapi.fr/tools?origin=claudecode*
```

---

## Phase 5: Interactive Triage

After displaying the report, use the `AskUserQuestion` tool to present the interactive menu:

```json
{
  "question": "Which category do you want to address?",
  "options": [
    {
      "label": "A) Quick Wins",
      "description": "[X] low-effort fixes"
    },
    {
      "label": "B) Recommended",
      "description": "[X] medium-effort improvements"
    },
    {
      "label": "C) Advanced",
      "description": "[X] high-effort optimizations"
    },
    {
      "label": "D) All categories",
      "description": "Walk through everything"
    },
    {
      "label": "E) Done",
      "description": "Just the report, no changes"
    }
  ]
}
```

Replace `[X]` with the actual item counts from the Action Plan.

If user selects **E)**, stop here. Otherwise, proceed to Phase 6.

---

## Phase 6: Item-by-Item Decisions

For each item in the selected category (or all categories if D), present one at a time using `AskUserQuestion`:

```json
{
  "question": "[A1] Add .env to deny rules in settings.json\n\nWhat would you like to do?",
  "options": [
    {
      "label": "Yes",
      "description": "Apply this fix"
    },
    {
      "label": "No",
      "description": "Skip this item"
    },
    {
      "label": "Other",
      "description": "Type a custom instruction for this item"
    },
    {
      "label": "Yes to all",
      "description": "Apply all remaining items in this category"
    }
  ]
}
```

**Response handling:**
- **Yes** → Mark as "Apply"
- **No** → Mark as "Skip"
- **Other** → Follow up by asking the user to type their custom instruction, then mark as "Apply (custom: [user's instruction])"
- **Yes to all** → Mark all remaining items in the current category as "Apply" and skip to Phase 7

Collect all decisions before proceeding.

---

## Phase 7: Execution Plan & Apply

### 7a. Display Execution Plan

Show a consolidated summary of all decisions:

```markdown
## Execution Plan

| # | Action | Decision |
|---|--------|----------|
| A1 | Add .env deny rules | ✓ Apply |
| A2 | Add .git/ to .claudeignore | ✗ Skip |
| A3 | Fix JSON trailing comma | ✓ Apply (custom: also reformat the file) |
| B1 | Restructure CLAUDE.md sections | ✓ Apply |
```

Then ask for confirmation:

```json
{
  "question": "Execute this plan?",
  "options": [
    {
      "label": "Yes",
      "description": "Apply all accepted changes now"
    },
    {
      "label": "No",
      "description": "Cancel — no changes will be made"
    },
    {
      "label": "Revise",
      "description": "Go back and change some decisions"
    }
  ]
}
```

### 7b. Build Execution Phases

Before executing, analyze the accepted fixes and organize them into **parallel execution phases** for optimal speed:

1. **Map dependencies** — For each accepted fix, identify which file(s) it modifies
2. **Group by independence** — Fixes that touch **different files** are independent and can run in parallel. Fixes that touch the **same file** must run sequentially (earlier fix first)
3. **Build phases** — Organize into ordered phases where all fixes within a phase are independent

**Dependency rule:** Two fixes are dependent if they modify the same file. Within a dependency chain, preserve the original action plan order (A before B before C).

Display the phased plan before executing:

```markdown
## Execution Phases

### Phase 1 (parallel — X changes)
| # | Action | Target File |
|---|--------|-------------|
| A2 | Add .git/ to .claudeignore | .claudeignore |
| B1 | Restructure CLAUDE.md sections | CLAUDE.md |

### Phase 2 (parallel — X changes)
| # | Action | Target File |
|---|--------|-------------|
| A1 | Add .env deny rules | settings.json |

### Phase 3 (sequential — depends on Phase 2)
| # | Action | Depends On |
|---|--------|------------|
| A3 | Fix JSON trailing comma | A1 (same file) |
```

### 7c. Execute

On **Yes**:

1. Execute one phase at a time, starting from Phase 1
2. **Within each phase**, launch all fixes in parallel using the Agent tool (one agent per fix)
3. Wait for the entire phase to complete before starting the next phase
4. **Failure propagation** — If a fix fails, skip any dependent fixes in later phases and report why
5. For each fix (whether parallel or sequential), show what changed and confirm success or failure

On **No**: Stop. Tell the user no changes were made.

On **Revise**: Go back to Phase 6 and re-present the items.

### 7d. Results

After executing, display a summary:

```markdown
## Execution Results

**Applied:** X changes
**Skipped:** Y items
**Failed:** Z items (if any)
**Phases executed:** N

### Changes Made
✓ [A2] Added .git/ to .claudeignore (Phase 1)
✓ [B1] Restructured CLAUDE.md into 4 sections (Phase 1)
✓ [A1] Added .env deny rules to settings.json (Phase 2)
✓ [A3] Fixed trailing comma and reformatted settings.json (Phase 3)

### Skipped
— [item] (user chose to skip)

### Failed (if any)
✗ [description and reason]
✗ [dependent item] — skipped because [parent fix] failed
```

---

## Safety Rules (for execution phase)

1. **Never modify source code** — Only configuration files, instruction files, and .claudeignore
2. **Show before applying** — Always show what will change before making edits
3. **Conservative fixes** — When uncertain about a custom instruction, ask for clarification
4. **Atomic changes** — Each fix is independent; a failure in one doesn't block others
5. **No destructive actions** — Never delete user content; only add, modify, or reorganize
6. **Phase isolation** — Never start a phase until the previous phase has fully completed
7. **Fail-safe propagation** — If a fix fails, all fixes that depend on it (same file, later phase) are automatically skipped

---

Begin analysis now.
