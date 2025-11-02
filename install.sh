#!/bin/bash

# 3Brains Installation Script
# Installs 3brains command system-wide

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
    _____ ____            _
   |___ /| __ ) _ __ __ _(_)_ __  ___
     |_ \|  _ \| '__/ _` | | '_ \/ __|
    ___) | |_) | | | (_| | | | | \__ \
   |____/|____/|_|  \__,_|_|_| |_|___/

   3Brains Installation
EOF
echo -e "${NC}"

# Detect install location
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo -e "${YELLOW}Note: $HOME/.local/bin is not in your PATH${NC}"
        echo -e "${YELLOW}Add this to your ~/.bashrc or ~/.zshrc:${NC}"
        echo -e "${GREEN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    fi
else
    echo -e "${RED}Error: Could not find suitable installation directory${NC}"
    echo -e "${YELLOW}Please create $HOME/.local/bin and add it to your PATH${NC}"
    exit 1
fi

echo -e "${GREEN}Installing 3brains to: ${INSTALL_DIR}${NC}"
echo ""

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"

MISSING_DEPS=()

if ! command -v tmux &> /dev/null; then
    MISSING_DEPS+=("tmux")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}Error: Missing required dependencies: ${MISSING_DEPS[*]}${NC}"
    echo ""
    echo "Please install tmux first:"
    echo ""
    echo "  Ubuntu/Debian:  sudo apt-get install tmux"
    echo "  MacOS:          brew install tmux"
    echo "  Manjaro/Arch:   sudo pacman -S tmux"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ All dependencies found${NC}"
echo ""

# Check for AI tools (optional)
echo -e "${BLUE}Checking for AI tools (optional)...${NC}"

AI_TOOLS=()
command -v claude &> /dev/null && AI_TOOLS+=("claude") || echo -e "${YELLOW}  claude: not found${NC}"
command -v gemini &> /dev/null && AI_TOOLS+=("gemini") || echo -e "${YELLOW}  gemini: not found${NC}"
command -v codex &> /dev/null && AI_TOOLS+=("codex") || echo -e "${YELLOW}  codex: not found${NC}"

if [ ${#AI_TOOLS[@]} -eq 0 ]; then
    echo -e "${YELLOW}Warning: No AI CLI tools found${NC}"
    echo -e "${YELLOW}3brains will work but you should install:${NC}"
    echo "  - Claude Code: https://claude.com/product/claude-code"
    echo "  - Gemini CLI: https://ai.google.dev/gemini-api"
    echo ""
else
    echo -e "${GREEN}✓ Found: ${AI_TOOLS[*]}${NC}"
    echo ""
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy script
echo -e "${BLUE}Installing 3brains...${NC}"

if [ -f "$SCRIPT_DIR/3brains.sh" ]; then
    cp "$SCRIPT_DIR/3brains.sh" "$INSTALL_DIR/3brains"
    chmod +x "$INSTALL_DIR/3brains"
    echo -e "${GREEN}✓ Installed to: $INSTALL_DIR/3brains${NC}"
else
    echo -e "${RED}Error: 3brains.sh not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Verify installation
echo ""
echo -e "${BLUE}Verifying installation...${NC}"

if command -v 3brains &> /dev/null; then
    echo -e "${GREEN}✓ 3brains is ready to use!${NC}"
else
    echo -e "${YELLOW}Warning: 3brains command not found in PATH${NC}"
    echo -e "${YELLOW}You may need to restart your shell or add $INSTALL_DIR to PATH${NC}"
fi

# Success message
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  cd ~/my-project"
echo "  3brains"
echo ""
echo -e "${BLUE}Or specify a directory:${NC}"
echo "  3brains /path/to/project"
echo ""
echo -e "${BLUE}To reattach to a session:${NC}"
echo "  tmux attach -t 3brains"
echo ""
echo -e "${BLUE}For more help:${NC}"
echo "  View README.md at: $SCRIPT_DIR/README.md"
echo ""
echo -e "${YELLOW}Happy multi-AI orchestrating! 🧠🧠🧠${NC}"
echo ""
