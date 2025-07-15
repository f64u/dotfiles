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
      "slack"
      "smlnj"
      "spotify"
      "steam"
      "whisky"
      "xquartz"
      "zen"
      "zoom"
    ];
  };
}
