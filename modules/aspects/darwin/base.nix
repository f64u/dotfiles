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
        # Re-declare the entries macOS and Homebrew already put there so the
        # generated file stays a superset of the original.
        environment.shells = [
          "/bin/bash"
          "/bin/csh"
          "/bin/dash"
          "/bin/ksh"
          "/bin/sh"
          "/bin/tcsh"
          "/bin/zsh"
          "/opt/homebrew/bin/zsh"
          "/opt/homebrew/bin/fish"
          "/opt/homebrew/bin/nu"
          "/usr/local/bin/pwsh"
        ];

        security.pam.services.sudo_local.touchIdAuth = true;

        nix = {
          enable = true;
          package = pkgs.nixVersions.stable;
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
