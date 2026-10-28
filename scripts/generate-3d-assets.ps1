#!/usr/bin/env pwsh
# ==============================================================================
# BroTel: Gym Bro Hotel Tycoon - Blender 3D Model Generation Script
# ==============================================================================

$ErrorActionPreference = "Stop"

$blenderExe = "C:\Program Files\Blender Foundation\Blender 5.0\blender.exe"
$scriptPath = "tools/blender/generate_brotel_models.py"

Write-Host "🎨 Starting 3D Asset Generation for BroTel..." -ForegroundColor Cyan

if (-not (Test-Path $blenderExe)) {
    Write-Host "❌ Blender 5.0 executable not found at '$blenderExe'" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ Generation script not found at '$scriptPath'" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Executing Blender in background mode..." -ForegroundColor Yellow
& $blenderExe --background --python $scriptPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Blender 3D model generation finished successfully!" -ForegroundColor Green
    Write-Host "📦 Generated assets in Assets/Models/:" -ForegroundColor Cyan
    Get-ChildItem -Path "Assets/Models" -Filter "*.obj" | Select-Object Name, Length | Format-Table -AutoSize
} else {
    Write-Host "❌ Blender script exited with code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}
