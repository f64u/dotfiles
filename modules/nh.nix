# Exposes a flake package per host so you can build or switch with nh:
#
#   nix run .#macbook-pro            # build (default action)
#   nix run .#macbook-pro -- switch
{ den, lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      # denPackages lists every host; keep this system's.
      mine = (den.hosts.${system} or { }) // (den.homes.${system} or { });
    in
    {
      packages = lib.filterAttrs (n: _: mine ? ${n}) (den.lib.nh.denPackages { fromFlake = true; } pkgs);
    };
}
