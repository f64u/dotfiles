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
        gc.automatic = true;
      };

      # home-manager is evaluated with the host's nixpkgs, so `allowUnfree`
      # above covers user packages too.
      home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "bak";
      };
    };

    includes = [
      # networking.hostName from den.hosts.<...>.hostName
      den.batteries.hostname
      # users.users.<name> + home.username / home.homeDirectory
      den.batteries.define-user
    ];
  };
}
