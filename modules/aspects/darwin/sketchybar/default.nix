{
  den.aspects.darwin-sketchybar.provides.to-users.homeManager =
    { pkgs, ... }:
    let
      sketchybarConfig = pkgs.stdenv.mkDerivation {
        name = "sketchybar-config";
        src = ./config;
        nativeBuildInputs = [ pkgs.gnumake ];
        buildPhase = ''
          runHook preBuild
          make -C ./helpers
          runHook postBuild
        '';
        # The app -> glyph map comes from the same font package that
        # darwin/fonts.nix installs, so the two can't drift apart.
        installPhase = ''
          runHook preInstall
          cp -r . $out
          cp ${pkgs.sketchybar-app-font}/lib/sketchybar-app-font/icon_map.lua $out/helpers/app_icons.lua
          runHook postInstall
        '';
      };
    in
    {
      programs.sketchybar = {
        enable = true;
        config = {
          source = sketchybarConfig;
          recursive = true;
        };
        configType = "lua";

        # Runtime dependencies of the lua config. `gnumake` used to be here
        # because helpers/init.lua re-ran `make` on every launch -- the
        # derivation above builds the helpers instead, so it is not needed.
        extraPackages = with pkgs; [
          aerospace # items/spaces.lua queries workspaces
          nowplaying-cli # items/media.lua transport controls
          switchaudio-osx # items/widgets/volume.lua device switcher
        ];
      };
    };
}
