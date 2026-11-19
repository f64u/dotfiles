# `nix fmt` and `nix flake check`.
{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      onThisSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
    in
    {
      formatter = pkgs.treefmt.withConfig {
        settings = {
          tree-root-file = "flake.nix";
          on-unmatched = "info";
          formatter = lib.mapAttrs (_: f: {
            command = lib.getExe f.package;
            options = f.inPlace or [ ];
            includes = f.files;
          }) (import ./_formatters.nix pkgs);
        };
      };

      # Builds every configuration for this system.
      checks = lib.mapAttrs' (n: c: lib.nameValuePair "darwin-${n}" c.config.system.build.toplevel) (
        onThisSystem inputs.self.darwinConfigurations
      );
    };
}
