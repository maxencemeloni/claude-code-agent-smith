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
    "audit-context.md"
    "validate-agent.md"
    "create-agent.md"
    "fix-agent.md"
    "rate-instructions.md"
    "optimize-commands.md"
    "agent-smith-version.md"
    # Old commands (pre-v1.0.0)
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

# Remove version and repo tracking files
rm -f "$HOME/.claude/agent-smith-version"
rm -f "$HOME/.claude/agent-smith-repo"

echo ""
echo "Claude Code Agent Smith commands have been removed."
echo ""
