#!/bin/bash

# 3Brains - Multi-AI Terminal Orchestrator
# This script launches multiple AI tools in a synchronized tmux session

# Configuration
SESSION_NAME="3brains"
WORKING_DIR="${1:-$(pwd)}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧠🧠🧠 3Brains - Multi-AI Orchestrator${NC}"
echo -e "${GREEN}Working directory: ${WORKING_DIR}${NC}"
echo ""

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo -e "${YELLOW}Session '$SESSION_NAME' already exists. Attaching...${NC}"
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

# Create tmux session with multiple panes
echo -e "${GREEN}Creating new 3Brains session...${NC}"

# Create new session and detach immediately
tmux new-session -d -s "$SESSION_NAME" -c "$WORKING_DIR"

# Rename the first window
tmux rename-window -t "$SESSION_NAME:0" "3Brains"

# Split the window into 3 panes
# First split: horizontal (top and bottom)
tmux split-window -h -t "$SESSION_NAME:0" -c "$WORKING_DIR"

# Split the right pane vertically
tmux split-window -v -t "$SESSION_NAME:0.1" -c "$WORKING_DIR"

# Adjust layout to be more balanced
tmux select-layout -t "$SESSION_NAME:0" main-vertical

# Add pane titles/labels
tmux select-pane -t "$SESSION_NAME:0.0" -T "Claude (Orchestrator)"
tmux select-pane -t "$SESSION_NAME:0.1" -T "Gemini (Research)"
tmux select-pane -t "$SESSION_NAME:0.2" -T "Status/Monitor"

# Send commands to each pane
# Pane 0 (left): Claude Code
tmux send-keys -t "$SESSION_NAME:0.0" "echo -e '${BLUE}🤖 Claude Code - Orchestrator${NC}'" C-m
tmux send-keys -t "$SESSION_NAME:0.0" "echo 'This is the main Claude orchestrator.'" C-m
tmux send-keys -t "$SESSION_NAME:0.0" "echo 'Launch with: claude --dangerously-skip-permissions'" C-m
tmux send-keys -t "$SESSION_NAME:0.0" "echo ''" C-m
# Don't auto-launch yet, let user decide
# tmux send-keys -t "$SESSION_NAME:0.0" "claude" C-m

# Pane 1 (top right): Gemini CLI
tmux send-keys -t "$SESSION_NAME:0.1" "echo -e '${GREEN}🔍 Gemini CLI - Research Agent${NC}'" C-m
tmux send-keys -t "$SESSION_NAME:0.1" "echo 'Gemini is ready for research tasks.'" C-m
tmux send-keys -t "$SESSION_NAME:0.1" "echo 'Launch with: gemini'" C-m
tmux send-keys -t "$SESSION_NAME:0.1" "echo ''" C-m
# tmux send-keys -t "$SESSION_NAME:0.1" "gemini" C-m

# Pane 2 (bottom right): Status/Monitor pane
tmux send-keys -t "$SESSION_NAME:0.2" "echo -e '${YELLOW}📊 3Brains Status Monitor${NC}'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Working Directory: $WORKING_DIR'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Session: $SESSION_NAME'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Context Files:'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "ls -lh *.md 2>/dev/null || echo 'No .md files found yet'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '=== Tmux Shortcuts ==='" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Ctrl+b then arrow key - Switch panes'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Ctrl+b then d - Detach from session'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Ctrl+b then [ - Scroll mode (q to exit)'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo 'Ctrl+b then z - Zoom current pane'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m

# Focus on the Claude pane (left)
tmux select-pane -t "$SESSION_NAME:0.0"

# Attach to the session
echo ""
echo -e "${GREEN}✓ 3Brains session created!${NC}"
echo -e "${YELLOW}Attaching to session...${NC}"
echo ""
sleep 1

tmux attach-session -t "$SESSION_NAME"
