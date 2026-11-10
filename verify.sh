#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT

bash -n "$DOTFILES_DIR/setup.sh"
bash -n "$DOTFILES_DIR/hypr/switch-gpu.sh"
bash -n "$DOTFILES_DIR/caelestia/cheatsheet.sh"
bash -n "$DOTFILES_DIR/caelestia/paste-selected.sh"

HOME="$TMP_HOME" XDG_CONFIG_HOME="$TMP_HOME/.config" "$DOTFILES_DIR/setup.sh" --skip-clone
# Verify idempotency
HOME="$TMP_HOME" XDG_CONFIG_HOME="$TMP_HOME/.config" "$DOTFILES_DIR/setup.sh" --skip-clone

for target in \
    "$TMP_HOME/.config/caelestia" \
    "$TMP_HOME/.config/hypr/hyprland.lua" \
    "$TMP_HOME/.config/hypr/hyprland-caelestia.lua" \
    "$TMP_HOME/.config/hypr/hyprland" \
    "$TMP_HOME/.config/hypr/utils" \
    "$TMP_HOME/.config/hypr/variables.lua" \
    "$TMP_HOME/.config/hypr/xdph.conf" \
    "$TMP_HOME/.config/hypr/switch-gpu.sh" \
    "$TMP_HOME/.config/hypr/scheme/default.lua" \
    "$TMP_HOME/.config/uwsm/env" \
    "$TMP_HOME/.config/uwsm/env-hyprland"
do
    [[ -L "$target" && -e "$target" ]] || { echo "FAIL: broken link $target"; exit 1; }
done

echo "PASS: all scripts and symlinks verified"
