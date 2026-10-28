# Game Dojo — PostToolUse Markdown Lint Hook
# Performs basic markdown validation on written files.
# This script checks for common markdown issues without requiring external tools.

param()

# Read the file path from stdin (PostToolUse provides tool result context)
$input_json = $input | Out-String

try {
    $context = $input_json | ConvertFrom-Json -ErrorAction Stop
    $filePath = $context.toolResult.path
} catch {
    # If we can't parse context, exit cleanly
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
    Write-Output $output
    exit 0
}

# Only lint markdown files
if (-not $filePath -or -not ($filePath -match '\.md$')) {
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
    Write-Output $output
    exit 0
}

$warnings = @()

if (Test-Path $filePath) {
    $content = Get-Content $filePath -Raw -ErrorAction SilentlyContinue

    if ($content) {
        # Check: File should start with a top-level heading
        if (-not ($content -match '(?m)^# ')) {
            $warnings += "Missing top-level heading (# Title)"
        }

        # Check: No trailing whitespace on lines
        $lines = $content -split "`n"
        $trailingCount = ($lines | Where-Object { $_ -match '\s+$' }).Count
        if ($trailingCount -gt 0) {
            $warnings += "$trailingCount line(s) have trailing whitespace"
        }

        # Check: File should end with a newline
        if (-not ($content -match "`n$")) {
            $warnings += "File does not end with a newline"
        }

        # Check: No consecutive blank lines (more than 2 newlines in a row)
        if ($content -match "`n`n`n") {
            $warnings += "Contains consecutive blank lines"
        }
    }
}

if ($warnings.Count -gt 0) {
    $message = "Markdown lint warnings for $($filePath):`n" + ($warnings | ForEach-Object { "  - $_" } | Out-String)
    $output = @{
        injectMessages = @(
            @{
                role    = "system"
                content = $message.Trim()
            }
        )
    } | ConvertTo-Json -Depth 10 -Compress
} else {
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
}

Write-Output $output
