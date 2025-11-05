# 🚀 GUIA RÁPIDO - Sistema Claude Code CLI

## 🎯 **INÍCIO RÁPIDO**

### **Opção 1: Sistema Simplificado (5 Agentes)**
```bash
./claude-simple.sh
```

### **Opção 2: Sistema Completo (54 Agentes)**
```bash
./claude-enhanced.sh
```

---

## 🤖 **AGENTES PRINCIPAIS**

### **Desenvolvimento:**
- `code-reviewer` - Revisão de código
- `security-specialist` - Segurança
- `backend-architect` - Backend
- `frontend-specialist` - Frontend
- `devops-specialist` - DevOps

### **Linguagens:**
- `javascript-pro` - JavaScript
- `typescript-pro` - TypeScript
- `python-pro` - Python
- `react-pro` - React

### **Especialidades:**
- `ai-ml-specialist` - AI/ML
- `cloud-architect` - Cloud
- `performance-engineer` - Performance
- `testing-specialist` - Testes

---

## ⚡ **COMANDOS SLASH**

### **Análise:**
- `/code-review` - Revisão de código
- `/security-review` - Segurança
- `/architecture-review` - Arquitetura
- `/frontend-review` - Frontend
- `/devops-review` - DevOps

### **Utilitários:**
- `/help` - Ajuda
- `/model` - Modelo
- `/clear` - Limpar

---

## 🔧 **COMO USAR**

### **Agentes Nativos (Task Tool):**
```bash
Use the Explore subagent
Use the Plan subagent
Use the general-purpose subagent
```

### **Agentes Customizados (Wrapper):**
```bash
./claude-simple.sh "Revisar código"
./claude-enhanced.sh "Analisar segurança"
```

### **Exemplos Práticos:**
```bash
# Revisão de código
/code-review

# Análise de segurança
/security-review

# Desenvolvimento AI/ML
./claude-enhanced.sh "Criar modelo ML com ai-ml-specialist"

# Performance
./claude-enhanced.sh "Otimizar com performance-engineer"
```

---

## 🛠️ **FERRAMENTAS DISPONÍVEIS**

### **Básicas:**
- **Bash** - Comandos shell
- **Read/Write/Edit** - Arquivos
- **Grep** - Busca
- **Task** - Subagentes

### **MCP Servers:**
- **filesystem** - Arquivos
- **memory** - Memória
- **github** - GitHub
- **puppeteer** - Browser

---

## 📊 **FLUXOS RECOMENDADOS**

### **Desenvolvimento:**
```bash
# 1. Explorar
Use the Explore subagent

# 2. Planejar
Use the Plan subagent

# 3. Implementar
./claude-simple.sh "Implementar feature"

# 4. Revisar
/code-review
```

### **Segurança:**
```bash
# 1. Análise
/security-review

# 2. Agente especializado
./claude-enhanced.sh "Analisar com security-specialist"
```

---

## 💡 **DICAS RÁPIDAS**

### **Performance:**
- Use agentes em paralelo
- Configure timeouts
- Use background commands

### **Contexto:**
- Use `/clear` para limpar
- Seja específico nas instruções
- Use TodoWrite para tarefas complexas

### **Integração:**
- Combine com git
- Use MCP memory para contexto
- Integre com CI/CD

---

## 🔍 **SOLUÇÃO DE PROBLEMAS**

### **Agentes Não Detectados:**
```bash
# Usar wrapper
./claude-simple.sh
```

### **Comandos Não Funcionam:**
```bash
# Verificar estrutura
ls ~/.claude/commands/
```

### **Task Tool com Problemas:**
```bash
# Usar apenas agentes nativos
Use the Explore subagent
```

---

## 📞 **VERIFICAÇÃO DO SISTEMA**

### **Status:**
```bash
claude --version
ls -la ~/.claude/agents/ | wc -l
```

### **Logs:**
```bash
ls ~/.claude/logs/
```

---

**🎯 SISTEMA PRONTO PARA USO!**

*Use os comandos acima para começar imediatamente.*