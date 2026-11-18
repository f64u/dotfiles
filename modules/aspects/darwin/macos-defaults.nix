# macOS UI and input settings.
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
        # Auto-hide the menu bar; sketchybar sits above it (alt-m reveals it).
        NSGlobalDomain = {
          _HIHideMenuBar = true;
          AppleInterfaceStyle = "Dark";
          # The fastest the System Settings sliders allow.
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          # Holding a key repeats it instead of opening the accent picker.
          ApplePressAndHoldEnabled = false;
        };
      };
    };

    # Display: never sleeps on the charger, 5 minutes on battery. pmset,
    # because nix-darwin has one value for both. `-c sleep 0` stops the
    # machine's idle sleep taking the display with it.
    system.activationScripts.postActivation.text = ''
      pmset -c displaysleep 0 sleep 0
      pmset -b displaysleep 5
    '';

    # Authenticate `sudo` with Touch ID, inside tmux too (pam_reattach).
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      reattach = true;
    };
  };
}
