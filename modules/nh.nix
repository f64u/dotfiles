# Exposes a flake package per host so you can build or switch with nh:
#
#   nix run .#macbook-pro            # build (default action)
#   nix run .#macbook-pro -- switch
{ den, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # denPackages flattens every host regardless of the perSystem system,
      # which put both MacBooks into packages.x86_64-linux. Keep only the
      # hosts that actually belong to this system.
      mine = (den.hosts.${system} or { }) // (den.homes.${system} or { });
    in
    {
      packages = lib.filterAttrs (n: _: mine ? ${n}) (den.lib.nh.denPackages { fromFlake = true; } pkgs);
    };
}
