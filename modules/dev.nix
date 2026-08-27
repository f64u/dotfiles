# Developer-facing flake surface: `nix fmt` and `nix flake check`.
#
# All three were empty before, so `nix fmt` did nothing despite nixfmt being
# installed, and `nix flake check` verified nothing.
{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      onThisSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
    in
    {
      formatter = pkgs.nixfmt-tree;

      # Actually build every configuration for this system.
      checks = lib.mapAttrs' (n: c: lib.nameValuePair "darwin-${n}" c.config.system.build.toplevel) (
        onThisSystem inputs.self.darwinConfigurations
      );
    };
}
