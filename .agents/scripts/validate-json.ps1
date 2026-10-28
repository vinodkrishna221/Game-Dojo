# Read stdin for the tool call context
$input = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Check if the written file is a JSON file
$filePath = $input.toolCall.args.Path
if ($filePath -and $filePath -match '\.json$') {
    try {
        $content = Get-Content -Path $filePath -Raw -ErrorAction Stop
        $null = $content | ConvertFrom-Json -ErrorAction Stop
        # Valid JSON — no action needed
    } catch {
        # Invalid JSON detected — log warning
        Write-Error "⚠️ Invalid JSON detected in $filePath: $_"
    }
}

# PostToolUse expects empty JSON output
Write-Output '{}'
