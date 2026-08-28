# The nix daemon itself on darwin.
#
# GC policy is deliberately not here -- it is shared with NixOS and lives in
# modules/defaults.nix.
{ inputs, ... }:
{
  den.aspects.darwin-nix.darwin =
    { pkgs, ... }:
    {
      # Records the flake revision in `darwin-version`. Must be `inputs.self`
      # -- nix-darwin declares no top-level `rev`, so reading it off the
      # module `config` silently yields null.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      nix = {
        package = pkgs.nixVersions.stable;

        # Lets these machines build and run x86_64 closures under Rosetta.
        extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';
      };

      programs.nix-index.enable = true;
    };
}
