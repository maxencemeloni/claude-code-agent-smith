# Auto-Fix Configuration

You are Agent Smith. **Auto-repair common issues** in a Claude Code project configuration.

## Input

$ARGUMENTS - Local path to fix (defaults to current directory)

## Scope

**Fix:** `.claude/` directory, `.claudeignore`, instruction files.

**Never modify:** Source code, dependencies, user data.

## Fixable Issues

### 1. Structure Fixes

| Issue | Fix |
|-------|-----|
| `.claude/` missing | Create directory |
| `settings.json` missing | Create with basic deny rules |
| `.claude/commands/` missing | Create directory |

### 2. Security Fixes

| Issue | Fix |
|-------|-----|
| Missing deny rules | Add standard deny rules for sensitive files |
| `Bash(*)` in allow | Flag for manual review (too dangerous to auto-fix) |

**Standard deny rules to add:**
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

### 3. .claudeignore Fixes

| Issue | Fix |
|-------|-----|
| File missing | Create from `.gitignore` + add `.git/` |
| `.git/` missing | Add `.git/` to existing file |
| Missing project patterns | Add based on detected project type |

**If no .gitignore exists, create based on project type:**

| Project Type | Patterns |
|--------------|----------|
| Node.js | `.git/`, `node_modules/`, `dist/`, `.npm/` |
| Python | `.git/`, `__pycache__/`, `.venv/`, `venv/`, `*.pyc` |
| Rust | `.git/`, `target/` |
| Go | `.git/`, `vendor/`, `bin/` |
| Java | `.git/`, `target/`, `build/`, `*.class` |
| PHP | `.git/`, `vendor/` |
| Generic | `.git/`, `.idea/`, `*.log`, `.DS_Store` |

### 4. JSON Syntax Fixes

| Issue | Fix |
|-------|-----|
| Trailing comma | Remove |
| Missing closing brace | Add |
| Invalid JSON | Attempt parse, show error location |

### 5. Hooks Fixes

| Issue | Fix |
|-------|-----|
| Invalid JSON | Fix syntax |
| Dangerous commands | Flag for manual review (don't auto-remove) |
| Missing script references | Flag for manual review |

### 6. Consistency Fixes

| Issue | Fix |
|-------|-----|
| Duplicate content | Suggest consolidation (manual review) |
| Broken file references | Flag for manual review |
| Contradictions | Flag for manual review |

## Process

### Phase 1: Scan

1. Run validation checks (same as `/validate-agent`)
2. Categorize issues by type
3. Separate auto-fixable from manual-review

### Phase 2: Present

Show all issues with proposed fixes:

```markdown
# Issues Found

## Auto-fixable (safe to apply)
1. [Structure] `.claude/` missing → Create directory
2. [Security] No deny rules → Add standard rules
3. [.claudeignore] `.git/` missing → Add pattern

## Needs Confirmation
4. [.claudeignore] Missing `node_modules/` → Add? [y/N]
5. [Syntax] settings.json has trailing comma → Remove? [y/N]

## Manual Review Required
6. [Security] `Bash(*)` in allow rules → Too broad, review manually
7. [Hooks] Command `rm -rf $DIR` looks dangerous → Review manually
```

### Phase 3: Fix

1. Apply safe fixes automatically
2. Apply confirmed fixes
3. Skip manual review items

## Safety Rules

1. **Show before applying** — Never modify without showing what will change
2. **Offer backup** — Ask "Create backup before fixing? [y/N]"
3. **Atomic changes** — Each fix is independent
4. **Conservative** — When uncertain, flag for manual review instead of guessing

## Output Format

```markdown
# Fix Report: [Project Name]

**Issues Found:** X
**Fixed:** Y
**Skipped:** Z

---

## Fixes Applied

### Structure
✓ Created `.claude/` directory
✓ Created `.claude/commands/` directory

### Security
✓ Added deny rules to `settings.json`

### .claudeignore
✓ Created `.claudeignore` from `.gitignore`
✓ Added `.git/` pattern

### Syntax
✓ Removed trailing comma in `settings.json` (line 12)

---

## Skipped (manual review needed)

- [ ] `Bash(*)` in allow rules — review `settings.local.json:15`
- [ ] Hook command looks dangerous — review `hooks.json:8`
- [ ] Possible contradiction between files — review manually

---

## Verification

Run `/validate-agent` to verify fixes.
```

## After Fixing

1. Show summary of changes
2. Offer to run `/validate-agent`
3. List items that need manual review

Begin scanning for fixable issues now.
