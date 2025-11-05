#!/bin/bash
# System Deployment - Implantação do sistema Claude Code

set -e

CLAUDE_DIR="$HOME/Claude"
LOG_DIR="$CLAUDE_DIR/logs"
DEPLOY_LOG="$LOG_DIR/deploy-system-$(date +%Y%m%d-%H%M%S).log"

# Criar diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$DEPLOY_LOG"
}

# Função para verificar pré-requisitos
check_prerequisites() {
    log "🔍 VERIFICANDO PRÉ-REQUISITOS DO SISTEMA"

    local missing_deps=0

    # Verificar Node.js
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version)
        log "✅ Node.js: $node_version"
    else
        log "❌ Node.js não encontrado"
        ((missing_deps++))
    fi

    # Verificar npm
    if command -v npm >/dev/null 2>&1; then
        local npm_version=$(npm --version)
        log "✅ npm: $npm_version"
    else
        log "❌ npm não encontrado"
        ((missing_deps++))
    fi

    # Verificar Git
    if command -v git >/dev/null 2>&1; then
        local git_version=$(git --version)
        log "✅ Git: $git_version"
    else
        log "❌ Git não encontrado"
        ((missing_deps++))
    fi

    # Verificar Python
    if command -v python3 >/dev/null 2>&1; then
        local python_version=$(python3 --version)
        log "✅ Python: $python_version"
    else
        log "❌ Python3 não encontrado"
        ((missing_deps++))
    fi

    if [[ $missing_deps -gt 0 ]]; then
        log "⚠️  $missing_deps pré-requisitos faltando"
        return 1
    else
        log "✅ Todos os pré-requisitos atendidos"
        return 0
    fi
}

# Função para instalar Claude Code
install_claude_code() {
    log "📦 INSTALANDO CLAUDE CODE"

    if command -v npm >/dev/null 2>&1; then
        log "🔧 Instalando Claude Code via npm..."
        npm install -g @anthropic-ai/claude-code 2>&1 | tee -a "$DEPLOY_LOG" || {
            log "❌ Falha na instalação do Claude Code"
            return 1
        }
        log "✅ Claude Code instalado com sucesso"
    else
        log "❌ npm não disponível para instalação"
        return 1
    fi

    # Verificar instalação
    if command -v claude >/dev/null 2>&1; then
        local claude_version=$(claude --version)
        log "🎉 Claude Code instalado: $claude_version"
    else
        log "❌ Claude Code não encontrado após instalação"
        return 1
    fi
}

# Função para configurar estrutura de diretórios
setup_directory_structure() {
    log "📁 CONFIGURANDO ESTRUTURA DE DIRETÓRIOS"

    # Criar diretórios principais
    local directories=(
        "$CLAUDE_DIR/scripts"
        "$CLAUDE_DIR/docs"
        "$CLAUDE_DIR/configs"
        "$CLAUDE_DIR/templates"
        "$CLAUDE_DIR/backups"
        "$CLAUDE_DIR/logs"
        "$HOME/.claude/agents"
        "$HOME/.claude/commands"
    )

    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        log "✅ Diretório criado: $dir"
    done

    log "✅ Estrutura de diretórios configurada"
}

# Função para configurar agentes principais
setup_core_agents() {
    log "🤖 CONFIGURANDO AGENTES PRINCIPAIS"

    local core_agents=(
        "code-reviewer"
        "backend-architect"
        "frontend-specialist"
        "devops-specialist"
        "ai-ml-specialist"
        "intelligent-router-proxy"
        "security-specialist"
        "performance-optimizer"
    )

    # Criar agentes básicos se não existirem
    for agent in "${core_agents[@]}"; do
        local agent_file="$HOME/.claude/agents/$agent.md"

        if [[ ! -f "$agent_file" ]]; then
            cat > "$agent_file" << EOF
# $agent

Agente especializado em $(echo $agent | sed 's/-/ /g').

## Descrição
Este é um agente básico para $(echo $agent | sed 's/-/ /g'). Configure conforme suas necessidades.

## Especialização
- $(echo $agent | sed 's/-/ /g')

## Configuração
Adicione suas configurações específicas aqui.
EOF
            log "✅ Agente criado: $agent"
        else
            log "ℹ️  Agente já existe: $agent"
        fi
    done

    log "✅ Agentes principais configurados"
}

# Função para configurar MCP básico
setup_mcp_config() {
    log "🔌 CONFIGURANDO MCP BÁSICO"

    local mcp_file="$HOME/.claude/.mcp.json"

    if [[ ! -f "$mcp_file" ]]; then
        cat > "$mcp_file" << EOF
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
EOF
        log "✅ Configuração MCP básica criada"
    else
        log "ℹ️  Configuração MCP já existe"
    fi
}

# Função para configurar agentes mínimos
setup_minimal_agents() {
    log "📋 CONFIGURANDO AGENTES MÍNIMOS"

    local agents_file="$HOME/.claude/agents-minimal.json"

    if [[ ! -f "$agents_file" ]]; then
        cat > "$agents_file" << EOF
{
  "agents": {
    "code-reviewer": {
      "description": "Comprehensive code review with security, performance, and best practices analysis"
    },
    "backend-architect": {
      "description": "Backend architecture and API design analysis"
    },
    "frontend-specialist": {
      "description": "Frontend development and UX optimization analysis"
    },
    "devops-specialist": {
      "description": "DevOps pipeline and infrastructure analysis"
    },
    "ai-ml-specialist": {
      "description": "AI/ML model analysis, data science workflow, and machine learning optimization"
    }
  }
}
EOF
        log "✅ Configuração de agentes mínimos criada"
    else
        log "ℹ️  Configuração de agentes mínimos já existe"
    fi
}

# Função para configurar scripts básicos
setup_basic_scripts() {
    log "📜 CONFIGURANDO SCRIPTS BÁSICOS"

    # Verificar se já existem scripts
    local existing_scripts=$(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l)

    if [[ $existing_scripts -eq 0 ]]; then
        log "ℹ️  Nenhum script encontrado, criando scripts básicos..."

        # Criar script de verificação básico
        cat > "$CLAUDE_DIR/scripts/system-check.sh" << 'EOF'
#!/bin/bash
# Basic System Check

echo "🔍 Verificando sistema Claude Code..."

# Verificar Claude Code
if command -v claude >/dev/null 2>&1; then
    echo "✅ Claude Code: $(claude --version)"
else
    echo "❌ Claude Code não encontrado"
fi

# Verificar agentes
echo "🤖 Agentes: $(find ~/.claude/agents -name "*.md" 2>/dev/null | wc -l)"

# Verificar MCP
echo "🔌 MCP Servers: $(grep -c '\".*\":' ~/.claude/.mcp.json 2>/dev/null | head -1)"

echo "🚀 Sistema verificado!"
EOF

        chmod +x "$CLAUDE_DIR/scripts/system-check.sh"
        log "✅ Script básico criado: system-check.sh"
    else
        log "ℹ️  Scripts já existem: $existing_scripts encontrados"
    fi
}

# Função para validar implantação
validate_deployment() {
    log "🔍 VALIDANDO IMPLANTAÇÃO"

    local validation_passed=0

    # Verificar Claude Code
    if command -v claude >/dev/null 2>&1; then
        log "✅ Claude Code funcionando"
        ((validation_passed++))
    else
        log "❌ Claude Code não funciona"
    fi

    # Verificar estrutura de diretórios
    if [[ -d "$CLAUDE_DIR/scripts" && -d "$HOME/.claude/agents" ]]; then
        log "✅ Estrutura de diretórios OK"
        ((validation_passed++))
    else
        log "❌ Estrutura de diretórios incompleta"
    fi

    # Verificar agentes
    local agent_count=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l)
    if [[ $agent_count -gt 0 ]]; then
        log "✅ $agent_count agentes configurados"
        ((validation_passed++))
    else
        log "❌ Nenhum agente configurado"
    fi

    # Verificar MCP
    if [[ -f "$HOME/.claude/.mcp.json" ]]; then
        log "✅ Configuração MCP presente"
        ((validation_passed++))
    else
        log "❌ Configuração MCP ausente"
    fi

    if [[ $validation_passed -eq 4 ]]; then
        log "🎉 IMPLANTAÇÃO VALIDADA COM SUCESSO"
        return 0
    else
        log "⚠️  Implantação com problemas: $validation_passed/4 verificações passaram"
        return 1
    fi
}

# Função para gerar relatório de implantação
generate_deployment_report() {
    log ""
    log "📄 GERANDO RELATÓRIO DE IMPLANTAÇÃO"

    local report_file="$LOG_DIR/deployment-report-$(date +%Y%m%d-%H%M%S).md"

    cat > "$report_file" << EOF
# Relatório de Implantação - Sistema Claude Code
**Data:** $(date)
**Log:** $DEPLOY_LOG

## 🚀 Resumo da Implantação

### Componentes Instalados
- ✅ Claude Code CLI
- ✅ Estrutura de diretórios
- ✅ Agentes principais
- ✅ Configuração MCP básica
- ✅ Scripts de gerenciamento

### Status do Sistema
- **Versão Claude Code:** $(claude --version 2>/dev/null || echo "Desconhecida")
- **Total de Agentes:** $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
- **Servidores MCP:** $(grep -c '\".*\":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")
- **Scripts Configurados:** $(find "$CLAUDE_DIR/scripts" -name "*.sh" 2>/dev/null | wc -l || echo "0")

### Próximos Passos

1. **Configure agentes específicos** conforme suas necessidades
2. **Adicione servidores MCP** adicionais se necessário
3. **Teste o sistema** com: ./scripts/system-check.sh
4. **Personalize configurações** em ~/.claude/

## 📊 Validação

- **Claude Code:** $(if command -v claude >/dev/null 2>&1; then echo "✅"; else echo "❌"; fi)
- **Estrutura:** $(if [[ -d "$CLAUDE_DIR/scripts" && -d "$HOME/.claude/agents" ]]; then echo "✅"; else echo "❌"; fi)
- **Agentes:** $(if [[ $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l) -gt 0 ]]; then echo "✅"; else echo "❌"; fi)
- **MCP:** $(if [[ -f "$HOME/.claude/.mcp.json" ]]; then echo "✅"; else echo "❌"; fi)

## 🛠️ Comandos Úteis

\`\`\`bash
# Verificar sistema
./scripts/system-check.sh

# Iniciar Claude Code
claude

# Listar agentes
ls ~/.claude/agents/
\`\`\`

---
*Relatório gerado automaticamente pelo Sistema Claude Code*
EOF

    log "📄 Relatório salvo em: $report_file"
}

# Função principal
main() {
    log "🚀 INICIANDO IMPLANTAÇÃO DO SISTEMA CLAUDE CODE"
    log "📁 Log: $DEPLOY_LOG"
    log ""

    # Executar etapas de implantação
    check_prerequisites || {
        log "❌ Pré-requisitos não atendidos, abortando implantação"
        exit 1
    }
    log ""

    install_claude_code || {
        log "❌ Falha na instalação do Claude Code, abortando"
        exit 1
    }
    log ""

    setup_directory_structure
    log ""

    setup_core_agents
    log ""

    setup_mcp_config
    log ""

    setup_minimal_agents
    log ""

    setup_basic_scripts
    log ""

    validate_deployment
    log ""

    generate_deployment_report

    log ""
    log "✅ IMPLANTAÇÃO CONCLUÍDA COM SUCESSO"
    log "🎉 Sistema Claude Code implantado e pronto para uso!"
    log "📄 Relatório completo em: $DEPLOY_LOG"
    log "🚀 Execute: ./scripts/system-check.sh para verificar o sistema"
}

# Executar função principal
main