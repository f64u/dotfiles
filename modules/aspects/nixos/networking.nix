# Network stack, remote access, and clock.
{
  den.aspects.nixos-networking.nixos = {
    networking.networkmanager.enable = true;
    time.timeZone = "America/New_York";

    services.openssh.enable = true;
  };
}
