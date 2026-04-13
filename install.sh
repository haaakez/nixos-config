#!/bin/sh
HOST=${1:-nixos}
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/$HOST/hardware-configuration.nix 2>/dev/null || \
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos-config#$HOST
