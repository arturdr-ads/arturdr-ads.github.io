#!/bin/bash
# Teste direto de agentes customizados

# JSON com apenas 1 agente para teste
AGENTS_JSON='{
  "test-reviewer": {
    "description": "Test agent for code review",
    "prompt": "You are a test code reviewer. When asked to review code, respond with: ✅ AGENTE TESTE FUNCIONANDO - This is a test response from the custom agent."
  }
}'

echo "🧪 Testando agente customizado..."
echo "Prompt: 'Please review this code using the test-reviewer agent'"
echo ""

# Executar com agente carregado
echo "Please review this code using the test-reviewer agent" | claude --agents "$AGENTS_JSON" --print