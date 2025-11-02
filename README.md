# 3Brains - Multi-AI Terminal Orchestrator

**3Brains** enables you to use multiple AI tools (Claude, Gemini, Grok, etc.) simultaneously in your terminal with synchronized context.

## Features

- 🧠 **Multi-AI Sessions**: Run Claude, Gemini, and other AI tools side-by-side
- 🔄 **Synchronized Context**: Keep CLAUDE.md, GEMINI.md, and AGENTS.md in sync automatically
- 📊 **Visual Layout**: See all AI tools working together using tmux multi-pane layout
- 🎯 **Claude as Orchestrator**: Claude decides which AI and which agents to use
- 🔗 **Shared File Access**: All AIs work in the same directory with access to the same files
- 📝 **Session Continuity**: Resume conversations from where you left off

## Installation

### Prerequisites

- `tmux` (terminal multiplexer)
- At least one AI CLI tool installed:
  - [Claude Code](https://claude.com/product/claude-code)
  - [Gemini CLI](https://ai.google.dev/gemini-api)
  - [OpenCode](https://opencode.ai/) (optional)

Install tmux:
```bash
# Ubuntu/Debian
sudo apt-get install tmux

# MacOS
brew install tmux

# Manjaro/Arch
sudo pacman -S tmux
```

### Quick Start

1. Clone or download this repository
2. Run the 3brains launcher:

```bash
# Navigate to any project directory
cd ~/my-project

# Launch 3brains from this repo
/path/to/3brains-setup/3brains.sh

# Or copy the script to your PATH
cp /path/to/3brains-setup/3brains.sh ~/.local/bin/3brains
chmod +x ~/.local/bin/3brains
3brains
```

## Usage

### Basic Usage

```bash
# Launch in current directory
./3brains.sh

# Launch in specific directory
./3brains.sh /path/to/project
```

### Layout

The tmux session is split into 3 panes:

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

### Tmux Keyboard Shortcuts

- `Ctrl+b` then `arrow key` - Switch between panes
- `Ctrl+b` then `d` - Detach from session (keeps running)
- `Ctrl+b` then `[` - Scroll mode (press `q` to exit)
- `Ctrl+b` then `z` - Zoom/unzoom current pane (fullscreen toggle)
- `Ctrl+b` then `x` - Kill current pane
- `Ctrl+b` then `&` - Kill entire window

### Reattaching to Session

If you detach or close your terminal:

```bash
tmux attach-session -t 3brains
# or simply
tmux a -t 3brains
```

### Killing the Session

```bash
tmux kill-session -t 3brains
```

## Configuration

On first run, 3brains creates a `.3brains-config` file in your project directory:

```bash
# Use symlinks to keep context files in sync (recommended)
USE_SYMLINKS=true

# AI Tools to launch
ENABLED_AIS="claude gemini"

# Auto-launch AI tools on session start
AUTO_LAUNCH=false

# Layout: main-vertical, main-horizontal, tiled, even-vertical
TMUX_LAYOUT="main-vertical"

# Customize pane titles
PANE_CLAUDE_TITLE="Claude (Orchestrator)"
PANE_GEMINI_TITLE="Gemini (Research)"
PANE_STATUS_TITLE="Status/Monitor"
```

### Context File Synchronization

3Brains keeps your AI context files synchronized:

**Option 1: Symlinks (Recommended)**
- `GEMINI.md` and `AGENTS.md` are symlinks to `CLAUDE.md`
- Any AI updating the file updates it for all tools
- No divergence possible
- Set `USE_SYMLINKS=true` in config

**Option 2: File Copies**
- Separate files are created
- More control but can diverge
- Set `USE_SYMLINKS=false` in config

## Workflow Examples

### Example 1: Research and Writing

In Claude pane:
```
Create a research plan for AI security best practices.
Use the Gemini agent to research the top 10 sources.
```

Claude will delegate research to Gemini (in the adjacent pane), then compile results.

### Example 2: Multi-AI Comparison

Run different prompts in different panes to compare:
- Claude pane: "Write a technical explanation of transformers"
- Gemini pane: "Write a technical explanation of transformers"
- Compare outputs side-by-side

### Example 3: Agent Workflows

Claude can create agents that use other AIs:
```
Create an agent that uses Gemini in headless mode for web research.
Use: gemini -p "your prompt here"
```

## Project Structure

```
3brains-setup/
├── 3brains.sh          # Main launcher (advanced)
├── 3brains-demo.sh     # Simple demo launcher
├── README.md           # This file
├── CLAUDE.md           # Project context for 3Brains development
├── transcript.txt      # NetworkChuck video transcript (inspiration)
└── .3brains-config     # Auto-generated configuration
```

## Advanced Features

### Custom Layouts

Edit `.3brains-config` and change `TMUX_LAYOUT`:
- `main-vertical` - Large left pane, split right panes (default)
- `main-horizontal` - Large top pane, split bottom panes
- `tiled` - All panes evenly distributed
- `even-vertical` - All panes equal height
- `even-horizontal` - All panes equal width

### Auto-Launch AI Tools

Set `AUTO_LAUNCH=true` in config to automatically start AI tools when session launches.

### Adding More Panes

Manually add panes in tmux:
```bash
# Split current pane horizontally
Ctrl+b then "

# Split current pane vertically
Ctrl+b then %
```

### Git Integration

3Brains works great with Git. The status pane shows:
- Modified files
- Recent commits
- Current branch

Commit your AI conversations:
```bash
git add CLAUDE.md GEMINI.md
git commit -m "AI session: completed research phase"
```

## Inspiration

3Brains is inspired by [NetworkChuck's video](https://www.youtube.com/watch?v=XXXXX) on using AI in the terminal. See `transcript.txt` for the full transcript.

Key concepts:
- Break free from browser-based AI limitations
- Own your context (files on your hard drive)
- Use the best AI for each specific task
- Keep context across sessions using .md files

## Troubleshooting

### "tmux: command not found"
Install tmux using your package manager (see Installation section)

### "claude: command not found" or "gemini: command not found"
Install the AI CLI tools. The script will warn you but still create the session.

### Panes are too small
- Zoom a pane: `Ctrl+b` then `z`
- Resize panes: `Ctrl+b` then hold `Ctrl` and use arrow keys
- Change layout in config: set `TMUX_LAYOUT="main-horizontal"`

### Context files out of sync
If not using symlinks, manually sync:
```bash
cp CLAUDE.md GEMINI.md
cp CLAUDE.md AGENTS.md
```

Or enable symlinks in `.3brains-config`

## Roadmap

- [ ] Auto-install script (`curl | bash`)
- [ ] Session templates for different workflows
- [ ] AI agent library
- [ ] Context synchronization daemon
- [ ] Integration with more AI tools (Codex, Grok, etc.)
- [ ] Web dashboard for monitoring sessions
- [ ] MCP (Model Context Protocol) integration

## Contributing

This is an early-stage project. Contributions welcome!

## License

MIT License - See LICENSE file (TBD)

## Credits

- Inspired by [NetworkChuck](https://www.youtube.com/@NetworkChuck)
- Uses [Claude Code](https://claude.com/code) by Anthropic
- Uses [Gemini CLI](https://ai.google.dev/gemini-api) by Google
- Built with [tmux](https://github.com/tmux/tmux)
