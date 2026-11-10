-- Personal Hyprland configuration for Caelestia

-- Monitor configuration (native 1080p, scale 1.0)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@74.97",
    position = "1920x0",
    scale    = 1,
})

-- Cheatsheet popup (Native Caelestia Quickshell)
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/caelestia/cheatsheet.sh"))
