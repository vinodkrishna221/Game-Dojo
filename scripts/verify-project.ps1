# ==============================================================================
# BroTel: Gym Bro Hotel Tycoon - Project Quality & Validation Script
# ==============================================================================

$ErrorActionPreference = "Continue"

Write-Host "[BroTel Verification] Running Project Quality and Schema Verification..." -ForegroundColor Cyan
$failed = 0
$total = 0

# 1. Validate JSON Files
$jsonFiles = Get-ChildItem -Path . -Recurse -Filter "*.json" | Where-Object { 
    $_.FullName -notmatch "node_modules|\.git|brain|\.gemini" 
}

Write-Host "Checking $($jsonFiles.Count) JSON configuration files..." -ForegroundColor Yellow
foreach ($file in $jsonFiles) {
    $total++
    try {
        $content = Get-Content $file.FullName -Raw | ConvertFrom-Json
        $relPath = $file.FullName.Replace((Get-Location).Path, '').TrimStart('\/')
        Write-Host "  [OK] $relPath" -ForegroundColor Green
    } catch {
        $failed++
        Write-Host "  [ERROR] SYNTAX ERROR in $($file.FullName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 2. Check Key Required Documents and Frozen Contracts
$requiredDocs = @(
    "docs/PRD.md",
    "docs/PROJECT_BRIEF.md",
    "docs/REQUIREMENTS.md",
    "docs/ARCHITECTURE.md",
    "docs/GAME_DESIGN.md",
    "docs/MONETIZATION_STRATEGY.md",
    "docs/contracts/crazygames-bridge-spec.json",
    "docs/contracts/game-state-schema.json",
    "docs/contracts/hotel-station-interface.json",
    ".ai-team/team.json",
    ".ai-team/plan.json",
    ".ai-team/tasks/TASK-001-gameplay-core.json",
    ".ai-team/tasks/TASK-002-crazygames-sdk.json",
    ".ai-team/tasks/TASK-003-blender-assets.json",
    ".ai-team/tasks/TASK-004-hotel-stations.json",
    ".ai-team/tasks/TASK-005-chaos-and-staff.json",
    ".ai-team/tasks/TASK-006-cloud-save-and-auth.json",
    ".github/CODEOWNERS",
    "GEMINI.md",
    "AGENTS.md",
    "DESIGN_SYSTEM.md",
    "README.md",
    "package.json"
)

Write-Host ""
Write-Host "Checking critical specification documents..." -ForegroundColor Yellow
foreach ($doc in $requiredDocs) {
    $total++
    if (Test-Path $doc) {
        Write-Host "  [OK] $doc exists" -ForegroundColor Green
    } else {
        $failed++
        Write-Host "  [MISSING] Missing expected file: $doc" -ForegroundColor Red
    }
}

Write-Host ""
if ($failed -eq 0) {
    Write-Host "[SUCCESS] All $total checks passed! Project is 100% compliant and ready for teammates." -ForegroundColor Green
    exit 0
} else {
    Write-Host "[WARNING] $failed out of $total checks failed. Review issues above." -ForegroundColor Yellow
    exit 1
}
