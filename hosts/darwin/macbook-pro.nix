{ hostname, ... }: {
  # MacBook Pro specific configuration
  networking.computerName = "Fady's MacBook Pro";
  networking.hostName = "macbook-pro";
  system.defaults.smb.NetBIOSName = "macbook-pro";
  
  # Example: Different hostname-specific settings
  # You might want different dock settings, different apps, etc.
  system.defaults.dock.tilesize = 48;  # Larger dock on Pro
}