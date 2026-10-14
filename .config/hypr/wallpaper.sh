#!/bin/bash
# Animated RetroArch XMB ribbon wallpaper. ribbonbg source: https://github.com/trentbshelton/ribbonbg
# Background gradient is a Shadertoy-style shader; swap the .frag to change colors.
pkill -x ribbonbg 2>/dev/null
pkill -x swaybg 2>/dev/null
exec ~/.local/bin/ribbonbg --fps 30 '*' ~/.config/hypr/ribbon/midnight.frag
