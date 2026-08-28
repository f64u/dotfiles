# The graphical desktop: tiling window manager, status bar, and the menu-bar
# utilities that go with them.
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
        # aerospace's exec-on-workspace-change hook reaches sketchybar through
        # /run/current-system/sw/bin, so it needs a system copy. This one is
        # unwrapped -- home-manager installs a wrapper carrying LUA_PATH, and
        # that is the one that must handle anything loading the Lua config.
        #
        # aerospace itself is absent on purpose: services.aerospace already
        # adds its own cfg.package.
        environment.systemPackages = [ pkgs.sketchybar ];
      };

    # Host-scope `homeManager` is inert in den; home content for this host's
    # users goes through provides.to-users.
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          aldente # battery charge limiter
          maccy # clipboard history
          raycast # launcher
        ];

        # Spotlight does not index symlinks, so `linkApps` (the default at
        # stateVersion 23.11) leaves every GUI app unfindable -- including
        # Raycast. copyApps rsyncs real bundles instead, and asserts
        # !linkApps.enable, so both lines are required.
        targets.darwin.linkApps.enable = false;
        targets.darwin.copyApps.enable = true;
      };
  };
}
