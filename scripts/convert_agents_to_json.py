#!/usr/bin/env python3
"""
Script para converter agentes Markdown do diretório ~/.claude/agents/
para formato JSON compatível com a flag --agents do Claude Code CLI
"""

import os
import yaml
import json
import glob
from pathlib import Path


def parse_agent_file(file_path):
    """Parse um arquivo de agente Markdown com YAML frontmatter"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extrair frontmatter YAML
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            frontmatter = parts[1].strip()
            prompt_content = parts[2].strip()

            try:
                agent_data = yaml.safe_load(frontmatter)
                agent_data['prompt'] = prompt_content
                return agent_data
            except yaml.YAMLError as e:
                print(f"Erro ao parsear YAML em {file_path}: {e}")
                return None

    return None


def main():
    agents_dir = Path.home() / '.claude' / 'agents'
    agents_json = {}

    print(f"Procurando agentes em: {agents_dir}")

    # Listar todos os arquivos no diretório de agentes
    agent_files = list(agents_dir.glob('*'))
    print(f"Encontrados {len(agent_files)} arquivos de agente")

    for file_path in agent_files:
        if file_path.is_file():
            agent_name = file_path.name
            print(f"Processando: {agent_name}")

            agent_data = parse_agent_file(file_path)
            if agent_data:
                # Extrair informações essenciais para o formato JSON do Claude
                name = agent_data.get('name', agent_name)
                description = agent_data.get('description', '')
                prompt = agent_data.get('prompt', '')

                # Criar entrada no formato esperado pelo Claude
                agents_json[name] = {
                    'description': description,
                    'prompt': prompt
                }

                print(f"  ✓ Adicionado: {name}")
            else:
                print(f"  ✗ Erro ao processar: {agent_name}")

    # Gerar JSON final
    json_output = json.dumps(agents_json, indent=2, ensure_ascii=False)

    # Salvar em arquivo
    output_file = Path.home() / '.claude' / 'agents.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(json_output)

    print(f"\n✅ JSON gerado com {len(agents_json)} agentes")
    print(f"📁 Arquivo salvo em: {output_file}")

    # Mostrar estatísticas
    print(f"\n📊 Estatísticas:")
    print(f"   Total de agentes processados: {len(agents_json)}")

    # Listar alguns agentes como exemplo
    print(f"\n🔍 Exemplo de agentes carregados:")
    for i, agent_name in enumerate(list(agents_json.keys())[:5]):
        agent = agents_json[agent_name]
        print(f"   {i+1}. {agent_name}: {agent['description'][:50]}...")


if __name__ == "__main__":
    main()