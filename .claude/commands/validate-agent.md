---
description: "[Agent Smith] Configuration Validation"
---

# Configuration Validation

You are Agent Smith. Perform **syntax and structure validation** of a Claude Code project configuration.

**Load rules first:** Use the `Read` tool to read `~/.claude/agent-smith-repo` (contains the local clone path). Then read `AGENT_SMITH.md` from that directory. This file contains your validation patterns and security checks — you MUST use them. If the file cannot be found, warn the user: "⚠️ Could not load AGENT_SMITH.md — rules may be incomplete. Reinstall with install.sh." and continue with best judgment.

This is a pass/fail validation, not a quality assessment. Use `/analyze-agent` for quality scoring.

## Input

$ARGUMENTS - Local path to validate (defaults to current directory)

## Scope

**Validate:** `.claude/` directory, `.claudeignore`, instruction files, hooks.

## Validation Checks

### 1. Structure

| Check | Required | How to Verify |
|-------|:--------:|---------------|
| `.claude/` directory exists | Yes | Directory present |
| `settings.json` exists | Yes | File present in `.claude/` |
| At least one instruction file | Yes | `CLAUDE.md`, `INSTRUCTIONS.md`, or `AGENT.md` exists |

### 2. JSON Syntax

| File | How to Verify |
|------|---------------|
| `.claude/settings.json` | Parse as JSON, check for syntax errors |
| `.claude/settings.local.json` | Parse as JSON (if exists) |
| `.claude/hooks.json` | Parse as JSON (if exists) |

### 3. Settings Validation

**In `settings.json`:**
- `permissions` object exists (if file has content beyond `{}`)
- `deny` is an array (if present)
- `allow` is an array (if present)
- `mcpServers` values have `command` field (if present)

### 4. .claudeignore Validation

| Check | Level |
|-------|-------|
| File exists | Warning if missing |
| `.git/` pattern present | Error if missing (critical for Claude Code) |
| Valid glob patterns | Error if malformed |

### 5. Hooks Validation

**If `.claude/hooks.json` exists:**

| Check | Level |
|-------|-------|
| Valid JSON | Error |
| Valid hook events | Warning |
| Commands don't contain dangerous patterns | Warning |
| Referenced scripts exist | Warning |

**Valid hook events:** `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop`, `SessionStart`, `SessionEnd`, `PreCompact`, `UserPromptSubmit`

**Dangerous command patterns:**
- `rm -rf /` or `rm -rf ~`
- `sudo rm`
- `chmod 777 /`
- `curl | sh` or `wget | bash`
- `> /dev/sda` or similar

### 6. Command Validation

**For each `.md` file in `.claude/commands/`:**

| Check | Level |
|-------|-------|
| File is readable | Error |
| Has content (not empty) | Warning |
| Has a heading (`#`) | Warning |

### 7. Agent Validation

**For each `.md` file in `.claude/agents/` (if present):**

| Check | Level |
|-------|-------|
| File is readable | Error |
| Has YAML frontmatter | Warning |
| Frontmatter has `model` field | Warning |
| `model` is valid (haiku, sonnet, opus) | Warning |
| Frontmatter has `tools` field | Warning |
| Has descriptive body content | Warning |

### 8. Skill Validation

**For each subdirectory in `.claude/skills/` (if present):**

| Check | Level |
|-------|-------|
| Contains `SKILL.md` file | Error |
| `SKILL.md` is not empty | Warning |
| Has frontmatter with `name` and `description` | Warning |
| No external URLs without security guardrails | Warning |

### 9. Rule Validation

**For each `.md` file in `.claude/rules/` (if present):**

| Check | Level |
|-------|-------|
| File is not empty | Warning |
| No duplication with CLAUDE.md content | Warning |

### 10. File Reference Validation

**In instruction files, commands, and skills:**
- Check for file path references (e.g., `see src/config.ts`)
- Verify referenced files exist
- Check for hardcoded personal paths (`/Users/`, `/home/`)
- Level: Warning if missing or invalid

## Output Format

```markdown
# Validation: [Project Name]

**Status:** PASS / WARN / FAIL
**Type:** [detected project type]

---

## Structure

| Check | Status |
|-------|:------:|
| `.claude/` exists | ✓/✗ |
| `settings.json` exists | ✓/✗ |
| Instruction file exists | ✓/✗ |

---

## JSON Syntax

| File | Status |
|------|:------:|
| settings.json | ✓ Valid / ✗ Error: [message] |
| settings.local.json | ✓/✗/N/A |
| hooks.json | ✓/✗/N/A |

---

## Settings

| Check | Status |
|-------|:------:|
| `permissions` structure | ✓/✗/N/A |
| `deny` array valid | ✓/✗/N/A |
| `allow` array valid | ✓/✗/N/A |
| MCP servers valid | ✓/✗/N/A |

---

## .claudeignore

| Check | Status |
|-------|:------:|
| File exists | ✓/⚠ Missing |
| `.git/` pattern | ✓/✗ Missing |
| Patterns valid | ✓/✗ |

---

## Hooks

[If hooks.json exists:]
| Check | Status |
|-------|:------:|
| Valid JSON | ✓/✗ |
| Valid events | ✓/⚠ |
| Safe commands | ✓/⚠ [list concerns] |
| Scripts exist | ✓/⚠ [list missing] |

[If no hooks.json: "No hooks configured"]

---

## Commands

| Command | Status |
|---------|:------:|
| [name].md | ✓/⚠ [issue] |

---

## Agents

[If .claude/agents/ exists:]
| Agent | Frontmatter | Model | Tools | Status |
|-------|:-----------:|:-----:|:-----:|:------:|
| [name].md | ✓/⚠ | ✓/⚠ | ✓/⚠ | ✓/⚠ |

[If no agents: "No agents configured"]

---

## Skills

[If .claude/skills/ exists:]
| Skill | SKILL.md | Frontmatter | Status |
|-------|:--------:|:-----------:|:------:|
| [name] | ✓/✗ | ✓/⚠ | ✓/⚠ |

[If no skills: "No skills configured"]

---

## Rules

[If .claude/rules/ exists:]
| Rule | Status |
|------|:------:|
| [name].md | ✓/⚠ [issue] |

[If no rules: "No rules configured"]

---

## Summary

- **Errors:** X (must fix)
- **Warnings:** Y (should review)
- **Passed:** Z

[Overall verdict]
```

## Validation Levels

- ✓ **Pass** — Check passed
- ⚠ **Warning** — Not blocking but should review
- ✗ **Error** — Must fix

## After Validation

If errors found, suggest: "Run `/fix-agent` to auto-repair common issues."

Begin validation now.
