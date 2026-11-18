# Apple's SF Pro / SF Mono for `fonts.packages`. Not casks: brew-nix
# unpacks them wrongly and installs to the wrong directory.
#
# The URLs are version-less, so a hash mismatch means Apple updated them:
#
#   nix store prefetch-file --json <url> | python3 -c 'import json,sys;print(json.load(sys.stdin)["hash"])'
{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
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
        _7zz
        xarMinimal
        cpio
        gzip
      ];

      # DMG -> flat pkg -> Payload (gzip cpio). 7zz because undmg can't read APFS.
      sourceRoot = ".";
      unpackPhase = ''
        runHook preUnpack
        7zz e -r "$src" "*.pkg" >/dev/null
        xar -xf ./*.pkg
        for payload in */Payload; do
          zcat "$payload" | cpio -i --quiet
        done
        runHook postUnpack
      '';

      # .ttf too: the plain "SF Pro" family exists only in the variable SF-Pro.ttf.
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
        # Apple's license restricts redistribution.
        license = lib.licenses.unfree;
        platforms = lib.platforms.darwin;
      };
    };
in
{
  sf-pro = mkSfFont {
    pname = "sf-pro";
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    hash = "sha256-sn/mYi8fqWpwfHPcpmZtQ5w1sxLVsdR+DimA5hjrSyg=";
  };

  sf-mono = mkSfFont {
    pname = "sf-mono";
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };
}
