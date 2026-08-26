{
  description = "System Configuration";

  # Everything lives in ./modules as flake-parts modules, auto-imported by
  # import-tree. Den (github:denful/den) turns `den.hosts` / `den.aspects`
  # declarations into the usual darwinConfigurations / nixosConfigurations.
  #
  #   darwin-rebuild switch --flake .#macbook-pro
  #   nixos-rebuild  switch --flake .#nixos-desktop
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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Catppuccin themes consumed as plain source trees. These were previously
    # `builtins.fetchGit` calls pinned by rev inside the aspects, which meant
    # full git clones on every evaluation and revisions that flake.lock knew
    # nothing about -- `nix flake update` could not see them.
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };

    catppuccin-zsh-syntax-highlighting = {
      url = "github:catppuccin/zsh-syntax-highlighting";
      flake = false;
    };
  };
}
