{ ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [
      "gmp"
      "libuv"
    ];

    casks = [
      "dolphin"
      "firefox"
      "font-sf-mono"
      "font-sf-pro"
      "ghostty"
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
      "whatsapp"
      "whisky"
      "xquartz"
      "zen"
      "zoom"
    ];
  };
}
