{ pkgs, ... }:
{
  launchd.user.agents.sketchybar =
    {
      path = [ pkgs.sketchybar ];
      script = ''
        ${pkgs.sketchybar} --config ${./config/sketchybarrc}
      '';

      serviceConfig =
        {
          KeepAlive = true;
          StandardErrorPath = "/tmp/sketchybar.stderr.log";
          StandardOutPath = "/tmp/sketchybar.stdout.log";
        };
    };
}
