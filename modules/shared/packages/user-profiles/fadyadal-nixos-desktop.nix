# Package profile for fadyadal on nixos-desktop
{ pkgs }:

let
  base-packages = import ../base.nix { inherit pkgs; };
  development-packages = import ../development.nix { inherit pkgs; };
  media-packages = import ../media.nix { inherit pkgs; };
in
base-packages ++ development-packages ++ media-packages ++ [
  # Additional packages specific to fadyadal on NixOS desktop
  pkgs.claude-code
  pkgs.nmap
  # NixOS-specific packages
  pkgs.firefox  # Different browser choice on Linux
]