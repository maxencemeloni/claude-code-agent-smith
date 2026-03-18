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

Write-Host ""
Write-Host "Claude Code Agent Smith commands have been removed." -ForegroundColor Cyan
Write-Host ""
