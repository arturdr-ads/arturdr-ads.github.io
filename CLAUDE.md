# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the main Claude Code CLI configuration directory containing:
- **claude-agents-management** - Project for managing agent organization and conflict resolution
- **scripts/** - Shell scripts for launching Claude with different agent configurations
- **docs/** - System documentation and usage guides

## Project Structure

### Main Projects
- **claude-agents-management/** - Agent management project resolving "overridden by projectSettings" conflicts
  - `.claude/agents/` - Project-specific agents (agents-manager, project-coordinator)
  - `.claude.json` - Project configuration
  - Scripts for agent conversion and intelligent routing updates

### Agent Organization
- **Personal Agents**: `~/.claude/agents/` - 64+ specialized agents with intelligent routing
- **Project Agents**: `./.claude/agents/` - Project-specific agents (when in claude-agents-management)

## Development Workflow

### Launching Claude Code

#### Option 1: Enhanced System (53+ Agents)
```bash
./scripts/claude-enhanced.sh
```

#### Option 2: Simple System (5 Core Agents)
```bash
./scripts/claude-simple.sh
```

#### Option 3: Native System
```bash
claude
```

### Agent Management

#### Converting Agents to MD Format
```bash
python3 claude-agents-management/convert_agents_to_md.py
```

#### Updating Intelligent Routing
```bash
python3 claude-agents-management/update_intelligent_routing.py
```

#### Converting Agents to JSON for CLI
```bash
python3 scripts/convert_agents_to_json.py
```

### Available Agents

#### Core Development Agents
- `code-reviewer` - Comprehensive code review and quality assurance
- `security-specialist` - OWASP Top 10 vulnerability assessment
- `backend-architect` - Backend architecture and API design
- `frontend-specialist` - Frontend development and UX optimization
- `devops-specialist` - DevOps pipeline and infrastructure analysis

#### Language Specialists
- `javascript-pro` - JavaScript development
- `typescript-pro` - TypeScript development
- `python-pro` - Python development
- `react-pro` - React development
- `golang-pro` - Go programming
- `rust-pro` - Rust programming

#### Domain Experts
- `ai-ml-specialist` - AI/ML development and model training
- `database-specialist` - Database design and optimization
- `performance-optimizer` - Performance analysis and optimization
- `mobile-developer` - Mobile development

## Configuration Files

### Project Configuration
- `claude-agents-management/.claude.json` - Project-specific settings
- `~/.claude/agents.json` - Generated agent configuration for CLI usage

### Agent Files
- Agent files use Markdown format with YAML frontmatter
- Intelligent routing automatically configured for optimal model selection
- Specialization mapping for dynamic task routing

## Conflict Resolution

The `claude-agents-management` project resolves the "sonnet ⚠ overridden by projectSettings" conflict by:
1. Separating personal and project agent scopes
2. Moving conflicting `.claude.json` from home directory to backup
3. Creating clean project-specific configuration

## Key Scripts

- `claude-enhanced.sh` - Launch with 53+ specialized agents
- `claude-simple.sh` - Launch with 5 core agents
- `convert_agents_to_md.py` - Convert legacy agents to MD format
- `update_intelligent_routing.py` - Add intelligent routing to all agents
- `convert_agents_to_json.py` - Generate JSON for CLI agent loading

## Best Practices

### Agent Usage
- Use project agents when in `claude-agents-management` directory
- Use personal agents for general development tasks
- Leverage intelligent routing for optimal model selection

### Development Workflow
- Use appropriate specialized agents for specific tasks
- Run agent conversion scripts after adding new agents
- Maintain separation between personal and project agents
- Update intelligent routing when adding new agent types