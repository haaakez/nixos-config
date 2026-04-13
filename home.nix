{ config, pkgs, inputs, ... }: {
  home.username = "haakez";
  home.homeDirectory = "/home/haakez";
  home.stateVersion = "26.05";

  home.file.".config/niri".source = ./niri;
  home.file.".config/quickshell".source = ./quickshell;
  home.file.".config/noctalia".source = ./noctalia;
  home.file.".config/kitty".source = ./kitty;
  home.file.".config/spicetify".source = ./spicetify;
  home.file."Pictures/Wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
}
