<p align="center">
  <img src="./assets/banner.png" alt="Claude Code Agent Smith Banner" width="100%"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Slash_Commands-blueviolet?style=for-the-badge" alt="Claude Code"/>
  <img src="https://img.shields.io/badge/v1.4.0-Stable-green?style=for-the-badge" alt="Version"/>
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
| `/optimize-commands` | Command, agent, and skill quality analysis |

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
