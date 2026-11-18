# `nix fmt` and `nix flake check`.
{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      onThisSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
    in
    {
      # Style lives in ../.editorconfig.
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = [
          pkgs.nixfmt
          pkgs.stylua
          pkgs.shfmt
        ];
        settings = {
          tree-root-file = "flake.nix";
          on-unmatched = "info";
          formatter = {
            nixfmt = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };
            stylua = {
              command = "stylua";
              includes = [
                "*.lua"
                "*/sketchybarrc"
              ];
            };
            shfmt = {
              command = "shfmt";
              options = [ "-w" ];
              includes = [ "*.sh" ];
            };
          };
        };
      };

      # Builds every configuration for this system.
      checks = lib.mapAttrs' (n: c: lib.nameValuePair "darwin-${n}" c.config.system.build.toplevel) (
        onThisSystem inputs.self.darwinConfigurations
      );
    };
}
