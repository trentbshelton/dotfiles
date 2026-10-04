#!/bin/bash
# Set up these dotfiles on a fresh Arch install.
#   ./install.sh            install packages, link configs, build ribbonbg
#   ./install.sh --links    only link configs
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%F_%H-%M-%S)"

PACKAGES=(
    hyprland hyprlock hypridle hyprsunset hyprpolkitagent
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland
    waybar fuzzel mako libnotify cliphist wl-clipboard grim slurp
    brightnessctl playerctl pavucontrol power-profiles-daemon
    network-manager-applet blueman nwg-displays nwg-look
    ghostty starship fastfetch btop thunar
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    meson ninja git base-devel
)

# files and folders that get symlinked into $HOME
LINKS=(
    .bashrc
    .config/hypr
    .config/waybar
    .config/ghostty
    .config/fuzzel
    .config/mako
    .config/fastfetch
    .config/starship.toml
)

link_configs() {
    for path in "${LINKS[@]}"; do
        src="$REPO/$path"
        dst="$HOME/$path"
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            continue
        fi
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            mkdir -p "$BACKUP/$(dirname "$path")"
            mv "$dst" "$BACKUP/$path"
            echo "backed up $dst"
        fi
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
        echo "linked $path"
    done
}

build_ribbonbg() {
    tmp=$(mktemp -d)
    git clone --depth 1 https://github.com/trentbshelton/ribbonbg "$tmp/ribbonbg"
    meson setup "$tmp/ribbonbg/build" "$tmp/ribbonbg"
    ninja -C "$tmp/ribbonbg/build"
    install -Dm755 "$tmp/ribbonbg/build/ribbonbg" "$HOME/.local/bin/ribbonbg"
    rm -rf "$tmp"
    echo "installed ~/.local/bin/ribbonbg"
}

if [ "${1:-}" != "--links" ]; then
    sudo pacman -S --needed "${PACKAGES[@]}"
    build_ribbonbg
fi
link_configs
echo "done. log out and back in to start Hyprland with the new config."
