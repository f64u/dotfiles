{ den, ... }:
{
  den.aspects.macbook-pro-work = {
    includes = [
      den.aspects.darwin-nix
      den.aspects.darwin-macos-defaults
      den.aspects.darwin-shells
      den.aspects.darwin-fonts
      den.aspects.darwin-desktop
      den.aspects.darwin-casks
    ];

    darwin = {
      networking.computerName = "Fady's Work MacBook";

      system = {
        defaults.smb.NetBIOSName = "macbook-pro-work";
        stateVersion = 5;
      };
    };
  };
}
