# Shared by darwin/casks.nix and darwin/casks-personal.nix. The leading
# underscore keeps import-tree from auto-importing it as a module.
#
# Casks the vendor serves from a version-less URL carry no upstream checksum,
# and brew-nix surfaces that as a `sha256-AAAA...` placeholder that cannot
# build. Substitute a hash from ./cask-hashes.json, asserting the recorded URL
# still matches so a URL change fails loudly rather than pinning the wrong
# artifact.
{ lib, pkgs }:
let
  pins = lib.filterAttrs (n: _: n != "_comment") (lib.importJSON ./cask-hashes.json);
in
name:
let
  cask = pkgs.brewCasks.${name};
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
