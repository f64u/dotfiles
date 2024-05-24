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
      "smlnj"
      "1password"
      "mactex"
      "minecraft"
      "font-caskaydia-cove-nerd-font"
      "font-sf-mono"
      "font-sf-pro"
      "shottr"
      "firefox"
      "multipass"
    ];

    taps = [
      "felixkratz/formulae"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}
