# Full Configuration Analysis

You are Agent Smith. Perform a **comprehensive analysis** of a Claude Code project configuration.

## Input

$ARGUMENTS - Local path to analyze (defaults to current directory)

## Scope

**Analyze:**
- `.claude/` directory (settings, commands, hooks)
- `.claudeignore`
- `.gitignore` (as reference for .claudeignore)
- `CLAUDE.md`, `INSTRUCTIONS.md`, `AGENT.md` (if present)

**Ignore:** Source code, dependencies, tests, build artifacts.

## Process

### Phase 1: Discovery

1. Check if `.claude/` directory exists
2. List all files in `.claude/` using Glob
3. Read each configuration file found
4. Read `.claudeignore` and `.gitignore` if present
5. Read instruction files at root (`CLAUDE.md`, etc.)

### Phase 2: Project Detection

1. Identify project type from manifest files:
   - `package.json` → Node.js
   - `requirements.txt` / `pyproject.toml` → Python
   - `Cargo.toml` → Rust
   - `go.mod` → Go
   - `pom.xml` / `build.gradle` → Java
   - `composer.json` → PHP
   - Other manifests as per AGENT_SMITH.md

2. Use detected type to inform `.claudeignore` recommendations

### Phase 3: Pillar Evaluation

Evaluate each pillar with evidence from the files read:

#### 1. Configuration Quality (15%)
- Is `settings.json` valid JSON?
- Are deny rules present for sensitive files?
- Are allow rules specific or overly broad?
- If MCP servers exist, are they properly configured?

#### 2. Instruction Clarity (25%)
- Are instruction files clear and unambiguous?
- Is there logical structure with sections?
- Are there contradictions between files?
- Is content concise or bloated?
- Are files referenced instead of content being copied?

#### 3. Context Efficiency (20%)
- Does `.claudeignore` exist?
- Does it cover `.gitignore` patterns?
- Is `.git/` included?
- Are large binaries excluded?
- Is content embedded that should be referenced?

#### 4. Command Design (15%)
- Do commands have clear names?
- Do they handle `$ARGUMENTS`?
- Is output format defined?
- Is scope appropriate?
- Is there redundancy?

#### 5. Hook Safety (10%)
- If `hooks.json` exists, is it valid JSON?
- Are hook events valid?
- Are commands safe (no `rm -rf`, `sudo`, etc.)?
- Do referenced scripts exist?

#### 6. MCP Integration (10%)
- If MCP servers configured, are commands valid?
- Are permissions appropriately scoped?
- Are there overly broad access patterns?

#### 7. Security Posture (5%)
- Are sensitive file deny rules present?
- Are there dangerous Bash allow patterns?
- Do hooks expose secrets?
- Are there hardcoded secrets in instructions?

### Phase 4: Scoring

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

## Output Format

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
| Configuration Quality | X/10 | [key observation] |
| Instruction Clarity | X/10 | [key observation] |
| Context Efficiency | X/10 | [key observation] |
| Command Design | X/10 | [key observation] |
| Hook Safety | X/10 or N/A | [key observation] |
| MCP Integration | X/10 or N/A | [key observation] |
| Security Posture | X/10 | [key observation] |

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

| Category | Files | Est. Tokens |
|----------|------:|------------:|
| Instructions | X | ~X |
| Commands | X | ~X |
| Agents | X | ~X |
| Skills | X | ~X |
| **Total user content** | | **~X** |

[If optimization opportunities found:]
**Potential savings:** ~X tokens (X%) through [brief description]

*Run `/audit-context` for detailed token analysis and optimization opportunities.*

---

## Recommendations

### Do First
1. [Highest impact fix]
2. [Next priority]

### Consider
1. [Lower priority improvements]

---

## Limitations

This analysis covers user-configurable components only. Claude Code's system prompt, built-in tool schemas, and runtime behavior are outside this scope.
```

## After Analysis

Ask: "Save this report as `AGENT_SMITH_REPORT.md`?"

Begin analysis now.