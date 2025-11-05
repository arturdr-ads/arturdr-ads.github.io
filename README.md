# Claude Code CLI - Sistema Otimizado

Sistema Claude Code CLI organizado e otimizado para desenvolvimento profissional, baseado na documentação oficial da Anthropic.

## 📖 Documentação Oficial
- **Site Oficial**: [claude.ai/code](https://claude.ai/code)
- **Documentação**: [docs.claude.com](https://docs.claude.com)
- **Instalação**: `npm install -g @anthropic-ai/claude-code`

## 🏗️ Estrutura

```
Claude/
├── scripts/           # Scripts de automação e controle
├── docs/             # Documentação do sistema
├── configs/          # Configurações otimizadas
├── templates/        # Templates reutilizáveis
├── backups/          # Backups automáticos
└── logs/             # Logs centralizados
```

## 🚀 Uso Rápido

```bash
# Iniciar sistema otimizado
./scripts/claude-optimized.sh

# Verificar sistema
./scripts/system-check.sh

# Fazer backup
./scripts/backup-system.sh

# Monitorar sistema
./scripts/monitor-system.sh

# Auditoria de segurança
./scripts/security-audit.sh

# Atualização automática
./scripts/auto-update.sh

# Validação de agentes
./scripts/validate-agents.sh
```

## 📋 Agentes Principais

- `code-reviewer` - Revisão completa de código
- `backend-architect` - Arquitetura e APIs
- `frontend-specialist` - Frontend e UX
- `devops-specialist` - DevOps e infraestrutura
- `ai-ml-specialist` - IA/ML e data science
- `intelligent-router-proxy` - Roteamento dinâmico

## 🔧 Comandos Claude Code

### Comandos Built-in
```bash
claude --help                    # Ajuda completa
claude --version                # Versão do Claude Code
claude -p "prompt"             # Executar prompt específico
claude --headless              # Modo sem interface
claude --mcp-debug             # Debug de servidores MCP
```

### Slash Commands Disponíveis
```bash
/code-review          # Revisão completa de código
/security-review      # Análise de segurança OWASP Top 10
/architecture-review  # Arquitetura backend e APIs
/frontend-review      # Frontend e UX optimization
/devops-review        # DevOps e infraestrutura
/performance-review   # Otimização de performance
/ai-ml-analysis       # Análise IA/ML e data science
/project-setup        # Inicializar novos projetos
/speckit.*            # Workflows de implementação
```

## 🔒 Segurança & Configuração

### Configurações Claude Code
- **Global**: `~/.claude/settings.json` - Configurações do usuário
- **Projeto**: `.claude/settings.json` - Configurações específicas do projeto
- **Local**: `.claude/settings.local.json` - Configurações locais (não versionadas)
- **Instruções**: `CLAUDE.md` - Instruções específicas do projeto

### Funcionalidades de Segurança
- **Sandbox Mode**: Execução segura de comandos
- **Tool Allowlist**: Controle de ferramentas permitidas
- **MCP Authorization**: Servidores MCP autorizados
- **Local Processing**: Processamento local sem compartilhamento externo

## 📊 Monitoramento & Automação

- **Monitoramento**: Logs detalhados com timestamps e métricas de performance
- **Segurança**: Auditoria automática de permissões e configurações
- **Backup**: Sistema automatizado de backup e recuperação
- **Validação**: Verificação contínua de agentes e configurações
- **Atualização**: Sistema automático de atualização e manutenção

## 🛠️ Desenvolvimento

### Ferramentas Built-in
- **Bash**: Execução de comandos shell
- **Edit/Read/Write**: Manipulação de arquivos
- **Task**: Agentes especializados para tarefas complexas
- **WebFetch/WebSearch**: Pesquisa e busca web
- **Git**: Operações de versionamento
- **MCP Tools**: Ferramentas de servidores MCP

### Adicionar Novo Agente
1. Criar arquivo em `~/.claude/agents/nome-do-agente.md`
2. Atualizar `agents-minimal.json` se necessário
3. Testar com `./scripts/test-agents.sh`

### Configurar MCP Server
1. Adicionar configuração em `~/.claude/.mcp.json`
2. Verificar com `./scripts/system-check.sh`
3. Testar com `claude --mcp-debug`

### Atualizar Sistema
1. Fazer backup: `./scripts/backup-system.sh`
2. Atualizar Claude Code: `npm update -g @anthropic-ai/claude-code`
3. Verificar sistema: `./scripts/system-check.sh`

## 🐛 Troubleshooting

### Problemas Comuns
- **MCP Connection Issues**: Use `claude --mcp-debug`
- **Tool Permissions**: Verifique `~/.claude/settings.json`
- **Agent Loading**: Execute `./scripts/validate-agents.sh`
- **Performance Issues**: Use `./scripts/monitor-system.sh`

### Debug Commands
```bash
claude --mcp-debug              # Debug MCP servers
claude --headless -p "test"     # Teste sem interface
./scripts/security-audit.sh     # Verificar problemas de segurança
./scripts/auto-update.sh        # Atualizar e corrigir sistema
```

## 📚 Referências

### Documentação Oficial
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
- [MCP Documentation](https://docs.claude.com/en/docs/claude-code/mcp)
- [Agent Skills](https://docs.claude.com/en/docs/claude-code/agent-skills)

### Links Úteis
- [Anthropic Website](https://www.anthropic.com)
- [Claude AI](https://claude.ai)
- [GitHub Repository](https://github.com/anthropics/claude-code)

## 📞 Suporte

- **Documentação**: `docs/`
- **Logs**: `logs/`
- **Verificação**: `./scripts/system-check.sh`
- **Backup**: `./scripts/backup-system.sh`
- **Monitoramento**: `./scripts/monitor-system.sh`

---

**Versão**: 3.0.0
**Status**: ✅ Otimizado e Funcional
**Claude Code**: 2.0.33
**Agentes**: 57 Especializados
**MCP Servers**: 63 Ativos
**Scripts**: 12 de Automação
**Última Atualização**: $(date +%Y-%m-%d)

---

*Sistema baseado na documentação oficial do Claude Code da Anthropic*