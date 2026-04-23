# Contributing to Agent Smith

Thanks for your interest in improving Agent Smith. This document explains how to propose changes.

## Code of Conduct

This project follows the [Contributor Covenant](./CODE_OF_CONDUCT.md). By participating, you agree to uphold it.

## Ways to Contribute

- **Bug reports** — open an [issue](https://github.com/maxencemeloni/claude-code-agent-smith/issues/new/choose) using the Bug Report template.
- **Feature requests** — open an issue using the Feature Request template. Be clear about whether the suggestion is *for users* (a recommendation Agent Smith should surface) or *for the tool* (a change to Agent Smith's internals). See `CLAUDE.md` for the distinction.
- **Pull requests** — see the workflow below.

## Development Setup

Agent Smith is distributed as a Claude Code plugin. No build step is required — the project is a set of Markdown slash command definitions and supporting docs.

```bash
git clone git@github.com:maxencemeloni/claude-code-agent-smith.git
cd claude-code-agent-smith
```

To test changes locally:

1. The `.claude/commands/` directory contains the **dev** versions of the commands, loaded automatically when you run Claude Code inside this repo.
2. The `commands/` directory contains the **plugin** versions distributed to end users.
3. Most changes must be applied to both (see `CLAUDE.md` → *Dev vs Plugin Command Parity* for the few deliberate divergences).

## Repository Layout

See `CLAUDE.md` → *Repository Structure* for the canonical layout. Key entry points:

| Path | Purpose |
|------|---------|
| `AGENT_SMITH.md` | Core identity and pillar definitions |
| `commands/` | Plugin slash commands (user-facing) |
| `.claude/commands/` | Dev slash commands (local testing) |
| `.claude-plugin/` | Plugin and marketplace manifests |
| `wiki/` (separate repo) | Public documentation |

## Design Principles

Before proposing changes, read `CLAUDE.md` → *Design Principles*. The short version:

1. **Honesty over hype** — we only claim to measure what we actually measure.
2. **Scope clarity** — out-of-scope items (system prompt, tool schemas, runtime) stay out of scope.
3. **Evidence required** — findings need file paths and specific issues.
4. **Conservative fixes** — when uncertain, flag for manual review.
5. **Developer respect** — no dumbed-down language.

## Pull Request Workflow

1. Fork the repo and create a topic branch from `main`.
2. Make your changes. Keep commits focused and messages descriptive.
3. If your change affects behavior, update:
   - The relevant command file(s) in both `commands/` and `.claude/commands/`
   - `README.md` if user-facing
   - `IMPROVEMENTS.md` with a changelog entry
   - Wiki pages if documentation needs updating (separate repo)
4. Bump the version in `VERSION`, `.claude-plugin/plugin.json`, and `.claude-plugin/marketplace.json` following semver:
   - **Patch** — bug fixes
   - **Minor** — new features, non-breaking
   - **Major** — breaking changes
5. Open a pull request using the template. Link any related issues.

## Testing a Change

Before requesting review:

1. Run `claude plugin validate .` to confirm the plugin manifest is valid.
2. Test the affected command against a sample project.
3. Verify report output (when applicable) still matches the documented structure.
4. Confirm both dev and plugin command variants behave identically (outside of the documented parity exceptions).

## Commit Message Style

Follow the existing pattern visible in `git log`:

```
Release vX.Y.Z — Short description
Add <feature> to <command>
Fix <issue> in <area>
```

Keep the subject under 72 characters. Use the body for context when the subject is not self-explanatory.

## Reporting Security Issues

Do **not** open a public issue for security vulnerabilities. See [`SECURITY.md`](./SECURITY.md) for the disclosure process.

## Questions

Open a [Discussion](https://github.com/maxencemeloni/claude-code-agent-smith/discussions) or reach out via an issue labeled `question`.
