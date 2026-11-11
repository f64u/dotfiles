# Settings applied to every host / user / home.
{
  den,
  inputs,
  lib,
  ...
}:
{
  den.default = {
    homeManager = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      home = {
        # Do not bump casually.
        stateVersion = "23.11";
        enableNixpkgsReleaseCheck = false;
      };

      # Programs opt in one by one, next to their own config.
      catppuccin = {
        enable = true;
        autoEnable = false;
        flavor = "mocha";
      };
    };

    # `os` forwards to both nixos and darwin; only darwin hosts exist today.
    os =
      { host, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        # `pkgs.brewCasks.*`. At OS level because home-manager runs with
        # useGlobalPkgs and shares this package set.
        nixpkgs.overlays = [ inputs.brew-nix.overlays.default ];

        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];

            # trusted-user is root-equivalent, so derive it from the host's
            # own user list rather than naming anyone here.
            trusted-users = builtins.attrNames host.users;
          };

          # `options` is load-bearing: it defaults to "", and bare
          # `nix-collect-garbage` only removes unreachable paths -- it never
          # deletes generations, and every retained generation roots its whole
          # closure. Without the age bound, `automatic` collects nothing.
          #
          # Only the schedule is platform-specific (below), because launchd
          # and systemd spell it differently.
          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };

          optimise.automatic = true;
        };

        # home-manager is evaluated with the host's nixpkgs, so `allowUnfree`
        # above covers user packages too.
        #
        # Do NOT add `useUserPackages = true`. It moves home.packages into
        # /etc/profiles/per-user/$USER, which NixOS puts on PATH via
        # environment.profiles and nix-darwin does not -- so on darwin every
        # user package silently disappears from the shell.
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "bak";
        };
      };

    darwin =
      { host, ... }:
      let
        accounts = lib.filter (u: u ? uid) (lib.attrValues host.users);
      in
      {
        # Sunday 03:00. If a NixOS host comes back, its counterpart is
        # `nixos.nix.gc.dates = "Sun *-*-* 03:00:00";`.
        nix.gc.interval = {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        };

        system.defaults.smb.NetBIOSName = host.hostName;

        # nix-darwin only manages accounts it's told about.
        users.knownUsers = map (u: u.userName) accounts;
        users.users = lib.genAttrs' accounts (
          u:
          lib.nameValuePair u.userName {
            inherit (u) uid;
            isHidden = false;
          }
        );
      };

    includes = [
      # networking.hostName from den.hosts.<...>.hostName
      den.batteries.hostname
      # users.users.<name> + home.username / home.homeDirectory
      den.batteries.define-user
    ];
  };
}
