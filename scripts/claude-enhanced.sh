#!/bin/bash
# Claude Code CLI Enhanced - Sistema Nativo com Agentes Customizados
# Wrapper otimizado que carrega agentes via JSON e mantém compatibilidade nativa

set -e

# Configurações
CLAUDE_BIN="claude"
AGENTS_JSON_FILE="/home/arturdr/.claude/agents.json"
TEMP_FILE=""

# Função para limpeza
trap cleanup EXIT
cleanup() {
    if [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]]; then
        rm -f "$TEMP_FILE"
    fi
}

# Verificar se o arquivo JSON existe
if [[ ! -f "$AGENTS_JSON_FILE" ]]; then
    echo "❌ Arquivo de agentes não encontrado: $AGENTS_JSON_FILE"
    echo "   Execute: python3 /home/arturdr/.claude/generate-slash-commands.py"
    exit 1
fi

# Ler JSON dos agentes
AGENTS_JSON=$(cat "$AGENTS_JSON_FILE")

# Mensagem de boas-vindas
echo "🚀 Claude Code CLI Enhanced"
echo "📋 Sistema Nativo com 53 Agentes Especializados"
echo ""

# Mostrar agentes disponíveis
echo "🤖 Agentes Proxy Disponíveis:"
echo "   • code-reviewer-proxy    - Revisão completa de código"
echo "   • security-specialist-proxy - Análise de segurança OWASP"
echo "   • backend-architect-proxy - Arquitetura e APIs"
echo "   • frontend-specialist-proxy - Frontend e UX"
echo "   • devops-specialist-proxy - DevOps e infraestrutura"
echo ""

# Mostrar comandos slash disponíveis
echo "🔧 Comandos Slash Disponíveis:"
echo "   • /code-review       - Revisão completa de código"
echo "   • /security-review   - Análise de segurança"
echo "   • /architecture-review - Arquitetura backend"
echo "   • /frontend-review   - Frontend e UX"
echo "   • /devops-review     - DevOps e infraestrutura"
echo ""

# Executar Claude com agentes carregados
echo "📡 Carregando 53 agentes customizados..."
"$CLAUDE_BIN" --agents "$AGENTS_JSON" "$@""