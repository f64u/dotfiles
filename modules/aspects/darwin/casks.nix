# macOS GUI apps as nix derivations, via brew-nix's `pkgs.brewCasks` overlay
# (wired up in modules/defaults.nix). Versions come from the `brew-api` input,
# so `nix flake update` is what moves them.
#
# `pin` handles casks with no upstream checksum -- see ./_cask-pin.nix.
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
        "ghostty"
        "rstudio"
        "xquartz"

        # Communication / meetings
        "slack"
        "zoom"

        # Browsers
        "firefox"

        # Documents and screen capture
        "licecap"
        "paintbrush"
        "shottr"
        "skim"

        # The SF fonts are not casks here -- see ./_sf-fonts.nix.
      ];
    };
}
