# Claude Code Agent Smith - Windows Installer
# This script installs global slash commands for Claude Code

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeCommandsDir = "$env:USERPROFILE\.claude\commands"

Write-Host ""
Write-Host "Claude Code Agent Smith - Installer" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository path: $ScriptDir"
Write-Host "Installing to:   $ClaudeCommandsDir"
Write-Host ""

# Create commands directory if it doesn't exist
if (-not (Test-Path $ClaudeCommandsDir)) {
    New-Item -ItemType Directory -Path $ClaudeCommandsDir -Force | Out-Null
    Write-Host "Created directory: $ClaudeCommandsDir" -ForegroundColor Green
}

# Remove old commands that were renamed/deleted
$OldCommands = @(
    "audit-tokens.md",
    "model-routing.md",
    "optimize-tools.md",
    "rate-prompts.md"
)

foreach ($File in $OldCommands) {
    $Target = Join-Path $ClaudeCommandsDir $File
    if (Test-Path $Target) {
        Remove-Item -Path $Target -Force
        $CommandName = [System.IO.Path]::GetFileNameWithoutExtension($File)
        Write-Host "Removed old /$CommandName" -ForegroundColor Yellow
    }
}

# Copy new command files
$CommandFiles = @(
    "analyze-agent.md",
    "quick-rate.md",
    "audit-context.md",
    "validate-agent.md",
    "create-agent.md",
    "fix-agent.md",
    "rate-instructions.md",
    "optimize-commands.md",
    "agent-smith-version.md"
)

foreach ($File in $CommandFiles) {
    $Source = Join-Path $ScriptDir ".claude\commands\$File"
    $Dest = Join-Path $ClaudeCommandsDir $File

    if (Test-Path $Source) {
        Copy-Item -Path $Source -Destination $Dest -Force
        $CommandName = [System.IO.Path]::GetFileNameWithoutExtension($File)
        Write-Host "Installed /$CommandName" -ForegroundColor Green
    } else {
        Write-Host "Warning: $Source not found" -ForegroundColor Yellow
    }
}

# Save version info for update checking
$VersionFile = Join-Path $ScriptDir "VERSION"
if (Test-Path $VersionFile) {
    $Version = (Get-Content $VersionFile -Raw).Trim()
    Copy-Item -Path $VersionFile -Destination "$env:USERPROFILE\.claude\agent-smith-version" -Force
    Write-Host ""
    Write-Host "Version $Version installed" -ForegroundColor Green
}

# Save repo path for updates
$ScriptDir | Out-File -FilePath "$env:USERPROFILE\.claude\agent-smith-repo" -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "Installation Complete!" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available commands (use from any Claude Code session):"
Write-Host ""
Write-Host "  /analyze-agent       [Agent Smith] Full Configuration Analysis"
Write-Host "  /quick-rate          [Agent Smith] Quick Configuration Rating"
Write-Host "  /audit-context       [Agent Smith] Context Efficiency Audit"
Write-Host "  /validate-agent      [Agent Smith] Configuration Validation"
Write-Host "  /fix-agent           [Agent Smith] Auto-Fix Configuration"
Write-Host "  /create-agent        [Agent Smith] Create Configuration"
Write-Host "  /rate-instructions   [Agent Smith] Instruction Quality Analysis"
Write-Host "  /optimize-commands   [Agent Smith] Command & Extension Quality Analysis"
Write-Host "  /agent-smith-version [Agent Smith] Version & Update Check"
Write-Host ""
Write-Host "Usage:"
Write-Host "  cd your-project"
Write-Host "  claude"
Write-Host "  /analyze-agent"
Write-Host ""
