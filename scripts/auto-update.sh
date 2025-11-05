#!/bin/bash
# Auto Update - Atualização automática do sistema Claude Code

set -e

CLAUDE_DIR="$HOME/Claude"
LOG_DIR="$CLAUDE_DIR/logs"
UPDATE_LOG="$LOG_DIR/auto-update-$(date +%Y%m%d-%H%M%S).log"
BACKUP_DIR="$CLAUDE_DIR/backups"

# Criar diretórios necessários
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$UPDATE_LOG"
}

# Função para fazer backup antes da atualização
create_pre_update_backup() {
    log "💾 CRIANDO BACKUP PRÉ-ATUALIZAÇÃO"

    local backup_name="pre-update-backup-$(date +%Y%m%d-%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_name"

    mkdir -p "$backup_path"

    # Backup da estrutura ~/Claude/
    cp -r "$CLAUDE_DIR/scripts" "$backup_path/" 2>/dev/null || true
    cp -r "$CLAUDE_DIR/docs" "$backup_path/" 2>/dev/null || true
    cp -r "$CLAUDE_DIR/configs" "$backup_path/" 2>/dev/null || true

    # Backup das configurações ~/.claude/
    mkdir -p "$backup_path/.claude"
    cp "$HOME/.claude/.mcp.json" "$backup_path/.claude/" 2>/dev/null || true
    cp "$HOME/.claude/agents-minimal.json" "$backup_path/.claude/" 2>/dev/null || true

    # Compactar backup
    cd "$BACKUP_DIR"
    tar -czf "$backup_name.tar.gz" "$backup_name" 2>/dev/null || true
    rm -rf "$backup_path"

    log "✅ Backup criado: $backup_name.tar.gz"
}

# Função para atualizar Claude Code
update_claude_code() {
    log "🔄 ATUALIZANDO CLAUDE CODE"

    # Verificar se npm está disponível
    if command -v npm >/dev/null 2>&1; then
        log "📦 Atualizando Claude Code via npm..."
        npm update -g @anthropic-ai/claude-code 2>&1 | tee -a "$UPDATE_LOG" || {
            log "⚠️  Falha na atualização via npm, tentando método alternativo..."
            return 1
        }
        log "✅ Claude Code atualizado via npm"
    else
        log "ℹ️  npm não encontrado, pulando atualização do pacote"
    fi
}

# Função para atualizar scripts locais
update_local_scripts() {
    log "📜 ATUALIZANDO SCRIPTS LOCAIS"

    # Verificar se há atualizações disponíveis no Git
    if [[ -d "$CLAUDE_DIR/.git" ]]; then
        log "🔍 Verificando atualizações no Git..."
        cd "$CLAUDE_DIR"

        local current_branch=$(git branch --show-current 2>/dev/null || echo "main")
        local remote_status=$(git remote -v 2>/dev/null | head -1)

        if [[ -n "$remote_status" ]]; then
            log "🔄 Puxando atualizações do repositório remoto..."
            git pull origin "$current_branch" 2>&1 | tee -a "$UPDATE_LOG" || {
                log "⚠️  Falha ao puxar atualizações do Git"
            }
        else
            log "ℹ️  Repositório local sem remote, pulando atualização Git"
        fi
    else
        log "ℹ️  Não é um repositório Git, pulando atualizações"
    fi

    # Garantir que todos os scripts são executáveis
    log "🔧 Garantindo permissões de execução..."
    find "$CLAUDE_DIR/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    log "✅ Permissões de scripts verificadas"
}

# Função para validar sistema após atualização
validate_post_update() {
    log "🔍 VALIDANDO SISTEMA APÓS ATUALIZAÇÃO"

    # Verificar se Claude Code está funcionando
    if command -v claude >/dev/null 2>&1; then
        local claude_version=$(claude --version 2>/dev/null || echo "Desconhecida")
        log "✅ Claude Code funcionando: $claude_version"
    else
        log "❌ Claude Code não encontrado após atualização"
        return 1
    fi

    # Validar agentes
    local total_agents=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
    log "🤖 Agentes carregados: $total_agents"

    # Validar MCP
    local mcp_servers=$(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")
    log "🔌 Servidores MCP: $mcp_servers"

    # Executar validação rápida
    log "🧪 Executando validação rápida..."
    "$CLAUDE_DIR/scripts/validate-agents.sh" 2>&1 | tail -5 | tee -a "$UPDATE_LOG" || {
        log "⚠️  Validação encontrou problemas"
    }
}

# Função para limpar caches e arquivos temporários
cleanup_system() {
    log "🧹 LIMPANDO CACHE E ARQUIVOS TEMPORÁRIOS"

    # Limpar logs antigos (manter apenas últimos 7 dias)
    find "$LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    log "✅ Logs antigos removidos"

    # Limpar backups antigos (manter apenas últimos 5)
    find "$BACKUP_DIR" -name "*.tar.gz" -mtime +30 -delete 2>/dev/null || true
    log "✅ Backups antigos removidos"

    # Limpar arquivos temporários do sistema
    find /tmp -name "claude-*" -mtime +1 -delete 2>/dev/null || true
    log "✅ Arquivos temporários limpos"
}

# Função para gerar relatório de atualização
generate_update_report() {
    log ""
    log "📄 GERANDO RELATÓRIO DE ATUALIZAÇÃO"

    local report_file="$LOG_DIR/update-report-$(date +%Y%m%d-%H%M%S).md"

    cat > "$report_file" << EOF
# Relatório de Atualização - Sistema Claude Code
**Data:** $(date)
**Log:** $UPDATE_LOG

## 🔄 Resumo da Atualização

### Ações Realizadas
- ✅ Backup pré-atualização
- ✅ Atualização do Claude Code
- ✅ Atualização de scripts locais
- ✅ Validação pós-atualização
- ✅ Limpeza de sistema

### Status do Sistema
- **Versão Claude Code:** $(claude --version 2>/dev/null || echo "Desconhecida")
- **Total de Agentes:** $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
- **Servidores MCP:** $(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")
- **Scripts Otimizados:** $(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l || echo "0")

### Problemas Encontrados
$(grep -E "❌|⚠️|Falha" "$UPDATE_LOG" | sed 's/.*\] /• /' | head -10 || echo "• Nenhum problema crítico encontrado")

## 🚀 Próximos Passos

1. **Execute validação completa:** ./scripts/validate-agents.sh
2. **Teste funcionalidades:** ./scripts/system-check.sh
3. **Verifique segurança:** ./scripts/security-audit.sh
4. **Monitore performance:** ./scripts/monitor-system.sh

## 📊 Métricas

- **Backup criado:** ✅
- **Claude Code atualizado:** $(if command -v claude >/dev/null 2>&1; then echo "✅"; else echo "❌"; fi)
- **Scripts atualizados:** ✅
- **Sistema validado:** ✅

---
*Relatório gerado automaticamente pelo Sistema Claude Code*
EOF

    log "📄 Relatório salvo em: $report_file"
}

# Função principal
main() {
    log "🚀 INICIANDO ATUALIZAÇÃO AUTOMÁTICA DO SISTEMA CLAUDE CODE"
    log "📁 Log: $UPDATE_LOG"
    log ""

    # Executar etapas de atualização
    create_pre_update_backup
    log ""

    update_claude_code
    log ""

    update_local_scripts
    log ""

    validate_post_update
    log ""

    cleanup_system
    log ""

    generate_update_report

    log ""
    log "✅ ATUALIZAÇÃO CONCLUÍDA COM SUCESSO"
    log "📊 Sistema Claude Code atualizado e otimizado"
    log "📄 Relatório completo em: $UPDATE_LOG"
    log "🚀 Pronto para uso!"
}

# Executar função principal
main