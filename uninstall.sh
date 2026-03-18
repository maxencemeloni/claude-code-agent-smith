#!/bin/bash

# Claude Code Agent Smith - Mac/Linux Uninstaller
# Removes global slash commands from Claude Code

CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

echo ""
echo "Claude Code Agent Smith - Uninstaller"
echo "=========================="
echo ""

COMMANDS=(
    "analyze-agent.md"
    "quick-rate.md"
    "audit-tokens.md"
    "model-routing.md"
    "optimize-tools.md"
    "rate-prompts.md"
)

for cmd in "${COMMANDS[@]}"; do
    if [ -f "$CLAUDE_COMMANDS_DIR/$cmd" ]; then
        rm "$CLAUDE_COMMANDS_DIR/$cmd"
        echo "Removed /${cmd%.md}"
    fi
done

echo ""
echo "Claude Code Agent Smith commands have been removed."
echo ""
