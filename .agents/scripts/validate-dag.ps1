# Game Dojo — Directed Acyclic Graph (DAG) Task Cycle Validator
# Validates that task dependencies in .ai-team/tasks/*.json do not contain circular dependencies.

param(
    [string]$TaskDir = ".ai-team/tasks"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Test-Path $TaskDir)) {
    Write-Output "INFO: Task directory '$TaskDir' not found. Skipping DAG validation."
    exit 0
}

$taskFiles = Get-ChildItem -Path $TaskDir -Filter "*.json" -ErrorAction SilentlyContinue

if (-not $taskFiles -or $taskFiles.Count -eq 0) {
    Write-Output "INFO: No task manifest files found in '$TaskDir'."
    exit 0
}

$tasks = @()
foreach ($file in $taskFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction Stop
        $parsed = $content | ConvertFrom-Json -ErrorAction Stop
        $tasks += $parsed
    } catch {
        Write-Error "Failed to parse task JSON at $($file.FullName): $($_.Exception.Message)"
        exit 1
    }
}

$graph = @{}
foreach ($t in $tasks) {
    if (-not $t.id) { continue }
    $deps = @()
    if ($t.dependencies) {
        $deps += @($t.dependencies)
    } elseif ($t.blockedBy) {
        $deps += @($t.blockedBy)
    }
    $graph[$t.id] = $deps
}

$visited = @{}
$inStack = @{}
$detectedCycles = @()

function Test-TaskCycle($node, $path) {
    $visited[$node] = $true
    $inStack[$node] = $true
    $path += $node

    if ($graph.ContainsKey($node)) {
        foreach ($dep in $graph[$node]) {
            if (-not $graph.ContainsKey($dep)) {
                # Dependency is external or not in current task set; skip
                continue
            }
            if (-not $visited[$dep]) {
                Test-TaskCycle $dep $path
            } elseif ($inStack[$dep]) {
                $cycleStart = $path.IndexOf($dep)
                $cycle = ($path[$cycleStart..($path.Length - 1)] + $dep) -join " -> "
                $script:detectedCycles += $cycle
            }
        }
    }
    $inStack[$node] = $false
}

foreach ($id in $graph.Keys) {
    if (-not $visited[$id]) {
        Test-TaskCycle $id @()
    }
}

if ($detectedCycles.Count -gt 0) {
    Write-Error "DAG Validation Failed! Circular task dependencies detected:"
    foreach ($c in $detectedCycles) {
        Write-Host "  ❌ Cycle: $c" -ForegroundColor Red
    }
    exit 1
} else {
    Write-Output "✅ DAG Validation Passed: $($graph.Count) tasks verified with zero dependency cycles."
    exit 0
}
