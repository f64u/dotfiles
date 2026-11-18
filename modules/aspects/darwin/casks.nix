# macOS GUI apps via brew-nix's `pkgs.brewCasks`. `nix flake update` moves
# their versions (the `brew-api` input). `pin`: see ./_cask-pin.nix.
{ lib, ... }:
{
  den.aspects.darwin-casks.provides.to-users.homeManager =
    { pkgs, ... }:
    let
      pin = import ./_cask-pin.nix { inherit lib pkgs; };
    in
    {
      home.packages = map pin [
        # Development
        "docker-desktop"
        "xquartz"

        # Communication / meetings
        "slack"
        "zoom"

        # Browsers
        "firefox"
        "thebrowsercompany-dia"

        # Documents and screen capture
        "licecap"
        "paintbrush"
        "shottr"
        "skim"
      ];
    };
}
