# Legacy default.nix - use common.nix + specific configs instead
{ ... }:
{
  imports = [
    ./common.nix
    ./macbook-pro.nix
  ];
}
