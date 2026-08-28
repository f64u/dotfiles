# Helper shared by darwin/casks.nix and darwin/casks-personal.nix.
#
# NOTE the leading underscore: import-tree ignores any path containing `/_`,
# so this is a plain library file rather than an auto-imported flake-parts
# module.
#
# Some casks carry no upstream checksum -- Homebrew marks them
# `sha256 :no_check` because the vendor serves them from a version-less URL
# and overwrites the file in place. brew-nix surfaces that as a
# `sha256-AAAA...` placeholder which cannot build. This substitutes a hash
# recorded in ./cask-hashes.json, and asserts the recorded URL still matches
# what brew-api reports so that an upstream URL change fails loudly instead of
# silently pinning the wrong artifact.
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
