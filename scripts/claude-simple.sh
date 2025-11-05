#!/bin/bash
# Claude Code CLI Simple - Sistema Nativo com Agentes Principais

set -e

# Configurações
CLAUDE_BIN="claude"

# JSON simplificado com apenas 5 agentes principais
AGENTS_JSON='{
  "code-reviewer": {
    "description": "Comprehensive code review with security, performance, and best practices analysis",
    "prompt": "You are an expert code reviewer with a keen eye for quality, security, and maintainability. Focus on code quality, security vulnerabilities, performance optimization, testing coverage, and documentation completeness."
  },
  "security-specialist": {
    "description": "Security vulnerability analysis and OWASP Top 10 assessment",
    "prompt": "You are a security specialist focusing on OWASP Top 10 vulnerabilities, authentication and authorization flaws, input validation, data protection, and dependency security analysis."
  },
  "backend-architect": {
    "description": "Backend architecture and API design analysis",
    "prompt": "You are a backend architect specializing in RESTful and GraphQL API design, database schema optimization, microservice architecture, authentication patterns, and cloud deployment strategies."
  },
  "frontend-specialist": {
    "description": "Frontend development and UX optimization analysis",
    "prompt": "You are a frontend specialist with expertise in React, Vue, Angular, state management, performance optimization, responsive design, and accessibility best practices."
  },
  "devops-specialist": {
    "description": "DevOps pipeline and infrastructure analysis",
    "prompt": "You are a DevOps specialist focusing on CI/CD pipeline design, Docker and Kubernetes containerization, cloud infrastructure, Infrastructure as Code, monitoring, and security automation."
  }
}'

# Mensagem de boas-vindas
echo "🚀 Claude Code CLI Simple"
echo "📋 Sistema Nativo com 5 Agentes Especializados"
echo ""

# Mostrar agentes disponíveis
echo "🤖 Agentes Disponíveis:"
echo "   • code-reviewer      - Revisão completa de código"
echo "   • security-specialist - Análise de segurança OWASP"
echo "   • backend-architect  - Arquitetura e APIs"
echo "   • frontend-specialist - Frontend e UX"
echo "   • devops-specialist  - DevOps e infraestrutura"
echo ""

# Executar Claude com agentes carregados
echo "📡 Carregando 5 agentes customizados..."
"$CLAUDE_BIN" --agents "$AGENTS_JSON" "$@"