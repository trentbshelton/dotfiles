#!/bin/bash
# Low battery notifications: warning at 20%, critical at 10%. Each fires once per discharge.

BAT=/sys/class/power_supply/BAT0
warned=0
critical=0

while true; do
    cap=$(cat "$BAT/capacity")
    status=$(cat "$BAT/status")

    if [ "$status" != "Discharging" ]; then
        warned=0
        critical=0
    elif [ "$cap" -le 10 ] && [ "$critical" -eq 0 ]; then
        notify-send -u critical "battery critical" "${cap}% left, plug in now"
        critical=1
        warned=1
    elif [ "$cap" -le 20 ] && [ "$warned" -eq 0 ]; then
        notify-send -u normal "battery low" "${cap}% left"
        warned=1
    fi

    sleep 60
done
