# Common NixOS configuration
{ config, pkgs, ... }: {
  imports = [
    ../../modules/nixos
  ];

  # Basic NixOS settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";  # Adjust as needed

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "fadyadal" ];
    };
    package = pkgs.nixVersions.stable;
    gc.automatic = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable common services
  services.openssh.enable = true;

  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  system.stateVersion = "24.05"; # Adjust based on your NixOS version
}