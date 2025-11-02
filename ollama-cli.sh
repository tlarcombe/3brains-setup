#!/bin/bash

# Ollama CLI - Interactive wrapper for local LLM research tool
# Compatible with any Ollama model

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Default model (can be changed)
MODEL="${OLLAMA_MODEL:-qwen3:latest}"

# Show banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
   ___  _ _
  / _ \| | | __ _ _ __ ___   __ _
 | | | | | |/ _` | '_ ` _ \ / _` |
 | |_| | | | (_| | | | | | | (_| |
  \___/|_|_|\__,_|_| |_| |_|\__,_|

  Local LLM Research Tool
  Powered by Ollama
EOF
    echo -e "${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Model: $MODEL${NC}"
    echo ""
}

# Send question to Ollama
ask_ollama() {
    local question="$1"

    echo -e "${YELLOW}🤔 Thinking...${NC}"
    echo ""

    # Make API request to local Ollama
    response=$(curl -s http://localhost:11434/api/generate \
        -d "{\"model\": \"$MODEL\", \"prompt\": \"$question\", \"stream\": false}" 2>/dev/null)

    # Check if request succeeded
    if [ $? -ne 0 ] || [ -z "$response" ]; then
        echo -e "${RED}❌ Error: Ollama API request failed${NC}"
        echo -e "${YELLOW}Make sure Ollama is running: systemctl status ollama${NC}"
        return 1
    fi

    # Parse response
    answer=$(echo "$response" | jq -r '.response // empty')

    if [ -z "$answer" ]; then
        echo -e "${RED}❌ Error: No response from model${NC}"
        return 1
    fi

    # Display result
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📊 Answer:${NC}"
    echo ""
    echo -e "$answer"
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Interactive mode
interactive_mode() {
    show_banner
    echo -e "${CYAN}Type your research questions. Type 'exit' to quit.${NC}"
    echo -e "${CYAN}Type 'help' for available commands.${NC}"
    echo ""

    while true; do
        echo -e -n "${PURPLE}ollama>${NC} "
        read -r input

        # Trim whitespace
        input=$(echo "$input" | xargs)

        # Check for empty input
        if [ -z "$input" ]; then
            continue
        fi

        # Handle commands
        case "$input" in
            exit|quit|q)
                echo -e "${CYAN}Goodbye!${NC}"
                exit 0
                ;;
            help|h|\?)
                echo ""
                echo -e "${CYAN}Available commands:${NC}"
                echo "  exit, quit, q  - Exit Ollama CLI"
                echo "  help, h, ?     - Show this help"
                echo "  clear, cls     - Clear screen"
                echo "  models         - List available models"
                echo "  model <name>   - Switch model"
                echo ""
                echo -e "${CYAN}Or just type your question!${NC}"
                echo ""
                ;;
            clear|cls)
                show_banner
                ;;
            models)
                echo ""
                echo -e "${CYAN}Available Ollama models:${NC}"
                ollama list 2>/dev/null || echo "  Error: Cannot connect to Ollama"
                echo ""
                ;;
            model\ *)
                new_model="${input#model }"
                MODEL="$new_model"
                echo ""
                echo -e "${GREEN}✓ Switched to model: $MODEL${NC}"
                echo ""
                ;;
            *)
                echo ""
                ask_ollama "$input"
                ;;
        esac
    done
}

# Single question mode (non-interactive)
single_question_mode() {
    local question="$1"
    ask_ollama "$question"
}

# Main entry point
main() {
    # Check for jq
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required but not installed.${NC}"
        echo "Install with: sudo pacman -S jq"
        exit 1
    fi

    # Check for curl
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: curl is required but not installed.${NC}"
        exit 1
    fi

    # Check for ollama
    if ! command -v ollama &> /dev/null; then
        echo -e "${RED}Error: Ollama is not installed.${NC}"
        echo "Install from: https://ollama.ai"
        exit 1
    fi

    # Check if Ollama is running
    if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo -e "${YELLOW}Warning: Ollama API may not be running.${NC}"
        echo "Start with: systemctl start ollama"
        echo ""
    fi

    # Check if question provided as argument
    if [ $# -gt 0 ]; then
        single_question_mode "$*"
    else
        interactive_mode
    fi
}

main "$@"
