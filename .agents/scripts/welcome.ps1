# Game Dojo — SessionStart Welcome Hook
# Outputs a JSON payload that injects a welcome message into the session context.

$output = @{
    injectMessages = @(
        @{
            role    = "system"
            content = @"
🥋 Welcome to Game Dojo! Describe your project idea and I'll set up everything you need.

I can help you bootstrap a complete project from scratch. Just tell me:
- What kind of app or game you want to build
- Who your target audience is
- Any technologies you prefer

I'll walk you through a structured interview, analyze your requirements, and generate
a fully scaffolded workspace with architecture docs, design systems, and implementation plans.

Type your idea to get started!
"@
        }
    )
} | ConvertTo-Json -Depth 10 -Compress

Write-Output $output
