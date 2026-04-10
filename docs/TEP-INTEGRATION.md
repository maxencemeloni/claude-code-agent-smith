# TEP Integration Plan

## Context

**Date:** 2026-03-27
**Source:** [Token Economy Paradigm (TEP)](https://github.com/marcantoinedutoit/tep) by Marc-Antoine Dutoit
**Article:** [TEP: Stop Paying Full Price for Claude Code](https://medium.com/@marc.antoine.dutoit/token-economy-paradigm-tep-stop-paying-full-price-for-claude-code-9fc4796cf31a)

TEP is an open-source CLI audit tool that optimizes Claude Code usage by analyzing prompt caching efficiency. It scores projects on an 8-point scale using a single bash script that parses session data and configuration files.

Agent Smith and TEP solve two halves of the same problem:
- **Agent Smith** optimizes for configuration **quality, safety, and structure**
- **TEP** optimizes for **token cost via prompt caching**

This document captures what each project can learn from the other, for later implementation.

---

## How Prompt Caching Works (TEP's Core Insight)

Claude Code transmits a complete prompt each turn: system instructions + tools + CLAUDE.md + session history + messages. **Prompt caching** reuses pre-processed tokens when prompt prefixes match previous turns via exact prefix matching.

- Cache-read tokens cost **90% less** than regular input tokens
- Cache creation costs 1.25x standard input but pays off on repeated reads
- Any single token deviation in the prefix triggers recomputation of all downstream content
- **Stable content must be at the top, volatile content at the bottom**

### Cache Hit Rate Benchmarks

| Rate | Assessment |
|------|------------|
| >95% | Excellent (Anthropic target) |
| >80% | Good (TEP minimum target) |
| 50-80% | Needs optimization |
| <50% | Structural problem |

---

## What Agent Smith Should Absorb from TEP

### Level 1 — Enrich Existing Pillars (No Structural Changes)

These are new checks added to existing pillar evaluations.

#### 1.1 Volatile Content Detection

**Pillar:** Instruction Clarity + Context Efficiency
**What:** Detect cache-breaking volatile markers in instruction files.

Patterns to flag:
- `TODO`, `FIXME`, `WIP`, `HACK` markers in CLAUDE.md, rules, skills
- Hardcoded dates matching `YYYY-MM-DD` (already stale or will become stale)
- Timestamps or "last updated" lines
- Git status dumps or commit hashes embedded in instructions

**Severity:** Suggestion (not critical — these don't break functionality, they break caching)
**Fix guidance:** Remove volatile markers or move them to the bottom of the file. Use comments in code files instead of instruction files for TODOs.

#### 1.2 CLAUDE.md Token Threshold

**Pillar:** Instruction Clarity
**What:** Add a concrete size recommendation based on TEP's research.

| Size | Verdict |
|------|---------|
| <5,000 tokens | Good — fits comfortably in cache prefix |
| 5,000-8,000 tokens | Warning — consider splitting into rules/skills |
| >8,000 tokens | Critical — actively hurting cache hit rates |

**Token estimation:** ~1.3 tokens per word, or ~4 characters per token.
**Fix guidance:** Move stable reference content to `.claude/skills/` (loaded on-demand) or `.claude/rules/` (always loaded but modular). Keep CLAUDE.md as the high-level project identity and conventions.

#### 1.3 Cache-Friendly Ordering

**Pillar:** Instruction Clarity
**What:** Check that CLAUDE.md follows a stable-first, volatile-last structure.

Recommended order:
1. Project identity (name, purpose) — **stable**
2. Tech stack — **stable**
3. Code conventions — **stable**
4. Commands and workflows — **semi-stable**
5. Current sprint/context — **volatile, always last**

**Detection:** Scan for volatile markers (TODO, WIP, dates). If they appear in the first half of the file, flag as "volatile content in cache-critical prefix."
**Severity:** Suggestion

#### 1.4 Hardcoded Date Detection

**Pillar:** Security Posture (alongside existing hardcoded path detection)
**What:** Flag `YYYY-MM-DD` patterns in shared configuration files.

Hardcoded dates in CLAUDE.md or rules become stale and break cache when updated. Already detected patterns:
- `/Users/<name>/` — hardcoded paths (existing)
- `2026-03-27` — hardcoded dates (**new**)

**Severity:** Suggestion (dates in changelogs or version history are acceptable — only flag in instruction/rule content)

#### 1.5 Hook Cache Impact

**Pillar:** Hook Safety
**What:** Detect hooks that inject dynamic content into the system prompt.

Hooks that run on `PreToolUse` or `UserPromptSubmit` and output timestamps, git status, or other changing data will modify the prompt prefix on every turn, destroying cache continuity.

**Patterns to flag:**
- Hook commands containing `date`, `git status`, `git log`, `git diff` when outputting to prompt
- Any hook that writes to or modifies CLAUDE.md dynamically
- Hooks that inject environment variables that change between sessions

**Severity:** Important (these silently cost money)

---

### Level 2 — New Report Content: Cache Efficiency Section

A new section in the analysis report, folded into the **Context Efficiency pillar** (not a new pillar).

#### 2.1 Token Budget with Cache Framing

Enhance the existing "Content Overview > File Inventory" table with caching context:

```markdown
## Cache Efficiency

### Token Budget

| File | Est. Tokens | Loaded | Cache Impact |
|------|------------:|--------|--------------|
| CLAUDE.md | ~3,200 | Always | High — in prefix every turn |
| .claude/rules/testing.md | ~450 | Always | High — in prefix every turn |
| .claude/rules/style.md | ~300 | Always | High — in prefix every turn |
| .claude/skills/deploy/SKILL.md | ~1,800 | On-demand | Low — only when invoked |
| .claude/commands/release.md | ~600 | On-demand | Low — only when invoked |

**Always-loaded total:** ~3,950 tokens (cache prefix impact)
**On-demand total:** ~2,400 tokens (no cache impact when unused)
```

#### 2.2 Cross-File Duplication Score

Expand existing duplication checks to cover all extension types:

- CLAUDE.md vs `.claude/rules/*.md` (existing, shallow)
- CLAUDE.md vs `.claude/skills/**/SKILL.md` (**new**)
- CLAUDE.md vs `.claude/agents/*.md` (**new**)
- Rules vs skills (**new**)
- Rules vs agents (**new**)

**Detection method:** Extract key phrases (3+ word sequences) from each file, check for overlaps. Flag files with 3+ shared phrases as likely duplication.

**Report output:**
```markdown
### Duplication Analysis

| Source | Target | Shared Phrases | Verdict |
|--------|--------|:--------------:|---------|
| CLAUDE.md | rules/testing.md | 5 | Likely duplication — consider removing from CLAUDE.md |
| CLAUDE.md | skills/deploy/SKILL.md | 1 | Clean |
```

#### 2.3 Ordering Analysis

Score what percentage of volatile content appears after stable content:

```markdown
### Content Ordering

| File | Volatile Markers | Position | Verdict |
|------|:----------------:|----------|---------|
| CLAUDE.md | 3 | Top half (lines 12, 45, 67) | Move to bottom |
| rules/workflow.md | 0 | — | Clean |
```

---

### Level 3 — Session Analysis (Optional, Advanced)

Parse Claude Code session data from `~/.claude/projects/<path>/` to show real-world usage metrics. This would make Agent Smith the only tool combining **static analysis + runtime data**.

#### 3.1 Session Data Parsing

Claude Code stores session data as JSONL files in `~/.claude/projects/`. Each line contains:
- Token counts: `input`, `output`, `cache_read`, `cache_creation`
- Tool calls and file access patterns
- Timestamps

#### 3.2 Metrics to Extract

| Metric | How |
|--------|-----|
| Cache hit rate | `cache_read / (cache_read + input) * 100` |
| Estimated session cost | Apply Sonnet pricing: input $3/M, output $15/M, cache read $0.30/M, cache creation $3.75/M |
| Top files accessed | Count file reads per session |
| Tool call frequency | Count tool invocations by type |

#### 3.3 Report Section

```markdown
## Session Analysis (Last Session)

| Metric | Value |
|--------|-------|
| Cache hit rate | 87% (Good) |
| Input tokens | 45,230 |
| Cached tokens | 312,400 |
| Output tokens | 8,900 |
| Estimated cost | $0.42 |
| Top files read | src/index.ts (12x), CLAUDE.md (8x), package.json (5x) |
```

#### 3.4 Considerations

- Session data is **local and personal** — frame as optional/informational
- Requires `jq` for JSONL parsing (or implement in the command prompt itself)
- Privacy: never include session data in saved reports — display only
- May need user consent prompt before reading `~/.claude/` session files
- JSONL format may change across Claude Code versions — handle gracefully

---

## What TEP Could Absorb from Agent Smith

For reference (to share with TEP's author), these are gaps in TEP that Agent Smith already covers.

### Security

| Check | Why TEP Needs It |
|-------|------------------|
| Deny rules for sensitive files (.env, *.pem, *.key) | A cache-optimized config that leaks secrets is worse than an expensive one |
| `Bash(*)` in allow rules | Overly broad permissions are a security risk regardless of caching |
| No hardcoded secrets in instruction files | TEP reads these files but doesn't flag secrets |
| External URL guardrails in skills | Transitive prompt injection risk |

### Extension Quality

| Check | Why TEP Needs It |
|-------|------------------|
| Agent frontmatter validation (model, tools) | Missing `model` field wastes tokens on wrong model — a cost issue TEP should care about |
| Skill structure validation | Poorly structured skills waste tokens when loaded |
| Tool permission scoping | Agents with all tools granted add unnecessary schema to context |

### Wiring Integrity

| Check | Why TEP Needs It |
|-------|------------------|
| Cross-reference validation | A CLAUDE.md referencing a non-existent skill wastes tokens on broken instructions |
| Orphan detection | Unused extensions in `.claude/` add cognitive load and maintenance burden |
| Stale reference detection | References to removed files cause Claude to search and fail (wasted tokens + time) |

### Interactive Fixes

TEP generates a report and stops. Agent Smith's interactive triage workflow (categorize > decide > plan > execute) could make TEP actionable instead of just informational.

### Project-Aware Recommendations

TEP's `.claudeignore` check is generic. Agent Smith detects project type from manifests and recommends ecosystem-specific patterns (e.g., `node_modules/` for Node.js, `target/` for Rust).

---

## Implementation Priority

| Priority | Item | Effort | Impact |
|:--------:|------|--------|--------|
| 1 | Volatile content detection (1.1) | Low | High — easy check, immediate value |
| 2 | CLAUDE.md token threshold (1.2) | Low | High — concrete, actionable guidance |
| 3 | Cache-friendly ordering (1.3) | Low | Medium — helps users structure better |
| 4 | Hook cache impact (1.5) | Low | Medium — catches silent cost leaks |
| 5 | Hardcoded date detection (1.4) | Low | Low — minor but easy |
| 6 | Token budget with cache framing (2.1) | Medium | High — reframes existing data |
| 7 | Cross-file duplication score (2.2) | Medium | Medium — deeper analysis |
| 8 | Ordering analysis (2.3) | Medium | Low — nice to have |
| 9 | Session analysis (3.1-3.4) | High | High — unique differentiator |

---

## Version Planning

- **Level 1** fits in a single minor release (v2.5.0)
- **Level 2** fits in a follow-up minor release (v2.6.0)
- **Level 3** is a standalone feature release (v2.7.0 or v3.0.0 if scope warrants)

---

## References

- [TEP Repository](https://github.com/marcantoinedutoit/tep)
- [TEP Article](https://medium.com/@marc.antoine.dutoit/token-economy-paradigm-tep-stop-paying-full-price-for-claude-code-9fc4796cf31a)
- [TEP Methodology](https://github.com/marcantoinedutoit/tep/blob/main/docs/METHODOLOGY.md)
- [Anthropic Prompt Caching Docs](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
