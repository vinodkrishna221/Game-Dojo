# Game Dojo — PostInvocation Validation Reminder Hook
# Outputs a JSON payload reminding the agent to validate generated documents.
# Uses empty injectSteps and does not force continuation, allowing the agent
# to organically include validation in its workflow.

$output = @{
    injectSteps    = @()
    forceContinue  = $false
    injectMessages = @(
        @{
            role    = "system"
            content = "Reminder: If you generated or modified project documents in this invocation, consider running validation to ensure all files are consistent, cross-references are intact, and no required sections are missing."
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Output $output
