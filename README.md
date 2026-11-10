# Hyprland + Caelestia + AirDrop Dotfiles

Konfigurasi Hyprland (Lua), Caelestia custom topbar shell, dan integrasi AirDrop (`omdrop` + tray + dialog Zenity) untuk CachyOS / Arch Linux.

## Struktur

- `hypr/` — Config Hyprland (`hyprland-caelestia.lua`, modular `hyprland/*.lua`, keybinds, rules, `switch-gpu.sh`)
- `caelestia/` — Config user Caelestia (`shell.json`, `hypr-vars.lua`, `hypr-user.lua`, `monitors/`, `cheatsheet/`, `paste-selected.sh`)
- `uwsm/` — Environment variables (`env`, `env-hyprland` adaptive multi-GPU)
- `bin/` — Wrapper `caelestia` (NVIDIA EGL fallback) dan helper AirDrop (`omdrop-tray`, `omdrop-toggle`, `omdrop-send-gui`, `omdrop-quick-share`, `omdrop-gui-action`)
- `airdrop/`, `systemd/`, `autostart/`, `icons/`, `applications/`, `patches/` — Config, tray autostart, systemd receiver, dan patch prompt Zenity + notifikasi untuk `omdrop-plugin`
- `setup.sh` — Link semua config, clone `caelestia-topbar` & `omdrop-plugin`, apply patch, dan auto-build plugin C++ CMake jika belum terinstall
- `verify.sh` — Self-test syntax, symlink, dan alur build CMake

## Fresh Install CachyOS (Hyprland)

### 1. Install Dependensi
```sh
paru -S --needed \
  cmake ninja gcc-libs git \
  quickshell-git qt6-m3shapes-git caelestia-cli \
  ddcutil brightnessctl libcava networkmanager lm_sensors aubio libpipewire libqalculate \
  power-profiles-daemon swappy fish foot ydotool cliphist wl-clipboard \
  ttf-material-symbols-variable ttf-rubik-vf ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd \
  omdrop-owl libayatana-appindicator gtk3 zenity python-gobject python-libarchive-c keyutils
```

### 2. Clone & Setup
```sh
git clone https://github.com/ZulfiFazhar/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./setup.sh
```

### 3. Aktifkan AirDrop Service
```sh
systemctl --user enable --now airdrop-receiver.service
```

## Opsi `setup.sh`
- `--build`: paksa build & install ulang plugin C++ CMake
- `--skip-build`: lewati step build CMake
- `--skip-clone`: lewati clone `caelestia-topbar` & `omdrop-plugin`

## Custom Shell
https://github.com/ZulfiFazhar/caelestia-topbar
