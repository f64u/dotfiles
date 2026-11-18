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

        # `pkgs.brewCasks.*`; home-manager shares this package set.
        nixpkgs.overlays = [ inputs.brew-nix.overlays.default ];

        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];

            # Root-equivalent, so derived from the host's users. Account names, not
            # den attribute names.
            trusted-users = map (u: u.userName) (lib.attrValues host.users);
          };

          # Without `options`, `automatic` deletes no generations and so frees
          # nothing. The schedule is per platform, below.
          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };

          optimise.automatic = true;
        };

        # Do NOT add `useUserPackages = true`: nix-darwin does not put
        # /etc/profiles/per-user on PATH, so every user package disappears.
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
        # Sunday 03:00.
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
