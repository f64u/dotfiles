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
      "licecap"
      "minecraft"
      "paintbrush"
      "rstudio"
      "r"
      "shottr"
      "smlnj"
      "spacelauncher"
      "steam"
      "vmware-fusion"
      "whisky"
      "xquartz"
      "zoom"
    ];

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}
