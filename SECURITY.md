# Security Policy

## Supported Versions

Only the latest minor release of Agent Smith receives security updates.

| Version | Supported |
|---------|:---------:|
| 2.5.x   | ✅        |
| < 2.5   | ❌        |

## Reporting a Vulnerability

If you discover a security issue in Agent Smith, please **do not open a public GitHub issue**.

Instead, report it privately via one of these channels:

1. **Email** — `maxence@mmapi.fr` with subject line `[SECURITY] Agent Smith — <short summary>`
2. **GitHub Security Advisories** — use the [Report a vulnerability](https://github.com/maxencemeloni/claude-code-agent-smith/security/advisories/new) form

### What to Include

- A clear description of the issue and its impact
- Steps to reproduce (commands, file contents, or a minimal repro case)
- The version of Agent Smith and Claude Code you are using
- Any proof-of-concept code or screenshots, if applicable

### What to Expect

- Acknowledgement within **72 hours** of your report
- An initial assessment and severity estimate within **7 days**
- Regular updates until the issue is resolved or closed
- Credit in the release notes once a fix is published (if desired)

## Scope

Agent Smith is a set of Markdown slash command definitions executed inside a Claude Code session. Relevant security concerns include:

- Command definitions that could cause unintended file system writes or deletions
- Instructions that could expose secrets when analyzing a user's configuration
- Hook or settings recommendations that reduce the safety of the user's environment

### Out of Scope

- Vulnerabilities in Claude Code itself (report to Anthropic)
- Vulnerabilities in third-party plugins or MCP servers
- Issues that require local file system access the user has already granted

## Disclosure

We follow coordinated disclosure. Please allow a reasonable window for a fix to be released before public discussion.
