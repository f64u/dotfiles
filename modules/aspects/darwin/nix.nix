# The nix daemon on darwin. GC policy is in modules/defaults.nix.
{ inputs, ... }:
{
  den.aspects.darwin-nix.darwin =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-index-database.darwinModules.nix-index ];

      # Must be `inputs.self`: nix-darwin has no top-level `rev`.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      nix = {
        package = pkgs.nixVersions.stable;

        # Lets these machines build and run x86_64 closures under Rosetta.
        extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';
      };

      # The package comes from nix-index-database, with the index baked in.
      programs.nix-index.enable = true;
    };
}
