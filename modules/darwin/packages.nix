{ pkgs, ... }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  # XXX: yabai & skhd are installed system-wide
  aldente
  lima
  skimpdf
  utm
]
