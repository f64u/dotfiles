{ hostname, ... }: {
  # MacBook Air specific configuration
  networking.computerName = "Fady's MacBook Air";
  networking.hostName = "macbook-air";
  system.defaults.smb.NetBIOSName = "macbook-air";
  
  # System-specific package overrides
  # You can override packages here if needed for this specific machine
}