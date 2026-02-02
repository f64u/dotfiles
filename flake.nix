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

    # nix-rosetta-builder = {
    #   url = "github:cpick/nix-rosetta-builder";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      # nix-rosetta-builder,
      nixpkgs,
      ...
    }@inputs:
    let
      # Common system builder function for Darwin
      mkDarwinSystem =
        {
          hostname,
          system ? "aarch64-darwin",
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
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

            ./hosts/darwin/common.nix
            ./hosts/darwin/${hostname}.nix

            # nix-rosetta-builder.darwinModules.default
            # {
            #   # see available options in module.nix's `options.nix-rosetta-builder`
            #   nix-rosetta-builder.onDemand = true;
            # }
          ]
          ++ extraModules;
          specialArgs = { inherit inputs hostname; };
        };

      # Common system builder function for NixOS
      mkNixosSystem =
        {
          hostname,
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/nixos/common.nix
            ./hosts/nixos/${hostname}.nix
          ]
          ++ extraModules;
          specialArgs = { inherit inputs hostname; };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook-air
      # $ darwin-rebuild build --flake .#macbook-pro
      darwinConfigurations = {
        "macbook-pro" = mkDarwinSystem {
          hostname = "macbook-air";
          system = "aarch64-darwin";
        };
        "macbook-pro-work" = mkDarwinSystem {
          hostname = "macbook-pro-work";
          system = "aarch64-darwin";
        };
      };

      # Build nixos flake using:
      # $ nixos-rebuild build --flake .#nixos-desktop
      nixosConfigurations = {
        "nixos-desktop" = mkNixosSystem {
          hostname = "nixos-desktop";
          system = "x86_64-linux";
        };
      };

    };
}
