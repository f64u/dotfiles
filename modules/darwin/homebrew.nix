{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    brews = [
      #"sketchybar"
      "gmp"
      # {
      #   name = "llvm";
      #   link = true;
      # }
    ];

    casks = [
      "1password"
      "firefox"
      "font-caskaydia-cove-nerd-font"
      "font-sf-mono"
      "font-sf-pro"
      "mactex"
      "minecraft"
      "multipass"
      "shottr"
      "smlnj"
      "steam"
    ];

    taps = [
      "felixkratz/formulae"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}
