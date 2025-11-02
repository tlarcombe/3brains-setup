#!/bin/bash

# 3Brains - Multi-AI Terminal Orchestrator (Advanced Version)
# This script provides a sophisticated multi-AI environment using tmux

set -e

# Configuration
SESSION_NAME="3brains"
WORKING_DIR="${1:-$(pwd)}"
CONFIG_FILE="$WORKING_DIR/.3brains-config"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

# ASCII Art Banner
show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    _____ ____            _
   |___ /| __ ) _ __ __ _(_)_ __  ___
     |_ \|  _ \| '__/ _` | | '_ \/ __|
    ___) | |_) | | | (_| | | | | \__ \
   |____/|____/|_|  \__,_|_|_| |_|___/

   Multi-AI Terminal Orchestrator
EOF
    echo -e "${NC}"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()

    if ! command -v tmux &> /dev/null; then
        missing_deps+=("tmux")
    fi

    # Check for AI tools (optional but recommended)
    command -v claude &> /dev/null || echo -e "${YELLOW}Warning: claude not found${NC}" >&2
    command -v gemini &> /dev/null || echo -e "${YELLOW}Warning: gemini not found${NC}" >&2

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}Error: Missing required dependencies: ${missing_deps[*]}${NC}" >&2
        exit 1
    fi
}

# Initialize context files
init_context_files() {
    cd "$WORKING_DIR"

    # Create CLAUDE.md if it doesn't exist
    if [ ! -f "CLAUDE.md" ]; then
        cat > "CLAUDE.md" << 'EOF'
# Project Context

This is a 3Brains-enabled project with synchronized AI context.

## Current Status

Project initialized with 3Brains multi-AI orchestrator.

## Active AI Tools

- Claude (Orchestrator)
- Gemini (Research/Tasks)

## Notes

EOF
        echo -e "${GREEN}✓ Created CLAUDE.md${NC}"
    fi

    # Create or sync GEMINI.md
    if [ ! -f "GEMINI.md" ]; then
        if [ -f ".3brains-config" ] && grep -q "USE_SYMLINKS=true" ".3brains-config"; then
            ln -sf CLAUDE.md GEMINI.md
            echo -e "${GREEN}✓ Created GEMINI.md (symlink to CLAUDE.md)${NC}"
        else
            cp CLAUDE.md GEMINI.md
            echo -e "${GREEN}✓ Created GEMINI.md (copy of CLAUDE.md)${NC}"
        fi
    fi

    # Create AGENTS.md for codex or other agent-based tools
    if [ ! -f "AGENTS.md" ]; then
        if [ -f ".3brains-config" ] && grep -q "USE_SYMLINKS=true" ".3brains-config"; then
            ln -sf CLAUDE.md AGENTS.md
            echo -e "${GREEN}✓ Created AGENTS.md (symlink to CLAUDE.md)${NC}"
        else
            cp CLAUDE.md AGENTS.md
            echo -e "${GREEN}✓ Created AGENTS.md (copy of CLAUDE.md)${NC}"
        fi
    fi
}

# Create default config file
create_config() {
    cat > "$CONFIG_FILE" << 'EOF'
# 3Brains Configuration

# Use symlinks to keep context files in sync
USE_SYMLINKS=true

# AI Tools to launch (space-separated)
ENABLED_AIS="claude gemini"

# Auto-launch AI tools on session start
AUTO_LAUNCH=false

# Layout: main-vertical, main-horizontal, tiled, even-vertical, even-horizontal
TMUX_LAYOUT="main-vertical"

# Pane titles
PANE_CLAUDE_TITLE="Claude (Orchestrator)"
PANE_GEMINI_TITLE="Gemini (Research)"
PANE_STATUS_TITLE="Status/Monitor"
EOF
    echo -e "${GREEN}✓ Created configuration file: $CONFIG_FILE${NC}"
}

# Load config if it exists
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        # Defaults
        USE_SYMLINKS=true
        ENABLED_AIS="claude gemini"
        AUTO_LAUNCH=false
        TMUX_LAYOUT="main-vertical"
        PANE_CLAUDE_TITLE="Claude (Orchestrator)"
        PANE_GEMINI_TITLE="Gemini (Research)"
        PANE_STATUS_TITLE="Status/Monitor"
    fi
}

# Create the tmux session
create_session() {
    echo -e "${GREEN}Creating 3Brains session in: ${WORKING_DIR}${NC}"

    # Create new detached session
    tmux new-session -d -s "$SESSION_NAME" -c "$WORKING_DIR"

    # Rename window
    tmux rename-window -t "$SESSION_NAME:0" "3Brains"

    # Create pane layout
    # Split horizontally (left and right)
    tmux split-window -h -t "$SESSION_NAME:0" -c "$WORKING_DIR"

    # Split right pane vertically (top-right and bottom-right)
    tmux split-window -v -t "$SESSION_NAME:0.1" -c "$WORKING_DIR"

    # Apply layout
    tmux select-layout -t "$SESSION_NAME:0" "$TMUX_LAYOUT"

    # Set pane titles (requires tmux 2.6+)
    tmux select-pane -t "$SESSION_NAME:0.0" -T "$PANE_CLAUDE_TITLE"
    tmux select-pane -t "$SESSION_NAME:0.1" -T "$PANE_GEMINI_TITLE"
    tmux select-pane -t "$SESSION_NAME:0.2" -T "$PANE_STATUS_TITLE"

    # Enable pane borders and titles
    tmux set-option -g pane-border-status top
    tmux set-option -g pane-border-format "#{pane_title}"

    # Setup Claude pane (left)
    setup_claude_pane

    # Setup Gemini pane (top-right)
    setup_gemini_pane

    # Setup status pane (bottom-right)
    setup_status_pane

    # Focus on Claude pane
    tmux select-pane -t "$SESSION_NAME:0.0"
}

setup_claude_pane() {
    tmux send-keys -t "$SESSION_NAME:0.0" "clear" C-m
    tmux send-keys -t "$SESSION_NAME:0.0" "echo -e '${BLUE}🤖 Claude Code - Main Orchestrator${NC}'" C-m
    tmux send-keys -t "$SESSION_NAME:0.0" "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'" C-m
    tmux send-keys -t "$SESSION_NAME:0.0" "echo 'Claude will orchestrate the multi-AI workflow.'" C-m
    tmux send-keys -t "$SESSION_NAME:0.0" "echo ''" C-m

    if [ "$AUTO_LAUNCH" = "true" ] && command -v claude &> /dev/null; then
        tmux send-keys -t "$SESSION_NAME:0.0" "claude --dangerously-skip-permissions" C-m
    else
        tmux send-keys -t "$SESSION_NAME:0.0" "echo 'To launch Claude: claude --dangerously-skip-permissions'" C-m
        tmux send-keys -t "$SESSION_NAME:0.0" "echo 'Or just: claude (for safe mode)'" C-m
    fi
}

setup_gemini_pane() {
    tmux send-keys -t "$SESSION_NAME:0.1" "clear" C-m
    tmux send-keys -t "$SESSION_NAME:0.1" "echo -e '${GREEN}🔍 Gemini CLI - Research & Tasks${NC}'" C-m
    tmux send-keys -t "$SESSION_NAME:0.1" "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'" C-m
    tmux send-keys -t "$SESSION_NAME:0.1" "echo 'Gemini handles research and specialized tasks.'" C-m
    tmux send-keys -t "$SESSION_NAME:0.1" "echo ''" C-m

    if [ "$AUTO_LAUNCH" = "true" ] && command -v gemini &> /dev/null; then
        tmux send-keys -t "$SESSION_NAME:0.1" "gemini" C-m
    else
        tmux send-keys -t "$SESSION_NAME:0.1" "echo 'To launch Gemini: gemini'" C-m
        tmux send-keys -t "$SESSION_NAME:0.1" "echo 'For headless mode: gemini -p \"your prompt\"'" C-m
    fi
}

setup_status_pane() {
    tmux send-keys -t "$SESSION_NAME:0.2" "clear" C-m

    # Create a simple status monitoring script
    tmux send-keys -t "$SESSION_NAME:0.2" "cat << 'STATUSEOF'
echo -e '${PURPLE}📊 3Brains Status Monitor${NC}'
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo ''
echo -e '${YELLOW}Working Directory:${NC} $WORKING_DIR'
echo -e '${YELLOW}Session Name:${NC} $SESSION_NAME'
echo ''
echo -e '${YELLOW}Context Files:${NC}'
ls -lh *.md 2>/dev/null | grep -v total || echo '  No .md files found'
echo ''
echo -e '${YELLOW}Git Status:${NC}'
if git rev-parse --git-dir > /dev/null 2>&1; then
    git status --short | head -5
    echo ''
    git log --oneline -3 2>/dev/null || echo '  No commits yet'
else
    echo '  Not a git repository'
fi
echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
echo -e '${BLUE}Tmux Shortcuts:${NC}'
echo '  Ctrl+b → arrow  : Switch panes'
echo '  Ctrl+b → d      : Detach session'
echo '  Ctrl+b → [      : Scroll mode (q to exit)'
echo '  Ctrl+b → z      : Zoom/unzoom pane'
echo '  Ctrl+b → x      : Kill pane'
echo '  Ctrl+b → &      : Kill window'
echo ''
echo -e '${BLUE}3Brains Commands:${NC}'
echo '  Watch files: watch -n 2 ls -lth *.md'
echo '  Sync check: diff CLAUDE.md GEMINI.md'
echo '  Git commit: git add . && git commit -m \"msg\"'
echo ''
STATUSEOF
" C-m

    # Execute the status script
    sleep 0.5
    tmux send-keys -t "$SESSION_NAME:0.2" "" C-m

    # Add file watcher (optional)
    tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Type: watch -n 2 ls -lth *.md  (to monitor file changes)'" C-m
}

# Main execution
main() {
    show_banner

    # Check if session exists
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo -e "${YELLOW}Session '$SESSION_NAME' already exists.${NC}"
        echo -e "${YELLOW}Attaching to existing session...${NC}"
        echo ""
        sleep 1
        tmux attach-session -t "$SESSION_NAME"
        exit 0
    fi

    # Check dependencies
    check_dependencies

    # Load or create config
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${YELLOW}No configuration file found. Creating default...${NC}"
        create_config
    fi
    load_config

    # Initialize context files
    init_context_files

    # Create session
    create_session

    # Success message
    echo ""
    echo -e "${GREEN}✓ 3Brains session created successfully!${NC}"
    echo -e "${BLUE}→ Attaching to session...${NC}"
    echo ""
    sleep 1

    # Attach to session
    tmux attach-session -t "$SESSION_NAME"
}

# Run main function
main
