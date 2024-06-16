{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nix-darwin, nix-homebrew, home-manager, ... }@inputs:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Fadys-MacBook-Pro
      darwinConfigurations."Fadys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "fadyadal";
              autoMigrate = true;
            };
          }

          ./hosts/darwin
        ];
        specialArgs = { inherit inputs; };
      };

      darwinPackages = self.darwinConfigurations."Fadys-MacBook-Pro".pkgs;
    };
} 
