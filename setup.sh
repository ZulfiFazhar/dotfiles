#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
SHELL_REPO="https://github.com/ZulfiFazhar/caelestia-topbar.git"
SKIP_CLONE=false

if [[ "${1:-}" == "--skip-clone" ]]; then
    SKIP_CLONE=true
fi

link_path() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        return 0
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        mv "$dst" "${dst}.bak-$(date +%Y%m%d%H%M%S)"
    fi

    ln -s "$src" "$dst"
}

# 1. Caelestia user config
link_path "$DOTFILES_DIR/caelestia" "$CONFIG_DIR/caelestia"

# 2. Hyprland Lua config
mkdir -p "$CONFIG_DIR/hypr/scheme"
link_path "$DOTFILES_DIR/hypr/hyprland-caelestia.lua" "$CONFIG_DIR/hypr/hyprland-caelestia.lua"
link_path "$CONFIG_DIR/hypr/hyprland-caelestia.lua" "$CONFIG_DIR/hypr/hyprland.lua"
link_path "$DOTFILES_DIR/hypr/hyprland" "$CONFIG_DIR/hypr/hyprland"
link_path "$DOTFILES_DIR/hypr/utils" "$CONFIG_DIR/hypr/utils"
link_path "$DOTFILES_DIR/hypr/variables.lua" "$CONFIG_DIR/hypr/variables.lua"
link_path "$DOTFILES_DIR/hypr/xdph.conf" "$CONFIG_DIR/hypr/xdph.conf"
link_path "$DOTFILES_DIR/hypr/switch-gpu.sh" "$CONFIG_DIR/hypr/switch-gpu.sh"
link_path "$DOTFILES_DIR/hypr/scheme/default.lua" "$CONFIG_DIR/hypr/scheme/default.lua"

# 3. UWSM environment
link_path "$DOTFILES_DIR/uwsm/env" "$CONFIG_DIR/uwsm/env"
link_path "$DOTFILES_DIR/uwsm/env-hyprland" "$CONFIG_DIR/uwsm/env-hyprland"

# 4. Custom shell repo
if [[ "$SKIP_CLONE" == false && ! -e "$CONFIG_DIR/quickshell/caelestia" ]]; then
    mkdir -p "$CONFIG_DIR/quickshell"
    git clone "$SHELL_REPO" "$CONFIG_DIR/quickshell/caelestia"
fi

echo "Dotfiles linked to $CONFIG_DIR"
