# Settings applied to every host / user / home.
{ den, inputs, ... }:
{
  den.default = {
    # State versions — do not bump these casually.
    homeManager.home.stateVersion = "23.11";

    # `os` forwards to both nixos and darwin; only darwin hosts exist today.
    os =
      { host, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        # `pkgs.brewCasks.*`. Applied at the OS level rather than per-home
        # because home-manager runs with useGlobalPkgs, so it shares this
        # package set.
        nixpkgs.overlays = [ inputs.brew-nix.overlays.default ];

        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];

            # Derived from the host's own user list rather than hardcoding a
            # name in the every-host module. trusted-user is root-equivalent,
            # so it should not be granted from the least local place.
            trusted-users = builtins.attrNames host.users;
          };

          # Garbage collection. The whole policy lives here rather than being
          # split across the platform aspects.
          #
          # `automatic` and `options` are platform-neutral; only the *schedule*
          # differs, and only because launchd and systemd spell it differently
          # -- nix-darwin takes `gc.interval`, a launchd StartCalendarInterval
          # dict, while NixOS takes `gc.dates`, a systemd OnCalendar string.
          # Both already default to a sane schedule, so the one below states
          # intent rather than fixing anything.
          #
          # `options` is the part that actually mattered: it defaults to "",
          # and bare `nix-collect-garbage` only removes unreachable paths. It
          # never deletes old generations, and every retained generation roots
          # its whole closure -- which is how 125 generations and 199 GB of
          # store accumulated under `automatic = true`.
          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };

          optimise.automatic = true;
        };

        # home-manager is evaluated with the host's nixpkgs, so `allowUnfree`
        # above covers user packages too.
        #
        # NOTE: do NOT set `useUserPackages = true` here. That is a NixOS
        # convention: it moves home.packages out of ~/.nix-profile and into
        # /etc/profiles/per-user/$USER, which NixOS adds to
        # `environment.profiles` but **nix-darwin does not**. On darwin the
        # result is that every user package silently leaves PATH -- verified
        # the hard way: `atuin`, `eza` and the rest vanished from the shell
        # while sitting installed in /etc/profiles/per-user/fadyadal/bin.
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "bak";
        };
      };

    # Sunday 03:00. If a NixOS host comes back, its counterpart is
    # `nixos.nix.gc.dates = "Sun *-*-* 03:00:00";`.
    darwin.nix.gc.interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };

    includes = [
      # networking.hostName from den.hosts.<...>.hostName
      den.batteries.hostname
      # users.users.<name> + home.username / home.homeDirectory
      den.batteries.define-user
    ];
  };
}
