# Hyprland + Caelestia Dotfiles

Konfigurasi Hyprland (Lua) dan Caelestia shell untuk setup custom topbar.

## Struktur

- `hypr/` — Config Hyprland (`hyprland-caelestia.lua`, modular `hyprland/*.lua`, keybinds, rules, dual-GPU switcher)
- `caelestia/` — Config user Caelestia (`shell.json`, `hypr-vars.lua`, `hypr-user.lua`, `monitors/`, `cheatsheet/`, `paste-selected.sh`)
- `uwsm/` — Environment variables (`env`, `env-hyprland` adaptive multi-GPU)
- `setup.sh` — Link semua config ke `$XDG_CONFIG_HOME` (default `~/.config`), clone shell custom, dan auto-build plugin C++ CMake jika belum terinstall
- `verify.sh` — Self-test syntax, symlink, dan flow build CMake

## Custom Shell

Menggunakan fork custom topbar + clipboard + notes drawer:
https://github.com/ZulfiFazhar/caelestia-topbar

## Install

```sh
git clone https://github.com/ZulfiFazhar/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./setup.sh
```

Opsi `setup.sh`:
- `--build`: paksa build & install ulang plugin C++ CMake
- `--skip-build`: lewati step build CMake
- `--skip-clone`: lewati clone `caelestia-topbar`
