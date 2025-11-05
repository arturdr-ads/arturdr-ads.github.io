#!/bin/bash
# System Monitoring - Monitoramento do sistema Claude Code

set -e

CLAUDE_DIR="$HOME/Claude"
LOG_DIR="$CLAUDE_DIR/logs"
MONITOR_LOG="$LOG_DIR/system-monitor-$(date +%Y%m%d).log"

# Criar diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$MONITOR_LOG"
}

# Função para coletar métricas do sistema
collect_system_metrics() {
    log "📊 COLETANDO MÉTRICAS DO SISTEMA"

    # Contagem de agentes
    local total_agents=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
    local active_mcp_servers=$(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")

    # Uso de disco
    local disk_usage=$(du -sh "$HOME/.claude" 2>/dev/null | cut -f1 || echo "0")
    local scripts_count=$(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l || echo "0")

    # Status dos arquivos principais
    local mcp_status="✅"
    if [[ ! -f "$HOME/.claude/.mcp.json" ]]; then
        mcp_status="❌"
    fi

    local agents_config_status="✅"
    if [[ ! -f "$HOME/.claude/agents-minimal.json" ]]; then
        agents_config_status="❌"
    fi

    # Salvar métricas
    cat > "$LOG_DIR/system-metrics-$(date +%Y%m%d-%H%M%S).json" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "total_agents": $total_agents,
  "active_mcp_servers": $active_mcp_servers,
  "disk_usage": "$disk_usage",
  "scripts_count": $scripts_count,
  "mcp_config_status": "$mcp_status",
  "agents_config_status": "$agents_config_status",
  "system_uptime": "$(uptime -p 2>/dev/null || echo "unknown")",
  "memory_usage": "$(free -h | grep Mem: | awk '{print $3 "/" $2}' 2>/dev/null || echo "unknown")"
}
EOF

    log "🤖 Agentes: $total_agents"
    log "🔌 MCP Servers: $active_mcp_servers"
    log "💾 Uso de disco: $disk_usage"
    log "📜 Scripts: $scripts_count"
    log "⚙️  Config MCP: $mcp_status"
    log "⚙️  Config Agentes: $agents_config_status"
}

# Função para verificar integridade dos agentes
check_agent_integrity() {
    log "🔍 VERIFICANDO INTEGRIDADE DOS AGENTES"

    local invalid_count=0
    local agent_files=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null)

    for agent_file in $agent_files; do
        local agent_name=$(basename "$agent_file")

        # Verificar se é arquivo de texto válido
        if file "$agent_file" | grep -q "text"; then
            # Verificar se tem formato Markdown básico
            if head -n 5 "$agent_file" | grep -q "^#\|^---"; then
                log "✅ Agente válido: $agent_name"
            else
                log "⚠️  Problema de formato: $agent_name"
                ((invalid_count++))
            fi
        else
            log "❌ Arquivo inválido: $agent_name"
            ((invalid_count++))
        fi
    done

    if [[ $invalid_count -eq 0 ]]; then
        log "🎉 TODOS OS AGENTES SÃO VÁLIDOS!"
    else
        log "⚠️  $invalid_count agentes com problemas detectados"
    fi
}

# Função para verificar configurações MCP
check_mcp_config() {
    log "🔌 VERIFICANDO CONFIGURAÇÃO MCP"

    local mcp_file="$HOME/.claude/.mcp.json"

    if [[ ! -f "$mcp_file" ]]; then
        log "❌ Arquivo MCP não encontrado"
        return 1
    fi

    # Verificar JSON válido
    if python3 -m json.tool "$mcp_file" > /dev/null 2>&1; then
        local server_count=$(grep -c '".*":' "$mcp_file" | head -1)
        log "✅ Configuração MCP válida ($server_count servidores)"

        # Listar servidores ativos
        log "📋 Servidores MCP ativos:"
        grep '".*":' "$mcp_file" | sed 's/.*"\(.*\)":.*/  - \1/' | tee -a "$MONITOR_LOG"
    else
        log "❌ Configuração MCP JSON inválida"
        return 1
    fi
}

# Função para gerar relatório de performance
generate_performance_report() {
    log "📈 GERANDO RELATÓRIO DE PERFORMANCE"

    local report_file="$LOG_DIR/performance-report-$(date +%Y%m%d-%H%M%S).md"

    cat > "$report_file" << EOF
# Relatório de Performance - Sistema Claude Code
**Data:** $(date)

## 📊 Métricas do Sistema

### Agentes e Configurações
- **Total de Agentes:** $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
- **Servidores MCP Ativos:** $(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")
- **Scripts Otimizados:** $(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l || echo "0")

### Uso de Recursos
- **Uso de Disco:** $(du -sh "$HOME/.claude" 2>/dev/null | cut -f1 || echo "0")
- **Uso de Memória:** $(free -h | grep Mem: | awk '{print $3 "/" $2}' 2>/dev/null || echo "unknown")
- **Uptime do Sistema:** $(uptime -p 2>/dev/null || echo "unknown")

### Status de Configurações
- **Configuração MCP:** $(if [[ -f "$HOME/.claude/.mcp.json" ]]; then echo "✅ Válida"; else echo "❌ Ausente"; fi)
- **Configuração Agentes:** $(if [[ -f "$HOME/.claude/agents-minimal.json" ]]; then echo "✅ Válida"; else echo "❌ Ausente"; fi)

## 🔍 Verificações de Integridade

### Agentes
$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0") agentes verificados

### Servidores MCP
$(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0") servidores configurados

## 🚀 Recomendações

1. **Backup Regular:** Execute ./scripts/backup-system.sh
2. **Validação:** Execute ./scripts/validate-agents.sh
3. **Monitoramento:** Configure execução automática deste script

---
*Relatório gerado automaticamente pelo Sistema Claude Code*
EOF

    log "📄 Relatório salvo em: $report_file"
}

# Função principal
main() {
    log "🔍 INICIANDO MONITORAMENTO DO SISTEMA CLAUDE CODE"
    log "📁 Log: $MONITOR_LOG"
    log ""

    # Executar verificações
    collect_system_metrics
    log ""

    check_agent_integrity
    log ""

    check_mcp_config
    log ""

    generate_performance_report

    log ""
    log "✅ MONITORAMENTO CONCLUÍDO"
    log "📊 Relatórios salvos em: $LOG_DIR/"
    log "🚀 Sistema Claude Code monitorado com sucesso!"
}

# Executar função principal
main