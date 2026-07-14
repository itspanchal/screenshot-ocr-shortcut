#!/usr/bin/env bash
# Installer for screenshot-ocr-shortcut
# Sets up two GNOME keyboard shortcuts:
#   Ctrl+Shift+H  -> OCR the newest screenshot in ~/Pictures/Screenshots to clipboard
#   Super+Shift+T -> select a screen region, OCR it straight to clipboard
# Tested on Ubuntu 24.04 / GNOME (Wayland). Needs sudo once, to install packages.

set -e
cd "$(dirname "$0")"

echo "==> Installing dependencies (tesseract OCR, screenshot + clipboard tools)..."
sudo apt-get update -qq
sudo apt-get install -y tesseract-ocr gnome-screenshot wl-clipboard libnotify-bin

echo "==> Installing scripts to ~/.local/bin ..."
mkdir -p "$HOME/.local/bin"
install -m 755 ocr-from-clipboard.sh "$HOME/.local/bin/ocr-from-clipboard.sh"
install -m 755 ocr-grab.sh "$HOME/.local/bin/ocr-grab.sh"

echo "==> Registering GNOME keyboard shortcuts..."
python3 - "$HOME" <<'PYEOF'
import ast
import subprocess
import sys

home = sys.argv[1]
BASE = "org.gnome.settings-daemon.plugins.media-keys"
PREFIX = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom"

WANTED = [
    ("OCR newest screenshot to clipboard",
     f"{home}/.local/bin/ocr-from-clipboard.sh", "<Shift><Control>h"),
    ("OCR screen region to clipboard",
     f"{home}/.local/bin/ocr-grab.sh", "<Super><Shift>t"),
]

def gget(schema_path, key):
    return subprocess.check_output(["gsettings", "get"] + schema_path + [key], text=True).strip()

def gset(schema_path, key, value):
    subprocess.check_call(["gsettings", "set"] + schema_path + [key, value])

raw = gget([BASE], "custom-keybindings")
raw = raw.replace("@as ", "")
paths = ast.literal_eval(raw) if raw != "[]" else []

for name, cmd, binding in WANTED:
    # If an existing entry already uses this key combo, update it in place.
    target = None
    for p in paths:
        schema = [f"{BASE}.custom-keybinding:{p}"]
        if gget(schema, "binding").strip("'") == binding:
            target = p
            break
    if target is None:  # otherwise take the next free customN slot
        n = 0
        while f"{PREFIX}{n}/" in paths:
            n += 1
        target = f"{PREFIX}{n}/"
        paths.append(target)
    schema = [f"{BASE}.custom-keybinding:{target}"]
    gset(schema, "name", name)
    gset(schema, "command", cmd)
    gset(schema, "binding", binding)
    print(f"    {binding:22s} -> {cmd}")

gset([BASE], "custom-keybindings", str(paths))
PYEOF

echo
echo "Done! Try it:"
echo "  Super+Shift+T          select any screen region -> its text is copied"
echo "  PrtSc, then Ctrl+Shift+H   OCR the screenshot you just took"
