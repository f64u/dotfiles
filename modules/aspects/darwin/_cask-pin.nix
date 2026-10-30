# Shared by darwin/casks.nix and darwin/casks-personal.nix. The leading
# underscore keeps import-tree from auto-importing it as a module.
#
# Casks the vendor serves from a version-less URL carry no upstream checksum,
# and brew-nix surfaces that as a `sha256-AAAA...` placeholder that cannot
# build. Substitute a hash from ./cask-hashes.json, asserting the recorded URL
# still matches so a URL change fails loudly rather than pinning the wrong
# artifact.
#
# Every cask also gets its `name:attr` files stripped. Some vendor zips carry
# extended attributes (Shottr's has `com.dropbox.attrs`), and brew-nix's
# `unzip` path writes each one out as a stray `file:attr` file inside the
# bundle. That breaks the code signature, and Gatekeeper SIGKILLs the app a
# few seconds after launch. brew-nix already does this cleanup after 7zz.
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
