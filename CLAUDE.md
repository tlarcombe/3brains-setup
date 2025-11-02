# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**3Brains** is a multi-AI/LLM orchestration tool designed to leverage the strengths of different AI models (Claude, Gemini, Grok, and potentially others) simultaneously in the terminal environment.

### Core Concept

- **Claude as Orchestrator**: Claude decides which LLM and which agents to use for specific tasks
- **Agent-Based Architecture**: Agents can delegate tasks to other LLMs (e.g., a Claude agent using Gemini for specific research tasks)
- **Unified Context**: Maintains synchronized context across multiple AI tools via shared configuration files (CLAUDE.md, GEMINI.md, AGENTS.md)
- **Project Awareness**: Works in any directory - empty folders, existing projects, or folders with configuration files
- **Session Continuity**: Resumes conversations from where they left off in existing projects

### Project Goals

This repository (3brains-setup) will produce:
1. An installation script for the 3Brains application
2. A complete multi-AI toolbox that can be installed similar to Claude Code or Gemini CLI
3. Configuration management to keep all AI context files in sync

## Inspiration Source

The `transcript.txt` file contains the full transcript of NetworkChuck's video "You're Using AI WRONG (Terminal vs ChatGPT)" which inspired this project. Key concepts from the video (particularly the second half) include:

- Using multiple terminal-based AI tools simultaneously
- Maintaining project context across AI tools via local markdown files
- Agent-based workflows for fresh context windows
- Keeping AI tools working in the same directory for shared file access

## Development Approach

When building 3Brains, consider these architectural principles:

### Context File Synchronization
- All AI tools should read/write to shared context files
- Primary approach: Use symlinks to keep CLAUDE.md, GEMINI.md, and AGENTS.md in sync (mentioned at timestamp 26:15-26:39 in transcript)
- Alternative: Build sync mechanism into 3Brains orchestrator

### Launch Behavior
The `3brains` command should:
1. Detect if launched in an empty folder, folder with CLAUDE.md, or existing project
2. Initialize appropriate context files if needed
3. Resume previous conversations in existing projects
4. Provide the user with the Claude orchestrator interface

### Multi-AI Coordination
- Allow concurrent sessions with different AI tools in the same directory
- Enable AI tools to invoke each other (e.g., Claude spawning Gemini for research)
- Maintain awareness of what each AI is working on

## Current Status

**Prototype complete!** Working implementation using tmux for multi-pane visualization:
- `3brains.sh` - Full-featured launcher with configuration system
- `3brains-demo.sh` - Simple demonstration launcher
- Tmux-based multi-pane layout for simultaneous AI sessions
- Context file synchronization (symlink or copy mode)
- Status monitoring pane with git integration

Next steps: Installation script, additional AI tool integrations, agent library

## Installation Target

The end goal is for 3Brains to be installable via a simple script, similar to:
```bash
curl -fsSL https://example.com/install-3brains.sh | bash
```

After installation, users should be able to type `3brains` in any directory to launch the tool.

## Key Technical Considerations

### Context Management
- How to efficiently sync context files without divergence
- When to create new agents vs. use existing context
- Managing context window limits across multiple AIs

### AI Tool Integration
- Programmatic interfaces for Claude Code, Gemini CLI, and other tools
- Headless mode execution for agent-to-agent communication
- Authentication/API key management for multiple services

### Session Management
- Tracking conversation history across multiple AI tools
- Git integration for version controlling project decisions
- Session closure/summarization workflows

## Development Workflow

When working on this project:
1. Reference the transcript.txt for conceptual guidance on multi-AI workflows
2. Test integration points with actual Claude Code and Gemini CLI installations
3. Design for extensibility - new AI tools should be easy to add
4. Prioritize user experience - should feel seamless and "magical"

## Implementation Details

### Tmux Multi-Pane Architecture

3Brains uses **tmux** (terminal multiplexer) to create a visual multi-AI environment. This allows users to see multiple AI tools working simultaneously in split panes.

**Current Layout Structure:**
```
┌────────────────────┬──────────────────┐
│                    │                  │
│   Claude Code      │  Gemini CLI      │
│   (Orchestrator)   │  (Research)      │
│                    │                  │
│                    ├──────────────────┤
│                    │                  │
│                    │  Status Monitor  │
│                    │                  │
└────────────────────┴──────────────────┘
```

**Key Files:**
- `3brains.sh` - Production-ready launcher with full configuration system
- `3brains-demo.sh` - Simplified demo for quick testing
- `.3brains-config` - Per-project configuration (auto-generated)

**Features Implemented:**
1. **Session Management**: Creates/attaches to named tmux session "3brains"
2. **Context Initialization**: Auto-creates CLAUDE.md, GEMINI.md, AGENTS.md
3. **Symlink Sync**: Optional symlink mode to keep all .md files perfectly synchronized
4. **Status Monitoring**: Real-time display of files, git status, and shortcuts
5. **Configurable Layouts**: Support for multiple tmux layout styles
6. **Pane Titles**: Labeled panes for easy identification

**Configuration Options:**
- `USE_SYMLINKS` - Enable/disable symlink-based context file sync
- `ENABLED_AIS` - Which AI tools to prepare panes for
- `AUTO_LAUNCH` - Whether to auto-start AI tools or wait for user
- `TMUX_LAYOUT` - Visual layout style (main-vertical, tiled, etc.)

**Usage:**
```bash
# Launch in current directory
./3brains.sh

# Launch in specific project
./3brains.sh /path/to/project

# Reattach to existing session
tmux attach -t 3brains
```

See `README.md` for complete usage documentation.

## Notes

- This project lives at `/home/tlarcombe/projects/3brains-setup`
- The installed 3Brains application will live elsewhere (TBD)
- Configuration should be user-friendly for non-developers while remaining powerful for advanced users
- Tmux is required dependency - installation instructions in README.md
