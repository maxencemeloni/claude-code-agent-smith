#!/bin/bash

# Claude Code Agent Smith - Mac/Linux Installer
# This script installs global slash commands for Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

echo ""
echo "Claude Code Agent Smith - Installer"
echo "===================================="
echo ""
echo "Repository path: $SCRIPT_DIR"
echo "Installing to:   $CLAUDE_COMMANDS_DIR"
echo ""

# Create commands directory if it doesn't exist
mkdir -p "$CLAUDE_COMMANDS_DIR"

# Remove old commands that were renamed/deleted
OLD_COMMANDS=(
    "audit-tokens.md"
    "model-routing.md"
    "optimize-tools.md"
    "rate-prompts.md"
)

for cmd in "${OLD_COMMANDS[@]}"; do
    TARGET="$CLAUDE_COMMANDS_DIR/$cmd"
    if [ -f "$TARGET" ]; then
        rm "$TARGET"
        NAME="${cmd%.md}"
        echo "Removed old /$NAME"
    fi
done

# Copy new command files
COMMANDS=(
    "analyze-agent.md"
    "quick-rate.md"
    "audit-context.md"
    "validate-agent.md"
    "create-agent.md"
    "fix-agent.md"
    "rate-instructions.md"
    "optimize-commands.md"
)

for cmd in "${COMMANDS[@]}"; do
    SOURCE="$SCRIPT_DIR/.claude/commands/$cmd"
    if [ -f "$SOURCE" ]; then
        cp "$SOURCE" "$CLAUDE_COMMANDS_DIR/$cmd"
        NAME="${cmd%.md}"
        echo "Installed /$NAME"
    else
        echo "Warning: $SOURCE not found"
    fi
done

echo ""
echo "Installation Complete!"
echo "======================"
echo ""
echo "Available commands (use from any Claude Code session):"
echo ""
echo "  /analyze-agent       Full configuration analysis"
echo "  /quick-rate          Rapid assessment"
echo "  /audit-context       Context efficiency check"
echo "  /validate-agent      Syntax and structure validation"
echo "  /fix-agent           Auto-fix common issues"
echo "  /create-agent        Scaffold new configuration"
echo "  /rate-instructions   Instruction file quality"
echo "  /optimize-commands   Command quality analysis"
echo ""
echo "Usage:"
echo "  cd your-project"
echo "  claude"
echo "  /analyze-agent"
echo ""
