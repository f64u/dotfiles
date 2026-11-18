# Shared by darwin/casks.nix and darwin/casks-personal.nix.
#
# Casks served from a version-less URL have no upstream checksum; take the
# hash from ./cask-hashes.json, asserting the URL still matches.
#
# Also strips `name:attr` files that unzip writes for extended attributes:
# they break the code signature and Gatekeeper kills the app.
{ lib, pkgs }:
let
  pins = lib.filterAttrs (n: _: n != "_comment") (lib.importJSON ./cask-hashes.json);
in
name:
let
  cask = pkgs.brewCasks.${name}.overrideAttrs (old: {
    installPhase = ''
      find . -name '*:com.*' -print -delete
    ''
    + old.installPhase;
  });
  spec = pins.${name};
in
if !(pins ? ${name}) then
  cask
else
  cask.overrideAttrs (old: {
    src =
      let
        upstream = builtins.head old.src.urls;
      in
      assert lib.assertMsg (upstream == spec.url) ''
        cask-hashes.json is stale for "${name}":
          recorded: ${spec.url}
          brew-api: ${upstream}
        The pinned hash belongs to a different URL. Re-pin with:
          ./scripts/refresh-cask-hashes.sh ${name}
      '';
      pkgs.fetchurl {
        url = upstream;
        inherit (spec) hash;
      };
  })
