{
  description = "System Configuration";

  # Everything lives in ./modules as flake-parts modules, auto-imported by
  # import-tree. Den (github:denful/den) turns `den.hosts` / `den.aspects`
  # declarations into darwinConfigurations.
  #
  #   darwin-rebuild switch --flake .#macbook-pro
  #
  # or via the nh wrappers den exposes:
  #
  #   nix run .#macbook-pro -- switch
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

    # NOTE: den resolves the nix-darwin builder as `inputs.darwin.lib.darwinSystem`,
    # so this input has to be named `darwin`.
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages Homebrew casks as nix derivations, exposed as `pkgs.brewCasks.*`
    # through an overlay. This replaces nix-homebrew and nix-darwin's homebrew
    # module outright -- GUI apps are now real store paths that roll back with
    # a generation, and no `brew` is installed or invoked.
    #
    # NOTE: `brew-api` is not optional. brew-nix pins a stale copy by default
    # and its README says to override it -- it carries the cask metadata
    # (versions and hashes), so this input is what actually gets updated by
    # `nix flake update`.
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

    # Prebuilt nix-index database, refreshed weekly. Running `nix-index`
    # locally breaks whenever nixpkgs renames an attribute set it hardcodes
    # (e.g. coqPackages -> rocqPackages), and takes ages besides.
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
