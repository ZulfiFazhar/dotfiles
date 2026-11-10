#!/usr/bin/env bash
# switch-gpu.sh: Toggle or set Hyprland primary GPU between NVIDIA (performance/HDMI) and AMD (battery)

HYPR_DIR="$HOME/.config/hypr"
UWSM_ENV="$HOME/.config/uwsm/env-hyprland"
ENV_LUA="$HYPR_DIR/hyprland/env.lua"

# Ensure symlinks exist
mkdir -p "$HYPR_DIR"
ln -sf /dev/dri/by-path/pci-0000:01:00.0-card "$HYPR_DIR/card-nvidia"
ln -sf /dev/dri/by-path/pci-0000:06:00.0-card "$HYPR_DIR/card-amd"

set_nvidia() {
    cat << 'EOF' > "$UWSM_ENV"
# Aquamarine / Multi-GPU configuration
# RTX 2050 (card-nvidia) as primary renderer drives HDMI-A-1 directly with zero-copy scanout
export AQ_DRM_DEVICES="$HOME/.config/hypr/card-nvidia:$HOME/.config/hypr/card-amd"
export AQ_FORCE_LINEAR_BLIT=0
export MOZ_ENABLE_WAYLAND=1
EOF

    sed -i "s|hl\.env(\"AQ_DRM_DEVICES\",.*)|hl.env(\"AQ_DRM_DEVICES\", \"$HYPR_DIR/card-nvidia:$HYPR_DIR/card-amd\")|" "$ENV_LUA"
    echo "✅ Mode diatur ke: NVIDIA Primary (Performance & Second Monitor Smooth)"
    echo "ℹ️  Perubahan akan aktif setelah relogin atau restart Hyprland."
}

set_hybrid() {
    cat << 'EOF' > "$UWSM_ENV"
# Aquamarine / Multi-GPU configuration
# AMD Radeon 680M (card-amd) as primary renderer for power saving
export AQ_DRM_DEVICES="$HOME/.config/hypr/card-amd:$HOME/.config/hypr/card-nvidia"
export AQ_FORCE_LINEAR_BLIT=0
export MOZ_ENABLE_WAYLAND=1
EOF

    sed -i "s|hl\.env(\"AQ_DRM_DEVICES\",.*)|hl.env(\"AQ_DRM_DEVICES\", \"$HYPR_DIR/card-amd:$HYPR_DIR/card-nvidia\")|" "$ENV_LUA"
    echo "🔋 Mode diatur ke: Hybrid / AMD Primary (Hemat Baterai Laptop)"
    echo "ℹ️  Perubahan akan aktif setelah relogin atau restart Hyprland."
}

set_auto() {
    cat << 'EOF' > "$UWSM_ENV"
# Aquamarine / Multi-GPU configuration (Adaptive)
# - External HDMI connected on NVIDIA -> NVIDIA primary (zero-copy HDMI scanout)
# - Otherwise -> AMD iGPU primary (power saving, native Wayland EGL)
if grep -q "^connected" /sys/bus/pci/devices/0000:01:00.0/drm/card*/card*-*/status 2>/dev/null || grep -q "^connected" /sys/class/drm/card*-HDMI-*/status 2>/dev/null; then
    export AQ_DRM_DEVICES="$HOME/.config/hypr/card-nvidia:$HOME/.config/hypr/card-amd"
else
    export AQ_DRM_DEVICES="$HOME/.config/hypr/card-amd:$HOME/.config/hypr/card-nvidia"
fi
export AQ_FORCE_LINEAR_BLIT=0
export MOZ_ENABLE_WAYLAND=1
EOF

    echo "⚡ Mode diatur ke: Auto / Adaptive (NVIDIA jika HDMI terpasang, AMD jika tidak)"
    echo "ℹ️  Perubahan akan aktif setelah relogin atau restart Hyprland."
}

show_status() {
    echo "=== Current GPU Symlinks ==="
    ls -l "$HYPR_DIR"/card-*
    echo
    echo "=== DRM Connector Status ==="
    for s in /sys/class/drm/card*-*/status; do
        [ -f "$s" ] && echo "$(basename "$(dirname "$s")"): $(cat "$s")"
    done
    echo
    echo "=== Configured UWSM env-hyprland ==="
    cat "$UWSM_ENV" 2>/dev/null || grep "AQ_DRM_DEVICES" "$ENV_LUA"
    echo
    echo "=== Active Session AQ_DRM_DEVICES ==="
    echo "${AQ_DRM_DEVICES:-unset}"
    echo
    echo "=== Active Hyprland Monitor States ==="
    hyprctl monitors | grep -E "Monitor|hardwareCursorsInUse|availableModes" -A 1
}

case "$1" in
    nvidia|perf|performance)
        set_nvidia
        ;;
    hybrid|amd|battery)
        set_hybrid
        ;;
    auto|adaptive|dynamic)
        set_auto
        ;;
    status)
        show_status
        ;;
    *)
        echo "Penggunaan: switch-gpu.sh [auto|nvidia|hybrid|status]"
        echo "  auto   : Otomatis NVIDIA saat HDMI tersambung, AMD saat lepas (adaptive saat startup)"
        echo "  nvidia : Paksa NVIDIA sebagai GPU utama (optimal saat dicolok monitor eksternal 75Hz)"
        echo "  hybrid : Paksa AMD iGPU sebagai GPU utama (optimal untuk hemat baterai saat mobile)"
        echo "  status : Lihat status GPU & konektor yang sedang aktif"
        exit 1
        ;;
esac
