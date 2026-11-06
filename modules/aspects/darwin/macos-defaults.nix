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
        NSGlobalDomain = {
          _HIHideMenuBar = true;
          AppleInterfaceStyle = "Dark";
          # Shortest delay and fastest repeat that the System Settings sliders
          # allow (225ms and 30ms).
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          # Holding a key repeats it instead of opening the accent picker.
          ApplePressAndHoldEnabled = false;
        };
      };
    };

    # Display never sleeps on the charger, 5 minutes on battery. nix-darwin's
    # `power.sleep.display` is one value for both, so this goes through pmset
    # directly. `-c sleep 0` keeps the machine itself awake on the charger
    # too -- otherwise its 1-minute idle sleep can take the display with it.
    system.activationScripts.postActivation.text = ''
      pmset -c displaysleep 0 sleep 0
      pmset -b displaysleep 5
    '';

    # Authenticate `sudo` with Touch ID.
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
