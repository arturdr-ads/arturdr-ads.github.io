#!/bin/bash
# Claude Code CLI Optimized - Sistema Otimizado com Agentes Consolidados
# Versão otimizada que remove duplicações e melhora performance

set -e

# Configurações otimizadas
CLAUDE_BIN="claude"
AGENTS_JSON_FILE="/home/arturdr/.claude/agents-minimal.json"
CLAUDE_DIR="$HOME/Claude"
LOG_FILE="$CLAUDE_DIR/logs/claude-$(date +%Y%m%d-%H%M%S).log"

# Criar diretório de logs se não existir
mkdir -p "$CLAUDE_DIR/logs"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Função para limpeza
trap cleanup EXIT
cleanup() {
    log "🧹 Limpeza concluída"
}

# Verificar se o Claude está instalado
if ! command -v "$CLAUDE_BIN" &> /dev/null; then
    log "❌ Claude Code não encontrado no PATH"
    log "   Instale com: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Verificar se o arquivo JSON existe
if [[ ! -f "$AGENTS_JSON_FILE" ]]; then
    log "⚠️  Arquivo de agentes não encontrado: $AGENTS_JSON_FILE"
    log "   Usando agentes padrão do sistema..."
    AGENTS_JSON_FILE=""
fi

# Mensagem de boas-vindas otimizada
log "🚀 Claude Code CLI Optimized"
log "📋 Sistema Otimizado com Agentes Consolidados"
log "📁 Diretório: $CLAUDE_DIR"
log "📝 Log: $LOG_FILE"

# Mostrar agentes principais otimizados
echo ""
echo "🤖 Agentes Principais Otimizados:"
echo "   • code-reviewer       - Revisão completa de código"
echo "   • security-specialist - Análise de segurança OWASP"
echo "   • backend-architect   - Arquitetura e APIs"
echo "   • frontend-specialist - Frontend e UX"
echo "   • devops-specialist   - DevOps e infraestrutura"
echo "   • ai-ml-specialist    - IA/ML e data science"
echo "   • performance-optimizer - Otimização de performance"
echo ""

# Mostrar comandos slash otimizados
echo "🔧 Comandos Slash Otimizados:"
echo "   • /code-review       - Revisão completa de código"
echo "   • /security-review   - Análise de segurança"
echo "   • /architecture-review - Arquitetura backend"
echo "   • /frontend-review   - Frontend e UX"
echo "   • /devops-review     - DevOps e infraestrutura"
echo "   • /performance-review - Otimização de performance"
echo "   • /ai-ml-analysis    - Análise IA/ML"
echo ""

# Executar Claude com configuração otimizada
if [[ -n "$AGENTS_JSON_FILE" && -f "$AGENTS_JSON_FILE" ]]; then
    AGENTS_JSON=$(cat "$AGENTS_JSON_FILE")
    log "📡 Carregando agentes otimizados de: $AGENTS_JSON_FILE"
    "$CLAUDE_BIN" --agents "$AGENTS_JSON" "$@"
else
    log "📡 Iniciando Claude Code com agentes padrão..."
    "$CLAUDE_BIN" "$@"
fi

log "✅ Sessão Claude Code concluída"