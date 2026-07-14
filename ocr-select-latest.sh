#!/usr/bin/env bash
# Open the newest screenshot in the "Copy Text from Image" selector (ocr-textview),
# so you can drag-select exactly the lines you want to copy.

SHOTS_DIR="$HOME/Pictures/Screenshots"

IMG=$(ls -t "$SHOTS_DIR"/*.png "$SHOTS_DIR"/*.jpg "$SHOTS_DIR"/*.webp 2>/dev/null | head -n 1)

if [ -z "$IMG" ]; then
    notify-send "OCR" "No screenshot found in $SHOTS_DIR. Take one with PrtSc first." -i dialog-error
    exit 1
fi

exec "$HOME/.local/bin/ocr-textview" "$IMG"
