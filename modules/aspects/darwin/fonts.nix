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
      fonts.packages = with pkgs.nerd-fonts; [
        caskaydia-cove
        recursive-mono
      ];
    };
}
