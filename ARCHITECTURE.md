# 3Brains Architecture

**Multi-AI Terminal Orchestrator with Ensemble Learning**

---

## Architecture Overview

3Brains uses a 4-pane tmux layout to orchestrate multiple AI systems simultaneously, each specialized for different tasks.

```
┌─────────────────────┬─────────────────┐
│                     │  Gemini         │
│  Claude             │  (Agent Mgr)    │
│  (Orchestrator)     │                 │
│                     ├─────────────────┤
│                     │  Ollama         │
│                     │  (Local LLM)    │
│                     ├─────────────────┤
│                     │  Status         │
│                     │  Monitor        │
└─────────────────────┴─────────────────┘
```

---

## Pane Roles

### Pane 0: Claude (Orchestrator) - LEFT PANE
**Tool:** Claude Code
**Role:** Main orchestrator and task coordinator
**Responsibilities:**
- Delegates tasks to appropriate AI systems
- Manages overall workflow
- Creates scripts and files
- Coordinates multi-AI operations
- Maintains project context

**Example Tasks:**
- "Create a GitHub upload script"
- "Orchestrate code quality improvements"
- "Manage file operations and git commits"

---

### Pane 1: Gemini (Agent Manager) - TOP RIGHT
**Tool:** Gemini CLI
**Role:** Agent creation and management
**Responsibilities:**
- Creates specialized agents for specific tasks
- Manages agent lifecycle
- Handles complex multi-step workflows
- Provides Google Search integration
- Task automation and scripting

**Example Tasks:**
- "Create an agent to monitor log files"
- "Build a deployment automation agent"
- "Generate test suites for the codebase"

---

### Pane 2: Ollama (Local LLM Research) - MIDDLE RIGHT
**Tool:** Ollama (https://ollama.ai) - Local LLM platform
**Role:** Research and local AI queries
**Responsibilities:**
- Runs local LLMs for research tasks
- Provides fast, offline AI responses
- Handles research questions without API costs
- Privacy-focused (data never leaves your machine)
- Supports multiple models (qwen3, llama3.1, mistral, etc.)

**Available Models:** See `ollama list`
- Response time: ~5-15 seconds (depending on model)
- No API costs or rate limits
- Fully local and private

**Example Tasks:**
- "What are the best practices for bash scripting?"
- "Compare different testing frameworks"
- "Research security implications of X"

**API Usage:**
```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen3", "prompt": "Your question here", "stream": false}'
```

**Interactive CLI:**
```bash
./ollama-cli.sh
```

**Note:** For production use, you can also integrate custom ensemble APIs (like multi-LLM voting systems) by modifying the API endpoint.

---

### Pane 3: Status Monitor - BOTTOM RIGHT
**Tool:** Custom bash script with `watch`
**Role:** Real-time project monitoring
**Responsibilities:**
- Display AI agent status
- Show project files and sizes
- Monitor git status
- Display tmux shortcuts
- Track recent activity
- Auto-refresh every 2 seconds

**Status Script:**
```bash
watch -c -t -n 2 ./.3brains-status.sh
```

---

## Workflow Examples

### Example 1: Research + Implementation
**Task:** "Add linting to this project"

1. **Claude** (Orchestrator): Receives request, delegates research
2. **Ollama** (Local LLM): Researches best linting tools (shellcheck, shfmt)
3. **Claude** (Orchestrator): Captures results, creates implementation plan
4. **Gemini** (Agent Manager): Creates automation agent for CI/CD integration
5. **Claude** (Orchestrator): Implements changes, commits to git

**Result:** Research-backed implementation with automated testing

---

### Example 2: Multi-AI Code Review
**Task:** "Review and improve upload-to-github.sh"

1. **Ollama**: Research best practices for bash error handling
2. **Claude**: Analyze current script against research
3. **Gemini**: Create testing agent for script validation
4. **Claude**: Apply improvements and document changes

**Result:** Production-ready, well-tested script

---

### Example 3: Agent-Based Automation
**Task:** "Create a backup automation system"

1. **Claude**: Define requirements and architecture
2. **Ollama**: Research backup strategies and tools
3. **Gemini**: Create backup agent with scheduling
4. **Claude**: Integrate agent, test, and deploy

**Result:** Automated backup system with monitoring

---

## Key Features

### 1. Local AI Processing (Ollama)
- **Problem:** API costs and privacy concerns with cloud LLMs
- **Solution:** Run powerful LLMs locally on your machine
- **Benefit:** No API costs, complete privacy, offline capability

### 2. Specialization
- **Problem:** One AI trying to do everything
- **Solution:** Each AI has a specific role and strengths
- **Benefit:** Better results, faster execution, clearer workflows

### 3. Context Synchronization
- **Problem:** Multiple AIs losing track of project state
- **Solution:** Shared context files (CLAUDE.md, GEMINI.md, AGENTS.md)
- **Benefit:** All AIs work from same understanding

### 4. Visual Monitoring
- **Problem:** Can't see what each AI is doing
- **Solution:** Tmux multi-pane layout with status monitor
- **Benefit:** Real-time visibility into all operations

### 5. Session Persistence
- **Problem:** Losing work when closing terminal
- **Solution:** Tmux sessions persist in background
- **Benefit:** Resume work anytime with `tmux attach -t 3brains`

---

## Technical Implementation

### Context File Synchronization

All AI tools share access to project context:
- **CLAUDE.md** - Main project context
- **GEMINI.md** - Agent definitions and tasks (symlinked or copied)
- **AGENTS.md** - Agent library (symlinked or copied)

**Sync Mode Options:**
1. **Symlink Mode** (default): All .md files point to CLAUDE.md
2. **Copy Mode**: Independent files, manually synced

### Session Management

**Launch 3Brains:**
```bash
./3brains.sh
```

**Reattach to session:**
```bash
tmux attach -t 3brains
```

**Detach from session:**
```
Ctrl+b → d
```

### Navigation

**Mouse Mode (Enabled):**
- Click on pane to focus
- Scroll to view history
- Drag borders to resize

**Keyboard Mode:**
- `Ctrl+b` then arrow keys: Switch panes
- `Ctrl+b` then `z`: Zoom/unzoom pane
- `Ctrl+b` then `q` then `0-3`: Jump to specific pane

---

## Configuration

### 3Brains Config: `.3brains-config`

```bash
# Use symlinks to keep context files in sync
USE_SYMLINKS=true

# AI Tools to launch (space-separated)
ENABLED_AIS="claude gemini ollama"

# Auto-launch AI tools on session start
AUTO_LAUNCH=false

# Layout: main-vertical, main-horizontal, tiled
TMUX_LAYOUT="main-vertical"

# Pane titles
PANE_CLAUDE_TITLE="Claude (Orchestrator)"
PANE_GEMINI_TITLE="Gemini (Agent Manager)"
PANE_OLLAMA_TITLE="Ollama (Local LLM)"
PANE_STATUS_TITLE="Status Monitor"
```

---

## Advantages Over Single AI

| Aspect | Single AI | 3Brains |
|--------|-----------|---------|
| **Accuracy** | Can hallucinate | Validated by 7 LLMs |
| **Specialization** | Generalist | Task-specific experts |
| **Context** | Limited window | Shared across all AIs |
| **Workflow** | Linear | Parallel + orchestrated |
| **Visibility** | One chat | Multi-pane monitoring |
| **Agents** | Manual | Automated by Gemini |
| **Research** | Single source | Ensemble consensus |

---

## Future Enhancements

### Planned Features
- [ ] Add Grok integration for additional perspective
- [ ] Implement cross-AI conversation (AIs talking to each other)
- [ ] Add task queue system for batch operations
- [ ] Create agent library with pre-built specialists
- [ ] Add voice input/output for hands-free operation
- [ ] Implement session recording and playback
- [ ] Add web dashboard for remote monitoring

### Potential Integrations
- **Aider** - Git-aware code editing
- **GitHub Copilot CLI** - Command suggestions
- **Local Ollama models** - Offline fallback
- **Custom APIs** - Domain-specific AI services

---

## Cost Analysis

### Per-Query Costs

| AI Tool | Cost Model | Typical Cost |
|---------|------------|--------------|
| **Claude** | Anthropic API | ~$0.01-0.05/query |
| **Gemini** | Google API | Free tier, then ~$0.01/query |
| **Ollama** | Local (open source) | Free (hardware only) |
| **Tmux/Scripts** | Local | Free |

### Value Proposition
- **Higher quality** answers justify slightly higher costs
- **Reduced errors** save debugging time
- **Parallel workflows** increase productivity
- **Ensemble validation** prevents costly mistakes

---

## Best Practices

### When to Use Each AI

**Use Claude when:**
- Orchestrating complex workflows
- Creating files and scripts
- Managing git operations
- Coordinating multiple tasks

**Use Gemini when:**
- Creating specialized agents
- Automating repetitive tasks
- Need Google Search integration
- Building test suites

**Use Ollama when:**
- Researching best practices offline
- Need fast local responses
- Privacy is a concern
- Want to avoid API costs

### Workflow Tips

1. **Start with Claude** - Define the overall task
2. **Delegate research to Ollama** - Get local AI assistance
3. **Use Gemini for agents** - Automate complex sub-tasks
4. **Monitor via Status pane** - Track progress in real-time
5. **Capture results** - Save AI outputs to files for reference

---

## Troubleshooting

### Ollama Not Responding
**Symptom:** API request fails
**Solution:** Check if Ollama is running (`systemctl status ollama`)

### Pane Not Responding
**Symptom:** AI pane frozen
**Solution:** `Ctrl+C` to cancel, restart AI tool

### Context Out of Sync
**Symptom:** AIs have different project understanding
**Solution:** Use symlink mode or manually sync .md files

### Session Lost
**Symptom:** Can't find tmux session
**Solution:** `tmux ls` to list, `tmux attach -t 3brains` to reconnect

---

## Security Considerations

### API Keys
- Claude: Managed by `claude` CLI
- Gemini: Managed by `gemini` CLI
- Ollama: No API keys needed (fully local)

### Data Privacy
- **Claude/Gemini:** Sent to external APIs
- **Ollama:** Completely local (highest privacy)
- **Local scripts:** Never leave machine

### Best Practices
- Don't paste sensitive credentials in AI prompts
- Review auto-generated scripts before execution
- Use `.gitignore` to exclude sensitive files
- Commit context files but not API keys

---

## Credits

**Architecture:** Tony Larcombe
**Inspiration:** NetworkChuck's "Terminal vs ChatGPT" video
**AI Tools:**
- Claude Code (Anthropic)
- Gemini CLI (Google)
- Ollama (Open source local LLM platform)

**Special Thanks:**
- Tmux project for powerful terminal multiplexing
- Open source community for bash scripting best practices

---

**Version:** 1.0
**Last Updated:** 2025-11-02
**License:** MIT (see LICENSE file)
