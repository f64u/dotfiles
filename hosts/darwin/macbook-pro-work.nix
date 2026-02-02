{ hostname, ... }: {
  # MacBook Air specific configuration
  networking.computerName = "Fady's MacBook Air";
  networking.hostName = hostname;

  system = {
    defaults.smb.NetBIOSName = hostname;
    stateVersion = 5;
  };

}

