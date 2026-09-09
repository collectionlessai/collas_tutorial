#!/bin/bash

# Detect the name of the folder containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FOLDER_NAME="$(basename "$SCRIPT_DIR")"
DEST="../unaiverse-examples/worlds/$FOLDER_NAME"  # Relative to the current script dir (SCRIPT_DIR above)

# Guard: fail loudly if the destination folder does not exist
[ -d "$SCRIPT_DIR/$DEST" ] || { echo "Destination $DEST does not exist."; exit 1; }

read -p "This script will copy data from this folder to the one of the public repo unaiverse-examples ($DEST), then IT WILL COMMIT AND PUSH THE PUBLIC REPO unaiverse-examples! Continue? [y/n] " -n 1 -r
echo # Move to a new line after keypress

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Proceeding..."
    rsync -av --exclude='__pycache__/' --exclude='stats/' --exclude='.DS_Store' --exclude='synch_other_repo.sh' "$SCRIPT_DIR/" "$SCRIPT_DIR/$DEST"
    cd "$SCRIPT_DIR/$DEST" || exit
    git add -A .
    git commit -m "automatically updated"
    git pull
    git push
else
    echo "Exiting."
    exit 1
fi
