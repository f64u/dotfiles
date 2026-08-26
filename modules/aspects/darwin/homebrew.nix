{ inputs, ... }:
{
  den.aspects.homebrew =
    { user, ... }:
    {
      darwin = {
        imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = user.name;
          autoMigrate = true;
        };

        homebrew = {
          enable = true;

          # `zap` still removes anything not declared below, so the brew state
          # stays a function of this file. autoUpdate/upgrade are off: they
          # made every `darwin-rebuild switch` do a full network update and
          # upgrade, which is both slow and non-deterministic. Run
          # `brew update && brew upgrade` deliberately instead.
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = false;
          onActivation.upgrade = false;

          brews = [
            "gmp"
            "libuv"
          ];

          casks = [
            "docker-desktop"
            "dolphin"
            "firefox"
            # SF Pro / SF Mono are what the sketchybar config asks for by name
            # (see sketchybar/config/helpers/default_font.lua).
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
    };
}
