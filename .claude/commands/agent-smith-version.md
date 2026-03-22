---
description: "[Agent Smith] Version & Update Check"
---

# Agent Smith — Version & Update Check

You are Agent Smith. Display the current installed version, check for updates, and offer to update if a newer version is available.

## Step 1: Read Local Version

Use the `Read` tool to read `~/.claude/agent-smith-version`.

- If the file **does not exist**, display:
  ```
  ⚠️  Agent Smith is not installed via install.sh — no version info available.
  ```
  Then stop here.
- If the file exists, store the version string (trim whitespace). This is the **local version**.

## Step 2: Read Repo Path

Use the `Read` tool to read `~/.claude/agent-smith-repo`.

- If the file **does not exist**, set repo path to "unknown".
- If the file exists, store the path (trim whitespace). This is the **repo path**.

## Step 3: Display Current Version

Display:
```
┌─────────────────────────────────────────────────────────────┐
│  🤖 Agent Smith v[local version]                            │
└─────────────────────────────────────────────────────────────┘
```

If repo path is known, also display:
```
Installed from: [repo path]
```

## Step 4: Check for Updates

Use the `WebFetch` tool to fetch:
```
https://raw.githubusercontent.com/maxencemeloni/claude-code-agent-smith/main/VERSION
```

Extract the version string (trim whitespace). This is the **remote version**.

If the fetch fails (network error, timeout), display:
```
⚠️  Could not check for updates (network error). Current version: v[local version]
```
Then stop here.

## Step 5: Compare Versions

Parse both versions as semver (major.minor.patch).

### Case A: Up to date (remote == local)

Display:
```
✅ You're up to date! (v[local version])
```

### Case B: Update available (remote > local)

Display:
```
⬆️  Update available: v[local version] → v[remote version]
```

Then use `WebFetch` to fetch:
```
https://raw.githubusercontent.com/maxencemeloni/claude-code-agent-smith/main/IMPROVEMENTS.md
```

Extract changelog sections between the local version and the remote version. Show only the relevant entries:

```
## Changelog

[relevant changelog entries from IMPROVEMENTS.md]
```

Then use the `AskUserQuestion` tool with these exact parameters:

```json
{
  "questions": [
    {
      "question": "Would you like to update Agent Smith to v[remote version]?",
      "header": "Update",
      "options": [
        {
          "label": "Yes, update now",
          "description": "Run git pull and install.sh to update to the latest version"
        },
        {
          "label": "No, skip",
          "description": "Stay on the current version"
        }
      ],
      "multiSelect": false
    }
  ]
}
```

**If the user selects "Yes, update now":**

Run in Bash:
```bash
cd [repo path] && git pull && ./install.sh
```

Then display:
```
✅ Updated to v[remote version]!
```

**If the user selects "No, skip":**

Display:
```
To update later: cd [repo path] && git pull && ./install.sh
```

### Case C: Local is newer (local > remote)

Display:
```
🔧 You're running a development version (v[local version] > v[remote version])
```
