---
description: "[Agent Smith] Release New Version"
---

# Release New Version

You are releasing a new version of Agent Smith. Follow every step precisely.

## Input

$ARGUMENTS — Version number (e.g., `2.1.0`) and a short description (e.g., `Add release command`)

Parse the input:
- **VERSION**: The semver version number (required)
- **DESCRIPTION**: Everything after the version number (required)

If either is missing, ask the user before proceeding.

## Pre-flight Checks

1. Verify you are on the `main` branch
2. Verify the working tree is clean (no uncommitted changes)
3. Read the current version from `VERSION` file
4. Confirm with the user: "Releasing v{VERSION} — {DESCRIPTION} (current: v{OLD_VERSION}). Proceed?"

If any check fails, stop and explain.

## Step 1 — Bump Version

Update the version in all these files:

| File | What to Update |
|------|----------------|
| `VERSION` | Replace contents with new version |
| `.claude-plugin/plugin.json` | Update `"version"` field |
| `.claude-plugin/marketplace.json` | Update `"version"` in the plugin entry |
| `README.md` | Update version badge: `v{VERSION}-Stable-green` |

## Step 2 — Changelog

Add a new section at the **top** of `IMPROVEMENTS.md` (before the previous version entry):

```markdown
## v{VERSION} — {DESCRIPTION}

*Released: {MONTH} {YEAR}*

### Changes

{Ask the user what changed, or summarize from recent commits since last release}

---
```

Use `git log` to see commits since the last release tag to help draft the changelog.

## Step 3 — Update Wiki

The wiki repo is at `/Users/mam/WebstormProjects/claude-code-agent-smith-wiki/`.

### Roadmap.md

1. Update `**Version:**` to the new version
2. Add a new version entry under `## Version History` (above the previous current version):
   ```
   ### v{VERSION} — {DESCRIPTION} (Current)
   - {bullet points summarizing changes}
   ```
3. Remove `(Current)` from the previous version entry
4. Add a row to the `## Recently Completed` table

## Step 4 — Commit & Push

### Main repo

```
git add VERSION .claude-plugin/plugin.json .claude-plugin/marketplace.json README.md IMPROVEMENTS.md
git commit -m "Release v{VERSION} — {DESCRIPTION}"
git push
```

### Wiki repo

```
cd /Users/mam/WebstormProjects/claude-code-agent-smith-wiki/
git add Roadmap.md
git commit -m "Update for v{VERSION} — {DESCRIPTION}"
git push
```

## Step 5 — GitHub Release

Create the release using `gh`:

```
gh release create v{VERSION} --repo maxencemeloni/claude-code-agent-smith --title "v{VERSION} — {DESCRIPTION}" --notes "..."
```

The release notes should include:
- A "What's New" summary
- The install instructions block:
  ```bash
  # Add the marketplace (one-time)
  claude plugin marketplace add maxencemeloni/claude-code-agent-smith

  # Install
  claude plugin install agent-smith
  ```
- A bullet list of changes
- A link to IMPROVEMENTS.md for the full changelog

## Step 6 — Verify

1. Confirm the release URL is accessible
2. Show the user the release URL
3. Refresh the marketplace cache, then update the plugin:
   ```bash
   claude plugin marketplace update agent-smith-marketplace
   claude plugin update agent-smith@agent-smith-marketplace
   ```
4. Verify the plugin version matches the new release

## Rules

- Do NOT skip any step
- Do NOT proceed past pre-flight if checks fail
- Always use `--repo maxencemeloni/claude-code-agent-smith` with `gh release create`
- Use HEREDOC for commit messages and release notes
- If `gh release create` fails, do NOT try `gh auth refresh` — just report the error
