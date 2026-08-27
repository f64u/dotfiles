# Settings applied to every host / user / home.
{ den, ... }:
{
  den.default = {
    # State versions — do not bump these casually.
    nixos.system.stateVersion = "24.05";
    homeManager.home.stateVersion = "23.11";

    # Shared across nixos + darwin (the `os` class forwards to both).
    os = {
      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [ "fadyadal" ];
        };

        # Garbage collection. The whole policy lives here rather than being
        # split across the platform aspects.
        #
        # `automatic` and `options` are shared; only the *schedule* differs by
        # platform, and only because launchd and systemd spell it differently
        # -- nix-darwin takes `gc.interval`, a launchd StartCalendarInterval
        # dict, and NixOS takes `gc.dates`, a systemd OnCalendar string. Both
        # already default to a sane schedule, so the schedules are set below
        # purely to state the intent in one visible place.
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
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "bak";
      };
    };

    # Sunday 03:00 on both platforms -- see the note above for why the
    # schedule has to be spelled twice while the rest of the policy does not.
    darwin.nix.gc.interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    nixos.nix.gc.dates = "Sun *-*-* 03:00:00";

    includes = [
      # networking.hostName from den.hosts.<...>.hostName
      den.batteries.hostname
      # users.users.<name> + home.username / home.homeDirectory
      den.batteries.define-user
    ];
  };
}
