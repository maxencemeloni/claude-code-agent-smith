---
description: "[Agent Smith] Create Configuration"
---

# Create Configuration

You are Agent Smith. **Scaffold a Claude Code configuration** with sensible defaults.

**Load rules first:** Use the `Read` tool to read `${CLAUDE_PLUGIN_ROOT}/AGENT_SMITH.md`. This file contains your security patterns and project type detection rules — you MUST use them. If the file cannot be found, warn the user: "⚠️ Could not load AGENT_SMITH.md — reinstall the plugin." and continue with best judgment.

## Input

$ARGUMENTS - Project path (defaults to current directory)

## What Gets Created

```
.claude/
├── settings.json        # Permissions with deny rules
└── commands/
    └── example.md       # Command template
CLAUDE.md                # Instruction file
.claudeignore            # Context filtering
```

## Process

### 1. Check Existing Files

If any of these exist, ask before overwriting:
- `.claude/` directory
- `CLAUDE.md`
- `.claudeignore`

### 2. Detect Project Type

Check for manifest files:

| File | Type |
|------|------|
| `package.json` | Node.js |
| `requirements.txt` | Python |
| `pyproject.toml` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `pom.xml` | Java/Maven |
| `build.gradle` | Java/Gradle |
| `composer.json` | PHP |
| `Gemfile` | Ruby |

### 3. Create .claudeignore

**If `.gitignore` exists:**
1. Copy its contents
2. Add `.git/` at the top (required for Claude Code)
3. Add binary patterns if missing

**If no `.gitignore`:**
Create based on detected project type:

| Type | Patterns |
|------|----------|
| Node.js | `.git/`, `node_modules/`, `dist/`, `coverage/`, `*.log` |
| Python | `.git/`, `__pycache__/`, `.venv/`, `venv/`, `*.pyc`, `.pytest_cache/` |
| Rust | `.git/`, `target/` |
| Go | `.git/`, `vendor/`, `bin/` |
| Java | `.git/`, `target/`, `build/`, `*.class` |
| PHP | `.git/`, `vendor/` |
| Ruby | `.git/`, `vendor/bundle/`, `.bundle/` |
| Generic | `.git/`, `.idea/`, `.vscode/`, `*.log`, `.DS_Store` |

### 4. Create settings.json

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Read(./**/*_rsa)",
      "Read(./**/id_rsa)",
      "Read(./**/*.secret)"
    ]
  }
}
```

### 5. Create CLAUDE.md

```markdown
# [Project Name]

Brief description of the project and its purpose.

## Project Structure

- `src/` — Source code
- `tests/` — Test files
- `docs/` — Documentation

## Development

Key commands and workflows for this project.

## Guidelines

Project-specific rules and conventions.

## Reference

For detailed information, see:
- Architecture: `docs/architecture.md`
- API: `docs/api.md`

---

*Keep this file concise. Reference documentation files instead of copying content.*
```

### 6. Create Example Command

Create `.claude/commands/example.md`:

```markdown
# Example Command

Brief description of what this command does.

## Input

$ARGUMENTS - Description of expected input

## Process

1. First step
2. Second step
3. Third step

## Output

Description of expected output format.

Begin now.
```

## Output Format

```markdown
# Configuration Created

**Project:** [name]
**Location:** [path]
**Type:** [detected type]

---

## Files Created

| File | Status |
|------|--------|
| `.claude/settings.json` | ✓ Created |
| `.claude/commands/example.md` | ✓ Created |
| `CLAUDE.md` | ✓ Created |
| `.claudeignore` | ✓ Created |

---

## .claudeignore

[If based on .gitignore:]
- Based on existing `.gitignore`
- Added `.git/` (required for Claude Code)

[If created from scratch:]
- Created for [project type]
- Includes standard patterns

---

## Security

Deny rules configured for:
- `.env` files
- `secrets/` directory
- Private keys (`.pem`, `.key`, `*_rsa`)

---

## Next Steps

1. Edit `CLAUDE.md` with project-specific information
2. Add custom commands in `.claude/commands/`
3. Run `/analyze-agent` to check configuration quality
```

## Safety

- **Never overwrite** existing files without asking
- If files exist, ask: "Configuration exists. Overwrite? [y/N]"
- Show what will be created before creating

Begin scaffolding now.
