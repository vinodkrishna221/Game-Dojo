# MCP Server Guide for Game Dojo

This document explains each MCP server configured in `mcp_config.json` and how it integrates with the Game Dojo bootstrapping workflow.

---

## Configured Servers

### sequential-thinking

**Purpose:** Enables structured, multi-step reasoning during complex decision-making phases of project scaffolding.

**When it's used:**
- **Architecture Phase** — When analyzing user requirements to determine the optimal tech stack, the sequential-thinking server breaks down trade-offs systematically (e.g., "Should this app use a monorepo or polyrepo? What are the implications for CI/CD, shared types, and deployment?").
- **Dependency Resolution** — When determining the order in which files should be generated, ensuring templates that reference other files are created after their dependencies.
- **Conflict Resolution** — When user preferences conflict with best practices (e.g., requesting a NoSQL database for a highly relational data model), the server helps structure a reasoned recommendation.

**How to invoke:**
```
Use the sequentialthinking tool to break down complex architectural decisions
into discrete reasoning steps before committing to a solution.
```

**Example scenario:**
A user says "Build me a multiplayer game with leaderboards." The sequential-thinking server helps reason through:
1. Real-time vs turn-based → affects protocol choice (WebSocket vs REST)
2. Leaderboard scale → affects database choice (Redis for caching, PostgreSQL for persistence)
3. Auth requirements → OAuth vs custom auth
4. Hosting model → serverless vs dedicated game servers

---

## Adding New MCP Servers

To add a new MCP server to Game Dojo:

1. Add the server entry to `.agents/mcp_config.json` under the `mcpServers` key
2. Document the server's purpose, usage scenarios, and invocation patterns in this guide
3. If the server requires environment variables, document them in a `.env.example` file
4. Test the server integration with a sample scaffolding run

### Server Entry Format

```json
{
  "mcpServers": {
    "server-name": {
      "command": "executable",
      "args": ["arg1", "arg2"],
      "description": "What this server does and why it's included."
    }
  }
}
```

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `command` | string | The executable to launch the server |
| `args` | string[] | Command-line arguments |
| `env` | object | Environment variables to set |
| `description` | string | Human-readable explanation of the server's role |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Server fails to start | Ensure the required npm package is installed or that `npx` can fetch it |
| Timeout on first call | The first invocation may be slow due to package download; subsequent calls are cached |
| Tool not found | Verify the tool name matches the server's registered tools via `list_resources` |
