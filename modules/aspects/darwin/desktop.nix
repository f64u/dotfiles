# The graphical desktop: tiling window manager, status bar, and the menu-bar
# utilities that go with them.
{ den, ... }:
{
  den.aspects.darwin-desktop = {
    includes = [
      den.aspects.aerospace
      den.aspects.sketchybar
    ];

    # aerospace and sketchybar are needed system-wide, not just in a user
    # profile: aerospace's exec-on-workspace-change hook calls sketchybar
    # through /run/current-system/sw/bin.
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          aerospace
          sketchybar
        ];
      };

    # Host-scope `homeManager` is inert in den, so home content aimed at this
    # host's users goes through provides.to-users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          aldente # battery charge limiter
          maccy # clipboard history
          raycast # launcher
        ];
      };
  };
}
