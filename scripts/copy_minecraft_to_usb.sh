#!/usr/bin/env bash
set -euo pipefail

# Portable source directory (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/../Erika" ]; then
    SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    SRC="/home/alex/Documents/MinecraftServers"
fi

DEST="/media/alex/usb/MinecraftServers"
LOG="${HOME:-/home/alex}/backup_logs/minecraft_backup.log"

mkdir -p "$(dirname "$LOG")"

# Check if USB is mounted
if ! mountpoint -q /media/alex/usb; then
    echo "$(date) - USB not mounted at /media/alex/usb, skipping backup." >> "$LOG"
    exit 1
fi

mkdir -p "$DEST"

# Do the backup
rsync -a --no-owner --no-group --no-perms "$SRC"/ "$DEST"/ >> "$LOG" 2>&1

echo "$(date) - Backup completed successfully." >> "$LOG"
