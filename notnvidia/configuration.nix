# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

};
systemd.user.services.pipewire-restart = {
  description = "Restart pipewire before Steam";
  wantedBy = [ "default.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.systemd}/bin/systemctl --user restart pipewire";
    RemainAfterExit = true;
  };
};



environment.sessionVariables = {
  XCURSOR_THEME = "Bibata-Modern-Classic";
  XCURSOR_SIZE = "20";
};

services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};
services.displayManager.autoLogin = {
  enable = true;
  user = "haakez";
};
hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Sofia";

  # Select internationalisation properties.
i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "bg_BG.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bg_BG.UTF-8";
    LC_IDENTIFICATION = "bg_BG.UTF-8";
    LC_MEASUREMENT = "bg_BG.UTF-8";
    LC_MONETARY = "bg_BG.UTF-8";
    LC_NAME = "bg_BG.UTF-8";
    LC_NUMERIC = "bg_BG.UTF-8";
    LC_PAPER = "bg_BG.UTF-8";
    LC_TELEPHONE = "bg_BG.UTF-8";
    LC_TIME = "bg_BG.UTF-8";
  };

  # Configure keymap in X11
   services.xserver.xkb = {
    layout = "us,ua,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.haakez = {
    isNormalUser = true;
    description = "haakez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.niri.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.firefox = {
      enable = true;
      nativeMessagingHosts.packages = [
        (pkgs.writeTextDir "lib/mozilla/native-messaging-hosts/pywalfox.json" ''
          {
            "name": "pywalfox",
            "description": "Pywalfox native app",
            "path": "${pkgs.pywalfox-native}/bin/pywalfox",
            "type": "stdio",
            "allowed_extensions": [ "pywalfox@frewacom.org" ]
          }
        '')
      ];
    };

services.udev.extraHwdb = ''
  evdev:name:Logitech G502 X:*
    LIBINPUT_ATTR_ACCEL_PROFILE_HINT=custom
    LIBINPUT_ATTR_ACCEL_POINTS_MOTION=0.000;0.079;0.159;0.274;0.393;0.512;0.632;0.804;0.985;1.167;1.348;1.529;1.711;1.892;2.074;2.255;2.436;2.618;2.799;2.981;3.355
    LIBINPUT_ATTR_ACCEL_STEP_MOTION=0.2031610269
'';
  

 programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
      
 
};
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  extraPackages = with pkgs; [
    libXtst
    libXi
    gtk2
    pipewire
    libpulseaudio
    gdk-pixbuf
    libvdpau
    bzip2
  ];
};


  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
(pkgs.symlinkJoin {
  name = "discord";
  paths = [ (discord.override { withVencord = true; }) ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/discord --unset WAYLAND_DISPLAY
  '';
})

  cliphist
  wl-clipboard
	 git
     grim
     slurp
     wl-clipboard
     python3
     neovim
     libnotify
     ydotool
     kitty
     telegram-desktop
     inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
     micro
     fastfetch
     pfetch
     btop
     quickshell
     obs-studio
     bibata-cursors
     bzip2
     libXtst
     libXi
     gtk2
     libvdpau
     gtk2
     pipewire
     gimp
     guvcview
     vesktop
     cbonsai
     cava
kdePackages.kolourpaint
vscode
prismlauncher   
     xwayland-satellite
     nautilus
    cnijfilter2
     gutenprint
     mpv
  ];


fonts.packages = with pkgs; [
  inter
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
