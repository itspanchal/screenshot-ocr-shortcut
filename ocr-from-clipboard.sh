#!/bin/bash

SHOTS_DIR="$HOME/Pictures/Screenshots"

# 1. Find the newest screenshot file
IMG=$(ls -t "$SHOTS_DIR"/*.png 2>/dev/null | head -n 1)

if [ -z "$IMG" ] || [ ! -s "$IMG" ]; then
    notify-send "OCR Error" "No screenshot found. Take one with Prt Sc first." -i dialog-error
    exit 1
fi

# 2. Extract text from it
EXTRACTED_TEXT=$(tesseract "$IMG" stdout -l eng --psm 6 2>/dev/null)

if [ -z "$(echo "$EXTRACTED_TEXT" | tr -d '[:space:]')" ]; then
    notify-send "OCR Failed" "No readable text found in the screenshot." -i dialog-error
    exit 1
fi

# 3. Put the text on the clipboard
echo -n "$EXTRACTED_TEXT" | wl-copy

# 4. Success
notify-send "OCR Success!" "Text copied. Press Ctrl+V to paste." -i scanner
