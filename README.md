<p align="center">
  <img src="./assets/banner.png" alt="Claude Code Agent Smith Banner" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Slash_Commands-blueviolet?style=for-the-badge" alt="Claude Code"/>
  <img src="https://img.shields.io/badge/v2.0.2-Stable-green?style=for-the-badge" alt="Version"/>
  <img src="https://img.shields.io/badge/MIT-License-blue?style=for-the-badge" alt="License"/>
</p>

<h1 align="center">Claude Code Agent Smith</h1>

<p align="center">
  <strong>Slash commands for <a href="https://github.com/anthropics/claude-code">Claude Code</a></strong> that analyze, validate, and optimize your configuration.
</p>

<p align="center">
  <code>Requires Claude Code CLI — Run these commands inside a Claude Code session</code>
</p>

---

> **What is Claude Code?** [Claude Code](https://github.com/anthropics/claude-code) is Anthropic's official agentic coding CLI. Agent Smith adds slash commands that help you check and improve your Claude Code configuration.

---

## What It Does

Agent Smith **analyzes, validates, and fixes** your Claude Code configuration in one interactive workflow:

- **Analyze** — Full 7-pillar evaluation with token metrics, instruction quality, and extension ratings
- **Triage** — Interactive walkthrough of findings by effort level
- **Fix** — Apply accepted changes with an execution plan
- **Create** — Scaffold new configurations with best practices

---

## Quick Start

```bash
# Add the marketplace (one-time)
claude plugin marketplace add maxencemeloni/claude-code-agent-smith

# Install the plugin
claude plugin install agent-smith

# Use (in any project)
cd your-project
claude
/analyze-agent
```

> **Update:** `claude plugin update agent-smith`

---

## Commands

| Command | Purpose |
|---------|---------|
| `/analyze-agent` | Full configuration analysis, interactive triage, and guided fixes |
| `/create-agent` | Scaffold new configuration with best practices |

### `/analyze-agent` Workflow

1. **Analyze** — Validates structure, scores all 7 pillars, measures tokens, rates instructions and extensions
2. **Save Report** — Writes full report to `AGENT_SMITH_REPORT.md`
3. **Triage** — Pick a category: Quick Wins, Recommended, or Advanced
4. **Decide** — For each finding: Yes (apply) / No (skip) / Custom instruction
5. **Execute** — Review the execution plan, confirm, and apply all changes

---

## Sample Output

### `/analyze-agent`

```markdown
# Agent Smith Analysis

**Project:** your-project
**Type:** Node.js
**Score:** 7.8/10

## Pillar Scores

| Pillar | Score | Notes |
|--------|:-----:|-------|
| Security Posture | 7/10 | Could add more deny rules |
| Instruction Clarity | 8/10 | Well-structured CLAUDE.md |
| Configuration Quality | 8/10 | Good structure |
| Context Efficiency | 6/10 | Missing .claudeignore patterns |
| Command & Extension Design | 9/10 | Clear, well-documented |
| Hook Safety | N/A | No hooks configured |
| MCP Integration | 7/10 | 3 servers configured |

## Content Overview

| Category | Files | Est. Tokens |
|----------|------:|------------:|
| Instructions | 1 | ~4,800 |
| Commands | 5 | ~8,600 |
| Agents | 6 | ~10,500 |
| **Total user content** | | **~23,900** |

## Limitations

This analysis covers user-configurable components only.
Claude Code's system prompt and tool schemas are outside this scope.
```

### Interactive Triage

```
Which category do you want to address?
  A) Quick Wins     — 3 low-effort fixes
  B) Recommended    — 2 medium-effort improvements
  C) Advanced       — 1 high-effort optimization
  D) All categories — Walk through everything
  E) Done           — Just the report, no changes
```

After choosing, you walk through each item one by one and decide what to do. Then Agent Smith builds an execution plan and applies your choices.

---

## The 7 Evaluation Areas

| Area | Weight | What's Checked |
|------|:------:|----------------|
| **Security Posture** | 20% | Sensitive file protection, dangerous patterns |
| **Instruction Clarity** | 20% | CLAUDE.md quality, structure, contradictions |
| **Configuration Quality** | 15% | settings.json structure, allow rules |
| **Context Efficiency** | 15% | .claudeignore coverage, embedded vs referenced content |
| **Command & Extension Design** | 15% | Commands, agents, skills: quality, naming, structure |
| **Hook Safety** | 10% | hooks.json validity, dangerous commands |
| **MCP Integration** | 5% | MCP server configuration quality |

---

## What Issues It Finds

| Issue Type | Example |
|------------|---------|
| **Missing .claudeignore** | No context filtering → node_modules scanned |
| **Missing .git/ pattern** | Git history gets indexed |
| **Missing deny rules** | No protection for .env, secrets/, *.pem |
| **Dangerous Bash patterns** | `Bash(*)` allows any command |
| **Unsafe hook commands** | `rm -rf` or `sudo` in hooks |
| **Hardcoded personal paths** | `/Users/name/` in shared configs |
| **--no-verify bypasses** | Git safety hooks disabled |
| **Unscoped agents** | Missing model or tools in agent frontmatter |
| **Unstructured skills** | Missing SKILL.md or frontmatter |
| **Too many active MCPs** | >10 servers shrinks context window |
| **Duplicated content** | Same text in multiple files |
| **Embedded content** | File contents copied instead of referenced |

---

## Honest About Limitations

This tool measures what you can control:

| Can Measure | Cannot Measure |
|-------------|----------------|
| Your instruction files | Claude Code's system prompt |
| Your commands and agents | Built-in tool schemas |
| Your .claudeignore coverage | Runtime context usage |
| Duplicated content | Conversation history |

We provide **real measurements** with **honest scope**, not inflated claims.

---

## Security: Deny Rules

Prevent Claude from reading sensitive files:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Read(./**/*_rsa)"
    ]
  }
}
```

`/create-agent` includes these by default. `/analyze-agent` checks for missing rules.

---

## Install

```bash
# 1. Add the marketplace (one-time)
claude plugin marketplace add maxencemeloni/claude-code-agent-smith

# 2. Install the plugin
claude plugin install agent-smith
```

Works on all platforms.

```bash
# Update
claude plugin update agent-smith

# Uninstall
claude plugin uninstall agent-smith
```

---

## Contributing

1. Fork the repo
2. Add/modify commands in `commands/`
3. Validate with `claude plugin validate .`
4. Submit a PR

See [IMPROVEMENTS.md](./IMPROVEMENTS.md) for roadmap and design principles.

---

## Development

When working on Agent Smith with Claude Code, the `CLAUDE.md` file at the project root provides development context including:

- **Design principles** — Honesty over hype, scope clarity, evidence required
- **7-pillar system** — Rationale for each evaluation area
- **Out of scope** — What we explicitly don't measure (system prompt, model routing, etc.)
- **Version management** — How to bump versions and update documentation
- **Repository structure** — Where everything lives

This context is only loaded when developing Agent Smith itself, not when users run the commands in their projects.

### Release Checklist

When releasing a new version:

| Step | Files |
|------|-------|
| 1. Update version badge | `README.md` |
| 2. Add changelog entry | `IMPROVEMENTS.md` |
| 3. Update wiki | `Roadmap.md` (version + history) |
| 4. Commit with format | `Release vX.Y.Z — Description` |
| 5. Push main + wiki | Both repositories |

### Wiki

The [GitHub Wiki](https://github.com/maxencemeloni/claude-code-agent-smith/wiki) is maintained as a separate repository. When making changes that affect documentation, update both the README and relevant wiki pages.

---

## License

MIT

---

<p align="center">
  <a href="https://github.com/maxencemeloni/claude-code-agent-smith">GitHub</a> ·
  <a href="https://github.com/maxencemeloni/claude-code-agent-smith/wiki">Wiki</a> ·
  <a href="https://hub.mmapi.fr/tools?origin=claudecode">More AI Tools</a>
</p>
