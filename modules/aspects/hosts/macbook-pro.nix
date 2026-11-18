{ den, ... }:
{
  den.aspects.macbook-pro = {
    # Listed one by one, so a host can drop a piece.
    includes = [
      den.aspects.darwin-nix
      den.aspects.darwin-macos-defaults
      den.aspects.darwin-shells
      den.aspects.darwin-fonts
      den.aspects.darwin-desktop
      den.aspects.darwin-casks
      den.aspects.darwin-casks-personal
      den.aspects.packages-personal
    ];

    darwin = {
      networking.computerName = "Fady's MacBook Pro";

      system = {
        defaults.dock.tilesize = 48; # Larger dock on Pro
        stateVersion = 4;
      };
    };

  };
}
