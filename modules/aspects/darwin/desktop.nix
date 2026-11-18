# The graphical desktop: window manager, status bar, menu-bar utilities.
{ den, ... }:
{
  den.aspects.darwin-desktop = {
    includes = [
      den.aspects.darwin-aerospace
      den.aspects.darwin-sketchybar
    ];

    darwin =
      { pkgs, ... }:
      {
        # aerospace calls sketchybar from /run/current-system/sw/bin. Unwrapped;
        # the home-manager one carries LUA_PATH and loads the config. aerospace
        # itself comes from services.aerospace.
        environment.systemPackages = [ pkgs.sketchybar ];
      };

    # Host-scope `homeManager` is inert in den; use provides.to-users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          aldente # battery charge limiter
          maccy # clipboard history
          raycast # launcher
        ];

        # copyApps would roll a self-update back, and the older build can't
        # open databases the newer one migrated.
        targets.darwin.defaults."com.raycast.macos".DisableAutomaticUpdates = true;

        # Spotlight does not index symlinks, so copy the apps. copyApps asserts
        # !linkApps.enable; both lines are required.
        targets.darwin.linkApps.enable = false;
        targets.darwin.copyApps.enable = true;
      };
  };
}
