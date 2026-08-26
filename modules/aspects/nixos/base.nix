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

      # Weekly. The age bound lives in modules/defaults.nix.
      nix.gc.dates = "weekly";

      services.openssh.enable = true;

      # Deliberately minimal: just enough to repair a system with no user
      # profile activated. git/curl/wget come from the user's packages-base,
      # and the editor from programs.neovim.
      environment.systemPackages = [ pkgs.vim ];
    };
}
