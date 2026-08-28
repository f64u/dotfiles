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
        pkgs.sketchybar-app-font # per-workspace app glyphs in spaces.lua
        sf.sf-pro
        sf.sf-mono
      ];
    };
}
