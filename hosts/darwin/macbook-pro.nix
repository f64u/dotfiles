{ hostname, ... }: {
  # MacBook Pro specific configuration
  networking.computerName = "Fady's MacBook Pro";
  networking.hostName = hostname;

  system = {
    defaults.smb.NetBIOSName = hostname;
    defaults.dock.tilesize = 48; # Larger dock on Pro
    stateVersion = 4;
  };
}

