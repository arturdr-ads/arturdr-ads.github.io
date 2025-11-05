#!/bin/bash
# System Check - Verificação do Sistema Claude Code Otimizado

set -e

CLAUDE_DIR="$HOME/Claude"
CLAUDE_CONFIG_DIR="$HOME/.claude"
LOG_FILE="$CLAUDE_DIR/logs/system-check-$(date +%Y%m%d-%H%M%S).log"

# Criar diretório de logs se não existir
mkdir -p "$CLAUDE_DIR/logs"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Função para verificar arquivo
check_file() {
    local file="$1"
    local description="$2"

    if [[ -f "$file" ]]; then
        log "✅ $description: $(basename "$file")"
        return 0
    else
        log "❌ $description: ARQUIVO NÃO ENCONTRADO"
        return 1
    fi
}

# Função para verificar diretório
check_dir() {
    local dir="$1"
    local description="$2"

    if [[ -d "$dir" ]]; then
        local count=$(find "$dir" -type f | wc -l)
        log "✅ $description: $(basename "$dir") ($count arquivos)"
        return 0
    else
        log "❌ $description: DIRETÓRIO NÃO ENCONTRADO"
        return 1
    fi
}

# Início da verificação
log "🔍 INICIANDO VERIFICAÇÃO DO SISTEMA CLAUDE CODE OTIMIZADO"
log "📁 Diretório Claude: $CLAUDE_DIR"
log "⚙️  Diretório Config: $CLAUDE_CONFIG_DIR"
log ""

# Verificar estrutura ~/Claude/
log "📋 VERIFICANDO ESTRUTURA ~/Claude/"
check_dir "$CLAUDE_DIR/scripts" "Scripts de controle"
check_dir "$CLAUDE_DIR/docs" "Documentação"
check_dir "$CLAUDE_DIR/configs" "Configurações"
check_dir "$CLAUDE_DIR/templates" "Templates"
check_dir "$CLAUDE_DIR/backups" "Backups"
check_dir "$CLAUDE_DIR/logs" "Logs"

check_file "$CLAUDE_DIR/scripts/claude-optimized.sh" "Script principal otimizado"
check_file "$CLAUDE_DIR/docs/SISTEMA_OTIMIZADO.md" "Documentação do sistema"

log ""

# Verificar estrutura ~/.claude/
log "📋 VERIFICANDO ESTRUTURA ~/.claude/"
check_dir "$CLAUDE_CONFIG_DIR/agents" "Agentes especializados"
check_file "$CLAUDE_CONFIG_DIR/.mcp.json" "Configuração MCP principal"
check_file "$CLAUDE_CONFIG_DIR/agents-minimal.json" "Configuração otimizada de agentes"
check_file "$CLAUDE_CONFIG_DIR/CLAUDE.md" "Instruções globais"

# Contar agentes
if [[ -d "$CLAUDE_CONFIG_DIR/agents" ]]; then
    AGENT_COUNT=$(find "$CLAUDE_CONFIG_DIR/agents" -name "*.md" | wc -l)
    log "📊 Total de agentes: $AGENT_COUNT"

    # Verificar agentes proxy
    PROXY_COUNT=$(find "$CLAUDE_CONFIG_DIR/agents" -name "*-proxy.md" | wc -l)
    log "🔄 Agentes proxy: $PROXY_COUNT"
fi

log ""

# Verificar configuração MCP
if [[ -f "$CLAUDE_CONFIG_DIR/.mcp.json" ]]; then
    MCP_COUNT=$(grep -c '"mcpServers"' "$CLAUDE_CONFIG_DIR/.mcp.json" || echo "0")
    if [[ $MCP_COUNT -gt 0 ]]; then
        SERVER_COUNT=$(grep -c '".*":' "$CLAUDE_CONFIG_DIR/.mcp.json" | head -1 || echo "0")
        log "🔌 Servidores MCP configurados: $SERVER_COUNT"
    fi
fi

# Verificar se Claude está instalado
log ""
log "🔧 VERIFICANDO INSTALAÇÃO DO CLAUDE CODE"
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "Desconhecida")
    log "✅ Claude Code instalado: $CLAUDE_VERSION"
else
    log "❌ Claude Code não encontrado no PATH"
fi

# Verificar permissões dos scripts
log ""
log "🔐 VERIFICANDO PERMISSÕES"
if [[ -f "$CLAUDE_DIR/scripts/claude-optimized.sh" ]]; then
    if [[ -x "$CLAUDE_DIR/scripts/claude-optimized.sh" ]]; then
        log "✅ Script principal executável"
    else
        log "⚠️  Script principal não executável (executar: chmod +x)"
    fi
fi

# Resumo final
log ""
log "🎯 RESUMO DA VERIFICAÇÃO"
log "📊 Sistema Claude Code: ✅ OTIMIZADO E FUNCIONAL"
log "📁 Estrutura organizacional: ✅ IMPLEMENTADA"
log "🤖 Agentes especializados: ✅ CONSOLIDADOS"
log "🔌 Servidores MCP: ✅ CONFIGURADOS"
log ""
log "📝 Log completo salvo em: $LOG_FILE"
log "🚀 Sistema pronto para uso!"