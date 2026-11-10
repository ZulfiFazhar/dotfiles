#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "$TMP_HOME"' EXIT

# Syntax check shell & python scripts
bash -n "$DOTFILES_DIR/setup.sh"
bash -n "$DOTFILES_DIR/hypr/switch-gpu.sh"
bash -n "$DOTFILES_DIR/caelestia/cheatsheet.sh"
bash -n "$DOTFILES_DIR/caelestia/paste-selected.sh"
for f in "$DOTFILES_DIR"/bin/*; do
    [[ -f "$f" ]] || continue
    if head -n1 "$f" | grep -q "python"; then
        PYTHONPYCACHEPREFIX="$TMP_HOME/pycache" python3 -m py_compile "$f"
    else
        bash -n "$f"
    fi
done

[[ -s "$DOTFILES_DIR/patches/omdrop.patch" ]] || { echo "FAIL: omdrop.patch empty"; exit 1; }

# Prepare fake omdrop-plugin to test omdrop link too
mkdir -p "$TMP_HOME/.local/share/omdrop-plugin/bin"
touch "$TMP_HOME/.local/share/omdrop-plugin/bin/omdrop"

HOME="$TMP_HOME" XDG_CONFIG_HOME="$TMP_HOME/.config" "$DOTFILES_DIR/setup.sh" --skip-clone --skip-build
# Verify idempotency
HOME="$TMP_HOME" XDG_CONFIG_HOME="$TMP_HOME/.config" "$DOTFILES_DIR/setup.sh" --skip-clone --skip-build

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
    "$TMP_HOME/.config/uwsm/env-hyprland" \
    "$TMP_HOME/.config/airdrop" \
    "$TMP_HOME/.config/autostart/omdrop-tray.desktop" \
    "$TMP_HOME/.config/systemd/user/airdrop-receiver.service" \
    "$TMP_HOME/.config/systemd/user/airdrop-receiver.service.d/10-download-dir.conf" \
    "$TMP_HOME/.local/bin/caelestia" \
    "$TMP_HOME/.local/bin/caelestia-restart" \
    "$TMP_HOME/.local/bin/omdrop" \
    "$TMP_HOME/.local/bin/omdrop-tray" \
    "$TMP_HOME/.local/bin/omdrop-toggle" \
    "$TMP_HOME/.local/bin/omdrop-gui-action" \
    "$TMP_HOME/.local/bin/omdrop-send-gui" \
    "$TMP_HOME/.local/bin/omdrop-quick-share" \
    "$TMP_HOME/.local/share/icons/omdrop-radio.svg" \
    "$TMP_HOME/.local/share/applications/netmojo.omdrop-links.desktop"
do
    [[ -L "$target" && -e "$target" ]] || { echo "FAIL: broken link $target"; exit 1; }
done

[[ -d "$TMP_HOME/Downloads/AirDrop" ]] || { echo "FAIL: Downloads/AirDrop not created"; exit 1; }

# Verify CMake build invocation using mock binaries
mkdir -p "$TMP_HOME/bin" "$TMP_HOME/.config/quickshell/caelestia"
LOG_FILE="$TMP_HOME/cmake.log"

cat > "$TMP_HOME/bin/cmake" << EOF
#!/usr/bin/env bash
echo "cmake \$*" >> "$LOG_FILE"
EOF
cat > "$TMP_HOME/bin/ninja" << 'EOF'
#!/usr/bin/env bash
exit 0
EOF
cat > "$TMP_HOME/bin/sudo" << 'EOF'
#!/usr/bin/env bash
exec "$@"
EOF
chmod +x "$TMP_HOME/bin/cmake" "$TMP_HOME/bin/ninja" "$TMP_HOME/bin/sudo"

HOME="$TMP_HOME" XDG_CONFIG_HOME="$TMP_HOME/.config" PATH="$TMP_HOME/bin:$PATH" \
    "$DOTFILES_DIR/setup.sh" --skip-clone --build

grep -q -- "-G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/" "$LOG_FILE"
grep -q -- "--build $TMP_HOME/.config/quickshell/caelestia/build" "$LOG_FILE"
grep -q -- "--install $TMP_HOME/.config/quickshell/caelestia/build" "$LOG_FILE"

echo "PASS: all scripts, symlinks, AirDrop config, and CMake build flow verified"
