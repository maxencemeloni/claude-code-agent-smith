# Claude Code Agent Smith - Windows Uninstaller
# Removes global slash commands from Claude Code

$ClaudeCommandsDir = "$env:USERPROFILE\.claude\commands"

Write-Host ""
Write-Host "Claude Code Agent Smith - Uninstaller" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

$CommandFiles = @(
    "analyze-agent.md",
    "quick-rate.md",
    "audit-context.md",
    "validate-agent.md",
    "create-agent.md",
    "fix-agent.md",
    "rate-instructions.md",
    "optimize-commands.md",
    "agent-smith-version.md",
    # Old commands (pre-v1.0.0)
    "audit-tokens.md",
    "model-routing.md",
    "optimize-tools.md",
    "rate-prompts.md"
)

foreach ($File in $CommandFiles) {
    $Path = Join-Path $ClaudeCommandsDir $File
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Force
        $CommandName = [System.IO.Path]::GetFileNameWithoutExtension($File)
        Write-Host "Removed /$CommandName" -ForegroundColor Green
    }
}

# Remove version and repo tracking files
Remove-Item -Path "$env:USERPROFILE\.claude\agent-smith-version" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:USERPROFILE\.claude\agent-smith-repo" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Claude Code Agent Smith commands have been removed." -ForegroundColor Cyan
Write-Host ""
