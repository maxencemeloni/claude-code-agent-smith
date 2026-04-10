# Agent Smith Development Context

This file provides context for AI assistants (Claude Code) when working on Agent Smith itself.
It is NOT loaded when users run Agent Smith commands in their own projects.

---

## Project Identity

Agent Smith is a set of slash commands for Claude Code that analyze, validate, and optimize user configurations. The core principle is **honesty over hype** — we only claim to measure what we can actually measure.

---

## Understanding Suggestions

When the user proposes an idea or improvement, **always clarify the intent first** before responding:

- **"For the users"** — The suggestion is about what Agent Smith should **advise or recommend** to the people who run the commands. This means adding recommendations, tips, or best practices into report output. Agent Smith doesn't need to *do* it — it just needs to *tell users* to do it.
- **"For the tool"** — The suggestion is about improving Agent Smith's **internal behavior**, code, commands, or architecture. This is contributor/maintainer work.

**Do not assume.** If the intent is ambiguous, ask: *"Is this something Agent Smith should recommend to users, or a change to how Agent Smith itself works?"*

Common mistake to avoid: dismissing a feature idea because Agent Smith can't *execute* it, when the real ask is for Agent Smith to *recommend* it in its reports.

---

## Design Principles

1. **Honesty over hype** — Never claim capabilities we don't have
2. **Scope clarity** — Always explain what's analyzed vs. what's outside scope
3. **Evidence required** — Every finding needs file paths and specific issues
4. **Conservative fixes** — When uncertain, flag for manual review instead of auto-fixing
5. **Developer respect** — No dumbed-down language; users are professionals

---

## The 7-Pillar Evaluation System

| Pillar | Weight | What It Measures |
|--------|:------:|------------------|
| Security Posture | 20% | Sensitive file protection, dangerous patterns |
| Instruction Clarity | 20% | CLAUDE.md quality, structure, contradictions |
| Configuration Quality | 15% | settings.json structure, allow rules |
| Context Efficiency | 15% | .claudeignore coverage, duplication, references |
| Command & Extension Design | 15% | Commands, agents, skills: quality, naming, structure |
| Hook Safety | 10% | hooks.json validity, dangerous commands |
| MCP Integration | 5% | MCP server configuration quality |

### Why These Pillars?

**Removed from original design:**
- Memory & State — Not configurable in Claude Code
- Control Flow — Not configurable in Claude Code

**Added:**
- Hook Safety — Dedicated analysis for hooks.json
- MCP Integration — Dedicated analysis for MCP servers

**Renamed for clarity:**
- Architecture → Configuration Quality
- Prompt Engineering → Instruction Clarity
- Token Optimization → Context Efficiency
- Tool Design → Command Design

---

## What's Explicitly Out of Scope

These are NOT measurable by Agent Smith and we must never claim otherwise:

| Out of Scope | Why |
|--------------|-----|
| Claude Code's system prompt | Internal, ~10-15K tokens, not accessible |
| Built-in tool schemas | Fixed by Claude Code, ~3-8K tokens |
| Model routing | Not user-configurable in Claude Code |
| Runtime behavior | We analyze static files only |
| Conversation history | Session-specific |
| Total context usage | We can only measure user-configurable content |

---

## Commands Overview

| Command | Purpose |
|---------|---------|
| `/analyze-agent` | Full 7-pillar analysis, interactive triage, and guided fixes |
| `/create-agent` | Scaffold new configuration |

For workflow details, see the command files themselves in `commands/`.

---

## Report Structure

Reports follow a structured format defined in `commands/analyze-agent.md` Phase 4. Key sections: Header, Summary, Pillar Scores, Findings, Action Plan, Diagnostic Details, Limitations, and Footer.

For the full template, see the command file.

---

## Version Management

### Versioning Strategy

- **Patch (x.x.1)** — Bug fixes only
- **Minor (x.1.0)** — New features, non-breaking changes
- **Major (2.0.0)** — Breaking changes

### When Releasing a New Version

1. **Update version badge** in `README.md`
2. **Add changelog entry** in `IMPROVEMENTS.md` (at the top, before previous versions)
3. **Update wiki** `Roadmap.md` with new version in "Current Status" and "Version History"
4. **Commit** with message format: `Release vX.Y.Z — Short Description`
5. **Push** both main repo and wiki repo

### Files to Update

| File | What to Update |
|------|----------------|
| `VERSION` | Replace contents with new version |
| `.claude-plugin/plugin.json` | Update `"version"` field |
| `.claude-plugin/marketplace.json` | Update `"version"` in plugins array |
| `README.md` | Version badge |
| `IMPROVEMENTS.md` | Add new version section at top |
| `wiki/Roadmap.md` | Current Status + Version History |

### Post-Release Verification

After pushing, always verify the plugin update works (marketplace refresh is required before update):
```bash
claude plugin marketplace update agent-smith-marketplace
claude plugin update agent-smith@agent-smith-marketplace
```
The version should match the just-released version. If not, check that both `plugin.json` and `marketplace.json` have the correct version.

---

## Repository Structure

```
claude-code-agent-smith/
├── .claude-plugin/
│   ├── marketplace.json    # Marketplace manifest (version + metadata)
│   └── plugin.json         # Plugin manifest
├── .claude/
│   └── commands/           # Dev-time slash commands (local development)
│       ├── analyze-agent.md
│       ├── create-agent.md
│       └── release.md
├── commands/               # Plugin commands (distributed to users)
│   ├── analyze-agent.md
│   └── create-agent.md
├── docs/
│   └── TEP-INTEGRATION.md # Cache efficiency integration plan
├── examples/
│   ├── reports/            # Sample analysis reports (self-analysis)
│   └── configs/            # Starter configs (nodejs, python, generic)
├── assets/                 # Banner and logo images
├── AGENT_SMITH.md          # Core identity document (loaded by commands)
├── CLAUDE.md               # This file (development context)
├── IMPROVEMENTS.md         # Changelog
├── README.md               # User-facing documentation
└── VERSION                 # Current version
```

---

## Wiki Structure

The GitHub wiki is a separate repository located at `/Users/mam/WebstormProjects/claude-code-agent-smith-wiki/`.
**You must update the wiki yourself** when releasing a new version — do not ask the user to do it. Update `Roadmap.md` (version, history, recently completed table), then commit and push from the wiki repo.

| Page | Purpose |
|------|---------|
| Home.md | Overview and quick start |
| Commands.md | All 2 commands documented |
| Evaluation-Pillars.md | The 7-pillar system explained |
| Analysis-Scope.md | What we measure vs. don't measure |
| Installation.md | Setup instructions |
| Best-Practices.md | Tips for good configurations |
| Roadmap.md | Version history and planned features |
| Contributing.md | Development guide (to be created) |

---

## Common Development Tasks

### Adding a New Command

1. Create command in both `.claude/commands/` (dev) and `commands/` (plugin)
2. Update `README.md` commands table
3. Update wiki `Commands.md`
4. Bump minor version

### Modifying a Pillar

1. Update `AGENT_SMITH.md` pillar definition
2. Update all command files that reference pillars
3. Update wiki `Evaluation-Pillars.md`
4. Bump minor version

### Modifying the Report Format

1. Update report template in both `.claude/commands/analyze-agent.md` (dev) and `commands/analyze-agent.md` (plugin)
2. Update example reports in `examples/reports/` to reflect the new format
3. Bump minor version

### Renaming/Removing a Command

1. Remove/rename in both `.claude/commands/` and `commands/`
2. Update all documentation
3. Bump minor version (or major if breaking)

---

## Testing

Before releasing:

1. Run `claude plugin validate .` to validate the plugin
2. Test `/analyze-agent` on a sample project
3. Verify report format matches expected structure
4. Check that Action Plan checkboxes render correctly
5. Verify footer links are present

---

## Links

- **Repository:** https://github.com/maxencemeloni/claude-code-agent-smith
- **Wiki:** https://github.com/maxencemeloni/claude-code-agent-smith/wiki
- **AI Tools Hub:** https://hub.mmapi.fr/tools?origin=claudecode
