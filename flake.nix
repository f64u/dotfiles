{
  description = "System Configuration";

  # ./modules holds flake-parts modules, auto-imported by import-tree; den
  # turns `den.hosts` / `den.aspects` into darwinConfigurations.
  #
  #   darwin-rebuild switch --flake .#macbook-pro
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    den.url = "github:denful/den";
    import-tree.url = "github:vic/import-tree";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Must be named `darwin`: den looks up `inputs.darwin.lib.darwinSystem`.
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew casks as nix derivations (`pkgs.brewCasks.*`); no `brew` involved.
    # `brew-api` carries the cask versions and hashes, so it must be overridden:
    # brew-nix pins a stale copy.
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    # Prebuilt nix-index database; running `nix-index` locally is slow and
    # breaks on nixpkgs renames.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
