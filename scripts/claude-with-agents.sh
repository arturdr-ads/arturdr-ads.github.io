#!/bin/bash
# Wrapper script para Claude Code CLI com agentes carregados via --agents

# Ler o JSON dos agentes (versão minimal para evitar problemas de tamanho)
AGENTS_JSON=$(cat /home/arturdr/.claude/agents-minimal.json)

# Executar Claude com os agentes carregados
claude --agents "$AGENTS_JSON" "$@"