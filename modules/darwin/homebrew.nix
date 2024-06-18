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
      "font-sf-mono"
      "font-sf-pro"
      "minecraft"
      "shottr"
      "smlnj"
      "steam"
    ];

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}
