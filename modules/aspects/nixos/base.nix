# Shared NixOS configuration — included by every nixos host aspect.
{
  den.aspects.nixos-base.nixos =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;
      time.timeZone = "America/New_York"; # Adjust as needed

      nix.package = pkgs.nixVersions.stable;

      services.openssh.enable = true;

      # Basic system packages
      environment.systemPackages = with pkgs; [
        vim
        git
        curl
        wget
      ];
    };
}
