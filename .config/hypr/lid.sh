#!/bin/sh
# lid.sh close|open|check — laptop screen off while the lid is closed and an external monitor is connected
action=$1
if [ "$action" = check ]; then
    grep -q closed /proc/acpi/button/lid/*/state && action=close || exit 0
fi
case $action in
    close)
        # only blank eDP-1 if something else is plugged in (otherwise logind suspends anyway)
        [ "$(hyprctl monitors all | grep -c "^Monitor")" -gt 1 ] && hyprctl keyword monitor "eDP-1, disable" ;;
    open)
        hyprctl keyword monitor "eDP-1, preferred, auto, 1" ;;
esac
