#!/bin/sh
HOST=${1:-nixos}

mkdir -p ~/Pictures/Wallpapers/
cp ~/nixos-config/wallpapers/* ~/Pictures/Wallpapers/

# Get current monitor name and write wallpapers.json dynamically
MONITOR=$(niri msg outputs 2>/dev/null | grep "Output" | head -1 | awk '{print $2}' || echo "DP-3")
mkdir -p ~/.cache/noctalia/
cat > ~/.cache/noctalia/wallpapers.json << EOF
{
    "defaultWallpaper": "/home/haakez/Pictures/Wallpapers/wallpaper.png",
    "usedRandomWallpapers": {},
    "wallpapers": {
        "$MONITOR": {
            "dark": "/home/haakez/Pictures/Wallpapers/wallpaper.png",
            "light": "/home/haakez/Pictures/Wallpapers/wallpaper.png"
        }
    }
}
EOF

cp /etc/nixos/hardware-configuration.nix ~/nixos-config/$HOST/hardware-configuration.nix 2>/dev/null || \
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hardware-configuration.nix

sudo nixos-rebuild switch --flake ~/nixos-config#$HOST
