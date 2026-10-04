#!/bin/bash
# Keybind cheat sheet (Super+/). Lists every described bind (bindd) from Hyprland itself,
# so it never goes stale. Picking a line runs that action.

list=$(hyprctl binds -j | python3 -c '
import json, sys

MODS = [(64, "Super"), (4, "Ctrl"), (8, "Alt"), (1, "Shift")]
KEYS = {
    "Return": "Enter", "slash": "/", "Escape": "Esc", "Space": "Space",
    "left": "Left", "right": "Right", "up": "Up", "down": "Down",
    "mouse_down": "Scroll down", "mouse_up": "Scroll up",
    "mouse:272": "Left drag", "mouse:273": "Right drag",
    "Print": "PrtSc",
}

seen = set()
for b in json.load(sys.stdin):
    desc = b.get("description")
    if not desc or not b.get("has_description", True):
        continue
    key = b["key"]
    if key.startswith("XF86"):
        name = "Fn key"
    else:
        name = KEYS.get(key, key.upper() if len(key) == 1 else key)
    combo = " + ".join([m for bit, m in MODS if b["modmask"] & bit] + [name])
    if (combo, desc) in seen:
        continue
    seen.add((combo, desc))
    dispatcher = "-" if b.get("mouse") else b["dispatcher"]
    arg = b["arg"]
    print(f"{combo:<22} {desc}\t{dispatcher}\t{arg}")
')

choice=$(printf '%s\n' "$list" | cut -f1 | fuzzel --dmenu --prompt "keys > " --width 60 --lines 15)
[ -z "$choice" ] && exit 0

line=$(printf '%s\n' "$list" | grep -F -m1 "$choice"$'\t')
dispatcher=$(printf '%s' "$line" | cut -f2)
arg=$(printf '%s' "$line" | cut -f3)

case "$dispatcher" in
    -) exit 0 ;;  # mouse drags, nothing to run
    exec) hyprctl dispatch exec "$arg" ;;
    *) hyprctl dispatch "$dispatcher" "$arg" ;;
esac
