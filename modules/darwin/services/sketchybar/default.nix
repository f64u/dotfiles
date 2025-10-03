{ pkgs, config, ... }:
let
  sketchybarConfig = pkgs.stdenv.mkDerivation {
    name = "sketchybar-config-v0.1.0";
    src = ./config;
    buildPhase = ''
      make -C ./helpers
    '';
    installPhase = ''
      cp -r . $out
    '';
  };
in
{
  launchd.user.agents.sketchybar =
    {
      path = [ pkgs.sketchybar pkgs.lua5_4 pkgs.gnumake "/usr/bin" "/usr/sbin" ] ++ config.environment.systemPackages;
      environment = {
        LUA_PATH = "${sketchybarConfig}/?.lua;${sketchybarConfig}/?/?.lua;;";
      };
      command = "sketchybar --config ${sketchybarConfig}/sketchybarrc";

      serviceConfig =
        {
          KeepAlive = true;
          StandardErrorPath = "/tmp/sketchybar.stderr.log";
          StandardOutPath = "/tmp/sketchybar.stdout.log";
        };
    };
}
