# `nix fmt` and `nix flake check`.
{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      onThisSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
    in
    {
      formatter = pkgs.nixfmt-tree;

      # Builds every configuration for this system.
      checks = lib.mapAttrs' (n: c: lib.nameValuePair "darwin-${n}" c.config.system.build.toplevel) (
        onThisSystem inputs.self.darwinConfigurations
      );
    };
}
