# The nix daemon itself on darwin.
#
# GC policy is deliberately not here -- it is shared with NixOS and lives in
# modules/defaults.nix.
{
  den.aspects.darwin-nix.darwin =
    { config, pkgs, ... }:
    {
      # Records the flake revision in `darwin-version`.
      system.configurationRevision = config.rev or config.dirtyRev or null;

      nix = {
        enable = true;
        package = pkgs.nixVersions.stable;

        # Lets these machines build and run x86_64 closures under Rosetta.
        extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';
      };

      programs.nix-index.enable = true;
    };
}
