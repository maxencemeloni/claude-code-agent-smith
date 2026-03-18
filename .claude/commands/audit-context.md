# Context Efficiency Audit

You are Agent Smith. Perform a **context efficiency audit** with measurable metrics.

## Input

$ARGUMENTS - Local path to audit (defaults to current directory)

## Scope

**Measure:** User-configurable content that loads into context.

**Cannot measure:** System prompt, tool schemas, conversation history (internal to Claude Code).

## Process

### Phase 1: File Inventory

Count and measure all user-configurable files:

1. **Instruction files**: `CLAUDE.md`, `INSTRUCTIONS.md`, `AGENT.md`
2. **Settings**: `.claude/settings.json`, `.claude/settings.local.json`
3. **Commands**: `.claude/commands/*.md`
4. **Agents**: `.claude/agents/*.md` (if present)
5. **Skills**: `.claude/skills/**/SKILL.md` (if present)
6. **Other docs**: `.claudedocs/` or similar

**For each file, calculate:**
- Line count
- Character count
- Estimated tokens (characters ÷ 4)

### Phase 2: .claudeignore Analysis

1. Check if `.claudeignore` exists
2. If missing, estimate impact:
   - Count files in `node_modules/` (if exists)
   - Count files in other large directories
   - Estimate context bloat from Glob/Grep operations

### Phase 3: Duplication Detection

Scan for repeated content across files:
- Same paragraphs appearing multiple times
- Duplicated code examples
- Repeated lists (e.g., subdomain lists, enum values)
- Copy-pasted sections

### Phase 4: Compression Opportunities

Identify verbose content that could be condensed:
- Long example blocks that could be tables
- Verbose explanations that could be bullet points
- Embedded content that could reference external files
- Redundant "do/don't" examples

### Phase 5: Calculate Savings

For each optimization opportunity:
- Current tokens
- Optimized tokens
- Savings (tokens and percentage)

## Output Format

```markdown
# Context Efficiency Audit

**Project:** [name]
**Type:** [detected type]
**Date:** [date]

---

## What This Measures

This audit measures **user-configurable content** that loads into Claude's context:
- Instruction files, commands, agents, skills
- NOT Claude Code's system prompt or tool schemas (internal, ~15K+ tokens)

---

## Content Inventory

### Instruction Files

| File | Lines | Characters | Est. Tokens |
|------|------:|----------:|-----------:|
| CLAUDE.md | X | X | ~X |
| [other files] | X | X | ~X |
| **Subtotal** | | | **~X** |

### Commands

| Command | Lines | Est. Tokens |
|---------|------:|-----------:|
| /[name] | X | ~X |
| **Subtotal** | | **~X** |

### Agents (if present)

| Agent | Lines | Est. Tokens |
|-------|------:|-----------:|
| [name] | X | ~X |
| **Subtotal** | | **~X** |

### Skills (if present)

| Skill | Lines | Est. Tokens |
|-------|------:|-----------:|
| [name] | X | ~X |
| **Subtotal** | | **~X** |

---

## Total User Content

| Category | Est. Tokens | % of User Content |
|----------|------------:|------------------:|
| Instructions | ~X | X% |
| Commands | ~X | X% |
| Agents | ~X | X% |
| Skills | ~X | X% |
| **Total** | **~X** | 100% |

---

## .claudeignore Status

[If missing:]
⚠️ **No `.claudeignore` found**

| Directory | Files | Impact |
|-----------|------:|--------|
| node_modules/ | ~X | Scanned on every Glob/Grep |
| .git/ | ~X | Git history indexed |
| dist/ | ~X | Build artifacts indexed |

**Recommendation:** Create `.claudeignore` to exclude these directories.

[If exists:]
✓ `.claudeignore` configured

| Check | Status |
|-------|:------:|
| `.git/` excluded | ✓/✗ |
| Dependencies excluded | ✓/✗ |
| Build outputs excluded | ✓/✗ |

---

## Optimization Opportunities

### Duplicated Content

| Content | Locations | Tokens | Savings |
|---------|-----------|-------:|--------:|
| [description] | file1.md, file2.md | ~X | ~X (consolidate) |
| [description] | file3.md, file4.md | ~X | ~X (consolidate) |
| **Subtotal** | | | **~X** |

### Compressible Content

| File | Issue | Current | After | Savings |
|------|-------|--------:|------:|--------:|
| [file] | Verbose examples | ~X | ~X | ~X |
| [file] | Embedded content | ~X | ~X | ~X |
| **Subtotal** | | | | **~X** |

### Large Files

| File | Tokens | Issue | Recommendation |
|------|-------:|-------|----------------|
| [file] | ~X | [too large] | Split or reference external docs |

---

## Savings Summary

| Category | Current | Optimized | Savings |
|----------|--------:|----------:|--------:|
| User content | ~X | ~X | ~X (X%) |

**After optimization:** Your user-configurable content would use ~X tokens instead of ~X.

---

## Context Budget Perspective

| Component | Est. Tokens | Notes |
|-----------|------------:|-------|
| Claude Code system prompt | ~10,000-15,000 | Fixed, not configurable |
| Tool schemas | ~3,000-8,000 | Fixed, not configurable |
| **Your content (current)** | **~X** | ← What you control |
| **Your content (optimized)** | **~X** | ← After changes |
| Files read during session | Variable | Depends on task |

Your user content is ~X% of the estimated base context load.

---

## Recommendations

### Do First (Highest Impact)
1. [Most impactful optimization with token savings]
2. [Second priority]

### Consider
1. [Lower priority optimizations]

---

## Limitations

- Token estimates use characters ÷ 4 (approximate)
- System prompt and tool schemas cannot be measured
- Actual context usage varies by session and task
- File read operations add variable context
```

## Calculation Methods

**Token estimation:** characters ÷ 4 (industry standard approximation)

**Duplication detection:** Look for:
- Identical paragraphs (>50 words) in multiple files
- Same code blocks
- Repeated lists or tables

**Compression estimation:** Compare verbose patterns to concise alternatives:
- Bullet list → table: ~40% reduction
- Multiple examples → single example: ~60% reduction
- Embedded content → file reference: ~90% reduction

## After Audit

Ask: "Save this audit as `AGENT_SMITH_CONTEXT_AUDIT.md`?"

Begin audit now.
