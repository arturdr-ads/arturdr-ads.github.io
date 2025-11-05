# Claude Agents Management Project

## Project Overview
This project is specifically created to manage and organize Claude Code agents, separating personal agents from project agents to resolve configuration conflicts.

## Project Structure
```
claude-agents-management/
├── .claude/
│   └── agents/                    # Project-specific agents
│       ├── agents-manager.md      # Agent management specialist
│       └── project-coordinator.md # Project coordination agent
├── .claude.json                   # Project configuration
└── CLAUDE.md                      # This file
```

## Agent Organization

### Personal Agents (Global)
- Location: `~/.claude/agents/`
- Purpose: Generic, reusable agents for all projects
- Status: 63 agents available with intelligent routing

### Project Agents (Local)
- Location: `.claude/agents/`
- Purpose: Specific to this agents management project
- Status: 2 agents created for project management

## Conflict Resolution
This project resolves the "sonnet ⚠ overridden by projectSettings" conflict by:
1. Moving the conflicting `.claude.json` from home directory to backup
2. Creating a clean project-specific configuration
3. Separating agent scopes properly

## Available Agents in This Project
- **agents-manager**: Specialized in agent organization and conflict resolution
- **project-coordinator**: Coordinates workflows within this specific project

## Usage
Use project agents for:
- Agent management and organization
- Conflict resolution
- Project-specific coordination

Use personal agents for:
- General development tasks
- Code review and analysis
- Generic workflows