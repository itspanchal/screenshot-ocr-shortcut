# Screenshot OCR Shortcut ⌨️→📋

Copy text out of anything on your screen with a keyboard shortcut.
Two workflows, both fully local (Tesseract OCR — no cloud, no account):

| Shortcut | What it does |
|---|---|
| **Super+Shift+T** | Screen dims → drag-select any region → its text is OCR'd and copied to your clipboard instantly |
| **Ctrl+Shift+H** | OCRs the **newest screenshot** in `~/Pictures/Screenshots` and copies all its text (take one with `PrtSc` first) |

A notification confirms what was copied. Then just `Ctrl+V` anywhere.

## Install

```bash
git clone https://github.com/itspanchal/screenshot-ocr-shortcut.git
cd screenshot-ocr-shortcut
./install.sh
```

The installer:

1. Installs `tesseract-ocr`, `gnome-screenshot`, `wl-clipboard`, `libnotify-bin`
2. Copies the two scripts to `~/.local/bin/`
3. Registers both GNOME keyboard shortcuts — **without touching your existing
   custom shortcuts** (if a shortcut already uses the same key combo, it is
   updated in place; otherwise a new one is added)

Requirements: Linux with GNOME (built for Ubuntu 24.04 on Wayland).

## The scripts

### `ocr-grab.sh` (Super+Shift+T)

Region-select OCR: `gnome-screenshot -a` lets you drag-select part of the
screen, Tesseract extracts the text, `wl-copy` puts it on the clipboard, and a
notification shows a preview. Works on anything visible — text in images,
videos, error dialogs, remote-desktop windows.

### `ocr-from-clipboard.sh` (Ctrl+Shift+H)

Finds the most recent `.png` in `~/Pictures/Screenshots`, OCRs the whole
image, and copies the text. Handy right after taking a screenshot with `PrtSc`.

## Set up shortcuts manually (optional)

If you'd rather not run the installer, add them in
**Settings → Keyboard → View and Customize Shortcuts → Custom Shortcuts**:

| Name | Command | Shortcut |
|---|---|---|
| OCR screen region | `/home/YOU/.local/bin/ocr-grab.sh` | `Super+Shift+T` |
| OCR newest screenshot | `/home/YOU/.local/bin/ocr-from-clipboard.sh` | `Ctrl+Shift+H` |

## Other languages

```bash
sudo apt install tesseract-ocr-hin   # example: Hindi
```

Then edit the `tesseract` line in the scripts to use `-l eng+hin`.

## Troubleshooting

- **Nothing gets copied** — run the script from a terminal to see errors:
  `~/.local/bin/ocr-grab.sh`. Most common cause: `tesseract` not installed.
- **"No screenshot found" (Ctrl+Shift+H)** — that script only looks in
  `~/Pictures/Screenshots`; take a screenshot with `PrtSc` first.
- **Poor OCR results** — OCR quality depends on text size and contrast;
  zoom in before capturing if the text is tiny.

## Uninstall

```bash
rm ~/.local/bin/ocr-grab.sh ~/.local/bin/ocr-from-clipboard.sh
```

Then remove the two shortcuts in **Settings → Keyboard → Custom Shortcuts**.

## Related project

Want to open a **saved screenshot** and select just the lines you need, like
selecting real text? Check out the companion app:
[copy-text-from-image](https://github.com/itspanchal/copy-text-from-image).

## License

MIT
