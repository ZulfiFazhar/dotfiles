#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share"
SHELL_REPO="https://github.com/ZulfiFazhar/caelestia-topbar.git"
OMDROP_REPO="https://github.com/netmojo-systems/omdrop-plugin.git"

SKIP_CLONE=false
SKIP_BUILD=false
FORCE_BUILD=false

for arg in "$@"; do
    case "$arg" in
        --skip-clone) SKIP_CLONE=true ;;
        --skip-build) SKIP_BUILD=true ;;
        --build) FORCE_BUILD=true ;;
        *)
            echo "Unknown option: $arg" >&2
            echo "Usage: $0 [--build] [--skip-build] [--skip-clone]" >&2
            exit 1
            ;;
    esac
done

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

is_plugin_installed() {
    if command -v caelestia-shell &>/dev/null; then
        return 0
    fi

    local qml_dir
    for qml_dir in /usr/lib/qt6/qml /usr/lib64/qt6/qml /usr/local/lib/qt6/qml /lib/qt6/qml; do
        if [[ -f "$qml_dir/Caelestia/qmldir" ]]; then
            return 0
        fi
    done

    return 1
}

build_plugin() {
    local shell_dir="$CONFIG_DIR/quickshell/caelestia"

    if [[ ! -d "$shell_dir" ]]; then
        echo "Error: $shell_dir not found. Cannot build plugin." >&2
        return 1
    fi

    if ! command -v cmake &>/dev/null || ! command -v ninja &>/dev/null; then
        echo "Warning: cmake or ninja not found. Install build tools first." >&2
        return 0
    fi

    echo "Building Caelestia C++ plugin in $shell_dir..."
    cmake -B "$shell_dir/build" -S "$shell_dir" -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
    cmake --build "$shell_dir/build"

    local sudo_cmd=""
    if [[ $EUID -ne 0 ]]; then
        sudo_cmd="sudo"
    fi

    echo "Installing Caelestia C++ plugin..."
    $sudo_cmd cmake --install "$shell_dir/build"
    echo "C++ plugin installed successfully."
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

# 4. Local bin wrappers & AirDrop scripts
for f in "$DOTFILES_DIR"/bin/*; do
    [[ -f "$f" ]] || continue
    link_path "$f" "$LOCAL_BIN/$(basename "$f")"
done

# 5. AirDrop config, icons, autostart, desktop entry, systemd user unit
mkdir -p "$HOME/Downloads/AirDrop"
link_path "$DOTFILES_DIR/airdrop" "$CONFIG_DIR/airdrop"

for f in "$DOTFILES_DIR"/icons/*; do
    link_path "$f" "$LOCAL_SHARE/icons/$(basename "$f")"
done

for f in "$DOTFILES_DIR"/applications/*; do
    link_path "$f" "$LOCAL_SHARE/applications/$(basename "$f")"
done

for f in "$DOTFILES_DIR"/autostart/*; do
    link_path "$f" "$CONFIG_DIR/autostart/$(basename "$f")"
done

link_path "$DOTFILES_DIR/systemd/user/airdrop-receiver.service" "$CONFIG_DIR/systemd/user/airdrop-receiver.service"
link_path "$DOTFILES_DIR/systemd/user/airdrop-receiver.service.d/10-download-dir.conf" "$CONFIG_DIR/systemd/user/airdrop-receiver.service.d/10-download-dir.conf"

# 6. App configs (fish, foot, zed, spicetify, starship)
link_path "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
link_path "$DOTFILES_DIR/foot" "$CONFIG_DIR/foot"

link_path "$DOTFILES_DIR/fish/config.fish" "$CONFIG_DIR/fish/config.fish"
link_path "$DOTFILES_DIR/fish/functions/fish_greeting.fish" "$CONFIG_DIR/fish/functions/fish_greeting.fish"
link_path "$DOTFILES_DIR/fish/completions/bun.fish" "$CONFIG_DIR/fish/completions/bun.fish"

link_path "$DOTFILES_DIR/zed/settings.json" "$CONFIG_DIR/zed/settings.json"
link_path "$DOTFILES_DIR/zed/keymap.json" "$CONFIG_DIR/zed/keymap.json"
link_path "$DOTFILES_DIR/zed/themes/caelestia.json" "$CONFIG_DIR/zed/themes/caelestia.json"

link_path "$DOTFILES_DIR/spicetify/Themes/caelestia" "$CONFIG_DIR/spicetify/Themes/caelestia"
if [[ ! -e "$CONFIG_DIR/spicetify/config-xpui.ini" ]]; then
    mkdir -p "$CONFIG_DIR/spicetify"
    sed "s|__CONFIG_DIR__|$CONFIG_DIR|g" "$DOTFILES_DIR/spicetify/config-xpui.ini" > "$CONFIG_DIR/spicetify/config-xpui.ini"
fi

# 6. Custom shell & omdrop repos
if [[ "$SKIP_CLONE" == false ]]; then
    if [[ ! -e "$CONFIG_DIR/quickshell/caelestia" ]]; then
        mkdir -p "$CONFIG_DIR/quickshell"
        git clone "$SHELL_REPO" "$CONFIG_DIR/quickshell/caelestia"
    fi

    if [[ ! -e "$LOCAL_SHARE/omdrop-plugin" ]]; then
        mkdir -p "$LOCAL_SHARE"
        git clone "$OMDROP_REPO" "$LOCAL_SHARE/omdrop-plugin"
        git -C "$LOCAL_SHARE/omdrop-plugin" checkout -q cf0ccb4ae5cf560373cac2e5025ad496fcf9b2fa
        if [[ -s "$DOTFILES_DIR/patches/omdrop.patch" ]]; then
            git -C "$LOCAL_SHARE/omdrop-plugin" apply "$DOTFILES_DIR/patches/omdrop.patch"
        fi
    fi
fi

if [[ -e "$LOCAL_SHARE/omdrop-plugin/bin/omdrop" ]]; then
    link_path "$LOCAL_SHARE/omdrop-plugin/bin/omdrop" "$LOCAL_BIN/omdrop"
fi

# Reload user systemd only in real user environment
real_home="$(getent passwd "$(id -u)" | cut -d: -f6 || echo "$HOME")"
if [[ "$HOME" == "$real_home" ]] && command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload >/dev/null 2>&1 || true
fi

echo "Dotfiles linked to $CONFIG_DIR"

# 7. Auto-build CMake C++ plugin when missing or --build passed
if [[ "$SKIP_BUILD" == false ]]; then
    if [[ "$FORCE_BUILD" == true ]] || ! is_plugin_installed; then
        build_plugin
    fi
fi
