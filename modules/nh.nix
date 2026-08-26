# Exposes a flake package per host/home so you can build or switch with nh:
#
#   nix run .#macbook-pro            # build (default action)
#   nix run .#macbook-pro -- switch
{ den, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
    };
}
