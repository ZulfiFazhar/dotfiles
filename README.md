# Hyprland + Caelestia + AirDrop Dotfiles

Konfigurasi lengkap Hyprland (Lua), Caelestia custom topbar shell, AirDrop (`omdrop` + tray + dialog Zenity), dan aplikasi pendukung untuk CachyOS / Arch Linux.

## Custom Shell
https://github.com/ZulfiFazhar/caelestia-topbar
- Topbar horizontal
- Drawer clipboard & notes
- Integrasi dual-GPU adaptive (AMD iGPU + NVIDIA dGPU)

## Struktur

| Direktori / File | Target | Isi |
|---|---|---|
| `hypr/` | `~/.config/hypr/` | `hyprland-caelestia.lua`, `hyprland/*.lua`, `variables.lua`, `switch-gpu.sh`, `scheme/default.lua` |
| `caelestia/` | `~/.config/caelestia/` | `shell.json`, `hypr-vars.lua`, `hypr-user.lua`, `monitors/`, `cheatsheet/`, `paste-selected.sh` |
| `uwsm/` | `~/.config/uwsm/` | `env`, `env-hyprland` (adaptive `AQ_DRM_DEVICES`) |
| `bin/` | `~/.local/bin/` | Wrapper `caelestia` (NVIDIA EGL fallback), `caelestia-restart`, `omdrop-tray`, `omdrop-toggle`, `omdrop-send-gui`, `omdrop-quick-share`, `omdrop-gui-action` |
| `airdrop/`, `systemd/`, `autostart/`, `icons/`, `applications/`, `patches/` | `~/.config/` & `~/.local/share/` | Config AirDrop, tray autostart, `airdrop-receiver.service`, icon, dan patch Zenity + notifikasi untuk `omdrop-plugin` |
| `fish/`, `starship.toml` | `~/.config/fish/`, `~/.config/` | `config.fish`, `fish_greeting.fish`, `bun.fish`, prompt Starship |
| `foot/` | `~/.config/foot/` | Terminal Foot (`foot.ini`, opacity 0.78) |
| `zed/` | `~/.config/zed/` | `settings.json`, `keymap.json`, `themes/caelestia.json` |
| `spicetify/` | `~/.config/spicetify/` | Tema Spotify Caelestia + template `config-xpui.ini` |
| `setup.sh` | — | Auto-symlink semua config, clone + patch repo, auto-build plugin C++ CMake |
| `verify.sh` | — | Self-test syntax (`bash`, `python3`, `fish`), symlink, dan alur CMake |

## Fresh Install CachyOS (Hyprland)

### 1. Install Dependensi
```sh
paru -S --needed \
  cmake ninja gcc-libs git jq \
  quickshell-git qt6-m3shapes-git caelestia-cli \
  ddcutil brightnessctl libcava networkmanager lm_sensors aubio libpipewire libqalculate \
  power-profiles-daemon swappy ydotool cliphist wl-clipboard trash-cli \
  polkit-gnome gnome-keyring gammastep geoclue \
  ttf-material-symbols-variable ttf-rubik-vf ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd \
  fish foot starship eza zoxide direnv fastfetch thunar \
  zed spotify spicetify-cli \
  omdrop-owl libayatana-appindicator gtk3 zenity python-gobject python-libarchive-c keyutils
```

### 2. Clone & Setup
```sh
git clone https://github.com/ZulfiFazhar/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./setup.sh
```

### 3. Post-Install (AirDrop, Dual-GPU, Spicetify)
```sh
# Aktifkan service receiver AirDrop
systemctl --user enable --now airdrop-receiver.service

# Setup adaptive dual-GPU (AMD iGPU / NVIDIA saat HDMI tercolok)
~/.config/hypr/switch-gpu.sh auto

# Terapkan tema Spicetify (setelah install & buka Spotify pertama kali)
spicetify backup apply
```

## Opsi `setup.sh` & Verifikasi
- `./setup.sh --build` — paksa build & install ulang plugin C++ CMake
- `./setup.sh --skip-build` — lewati step build CMake
- `./setup.sh --skip-clone` — lewati clone `caelestia-topbar` & `omdrop-plugin`
- `./verify.sh` — verifikasi syntax script, validitas symlink, dan mock flow CMake
