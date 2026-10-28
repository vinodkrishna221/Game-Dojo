#!/usr/bin/env pwsh
# ==============================================================================
# BroTel: Gym Bro Hotel Tycoon - Unity WebGL Build Script
# ==============================================================================

$ErrorActionPreference = "Stop"

$projectPath = (Get-Location).Path
$buildOutput = "$projectPath\Builds\WebGL"
$logFile = "$projectPath\Builds\build.log"

Write-Host "🎮 Initiating Unity WebGL Build for CrazyGames..." -ForegroundColor Cyan
Write-Host "  Project: $projectPath" -ForegroundColor DarkGray
Write-Host "  Output:  $buildOutput" -ForegroundColor DarkGray

if (-not (Test-Path "$projectPath\Builds")) {
    New-Item -ItemType Directory -Path "$projectPath\Builds" -Force | Out-Null
}

$unityCmd = Get-Command unity -ErrorAction SilentlyContinue
if (-not $unityCmd) {
    Write-Host "⚠️ 'unity' command not found on PATH. Attempting to locate default Unity Editor..." -ForegroundColor Yellow
    $editorSearch = Get-ChildItem "C:\Program Files\Unity\Hub\Editor\*\Editor\Unity.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($editorSearch) {
        $unityPath = $editorSearch.FullName
        Write-Host "  Found Unity Editor at: $unityPath" -ForegroundColor Green
    } else {
        Write-Host "❌ Unity Editor executable could not be located automatically." -ForegroundColor Red
        Write-Host "   Please build from the Unity Editor GUI via File -> Build Settings -> WebGL." -ForegroundColor White
        exit 1
    }
} else {
    $unityPath = $unityCmd.Source
}

Write-Host "🚀 Executing Unity batchmode WebGL build..." -ForegroundColor Yellow
Write-Host "  Logging to: $logFile" -ForegroundColor DarkGray

& $unityPath -batchmode -quit -projectPath "$projectPath" -buildTarget WebGL -logFile "$logFile"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Unity WebGL build completed successfully!" -ForegroundColor Green
    Write-Host "📦 Output generated in: $buildOutput" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ Unity build finished with code $LASTEXITCODE. Inspect $logFile for compiler diagnostics." -ForegroundColor Yellow
}
