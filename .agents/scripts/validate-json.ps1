# Game Dojo — PostToolUse JSON Validation Hook
# Automatically validates JSON syntax when a .json file is written or modified.

param()

$input_json = $input | Out-String

try {
    $context = $input_json | ConvertFrom-Json -ErrorAction Stop
} catch {
    # If stdin context cannot be parsed, exit cleanly with no-op response
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
    Write-Output $output
    exit 0
}

# Resolve file path across supported Antigravity tool result / call formats
$filePath = $null
if ($context.toolResult -and $context.toolResult.path) {
    $filePath = $context.toolResult.path
} elseif ($context.toolCall -and $context.toolCall.args) {
    if ($context.toolCall.args.TargetFile) {
        $filePath = $context.toolCall.args.TargetFile
    } elseif ($context.toolCall.args.path) {
        $filePath = $context.toolCall.args.path
    } elseif ($context.toolCall.args.Path) {
        $filePath = $context.toolCall.args.Path
    }
}

# Only validate .json files
if (-not $filePath -or -not ($filePath -match '\.json$')) {
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
    Write-Output $output
    exit 0
}

if (Test-Path $filePath) {
    try {
        $content = Get-Content -Path $filePath -Raw -ErrorAction Stop
        $null = $content | ConvertFrom-Json -ErrorAction Stop
        # Valid JSON — return empty message list
        $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
    } catch {
        # Invalid JSON detected — inject system warning message for the agent
        $errorMessage = "⚠️ Invalid JSON detected in $($filePath): $($_.Exception.Message)"
        $output = @{
            injectMessages = @(
                @{
                    role    = "system"
                    content = $errorMessage
                }
            )
        } | ConvertTo-Json -Depth 10 -Compress
    }
} else {
    $output = @{ injectMessages = @() } | ConvertTo-Json -Depth 5 -Compress
}

Write-Output $output
