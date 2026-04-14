{ config, pkgs, lib, inputs, ... }: {
  
  # Core Home Manager Setup
  home.username = "haakez";
  home.homeDirectory = "/home/haakez";
  home.stateVersion = "26.05";

  # We use an activation script instead of home.file to ensure these 
  # directories are mutable (writeable) by Noctalia's templating engine.
  home.activation.copyMutableConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 1. Create the destination directories
    mkdir -p ~/.config/niri ~/.config/noctalia ~/.config/kitty ~/.config/spicetify

    # 2. Copy the contents from your Flake repo into ~/.config/
    # The --no-preserve=mode flag drops the read-only Nix store permissions
    cp -r --no-preserve=mode ${./niri}/* ~/.config/niri/ 2>/dev/null || true
    cp -r --no-preserve=mode ${./noctalia}/* ~/.config/noctalia/ 2>/dev/null || true
    cp -r --no-preserve=mode ${./kitty}/* ~/.config/kitty/ 2>/dev/null || true
    cp -r --no-preserve=mode ${./spicetify}/* ~/.config/spicetify/ 2>/dev/null || true

    # 3. Double-check that your user has write access to everything in these folders
    chmod -R u+w ~/.config/niri ~/.config/noctalia ~/.config/kitty ~/.config/spicetify
  '';

}
}
