#!/bin/bash

# 1. Environment Setup
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=${HOME:-/home/$(whoami)}

# 2. Paths (dynamically locates repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/../Erika" ]; then
    SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [ -d "$SCRIPT_DIR/Erika" ]; then
    SERVER_DIR="$SCRIPT_DIR"
else
    SERVER_DIR="$HOME/Documents/MinecraftServers"
fi

LOG="$HOME/Documents/mc-backup.log"

cd "$SERVER_DIR" || exit 1

echo "==== Backup started $(date) ====" >> "$LOG"

# 3. Flush live server data from memory to disk
# If servers are running inside tmux sessions, tell them to flush all chunks
if command -v tmux >/dev/null 2>&1; then
    for session in erika forever; do
        if tmux has-session -t "$session" 2>/dev/null; then
            echo "Flushing world data for tmux session: $session" >> "$LOG"
            tmux send-keys -t "$session" "save-all flush" C-m
        fi
    done
    # Give the server processes time to finish writing chunks to disk
    sleep 5
fi

# 4. Stage tracked changes (respects updated .gitignore)
git add . 2>> "$LOG"

# 5. Git Operations
if ! git diff-index --quiet HEAD --; then
    git commit -m "Auto backup $(date '+%Y-%m-%d %H:%M')" >> "$LOG" 2>&1
    git push origin main >> "$LOG" 2>&1
else
    echo "No changes detected. Skipping push." >> "$LOG"
fi

echo "==== Backup finished $(date) ====" >> "$LOG"
echo "------------------------------------" >> "$LOG"
