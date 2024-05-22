{ config, pkgs, ... }: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/yabai
    ../../modules/darwin/skhd
  ];

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    activationScripts.postActivation.text = ''
      su - fadyadal -c '${pkgs.skhd}/bin/skhd -r'
    '';

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
        nix
      ];
  };

  nix.package = pkgs.nix;
  nix.gc.automatic = true;
  nix.settings.trusted-users = [ "fadyadal" ];

  # Necessary for using flakes on this system.
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.linux-builder.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    enableFzfCompletion = true;
    enableFzfGit = true;
  };
  programs.bash.enable = true;
  # programs.fish.enable = true;
  programs.nix-index.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;


  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
