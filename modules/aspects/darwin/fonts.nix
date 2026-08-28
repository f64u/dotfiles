# System fonts.
#
# CaskaydiaCove is what the terminals ask for by name; RecMonoLinear is
# wezterm's face (see programs/wezterm/wezterm.lua); SF Pro / SF Mono are what
# the sketchybar config asks for (sketchybar/config/helpers/default_font.lua).
{
  den.aspects.darwin-fonts.darwin =
    { pkgs, ... }:
    let
      sf = pkgs.callPackage ./_sf-fonts.nix { };
    in
    {
      fonts.packages = [
        pkgs.nerd-fonts.caskaydia-cove
        pkgs.nerd-fonts.recursive-mono

        # The per-workspace app glyphs in sketchybar/config/items/spaces.lua
        # ask for this by name. It was only ever hand-installed into
        # ~/Library/Fonts, so a fresh machine rendered tofu for every icon.
        pkgs.sketchybar-app-font

        # Apple's own faces -- see ./_sf-fonts.nix for why these are packaged
        # here rather than taken from brewCasks.
        sf.sf-pro
        sf.sf-mono
      ];
    };
}
