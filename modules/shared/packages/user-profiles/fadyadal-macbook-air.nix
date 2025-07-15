# Package profile for fadyadal on macbook-air
{ pkgs }:

let
  base-packages = import ../base.nix { inherit pkgs; };
  development-packages = import ../development.nix { inherit pkgs; };
  media-packages = import ../media.nix { inherit pkgs; };
in
base-packages ++ development-packages ++ media-packages ++ [
  # Additional packages specific to fadyadal on macbook-air
  pkgs.claude-code
  pkgs.nmap
]