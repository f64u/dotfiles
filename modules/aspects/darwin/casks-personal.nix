# Personal-machine GUI apps. Included by macbook-pro, not macbook-pro-work.
{ lib, ... }:
{
  den.aspects.darwin-casks-personal.provides.to-users.homeManager =
    { pkgs, ... }:
    let
      pin = import ./_cask-pin.nix { inherit lib pkgs; };
    in
    {
      home.packages = map pin [
        "dolphin" # GameCube / Wii emulator
        "whisky" # Windows game compatibility layer
        "whatsapp"

        # Pinned in cask-hashes.json -- version-less upstream URLs.
        "minecraft"
        "steam"
      ];
    };
}
