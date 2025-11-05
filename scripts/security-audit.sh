#!/bin/bash
# Security Audit - Auditoria de segurança do sistema Claude Code

set -e

CLAUDE_DIR="$HOME/Claude"
LOG_DIR="$CLAUDE_DIR/logs"
SECURITY_LOG="$LOG_DIR/security-audit-$(date +%Y%m%d-%H%M%S).log"

# Criar diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$SECURITY_LOG"
}

# Função para verificar permissões de arquivos
check_file_permissions() {
    log "🔒 VERIFICANDO PERMISSÕES DE ARQUIVOS"

    local critical_files=(
        "$HOME/.claude/.mcp.json"
        "$HOME/.claude/agents-minimal.json"
        "$HOME/.claude/CLAUDE.md"
        "$HOME/.claude/settings.json"
    )

    local issues_found=0

    for file in "${critical_files[@]}"; do
        if [[ -f "$file" ]]; then
            local perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")
            local owner=$(stat -c "%U" "$file" 2>/dev/null || echo "unknown")

            # Verificar se permissões são muito abertas
            if [[ "$perms" == "777" || "$perms" == "666" ]]; then
                log "⚠️  Permissões muito abertas: $file ($perms)"
                ((issues_found++))
            elif [[ "$perms" == "755" || "$perms" == "644" ]]; then
                log "✅ Permissões seguras: $file ($perms) - $owner"
            else
                log "ℹ️  Permissões: $file ($perms) - $owner"
            fi
        else
            log "ℹ️  Arquivo não encontrado: $file"
        fi
    done

    # Verificar permissões dos scripts
    log ""
    log "📜 VERIFICANDO PERMISSÕES DOS SCRIPTS"

    local scripts=$(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null)
    for script in $scripts; do
        if [[ -f "$script" ]]; then
            local perms=$(stat -c "%a" "$script" 2>/dev/null || echo "000")
            local is_executable=0

            if [[ -x "$script" ]]; then
                is_executable=1
            fi

            if [[ $is_executable -eq 1 ]]; then
                if [[ "$perms" == "755" ]]; then
                    log "✅ Script executável seguro: $(basename "$script") ($perms)"
                else
                    log "⚠️  Permissões de script não padrão: $(basename "$script") ($perms)"
                    ((issues_found++))
                fi
            else
                log "ℹ️  Script não executável: $(basename "$script") ($perms)"
            fi
        fi
    done

    return $issues_found
}

# Função para verificar configurações sensíveis
check_sensitive_configs() {
    log ""
    log "🔍 VERIFICANDO CONFIGURAÇÕES SENSÍVEIS"

    local issues_found=0

    # Verificar arquivos .env
    local env_files=$(find "$HOME" -name ".env*" -type f 2>/dev/null)
    for env_file in $env_files; do
        local perms=$(stat -c "%a" "$env_file" 2>/dev/null || echo "000")

        if [[ "$perms" == "777" || "$perms" == "666" ]]; then
            log "❌ Arquivo .env com permissões muito abertas: $env_file ($perms)"
            ((issues_found++))
        else
            log "✅ Arquivo .env seguro: $env_file ($perms)"
        fi
    done

    # Verificar se há senhas hardcoded em scripts
    log ""
    log "🔑 VERIFICANDO SENHAS HARDCODED"

    local scripts_with_passwords=$(grep -r -i "password\|api_key\|secret" "$CLAUDE_DIR/scripts" 2>/dev/null | grep -v "#" || true)

    if [[ -n "$scripts_with_passwords" ]]; then
        log "⚠️  Possíveis senhas/API keys encontradas em scripts:"
        echo "$scripts_with_passwords" | while read -r line; do
            log "   $line"
        done
        ((issues_found++))
    else
        log "✅ Nenhuma senha hardcoded encontrada"
    fi

    return $issues_found
}

# Função para verificar integridade dos agentes
check_agent_security() {
    log ""
    log "🤖 VERIFICANDO SEGURANÇA DOS AGENTES"

    local issues_found=0
    local agent_files=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null)

    for agent_file in $agent_files; do
        local agent_name=$(basename "$agent_file")

        # Verificar se o agente contém comandos perigosos
        local dangerous_commands=$(grep -i "rm -rf\|chmod 777\|wget http://\|curl http://" "$agent_file" 2>/dev/null || true)

        if [[ -n "$dangerous_commands" ]]; then
            log "⚠️  Comandos potencialmente perigosos em $agent_name:"
            echo "$dangerous_commands" | while read -r line; do
                log "   $line"
            done
            ((issues_found++))
        else
            log "✅ Agente seguro: $agent_name"
        fi
    done

    return $issues_found
}

# Função para verificar configuração MCP
check_mcp_security() {
    log ""
    log "🔌 VERIFICANDO SEGURANÇA MCP"

    local mcp_file="$HOME/.claude/.mcp.json"
    local issues_found=0

    if [[ ! -f "$mcp_file" ]]; then
        log "❌ Arquivo MCP não encontrado"
        return 1
    fi

    # Verificar se há servidores MCP não autorizados
    local unauthorized_servers=$(grep -i "unknown\|test\|malicious" "$mcp_file" 2>/dev/null || true)

    if [[ -n "$unauthorized_servers" ]]; then
        log "⚠️  Possíveis servidores MCP não autorizados:"
        echo "$unauthorized_servers" | while read -r line; do
            log "   $line"
        done
        ((issues_found++))
    else
        log "✅ Configuração MCP parece segura"
    fi

    return $issues_found
}

# Função para gerar relatório de segurança
generate_security_report() {
    log ""
    log "📄 GERANDO RELATÓRIO DE SEGURANÇA"

    local report_file="$LOG_DIR/security-report-$(date +%Y%m%d-%H%M%S).md"

    cat > "$report_file" << EOF
# Relatório de Segurança - Sistema Claude Code
**Data:** $(date)
**Log:** $SECURITY_LOG

## 🔒 Resumo da Auditoria

### Verificações Realizadas
- ✅ Permissões de arquivos críticos
- ✅ Configurações sensíveis
- ✅ Segurança dos agentes
- ✅ Configuração MCP
- ✅ Scripts e execuções

### Problemas Encontrados
$(grep -E "⚠️|❌" "$SECURITY_LOG" | sed 's/.*\] /• /' || echo "• Nenhum problema crítico encontrado")

## 🛡️ Recomendações de Segurança

### Imediatas
1. **Revise permissões** de arquivos marcados com ⚠️
2. **Remova senhas hardcoded** se encontradas
3. **Verifique agentes** com comandos suspeitos

### Preventivas
1. **Execute auditorias regulares** com este script
2. **Mantenha backups** atualizados
3. **Monitore logs** de segurança
4. **Atualize agentes** regularmente

### Configurações
- Mantenha permissões de arquivos em 644 (leitura) ou 755 (execução)
- Evite senhas em scripts
- Use variáveis de ambiente para credenciais
- Revise novos agentes antes de adicionar

## 📊 Métricas de Segurança

- **Arquivos críticos verificados:** $(grep -c "VERIFICANDO PERMISSÕES DE ARQUIVOS" "$SECURITY_LOG" || echo "0")
- **Scripts analisados:** $(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l || echo "0")
- **Agentes verificados:** $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")

---
*Relatório gerado automaticamente pelo Sistema Claude Code*
EOF

    log "📄 Relatório salvo em: $report_file"
}

# Função principal
main() {
    log "🛡️ INICIANDO AUDITORIA DE SEGURANÇA DO SISTEMA CLAUDE CODE"
    log "📁 Log: $SECURITY_LOG"
    log ""

    local total_issues=0

    # Executar verificações
    check_file_permissions || total_issues=$((total_issues + $?))
    check_sensitive_configs || total_issues=$((total_issues + $?))
    check_agent_security || total_issues=$((total_issues + $?))
    check_mcp_security || total_issues=$((total_issues + $?))

    generate_security_report

    log ""
    log "🎯 AUDITORIA CONCLUÍDA"
    log "📊 Total de problemas encontrados: $total_issues"

    if [[ $total_issues -eq 0 ]]; then
        log "✅ SISTEMA SEGURO - Nenhum problema crítico encontrado"
    else
        log "⚠️  ATENÇÃO: $total_issues problemas de segurança encontrados"
        log "📄 Verifique o relatório completo em: $SECURITY_LOG"
    fi

    log "🚀 Sistema Claude Code auditado com sucesso!"
}

# Executar função principal
main