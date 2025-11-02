#!/bin/bash

# 3Brains GitHub Upload Script
# This script uploads the 3brains-setup project to GitHub

set -e  # Exit on error

echo "🚀 3Brains GitHub Upload Script"
echo "================================"
echo ""

# Step 1: Check if gh CLI is installed
echo "1. Checking for GitHub CLI (gh)..."
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed."
    echo "Install it with: sudo pacman -S github-cli"
    exit 1
fi
echo "✓ GitHub CLI found"
echo ""

# Step 2: Check if already a git repo
echo "2. Checking git repository status..."
if [ ! -d .git ]; then
    echo "⚠️  Not a git repository. Initializing..."
    git init
    echo "✓ Git repository initialized"
else
    echo "✓ Already a git repository"
fi
echo ""

# Step 3: Create .gitignore if needed
echo "3. Checking for .gitignore..."
if [ ! -f .gitignore ]; then
    echo "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Tmux
.tmux-*

# Config files (may contain personal settings)
.3brains-config

# Logs
*.log

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Backup files
*.bak
*.backup
EOF
    echo "✓ Created .gitignore"
else
    echo "✓ .gitignore already exists"
fi
echo ""

# Step 4: Show what will be staged
echo "4. Files to be committed:"
git status --short
echo ""

# Step 5: Stage all files
echo "5. Staging files..."
git add .
echo "✓ Files staged"
echo ""

# Step 6: Create initial commit
echo "6. Creating commit..."
if git diff --cached --quiet; then
    echo "⚠️  No changes to commit"
else
    git commit -m "3Brains multi-AI orchestrator - initial commit

- Tmux-based multi-pane layout for simultaneous AI sessions
- Support for Claude, Gemini, and Codex
- Context file synchronization (CLAUDE.md, GEMINI.md, AGENTS.md)
- Status monitoring pane with git integration
- Mouse-enabled navigation
- Configurable AI tool integration"
    echo "✓ Commit created"
fi
echo ""

# Step 7: Check if already has remote
echo "7. Checking GitHub remote..."
if git remote | grep -q origin; then
    echo "⚠️  Remote 'origin' already exists:"
    git remote -v
    echo ""
    read -p "Do you want to replace it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
        echo "✓ Removed old remote"
    else
        echo "❌ Keeping existing remote. Skipping repo creation."
        exit 0
    fi
fi
echo ""

# Step 8: Create GitHub repository
echo "8. Creating GitHub repository '3brains-setup'..."
gh repo create 3brains-setup --public --source=. --description="Multi-AI terminal orchestrator using Claude, Gemini, and Codex in tmux" --remote=origin

echo ""
echo "✓ GitHub repository created"
echo ""

# Step 9: Push to GitHub
echo "9. Pushing to GitHub..."
git branch -M main
git push -u origin main
echo "✓ Pushed to GitHub"
echo ""

# Step 10: Show repository URL
echo "================================"
echo "✅ Success! Repository uploaded to GitHub"
echo ""
echo "Repository URL:"
gh repo view --web --json url -q .url
echo ""
echo "To view in browser: gh repo view --web"
echo "================================"
