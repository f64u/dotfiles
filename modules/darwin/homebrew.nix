{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [
      {
        name = "gmp";
        link = true;
      }
      "libuv"
    ];

    casks = [
      "dolphin"
      "firefox"
      "font-sf-mono"
      "font-sf-pro"
      "nvidia-geforce-now"
      "licecap"
      "minecraft"
      "paintbrush"
      "rstudio"
      "shottr"
      "smlnj"
      "spotify"
      "steam"
      "vmware-fusion"
      "whisky"
      "xquartz"
      "zen"
      "zoom"
    ];

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
  };
}
