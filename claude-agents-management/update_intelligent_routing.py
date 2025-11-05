#!/usr/bin/env python3
"""
Script para atualizar todos os agentes MD com roteamento inteligente
"""

import os
import glob
import re

# Mapeamento de especialização para roteamento inteligente
TASK_TYPE_MAP = {
    'code-reviewer': 'code-review',
    'workflow-optimizer': 'optimization',
    'database-specialist': 'database',
    'monitoring-specialist': 'monitoring',
    'e2e-test-specialist': 'testing',
    'cloud-architect': 'architecture',
    'frontend-specialist': 'frontend',
    'project-manager': 'coordination',
    'rust-pro': 'rust',
    'fintech-specialist': 'finance',
    'react-pro': 'react',
    'accessibility-auditor': 'accessibility',
    'performance-tester': 'performance',
    'embedded-engineer': 'embedded',
    'data-engineer': 'data',
    'golang-pro': 'golang',
    'devops-engineer': 'devops',
    'documentation-writer': 'documentation',
    'orchestrator': 'coordination',
    'product-strategist': 'strategy',
    'ai-ml-specialist': 'ai-ml',
    'intelligent-router-proxy': 'routing',
    'typescript-pro': 'typescript',
    'healthcare-dev': 'healthcare',
    'fullstack-engineer': 'fullstack',
    'deployment-manager': 'deployment',
    'data-scientist': 'data-science',
    'ai-engineer': 'ai-engineering',
    'frontend-specialist-proxy': 'frontend',
    'test-simple': 'testing',
    'ecommerce-expert': 'ecommerce',
    'test-engineer': 'testing',
    'backend-architect-proxy': 'backend',
    'vue-specialist': 'vue',
    'python-pro': 'python',
    'mobile-developer': 'mobile',
    'blockchain-developer': 'blockchain',
    'api-designer': 'api-design',
    'java-enterprise': 'java',
    'prompt-engineer': 'prompt-engineering',
    'backend-architect': 'backend',
    'javascript-pro': 'javascript',
    'requirements-analyst': 'requirements',
    'ux-designer': 'ux-design',
    'incident-responder': 'incident-response',
    'game-developer': 'game-development',
    'analytics-engineer': 'analytics',
    'nextjs-pro': 'nextjs',
    'angular-expert': 'angular',
    'security-specialist-proxy': 'security',
    'mlops-engineer': 'mlops',
    'context-manager': 'context-management',
    'security-auditor': 'security',
    'devops-specialist-proxy': 'devops',
    'business-analyst': 'business-analysis',
    'technical-writer': 'technical-writing',
    'performance-engineer': 'performance',
    'code-reviewer-proxy': 'code-review',
    'performance-optimizer': 'optimization',
    'agent-generator': 'agent-generation',
    'error-detective': 'debugging',
    'kubernetes-expert': 'kubernetes'
}

# Template de roteamento inteligente
INTELLIGENT_ROUTING_SECTION = """
## Intelligent Routing Configuration
- **Task Type**: {task_type}
- **Specialization**: {specialization}
- **Model Selection**: Dynamic routing via intelligent-router-proxy
- **Cost Optimization**: Automatic model selection based on task complexity
- **Routing Strategy**: Semantic analysis + capability mapping

## Routing Capabilities
- **Primary Model**: Selected dynamically based on task requirements
- **Fallback Models**: Multiple options for reliability
- **Cost Awareness**: Optimized for budget and performance
- **Quality Assurance**: Best model for specific task types
"""

def detect_task_type(agent_name):
    """Detecta o tipo de tarefa baseado no nome do agente"""
    for key, value in TASK_TYPE_MAP.items():
        if key in agent_name:
            return value
    return 'general'

def update_agent_with_intelligent_routing(agent_path):
    """Atualiza um agente com seção de roteamento inteligente"""
    agent_name = os.path.basename(agent_path).replace('.md', '')

    # Ler conteúdo atual
    with open(agent_path, 'r') as f:
        content = f.read()

    # Detectar tipo de tarefa
    task_type = detect_task_type(agent_name)

    # Verificar se já tem roteamento inteligente
    if 'Intelligent Routing Configuration' in content:
        # Atualizar seção existente
        pattern = r'## Intelligent Routing Configuration[\s\S]*?(?=##|$)'
        new_routing_section = INTELLIGENT_ROUTING_SECTION.format(
            task_type=task_type,
            specialization=task_type
        )
        content = re.sub(pattern, new_routing_section, content)
    else:
        # Adicionar nova seção após a descrição
        description_end = content.find('\n\n##')
        if description_end == -1:
            description_end = len(content)

        new_routing_section = INTELLIGENT_ROUTING_SECTION.format(
            task_type=task_type,
            specialization=task_type
        )
        content = content[:description_end] + new_routing_section + content[description_end:]

    # Escrever conteúdo atualizado
    with open(agent_path, 'w') as f:
        f.write(content)

    print(f"✓ Updated: {agent_name} with intelligent routing")
    return True

def main():
    agents_dir = os.path.expanduser("~/.claude/agents/")

    # Encontrar todos os agentes MD
    md_agents = glob.glob(os.path.join(agents_dir, "*.md"))

    print(f"Found {len(md_agents)} MD agents to update with intelligent routing...")

    # Atualizar agentes
    updated_count = 0
    for agent_path in md_agents:
        try:
            if update_agent_with_intelligent_routing(agent_path):
                updated_count += 1
        except Exception as e:
            print(f"✗ Failed to update {os.path.basename(agent_path)}: {e}")

    print(f"\n✅ Intelligent routing update complete: {updated_count}/{len(md_agents)} agents updated")

    # Mostrar estatísticas de tipos de tarefa
    task_types = {}
    for agent_path in md_agents:
        agent_name = os.path.basename(agent_path).replace('.md', '')
        task_type = detect_task_type(agent_name)
        task_types[task_type] = task_types.get(task_type, 0) + 1

    print(f"\n📊 Task Type Distribution:")
    for task_type, count in sorted(task_types.items(), key=lambda x: x[1], reverse=True)[:10]:
        print(f"  - {task_type}: {count} agents")

if __name__ == "__main__":
    main()