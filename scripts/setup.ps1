#!/usr/bin/env pwsh
# ==============================================================================
# BroTel: Gym Bro Hotel Tycoon - Workspace Setup Script
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "🏨===========================================================🏨" -ForegroundColor Cyan
Write-Host "   BroTel: Gym Bro Hotel Tycoon - Setup & Prerequisite Check" -ForegroundColor Cyan
Write-Host "🏨===========================================================🏨" -ForegroundColor Cyan
Write-Host ""

# 1. Check Git
Write-Host "🔍 [1/5] Checking Git installation..." -ForegroundColor Yellow
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVer = git --version
    Write-Host "  ✅ Git detected: $gitVer" -ForegroundColor Green
} else {
    Write-Host "  ❌ Git not found! Please install Git." -ForegroundColor Red
}

# 2. Check Unity CLI
Write-Host "🎮 [2/5] Checking Unity CLI..." -ForegroundColor Yellow
$unityCmd = Get-Command unity -ErrorAction SilentlyContinue
if ($unityCmd) {
    Write-Host "  ✅ Unity CLI detected at: $($unityCmd.Source)" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Unity CLI not on PATH. Standard Unity Editor installations are still supported." -ForegroundColor Yellow
}

# 3. Check Blender 5.0
Write-Host "🎨 [3/5] Checking Blender 5.0..." -ForegroundColor Yellow
$blenderPath = "C:\Program Files\Blender Foundation\Blender 5.0\blender.exe"
if (Test-Path $blenderPath) {
    Write-Host "  ✅ Blender 5.0 detected at: $blenderPath" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Blender 5.0 default path not found at $blenderPath" -ForegroundColor Yellow
}

# 4. Check Node.js / npx for Local WebGL Server
Write-Host "🌐 [4/5] Checking Node.js / npx (for CrazyGames WebGL test server)..." -ForegroundColor Yellow
if (Get-Command npx -ErrorAction SilentlyContinue) {
    $nodeVer = node --version
    Write-Host "  ✅ Node.js detected: $nodeVer" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Node.js/npx not found. You can use Python 'python -m http.server' to host WebGL builds." -ForegroundColor Yellow
}

# 5. Initialize Directory Structure
Write-Host "📁 [5/5] Verifying workspace folders..." -ForegroundColor Yellow
$directories = @(
    "Assets/Scripts/Core",
    "Assets/Scripts/Gameplay",
    "Assets/Scripts/CrazyGames",
    "Assets/Scripts/Monetization",
    "Assets/Plugins/WebGL",
    "Assets/WebGLTemplates/CrazyGames",
    "Assets/Models",
    "Assets/Materials",
    "Assets/Prefabs",
    "tools/blender",
    "Builds/WebGL",
    "docs/contracts",
    ".ai-team/tasks"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ➕ Created directory: $dir" -ForegroundColor DarkGray
    }
}
Write-Host "  ✅ Directory structure verified." -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Setup check complete! You are ready to develop BroTel: Gym Bro Hotel Tycoon." -ForegroundColor Cyan
Write-Host "👉 Run 'powershell ./scripts/generate-3d-assets.ps1' to generate 3D models via Blender." -ForegroundColor White
Write-Host "👉 Run 'powershell ./scripts/serve-local.ps1' to launch the CrazyGames local test server." -ForegroundColor White
Write-Host ""
