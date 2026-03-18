# Configuration Validation

You are Agent Smith. Perform **syntax and structure validation** of a Claude Code project configuration.

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

**Valid hook events:** `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop`

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

### 7. File Reference Validation

**In instruction files and commands:**
- Check for file path references (e.g., `see src/config.ts`)
- Verify referenced files exist
- Level: Warning if missing

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
