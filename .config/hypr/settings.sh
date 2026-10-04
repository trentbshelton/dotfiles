#!/bin/bash
# Settings menu (Super+I): one fuzzel list that opens the right tool for each setting.

choice=$(printf '%s\n' \
    "wifi" \
    "bluetooth" \
    "sound" \
    "display" \
    "appearance" \
    "power profile" \
    "battery + system" \
    "edit hyprland config" \
    "edit waybar config" \
    "reload hyprland" \
    "night light toggle" \
    | fuzzel --dmenu --prompt "settings > " --lines 11)

case "$choice" in
    "wifi")                 nm-connection-editor || ghostty -e nmtui ;;
    "bluetooth")            blueman-manager ;;
    "sound")                pavucontrol ;;
    "display")              nwg-displays ;;
    "appearance")           nwg-look ;;
    "power profile")
        p=$(printf 'power-saver\nbalanced\nperformance\n' | fuzzel --dmenu --prompt "power ($(powerprofilesctl get)) > " --lines 3)
        [ -n "$p" ] && powerprofilesctl set "$p" && notify-send "power profile" "$p" ;;
    "battery + system")     ghostty -e btop ;;
    "edit hyprland config") ghostty -e nano ~/.config/hypr/hyprland.conf ;;
    "edit waybar config")   ghostty -e nano ~/.config/waybar/config.jsonc ;;
    "night light toggle")
        if pgrep -x hyprsunset >/dev/null; then
            pkill -x hyprsunset && notify-send "night light" "off"
        else
            hyprctl dispatch exec hyprsunset && notify-send "night light" "on (warm from 8pm to 7am)"
        fi ;;
    "reload hyprland")      hyprctl reload && pkill -SIGUSR2 waybar && notify-send "hyprland" "config reloaded" ;;
esac
