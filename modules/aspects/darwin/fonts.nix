# System fonts: CaskaydiaCove for terminals, RecMonoLinear for wezterm,
# SF Pro / SF Mono for sketchybar.
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
