{ pkgs, config, ... }:
let configPath = "/Users/fadyadal/.config/nix/modules/darwin/sketchybar/config"; in
{
  launchd.user.agents.sketchybar =
    {
      path = [ pkgs.sketchybar pkgs.lua5_4 pkgs.gnumake ] ++ config.environment.systemPackages;
      environment = {
        LUA_PATH = "${configPath}/?.lua;${configPath}/?/?.lua;;";
      };
      command = "sketchybar --config ${configPath}/sketchybarrc";

      serviceConfig =
        {
          KeepAlive = true;
          StandardErrorPath = "/tmp/sketchybar.stderr.log";
          StandardOutPath = "/tmp/sketchybar.stdout.log";
        };
    };
}
