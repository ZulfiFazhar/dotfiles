# Hyprland + Caelestia Dotfiles

Konfigurasi Hyprland (Lua) dan Caelestia shell untuk setup custom topbar.

## Struktur

- `hypr/` — Config Hyprland (`hyprland-caelestia.lua`, modular `hyprland/*.lua`, keybinds, rules, dual-GPU switcher)
- `caelestia/` — Config user Caelestia (`shell.json`, `hypr-vars.lua`, `hypr-user.lua`, `monitors/`, `cheatsheet/`, `paste-selected.sh`)
- `uwsm/` — Environment variables (`env`, `env-hyprland` adaptive multi-GPU)
- `setup.sh` — Link semua config ke `$XDG_CONFIG_HOME` (default `~/.config`) dan clone shell custom

## Custom Shell

Menggunakan fork custom topbar + clipboard + notes drawer:
https://github.com/ZulfiFazhar/caelestia-topbar

## Install

```sh
git clone https://github.com/ZulfiFazhar/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./setup.sh
```

Jika install dari nol (plugin C++ Quickshell belum ter-build), build `caelestia-topbar`:

```sh
cd ~/.config/quickshell/caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```
