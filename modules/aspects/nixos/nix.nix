# The nix daemon itself on NixOS. The counterpart to darwin/nix.nix.
#
# GC policy is shared with darwin and lives in modules/defaults.nix.
{
  den.aspects.nixos-nix.nixos =
    { pkgs, ... }:
    {
      nix.package = pkgs.nixVersions.stable;

      # Deliberately minimal: just enough to repair a system whose user
      # profile has not been activated. git/curl/wget come from the user's
      # packages-base, and the real editor from programs.neovim.
      environment.systemPackages = [ pkgs.vim ];
    };
}
