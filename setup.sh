#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
SHELL_REPO="https://github.com/ZulfiFazhar/caelestia-topbar.git"

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

# 4. Custom shell repo
if [[ "$SKIP_CLONE" == false && ! -e "$CONFIG_DIR/quickshell/caelestia" ]]; then
    mkdir -p "$CONFIG_DIR/quickshell"
    git clone "$SHELL_REPO" "$CONFIG_DIR/quickshell/caelestia"
fi

echo "Dotfiles linked to $CONFIG_DIR"

# 5. Auto-build CMake C++ plugin when missing or --build passed
if [[ "$SKIP_BUILD" == false ]]; then
    if [[ "$FORCE_BUILD" == true ]] || ! is_plugin_installed; then
        build_plugin
    fi
fi
