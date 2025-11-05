#!/bin/bash
# Automated Agent Validation - Validação automatizada de agentes

set -e

CLAUDE_DIR="$HOME/Claude"
CLAUDE_CONFIG_DIR="$HOME/.claude"
LOG_FILE="$CLAUDE_DIR/logs/agent-validation-$(date +%Y%m%d-%H%M%S).log"
VALIDATION_RESULTS_DIR="$CLAUDE_DIR/validation-results"

# Criar diretórios necessários
mkdir -p "$CLAUDE_DIR/logs" "$VALIDATION_RESULTS_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Função para validar agente individual
validate_agent() {
    local agent_name="$1"
    local agent_file="$CLAUDE_CONFIG_DIR/agents/$agent_name.md"

    log "🧪 Validando agente: $agent_name"

    if [[ ! -f "$agent_file" ]]; then
        log "❌ Agente não encontrado: $agent_file"
        return 1
    fi

    # Verificar sintaxe básica do arquivo
    if file "$agent_file" | grep -q "text"; then
        log "✅ Sintaxe válida: $agent_name"

        # Verificar se é um arquivo Markdown válido
        if head -n 5 "$agent_file" | grep -q "^#\|^---"; then
            log "✅ Formato Markdown válido: $agent_name"
            return 0
        else
            log "⚠️  Possível problema de formato: $agent_name"
            return 1
        fi
    else
        log "❌ Arquivo inválido: $agent_name"
        return 1
    fi
}

# Função para validar configuração MCP
validate_mcp_config() {
    local config_file="$CLAUDE_CONFIG_DIR/.mcp.json"

    log "🔌 Validando configuração MCP"

    if [[ ! -f "$config_file" ]]; then
        log "❌ Configuração MCP não encontrada"
        return 1
    fi

    # Verificar se é JSON válido
    if python3 -m json.tool "$config_file" > /dev/null 2>&1; then
        local server_count=$(grep -c '".*":' "$config_file" | head -1)
        log "✅ Configuração MCP válida ($server_count servidores)"
        return 0
    else
        log "❌ Configuração MCP JSON inválida"
        return 1
    fi
}

# Início da validação
log "🔍 INICIANDO VALIDAÇÃO AUTOMATIZADA DE AGENTES"
log "📁 Diretório de validação: $VALIDATION_RESULTS_DIR"
log ""

# Contadores de resultados
TOTAL_AGENTS=0
VALID_AGENTS=0
INVALID_AGENTS=0

# Validar agentes principais
MAIN_AGENTS=(
    "code-reviewer.md"
    "backend-architect.md"
    "frontend-specialist.md"
    "devops-specialist.md"
    "ai-ml-specialist.md"
    "intelligent-router-proxy.md"
    "security-specialist.md"
    "performance-optimizer.md"
)

log "🤖 VALIDANDO AGENTES PRINCIPAIS"
for agent in "${MAIN_AGENTS[@]}"; do
    if validate_agent "$agent"; then
        ((VALID_AGENTS++))
    else
        ((INVALID_AGENTS++))
    fi
    ((TOTAL_AGENTS++))
done

log ""

# Validar configuração MCP
if validate_mcp_config; then
    MCP_STATUS="✅"
else
    MCP_STATUS="❌"
fi

# Validar configuração de agentes
log "📋 VALIDANDO CONFIGURAÇÃO DE AGENTES"
if [[ -f "$CLAUDE_CONFIG_DIR/agents-minimal.json" ]]; then
    if python3 -m json.tool "$CLAUDE_CONFIG_DIR/agents-minimal.json" > /dev/null 2>&1; then
        log "✅ Configuração agents-minimal.json válida"
        AGENT_CONFIG_STATUS="✅"
    else
        log "❌ Configuração agents-minimal.json inválida"
        AGENT_CONFIG_STATUS="❌"
    fi
else
    log "⚠️  Configuração agents-minimal.json não encontrada"
    AGENT_CONFIG_STATUS="⚠️"
fi

# Resumo final
log ""
log "🎯 RESUMO DA VALIDAÇÃO"
log "📊 Agentes validados: $TOTAL_AGENTS"
log "✅ Agentes válidos: $VALID_AGENTS"
log "❌ Agentes inválidos: $INVALID_AGENTS"
log "🔌 Configuração MCP: $MCP_STATUS"
log "📋 Config agentes: $AGENT_CONFIG_STATUS"

# Calcular taxa de sucesso
if [[ $TOTAL_AGENTS -gt 0 ]]; then
    SUCCESS_RATE=$((VALID_AGENTS * 100 / TOTAL_AGENTS))
    log "📈 Taxa de sucesso: $SUCCESS_RATE%"
fi

# Salvar resultados
cat > "$VALIDATION_RESULTS_DIR/validation-results-$(date +%Y%m%d-%H%M%S).json" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "total_agents": $TOTAL_AGENTS,
  "valid_agents": $VALID_AGENTS,
  "invalid_agents": $INVALID_AGENTS,
  "success_rate": $SUCCESS_RATE,
  "mcp_config_status": "$MCP_STATUS",
  "agent_config_status": "$AGENT_CONFIG_STATUS"
}
EOF

log ""
log "📝 Log completo salvo em: $LOG_FILE"
log "📊 Resultados salvos em: $VALIDATION_RESULTS_DIR/"

if [[ $INVALID_AGENTS -eq 0 ]]; then
    log "🎉 TODOS OS AGENTES SÃO VÁLIDOS!"
    exit 0
else
    log "⚠️  ALGUNS AGENTES SÃO INVÁLIDOS. Verifique os logs."
    exit 1
fi