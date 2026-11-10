#!/usr/bin/env bash

# Toggle cheatsheet popup using Quickshell
if pgrep -f "qs.*cheatsheet" > /dev/null; then
    pkill -f "qs.*cheatsheet"
else
    qs -p "$HOME/.config/caelestia/cheatsheet/shell.qml"
fi
