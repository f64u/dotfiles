{ inputs, ... }:
{
  den.aspects.homebrew.darwin = {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "fadyadal";
      autoMigrate = true;
    };

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
        "docker-desktop"
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
        "skim"
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
  };
}
