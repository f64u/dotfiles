# Homebrew itself, plus the casks wanted on every mac.
#
# Games and personal media live in darwin-homebrew-personal, which the work
# laptop deliberately does not include -- `onActivation.cleanup = "zap"` means
# this list is enforced, not merely suggested, so anything here really does
# get installed on every machine that includes it.
{ inputs, ... }:
{
  den.aspects.darwin-homebrew.darwin =
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

        # `zap` removes anything not declared, so brew state stays a function
        # of these files. autoUpdate/upgrade are nix-darwin defaults; stated
        # explicitly because turning them ON made every `darwin-rebuild
        # switch` do a full network update and upgrade, which is slow and
        # non-deterministic. Run `brew upgrade` deliberately.
        onActivation = {
          cleanup = "zap";
          autoUpdate = false;
          upgrade = false;
        };

        # TODO: neither of these has an identifiable consumer, and both are in
        # nixpkgs. Likely pre-nix leftovers -- remove once confirmed.
        brews = [
          "gmp"
          "libuv"
        ];

        casks = [
          # Development
          "docker-desktop"
          "ghostty"
          "rstudio"
          "smlnj"
          "xquartz"

          # Communication / meetings
          "slack"
          "zoom"

          # Browsers
          "firefox"
          "zen"

          # Documents and screen capture
          "licecap"
          "paintbrush"
          "shottr"
          "skim"

          # SF Pro / SF Mono are what the sketchybar config asks for by name
          # (see sketchybar/config/helpers/default_font.lua). Apple does not
          # redistribute these in a form nixpkgs can package.
          "font-sf-mono"
          "font-sf-pro"
        ];
      };
    };
}
