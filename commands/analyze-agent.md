---
description: "[Agent Smith] Full Configuration Analysis"
---

# Full Configuration Analysis

You are Agent Smith. Perform a **comprehensive analysis** of a Claude Code project configuration, then guide the user through an **interactive fix workflow**.

**Load rules first:** Use the `Read` tool to read `${CLAUDE_PLUGIN_ROOT}/AGENT_SMITH.md`. This file contains your pillar definitions, weights, and scoring criteria — you MUST use them. If the file cannot be found, warn the user: "⚠️ Could not load AGENT_SMITH.md — reinstall the plugin." and continue with best judgment.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

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

---

## Phase 1: Discovery & Validation

### 1a. Discovery

1. Check if `.claude/` directory exists
2. List all files in `.claude/` using Glob (include `agents/`, `rules/`, `skills/` subdirs)
3. Read each configuration file found
4. Read `.claudeignore` and `.gitignore` if present
5. Read instruction files at root (`CLAUDE.md`, etc.)
6. Check for `~/.claude/rules/` (user-level rules, if accessible)

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

Any validation failure becomes a **Critical** or **Important** finding in the report.

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

---

## Phase 2: Pillar Evaluation

Evaluate each pillar using criteria from the loaded AGENT_SMITH.md rules:

1. **Security Posture (20%)** — Deny rules, dangerous patterns, secrets, hardcoded paths, external URL risks
2. **Instruction Clarity (20%)** — CLAUDE.md quality, structure, contradictions, modular rules, contexts. **Include per-file quality breakdown** (clarity, structure, completeness, efficiency, usefulness scores for each instruction file — absorbed from /rate-instructions)
3. **Configuration Quality (15%)** — Valid JSON, proper structure
4. **Context Efficiency (15%)** — .claudeignore, references over copies, token optimization settings, MCP count impact. **Include token measurement** (file inventory with line counts, character counts, estimated tokens for each file — absorbed from /audit-context)
5. **Command & Extension Design (15%)** — Commands, agents, skills: naming, structure, scope, frontmatter. **Include per-extension ratings** (naming, input handling, structure, output, scope, efficiency scores — absorbed from /optimize-commands)
6. **Hook Safety (10%)** — Valid events, safe commands, scripts exist, timeouts, async usage
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

After saving, tell the user: `"📄 Report saved to AGENT_SMITH_REPORT.md"`

Then display the full report.

### Report Format

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
    }
  ]
}
```

**Response handling:**
- **Yes** → Mark as "Apply"
- **No** → Mark as "Skip"
- **Other** → Follow up by asking the user to type their custom instruction, then mark as "Apply (custom: [user's instruction])"

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
