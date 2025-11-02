#!/bin/bash

# 3Brains Status Monitor Display
# This script shows current project status in a clean format

# Colors
PURPLE='\033[0;35m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m'

# Clear and show header
clear
echo -e "${PURPLE}📊 3Brains Status Monitor${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# AI Status
echo -e "${BLUE}🤖 AI Agents:${NC}"
echo "  Claude    : ✅ Orchestrator"
echo "  Gemini    : 🛠️  Agent Manager"
echo "  Genius2   : 🔬 7-LLM Research"
echo ""

# Project files
echo -e "${CYAN}📁 Project Files:${NC}"
if ls *.sh *.md &>/dev/null; then
    ls -lh *.sh *.md 2>/dev/null | grep -v total | awk '{printf "  %-25s %6s\n", $9, $5}' | head -8
else
    echo "  No files found"
fi
echo ""

# Git status
echo -e "${YELLOW}📝 Git Status:${NC}"
if git rev-parse --git-dir > /dev/null 2>&1; then
    git status --short 2>/dev/null | head -5 | sed 's/^/  /'
    if [ -z "$(git status --short 2>/dev/null)" ]; then
        echo "  (clean working tree)"
    fi
else
    echo "  Not a git repository"
fi
echo ""

# Recent activity
echo -e "${GREEN}✅ Recent Activity:${NC}"
echo "  • Genius2 integrated (7-LLM)"
echo "  • Code quality research done"
echo "  • GitHub upload script ready"
echo ""

# Quick reference
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}Quick Reference:${NC}"
echo "  Mouse    : Click to focus pane"
echo "  Ctrl+b z : Zoom/unzoom"
echo "  Ctrl+b d : Detach session"
echo ""
echo -e "${CYAN}Updated: $(date +'%H:%M:%S')${NC}"
