# System fonts.
#
# CaskaydiaCove is what the terminals ask for by name; RecMonoLinear is
# wezterm's face (see programs/wezterm/wezterm.lua). SF Pro / SF Mono, which
# the sketchybar config uses, are Homebrew casks -- Apple does not
# redistribute them in a form nixpkgs can package.
{
  den.aspects.darwin-fonts.darwin =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.caskaydia-cove
        pkgs.nerd-fonts.recursive-mono

        # The per-workspace app glyphs in sketchybar/config/items/spaces.lua
        # ask for this by name. It was only ever hand-installed into
        # ~/Library/Fonts, so a fresh machine rendered tofu for every icon.
        pkgs.sketchybar-app-font
      ];
    };
}
