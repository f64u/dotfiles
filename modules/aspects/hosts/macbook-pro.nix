{ den, ... }:
{
  den.aspects.macbook-pro = {
    includes = [ den.aspects.darwin-base ];

    darwin = {
      networking.computerName = "Fady's MacBook Pro";

      system = {
        defaults.smb.NetBIOSName = "macbook-pro";
        defaults.dock.tilesize = 48; # Larger dock on Pro
        stateVersion = 4;
      };
    };

    # Extra packages for this host's users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.tailscale ];
      };
  };
}
