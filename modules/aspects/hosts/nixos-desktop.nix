{ den, ... }:
{
  den.aspects.nixos-desktop = {
    includes = [ den.aspects.nixos-base ];

    # TODO: this host has never had a hardware configuration. Generate one on
    # the machine (`nixos-generate-config --show-hardware-config`), drop it in
    # ./nixos-desktop-hardware.nix and import it here:
    #
    #   nixos.imports = [ ./nixos-desktop-hardware.nix ];
    #
    # Until then `nixosConfigurations.nixos-desktop` fails the
    # "fileSystems option does not specify your root file system" assertion.

    # Extra packages for this host's users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.firefox ]; # Different browser choice on Linux
      };
  };
}
