{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
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
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "fadyadal";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }

          ./hosts/darwin
        ];
        specialArgs = { inherit inputs; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Fadys-MacBook-Pro".pkgs;
    };
} 
