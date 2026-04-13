{
  description = "NixOS Flake with Noctalia Shell";
  inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  inputs = {
    # Noctalia needs the latest dependencies, so we track unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # The official Noctalia GitHub Flake
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, noctalia, ... }@inputs: {
    # NOTE: "nixos" is your default hostname. If you named your PC 
    # something else during setup, change "nixos" here to match!
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Passes the flake inputs to your config
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
