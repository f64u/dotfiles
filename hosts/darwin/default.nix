{ config, pkgs, ... }: {
  imports = [
    ../../modules/darwin
  ];


  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
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


  environment = {
    etc = {
      terminfo = {
        source = "${pkgs.ncurses}/share/terminfo";
      };
    };

    systemPackages = with pkgs;
      [
        yabai
        skhd
        sketchybar
      ];
  };

  fonts.packages = with pkgs.nerd-fonts; [
    caskaydia-cove
    recursive-mono
  ];

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "fadyadal" ];
    };

    package = pkgs.nixVersions.stable;
    gc.automatic = true;
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    # linux-builder.enable = true;
  };

  programs = {
    # Create /etc/zshrc that loads the nix-darwin environment.
    zsh.enable = true;
    bash.enable = true;
    nix-index.enable = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
