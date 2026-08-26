# Shared nix-darwin configuration — included by every darwin host aspect.
{ den, ... }:
{
  den.aspects.darwin-base = {
    includes = [
      den.aspects.homebrew
      den.aspects.aerospace
      den.aspects.sketchybar
    ];

    # macOS-only GUI apps. Host-scope `homeManager` is inert in den, so
    # home content aimed at this host's users goes through provides.to-users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          aldente
          maccy
          raycast
        ];
      };

    darwin =
      { config, pkgs, ... }:
      {
        system = {
          # Set Git commit hash for darwin-version.
          configurationRevision = config.rev or config.dirtyRev or null;

          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToControl = true;
          };

          defaults = {
            # minimal dock
            dock = {
              autohide = true;
              orientation = "bottom";
              show-process-indicators = false;
              show-recents = false;
              static-only = true;
            };
            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
              FXEnableExtensionChangeWarning = false;
            };
          };
        };

        environment.systemPackages = with pkgs; [
          aerospace
          sketchybar
        ];

        fonts.packages = with pkgs.nerd-fonts; [
          caskaydia-cove
          recursive-mono
        ];

        # den's user-shell battery sets environment.shells, which makes
        # nix-darwin take ownership of /etc/shells and rewrite it wholesale.
        # Re-declare the stock macOS entries so the generated file stays a
        # superset of the original.
        #
        # NOTE: the Homebrew-installed fish/nu/pwsh entries that used to be
        # here are gone -- none of those shells is installed by this config,
        # so /etc/shells was advertising paths that do not exist.
        environment.shells = [
          "/bin/bash"
          "/bin/csh"
          "/bin/dash"
          "/bin/ksh"
          "/bin/sh"
          "/bin/tcsh"
          "/bin/zsh"
        ];

        security.pam.services.sudo_local.touchIdAuth = true;

        nix = {
          enable = true;
          package = pkgs.nixVersions.stable;

          # Sunday 03:00. The age bound lives in modules/defaults.nix.
          gc.interval = {
            Weekday = 0;
            Hour = 3;
            Minute = 0;
          };

          extraOptions = ''
            extra-platforms = x86_64-darwin aarch64-darwin
          '';
        };

        programs = {
          # Create /etc/zshrc that loads the nix-darwin environment.
          zsh.enable = true;
          bash.enable = true;

          nix-index.enable = true;
        };
      };
  };
}
