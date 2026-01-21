# .git/hooks/post-commit (PowerShell version)
# Automatic codebase intelligence update after each commit
#
# Installation:
#   Copy this file to .git/hooks/post-commit
#   Git on Windows will automatically use PowerShell if .ps1 extension present

# Configuration
$IntelDir = ".gsd/intel"
$Quiet = $true

# Check if intelligence directory exists
if (-not (Test-Path $IntelDir)) {
    # Intelligence not initialized, skip
    exit 0
}

# Run incremental indexing
if ($Quiet) {
    ./scripts/index-codebase.ps1 -Incremental 2>$null | Out-Null
} else {
    Write-Host "Updating codebase intelligence..."
    ./scripts/index-codebase.ps1 -Incremental
}

# Check if intelligence changed
$gitDiff = git diff --quiet $IntelDir
if ($LASTEXITCODE -eq 0) {
    # No changes, exit
    exit 0
}

# Intelligence changed, amend commit to include it
git add $IntelDir
git commit --amend --no-edit --no-verify

if (-not $Quiet) {
    Write-Host "Codebase intelligence updated and included in commit"
}

exit 0
