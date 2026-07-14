#!/usr/bin/env bash
# ocr-grab — select a screen region, OCR the text in it, copy to clipboard.
# Requires: gnome-screenshot, tesseract, wl-copy, notify-send

set -u

TMP="$(mktemp --suffix=.png)"
trap 'rm -f "$TMP"' EXIT

# Area-select screenshot (works on GNOME Wayland via the Shell screenshot API)
gnome-screenshot -a -f "$TMP" 2>/dev/null

# User pressed Esc or capture failed
if [ ! -s "$TMP" ]; then
    exit 0
fi

# OCR: psm 6 assumes a uniform block of text, good for screenshots
TEXT="$(tesseract "$TMP" stdout --psm 6 2>/dev/null)"

# Trim leading/trailing blank lines
TEXT="$(printf '%s' "$TEXT" | sed -e '/./,$!d' | sed -e ':a' -e '/^\n*$/{$d;N;ba' -e '}')"

if [ -z "$TEXT" ]; then
    notify-send -i edit-copy "OCR" "No text found in selection"
    exit 0
fi

printf '%s' "$TEXT" | wl-copy

# Show a short preview in the notification
PREVIEW="$(printf '%s' "$TEXT" | head -c 120)"
notify-send -i edit-copy "Text copied to clipboard" "$PREVIEW"
