{ den, ... }:
{
  den.aspects.macbook-pro = {
    # Composed explicitly rather than through a `darwin-base` catch-all, so
    # a host can drop one piece (say, darwin-desktop on a headless machine)
    # without having to unpick an aggregate.
    includes = [
      den.aspects.darwin-nix
      den.aspects.darwin-macos-defaults
      den.aspects.darwin-shells
      den.aspects.darwin-fonts
      den.aspects.darwin-desktop
      den.aspects.darwin-casks
      den.aspects.darwin-casks-personal
    ];

    darwin = {
      networking.computerName = "Fady's MacBook Pro";

      system = {
        defaults.smb.NetBIOSName = "macbook-pro";
        defaults.dock.tilesize = 48; # Larger dock on Pro
        stateVersion = 4;
      };
    };

  };
}
