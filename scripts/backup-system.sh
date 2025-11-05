#!/bin/bash
# Backup System - Backup otimizado do sistema Claude Code

set -e

CLAUDE_DIR="$HOME/Claude"
BACKUP_DIR="$CLAUDE_DIR/backups"
BACKUP_NAME="claude-system-backup-$(date +%Y%m%d-%H%M%S)"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_PATH"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Início do backup
log "💾 INICIANDO BACKUP DO SISTEMA CLAUDE CODE"
log "📁 Backup: $BACKUP_PATH"

# Backup da estrutura ~/Claude/
log "📋 BACKUP DA ESTRUTURA ~/Claude/"
cp -r "$CLAUDE_DIR/scripts" "$BACKUP_PATH/"
cp -r "$CLAUDE_DIR/docs" "$BACKUP_PATH/"
cp -r "$CLAUDE_DIR/configs" "$BACKUP_PATH/" 2>/dev/null || true
cp -r "$CLAUDE_DIR/templates" "$BACKUP_PATH/" 2>/dev/null || true

# Backup das configurações ~/.claude/
log "📋 BACKUP DAS CONFIGURAÇÕES ~/.claude/"
mkdir -p "$BACKUP_PATH/.claude"
cp "$HOME/.claude/.mcp.json" "$BACKUP_PATH/.claude/" 2>/dev/null || true
cp "$HOME/.claude/agents-minimal.json" "$BACKUP_PATH/.claude/" 2>/dev/null || true
cp "$HOME/.claude/CLAUDE.md" "$BACKUP_PATH/.claude/" 2>/dev/null || true

# Backup dos agentes principais
log "🤖 BACKUP DOS AGENTES PRINCIPAIS"
mkdir -p "$BACKUP_PATH/.claude/agents"
cp "$HOME/.claude/agents/code-reviewer.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true
cp "$HOME/.claude/agents/backend-architect.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true
cp "$HOME/.claude/agents/frontend-specialist.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true
cp "$HOME/.claude/agents/devops-specialist.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true
cp "$HOME/.claude/agents/ai-ml-specialist.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true
cp "$HOME/.claude/agents/intelligent-router-proxy.md" "$BACKUP_PATH/.claude/agents/" 2>/dev/null || true

# Criar arquivo de metadados do backup
cat > "$BACKUP_PATH/backup-info.txt" << EOF
Claude Code System Backup
=========================
Backup Date: $(date)
Backup Name: $BACKUP_NAME

System Information:
- Claude Version: $(claude --version 2>/dev/null || echo "Unknown")
- Total Agents: $(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l || echo "0")
- MCP Servers: $(grep -c '".*":' "$HOME/.claude/.mcp.json" 2>/dev/null | head -1 || echo "0")

Backup Contents:
- Scripts: $(find "$BACKUP_PATH/scripts" -type f 2>/dev/null | wc -l || echo "0") files
- Documentation: $(find "$BACKUP_PATH/docs" -type f 2>/dev/null | wc -l || echo "0") files
- Configurations: $(find "$BACKUP_PATH/configs" -type f 2>/dev/null | wc -l || echo "0") files
- Agents: $(find "$BACKUP_PATH/.claude/agents" -type f 2>/dev/null | wc -l || echo "0") files

Restore Instructions:
1. Copy scripts back to ~/Claude/scripts/
2. Copy docs back to ~/Claude/docs/
3. Copy configs back to ~/Claude/configs/
4. Copy .claude files back to ~/.claude/
EOF

# Compactar o backup
log "🗜️  COMPACTANDO BACKUP..."
cd "$BACKUP_DIR"
tar -czf "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"

# Remover diretório temporário
rm -rf "$BACKUP_PATH"

# Calcular tamanho do backup
BACKUP_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME.tar.gz" | cut -f1)

# Resumo final
log ""
log "✅ BACKUP CONCLUÍDO COM SUCESSO"
log "📦 Arquivo: $BACKUP_NAME.tar.gz"
log "📊 Tamanho: $BACKUP_SIZE"
log "📁 Local: $BACKUP_DIR"
log ""
log "💡 Para restaurar: tar -xzf $BACKUP_NAME.tar.gz"
log "🚀 Sistema Claude Code protegido!"