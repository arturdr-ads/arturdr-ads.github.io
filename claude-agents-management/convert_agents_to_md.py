#!/usr/bin/env python3
"""
Script para converter agentes antigos (sem extensão) para formato MD
com roteamento inteligente implementado
"""

import os
import glob
import re

# Mapeamento de especialização para roteamento inteligente
SPECIALIZATION_MAP = {
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
    'intelligent-router-proxy': 'routing'
}

# Template base para agentes MD
AGENT_TEMPLATE = """---
name: {name}
description: {description}
category: {category}
color: {color}
tools: Read, Write, Edit, Bash, Task
---

You are {name}, {description}

## Intelligent Routing Configuration
- **Task Type**: {task_type}
- **Specialization**: {specialization}
- **Model Selection**: Dynamic routing via intelligent-router-proxy
- **Cost Optimization**: Automatic model selection based on task complexity

## Core Responsibilities
{responsibilities}

## Best Practices
- Use intelligent routing for optimal model selection
- Leverage specialized tools for your domain
- Follow Claude Code CLI best practices
- Maintain clear documentation
"""

def detect_specialization(agent_name):
    """Detecta a especialização baseada no nome do agente"""
    for key, value in SPECIALIZATION_MAP.items():
        if key in agent_name:
            return value
    return 'general'

def generate_description(agent_name):
    """Gera descrição baseada no nome do agente"""
    descriptions = {
        'code-reviewer': 'specialized in comprehensive code review and quality assurance',
        'workflow-optimizer': 'specialized in workflow optimization and process improvement',
        'database-specialist': 'specialized in database design, optimization and management',
        'monitoring-specialist': 'specialized in system monitoring and observability',
        'e2e-test-specialist': 'specialized in end-to-end testing and quality assurance',
        'cloud-architect': 'specialized in cloud architecture and infrastructure design',
        'frontend-specialist': 'specialized in frontend development and user experience',
        'project-manager': 'specialized in project management and team coordination',
        'rust-pro': 'specialized in Rust programming and systems development',
        'fintech-specialist': 'specialized in financial technology and fintech solutions',
        'react-pro': 'specialized in React development and modern frontend frameworks',
        'accessibility-auditor': 'specialized in accessibility compliance and user experience',
        'performance-tester': 'specialized in performance testing and optimization',
        'embedded-engineer': 'specialized in embedded systems and IoT development',
        'data-engineer': 'specialized in data engineering and ETL processes',
        'golang-pro': 'specialized in Go programming and backend development',
        'devops-engineer': 'specialized in DevOps practices and infrastructure automation',
        'documentation-writer': 'specialized in technical documentation and user guides',
        'orchestrator': 'specialized in workflow orchestration and process coordination',
        'product-strategist': 'specialized in product strategy and market analysis'
    }

    for key, desc in descriptions.items():
        if key in agent_name:
            return desc

    return f'specialized in {agent_name.replace("-", " ")}'

def generate_responsibilities(agent_name):
    """Gera responsabilidades baseadas na especialização"""
    responsibilities = {
        'code-reviewer': '- Review code for quality, security, and best practices\n- Identify potential bugs and performance issues\n- Ensure coding standards compliance\n- Provide constructive feedback and improvement suggestions',
        'workflow-optimizer': '- Analyze and optimize development workflows\n- Identify bottlenecks and improvement opportunities\n- Implement automation and efficiency improvements\n- Monitor workflow performance metrics',
        'database-specialist': '- Design and optimize database schemas\n- Implement data migration strategies\n- Ensure data integrity and security\n- Optimize query performance and indexing',
        'ai-ml-specialist': '- Design and implement AI/ML solutions\n- Analyze data and build predictive models\n- Optimize machine learning workflows\n- Stay current with AI/ML research and trends'
    }

    for key, resp in responsibilities.items():
        if key in agent_name:
            return resp

    return f'- Provide expert guidance in {agent_name.replace("-", " ")}\n- Follow best practices for your specialization\n- Use appropriate tools and methodologies\n- Maintain high quality standards'

def convert_agent(old_agent_path):
    """Converte um agente antigo para formato MD"""
    agent_name = os.path.basename(old_agent_path)
    new_agent_path = f"{old_agent_path}.md"

    # Detectar especialização
    specialization = detect_specialization(agent_name)
    description = generate_description(agent_name)
    responsibilities = generate_responsibilities(agent_name)

    # Determinar categoria e cor
    if 'review' in agent_name or 'audit' in agent_name:
        category = 'review'
        color = 'blue'
    elif 'test' in agent_name or 'qa' in agent_name:
        category = 'testing'
        color = 'yellow'
    elif 'architect' in agent_name or 'design' in agent_name:
        category = 'architecture'
        color = 'purple'
    elif 'manager' in agent_name or 'coordinator' in agent_name:
        category = 'management'
        color = 'green'
    else:
        category = 'specialized'
        color = 'orange'

    # Gerar conteúdo MD
    md_content = AGENT_TEMPLATE.format(
        name=agent_name,
        description=description,
        category=category,
        color=color,
        task_type=specialization,
        specialization=specialization,
        responsibilities=responsibilities
    )

    # Escrever arquivo MD
    with open(new_agent_path, 'w') as f:
        f.write(md_content)

    print(f"✓ Converted: {agent_name} -> {agent_name}.md")
    return new_agent_path

def main():
    agents_dir = os.path.expanduser("~/.claude/agents/")

    # Encontrar agentes antigos (sem extensão)
    old_agents = []
    for item in os.listdir(agents_dir):
        item_path = os.path.join(agents_dir, item)
        if os.path.isfile(item_path) and '.' not in item:
            old_agents.append(item_path)

    print(f"Found {len(old_agents)} old agents to convert...")

    # Converter agentes
    converted_count = 0
    for agent_path in old_agents:
        try:
            convert_agent(agent_path)
            converted_count += 1
        except Exception as e:
            print(f"✗ Failed to convert {os.path.basename(agent_path)}: {e}")

    print(f"\n✅ Conversion complete: {converted_count}/{len(old_agents)} agents converted")

    # Listar agentes convertidos
    md_agents = glob.glob(os.path.join(agents_dir, "*.md"))
    print(f"\n📋 Total MD agents: {len(md_agents)}")

    # Mostrar alguns exemplos
    print("\n📝 Sample converted agents:")
    for agent in md_agents[:5]:
        print(f"  - {os.path.basename(agent)}")

if __name__ == "__main__":
    main()