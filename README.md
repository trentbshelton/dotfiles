# dotfiles

My Hyprland setup on Arch Linux, running on a ThinkPad L390 Yoga.

Minimal on purpose: a thin black bar, square borders, wide gaps, one
monospace font, no blur or shadows. The wallpaper is the RetroArch XMB
ribbon, rendered live by [ribbonbg](https://github.com/trentbshelton/ribbonbg),
a small Wayland program I modified to draw it.

## What's here

    .config/hypr/       Hyprland, lock screen, idle, night light, scripts
    .config/waybar/     top bar
    .config/fuzzel/     app launcher (also used for the menus)
    .config/mako/       notifications
    .config/ghostty/    terminal
    .config/fastfetch/  system info shown when a terminal opens
    .config/starship.toml
    .bashrc

Scripts in `.config/hypr/`:

    settings.sh       Super+I    menu for wifi, bluetooth, sound, display, power profile
    powermenu.sh      Super+Esc  lock, sleep, log out, reboot, shut down
    keybinds.sh       Super+/    searchable list of every keybind, read from Hyprland
    battery-alert.sh             notification at 20% and 10% battery
    wallpaper.sh                 starts the ribbon wallpaper

Keybinds are defined with `bindd`, so each one carries a description.
`Super+/` lists them all.

## Install

On a fresh Arch install:

    git clone https://github.com/trentbshelton/dotfiles ~/dotfiles
    cd ~/dotfiles
    ./install.sh

This installs the packages, builds ribbonbg into `~/.local/bin`, and
symlinks the configs into `$HOME`. Anything it would replace is moved to
`~/.dotfiles-backup/` first. To only relink configs, run
`./install.sh --links`.

## Changing the wallpaper colors

The ribbon is drawn over a gradient shader in `.config/hypr/ribbon/`.
Point `wallpaper.sh` at a different `.frag` file to change it.
`electric_blue.frag` is RetroArch's default theme, `purple.frag` is the
one I use.
