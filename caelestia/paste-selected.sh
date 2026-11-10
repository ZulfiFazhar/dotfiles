#!/usr/bin/env bash
set -euo pipefail

item="${1:-}"
if [[ -z "$item" ]]; then
    exit 0
fi

# 1. Decode item into Wayland clipboard
printf '%s\n' "$item" | cliphist decode | wl-copy

# 2. Wait briefly for Quickshell drawer to close and window focus to restore
sleep 0.18

# 3. Get active window class
active_class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty' 2>/dev/null || true)
active_class_lower=$(printf '%s' "$active_class" | tr '[:upper:]' '[:lower:]')

# 4. Trigger paste simulation via ydotool
# Key codes: LeftCtrl = 29, LeftShift = 42, V = 47
case "$active_class_lower" in
    foot|kitty|alacritty|wezterm|xterm)
        # Terminals typically require Ctrl + Shift + V
        ydotool key 29:1 42:1 47:1 47:0 42:0 29:0
        ;;
    *)
        # Standard GUI apps (Termius, Browser, Editor, Chat, etc.) use Ctrl + V
        ydotool key 29:1 47:1 47:0 29:0
        ;;
esac
