<p align="center">
  <img src="./assets/banner.png" alt="Claude Code Agent Smith Banner" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Slash_Commands-blueviolet?style=for-the-badge" alt="Claude Code"/>
  <img src="https://img.shields.io/badge/v1.0.0-Stable-green?style=for-the-badge" alt="Version"/>
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

Agent Smith **analyzes, validates, and fixes** your Claude Code configuration:

- **Analyze** — Rate your configuration across 7 evaluation areas
- **Measure** — Get real token estimates for your user-configurable content
- **Validate** — Check syntax and structure
- **Fix** — Auto-repair common issues
- **Create** — Scaffold new configurations with best practices

---

## Quick Start

```bash
# Install
git clone https://github.com/maxencemeloni/claude-code-agent-smith.git
cd claude-code-agent-smith && ./install.sh

# Use (in any project)
cd your-project
claude
/analyze-agent
```

---

## Commands

| Command | Purpose |
|---------|---------|
| `/analyze-agent` | Full configuration analysis with 7-pillar scoring |
| `/audit-context` | Token measurement and optimization opportunities |
| `/quick-rate` | Rapid assessment |
| `/validate-agent` | Syntax and structure validation |
| `/fix-agent` | Auto-repair common issues |
| `/create-agent` | Scaffold new configuration |
| `/rate-instructions` | Instruction file quality analysis |
| `/optimize-commands` | Custom command quality analysis |

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
| Configuration Quality | 8/10 | Good deny rules |
| Instruction Clarity | 8/10 | Well-structured CLAUDE.md |
| Context Efficiency | 6/10 | Missing .claudeignore patterns |
| Command Design | 9/10 | Clear, well-documented |
| Hook Safety | N/A | No hooks configured |
| MCP Integration | 7/10 | 3 servers configured |
| Security Posture | 7/10 | Could add more deny rules |

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

### `/audit-context`

```markdown
# Context Efficiency Audit

## What This Measures

This audit measures **user-configurable content** only:
- NOT Claude Code's system prompt (~10-15K tokens)
- NOT tool schemas (~3-8K tokens)

## Content Inventory

| Category | Files | Est. Tokens |
|----------|------:|------------:|
| Instructions | 1 | ~4,800 |
| Commands | 5 | ~8,600 |
| **Total** | | **~13,400** |

## Optimization Opportunities

| Issue | Location | Savings |
|-------|----------|--------:|
| Duplicated subdomain list | commit.md, create-pr.md | ~400 |
| Verbose examples | add-flow-node.md | ~3,000 |
| **Total potential savings** | | **~3,400 (25%)** |
```

---

## The 7 Evaluation Areas

| Area | What's Checked |
|------|----------------|
| **Configuration Quality** | settings.json structure, deny/allow rules |
| **Instruction Clarity** | CLAUDE.md quality, structure, contradictions |
| **Context Efficiency** | .claudeignore coverage, embedded vs referenced content |
| **Command Design** | Custom command quality, naming, structure |
| **Hook Safety** | hooks.json validity, dangerous commands |
| **MCP Integration** | MCP server configuration quality |
| **Security Posture** | Sensitive file protection, dangerous patterns |

---

## What Issues It Finds

| Issue Type | Example |
|------------|---------|
| **Missing .claudeignore** | No context filtering → node_modules scanned |
| **Missing .git/ pattern** | Git history gets indexed |
| **Missing deny rules** | No protection for .env, secrets/, *.pem |
| **Dangerous Bash patterns** | `Bash(*)` allows any command |
| **Unsafe hook commands** | `rm -rf` or `sudo` in hooks |
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

### Mac / Linux

```bash
git clone https://github.com/maxencemeloni/claude-code-agent-smith.git
cd claude-code-agent-smith && ./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/maxencemeloni/claude-code-agent-smith.git
cd claude-code-agent-smith
.\install.ps1
```

### Uninstall

```bash
./uninstall.sh      # Mac/Linux
.\uninstall.ps1     # Windows
```

---

## Contributing

1. Fork the repo
2. Add/modify commands in `.claude/commands/`
3. Update install scripts if needed
4. Submit a PR

See [IMPROVEMENTS.md](./IMPROVEMENTS.md) for roadmap and design principles.

---

## License

MIT

---

<p align="center">
  <a href="https://github.com/maxencemeloni/claude-code-agent-smith">GitHub</a>
</p>
