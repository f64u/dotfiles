# macOS GUI apps as nix derivations, via brew-nix's `pkgs.brewCasks` overlay
# (wired up in modules/defaults.nix). No Homebrew involved.
#
# These are real store paths: they roll back with a generation, are pinned by
# flake.lock through the `brew-api` input, and land in ~/Applications as real
# bundles via targets.darwin.copyApps (see darwin/desktop.nix).
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
        "zen"

        # Documents and screen capture
        "licecap"
        "paintbrush"
        "shottr"
        "skim"

        # NOTE: font-sf-mono / font-sf-pro are deliberately NOT here. brew-nix
        # mis-unpacks them and a cask would put them in the wrong prefix
        # anyway -- they are packaged for fonts.packages in ./_sf-fonts.nix.
      ];
    };
}
