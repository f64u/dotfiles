{ den, ... }:
{
  den.aspects.macbook-pro-work = {
    includes = [
      den.aspects.darwin-nix
      den.aspects.darwin-macos-defaults
      den.aspects.darwin-shells
      den.aspects.darwin-fonts
      den.aspects.darwin-desktop
      den.aspects.darwin-homebrew
      # NOTE: darwin-homebrew-personal is deliberately absent -- that is where
      # steam, minecraft, dolphin and friends live.
    ];

    darwin = {
      networking.computerName = "Fady's MacBook Air";

      system = {
        defaults.smb.NetBIOSName = "macbook-pro-work";
        stateVersion = 5;
      };
    };
  };
}
