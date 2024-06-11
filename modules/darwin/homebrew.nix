{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    brews = [
      "gmp"
    ];

    casks = [
      "1password"
      "firefox"
      "font-caskaydia-cove-nerd-font"
      "font-sf-mono"
      "font-sf-pro"
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
