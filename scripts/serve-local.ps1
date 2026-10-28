#!/usr/bin/env pwsh
# ==============================================================================
# BroTel: Gym Bro Hotel Tycoon - CrazyGames WebGL Local Dev Server
# ==============================================================================

$port = 8080
$buildDir = "Builds/WebGL"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

Write-Host "🏨 Starting local HTTP server for CrazyGames WebGL testing..." -ForegroundColor Cyan
Write-Host "👉 URL: http://localhost:$port" -ForegroundColor Yellow
Write-Host "ℹ️  CrazyGames SDK requires an HTTP/HTTPS environment (not file://)." -ForegroundColor DarkGray
Write-Host "   Press Ctrl+C to terminate." -ForegroundColor DarkGray
Write-Host ""

if (Get-Command npx -ErrorAction SilentlyContinue) {
    npx serve $buildDir -l $port --cors
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    python -m http.server $port --directory $buildDir
} else {
    Write-Host "❌ Neither npx nor python was found to start a local static file server." -ForegroundColor Red
    exit 1
}
