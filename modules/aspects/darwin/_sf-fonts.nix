# Apple's SF Pro / SF Mono, packaged for `fonts.packages`.
#
# NOTE the leading underscore: import-tree ignores any path containing `/_`,
# so this is a library file rather than an auto-imported flake-parts module.
#
# These were Homebrew casks. brew-nix does expose them, but badly: it picks
# the `pkg` unpack path (`xar -xf $src`) while Apple actually ships a DMG
# *containing* a pkg, so the build dies with "Error opening xar archive". And
# a cask lands its payload in $out/Library/Fonts, which is not where
# fonts.packages looks. Packaging them directly is both simpler and correct.
#
# Apple serves these from version-less URLs and overwrites in place, so the
# hashes below go stale on Apple's schedule. A hash mismatch is the expected
# signal; refresh with:
#
#   nix store prefetch-file --json <url> | python3 -c 'import json,sys;print(json.load(sys.stdin)["hash"])'
{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  xarMinimal,
  cpio,
  gzip,
}:
let
  mkSfFont =
    {
      pname,
      url,
      hash,
    }:
    stdenvNoCC.mkDerivation {
      inherit pname;
      version = "unstable";

      src = fetchurl { inherit url hash; };

      nativeBuildInputs = [
        undmg
        xarMinimal
        cpio
        gzip
      ];

      # DMG -> outer flat pkg -> component pkg Payload (gzip cpio).
      sourceRoot = ".";
      unpackPhase = ''
        runHook preUnpack
        undmg "$src"
        xar -xf *.pkg
        for payload in */Payload; do
          zcat "$payload" | cpio -i --quiet
        done
        runHook postUnpack
      '';

      # Both .otf and .ttf: the static OTFs carry the "SF Pro Text" /
      # "SF Pro Display" families, but the plain "SF Pro" family lives only in
      # the variable SF-Pro.ttf. Filtering to *.otf drops it.
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/share/fonts/opentype" "$out/share/fonts/truetype"
        find Library/Fonts -name '*.otf' -exec cp {} "$out/share/fonts/opentype/" \;
        find Library/Fonts -name '*.ttf' -exec cp {} "$out/share/fonts/truetype/" \;
        runHook postInstall
      '';

      meta = {
        description = "Apple ${pname} typeface";
        homepage = "https://developer.apple.com/fonts/";
        # Apple's own license; redistribution is restricted, which is why
        # nixpkgs does not carry these.
        license = lib.licenses.unfree;
        platforms = lib.platforms.darwin;
      };
    };
in
{
  sf-pro = mkSfFont {
    pname = "sf-pro";
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    hash = "sha256-qQlPDem3idc1RO5Q/FKgiE1Kn3/PYt5Sl04yBPOnSmI=";
  };

  sf-mono = mkSfFont {
    pname = "sf-mono";
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };
}
