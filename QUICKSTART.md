# 3Brains Quick Start Guide

## What You've Got

A working multi-AI terminal orchestrator using tmux! 🎉

## Installation (One Command)

```bash
cd /home/tlarcombe/projects/3brains-setup
./install.sh
```

This installs the `3brains` command system-wide.

## Try It Now (Without Installing)

```bash
cd /home/tlarcombe/projects/3brains-setup
./3brains.sh
```

Or try the simpler demo:

```bash
./3brains-demo.sh
```

## What Happens When You Run It

1. **Tmux session starts** named "3brains"
2. **Three panes appear**:
   - Left: Claude Code (orchestrator)
   - Top-right: Gemini CLI (research agent)
   - Bottom-right: Status monitor
3. **Context files created**: CLAUDE.md, GEMINI.md, AGENTS.md
4. **Configuration file**: .3brains-config

## Basic Tmux Controls

| Keys | Action |
|------|--------|
| `Ctrl+b` then `←→↑↓` | Switch panes |
| `Ctrl+b` then `d` | Detach (keeps running) |
| `Ctrl+b` then `z` | Zoom current pane |
| `Ctrl+b` then `[` | Scroll mode (press `q` to exit) |

## Reconnect to Running Session

```bash
tmux attach -t 3brains
# or
tmux a -t 3brains
```

## Stop the Session

```bash
tmux kill-session -t 3brains
```

## Example Workflow

1. **Launch 3brains** in your project directory
   ```bash
   cd ~/my-project
   3brains
   ```

2. **In Claude pane** (left):
   ```
   Research the top 5 Python web frameworks.
   Use Gemini to gather data from multiple sources.
   Create a comparison table.
   ```

3. **Switch to Gemini pane** (top-right):
   ```
   Research Python web frameworks: Django, Flask, FastAPI, etc.
   Focus on performance and ease of use.
   ```

4. **Both AIs work in same directory** - they can see each other's files!

5. **Status pane** (bottom-right) shows:
   - Current files
   - Git status
   - Keyboard shortcuts

## Configuration

Edit `.3brains-config` in your project:

```bash
# Use symlinks (recommended)
USE_SYMLINKS=true

# Auto-launch AI tools
AUTO_LAUNCH=false

# Layout style
TMUX_LAYOUT="main-vertical"
```

## Syncing Context Files

**With symlinks** (recommended):
- GEMINI.md and AGENTS.md point to CLAUDE.md
- Any AI updating the file updates for all
- Set `USE_SYMLINKS=true`

**Without symlinks**:
- Separate files for each AI
- Manually sync if needed:
  ```bash
  cp CLAUDE.md GEMINI.md
  ```

## Testing the Layout

Try this in a test directory:

```bash
mkdir ~/3brains-test
cd ~/3brains-test
/home/tlarcombe/projects/3brains-setup/3brains.sh
```

You'll see:
- Fresh context files created
- Three panes ready to go
- Instructions in each pane

## Troubleshooting

**"tmux not found"**
```bash
# Manjaro/Arch
sudo pacman -S tmux

# Ubuntu
sudo apt-get install tmux

# MacOS
brew install tmux
```

**"claude/gemini not found"**
- Install from official sources
- 3brains will still work, just shows instructions instead of auto-launching

**Panes too small**
- `Ctrl+b` then `z` - zoom current pane
- Change layout in .3brains-config

## Next Steps

1. **Install AI tools** if you haven't:
   - [Claude Code](https://claude.com/product/claude-code)
   - [Gemini CLI](https://ai.google.dev/gemini-api)

2. **Try in a real project**:
   ```bash
   cd ~/my-actual-project
   3brains
   ```

3. **Create custom agents** in Claude for specific tasks

4. **Use Git** to version control your AI conversations:
   ```bash
   git add CLAUDE.md
   git commit -m "AI research session complete"
   ```

## File Overview

| File | Purpose |
|------|---------|
| `3brains.sh` | Full-featured launcher |
| `3brains-demo.sh` | Simple demo version |
| `install.sh` | System-wide installation |
| `README.md` | Complete documentation |
| `CLAUDE.md` | Project context for development |
| `transcript.txt` | NetworkChuck video transcript (inspiration) |

## Support

- Read `README.md` for detailed documentation
- Check `CLAUDE.md` for development details
- Watch NetworkChuck's video (see transcript.txt)

---

**You now have a working multi-AI orchestrator!** 🧠🧠🧠

Try it out and see multiple AI tools working together in one visual environment.
