#!/bin/bash
# Power menu (Super+Escape). Reboot/shutdown/logout ask for confirmation.

confirm() {
    [ "$(printf 'no\nyes\n' | fuzzel --dmenu --prompt "$1? > " --lines 2)" = "yes" ]
}

choice=$(printf '%s\n' "lock" "sleep" "log out" "reboot" "shut down" \
    | fuzzel --dmenu --prompt "power > " --lines 5)

case "$choice" in
    "lock")      loginctl lock-session ;;
    "sleep")     systemctl suspend ;;
    "log out")   confirm "log out" && hyprctl dispatch exit ;;
    "reboot")    confirm "reboot" && systemctl reboot ;;
    "shut down") confirm "shut down" && systemctl poweroff ;;
esac
