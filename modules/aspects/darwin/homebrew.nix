{ inputs, ... }:
{
  den.aspects.homebrew.darwin =
    { config, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        enableRosetta = true;

        # The primary user owns the brew prefix, and it is set by
        # den.batteries.primary-user.
        #
        # NOTE: this deliberately is not a `{ user, ... }` parametric aspect.
        # den fans those out once per user and emits each copy on the host, so
        # on a two-user machine this single-owner option gets two conflicting
        # definitions and evaluation fails.
        user = config.system.primaryUser;
        autoMigrate = true;
      };

      homebrew = {
        enable = true;

        # `zap` removes anything not declared below, so brew state stays a
        # function of this file. autoUpdate/upgrade are nix-darwin defaults;
        # stated explicitly because turning them ON made every
        # `darwin-rebuild switch` do a full network update and upgrade, which
        # is slow and non-deterministic. Run `brew upgrade` deliberately.
        onActivation = {
          cleanup = "zap";
          autoUpdate = false;
          upgrade = false;
        };

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
}
