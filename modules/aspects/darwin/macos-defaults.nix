# macOS UI and input behaviour -- the settings you would otherwise click
# through in System Settings.
{
  den.aspects.darwin-macos-defaults.darwin = {
    system = {
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
        # Auto-hide the menu bar; sketchybar takes its place, drawn above it
        # (alt-m reveals it -- see sketchybar's items/menubar.lua).
        NSGlobalDomain._HIHideMenuBar = true;
      };
    };

    # Authenticate `sudo` with Touch ID.
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
