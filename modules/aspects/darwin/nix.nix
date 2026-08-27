# The nix daemon itself on darwin.
#
# GC policy is deliberately not here -- it is shared with NixOS and lives in
# modules/defaults.nix.
{ inputs, ... }:
{
  den.aspects.darwin-nix.darwin =
    { pkgs, ... }:
    {
      # Records the flake revision in `darwin-version`.
      #
      # NOTE: must be `inputs.self`, not the module `config`. nix-darwin
      # declares no top-level `rev` option, so `config.rev or config.dirtyRev
      # or null` silently resolved to null and recorded nothing.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      nix = {
        # `enable` defaults to true; the package and extra-platforms are the
        # only things worth stating.
        package = pkgs.nixVersions.stable;

        # Lets these machines build and run x86_64 closures under Rosetta.
        extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';
      };

      programs.nix-index.enable = true;
    };
}
