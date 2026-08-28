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
        # Only sketchybar needs a system copy: aerospace's
        # exec-on-workspace-change hook calls it through
        # /run/current-system/sw/bin to --trigger the running daemon.
        #
        # NOTE: aerospace is NOT listed here -- services.aerospace already adds
        # its own `cfg.package`, and duplicating it decouples the installed
        # binary from that option.
        #
        # This system sketchybar is the *unwrapped* one. home-manager installs
        # a wrapper carrying LUA_PATH/LUA_CPATH plus the aerospace /
        # nowplaying-cli / switchaudio-osx PATH, and its profile comes first in
        # environment.profiles, so interactive use gets the wrapper. Never
        # invoke the system path for anything that loads the Lua config
        # (`--reload`) -- it has no SbarLua on LUA_PATH.
        environment.systemPackages = [ pkgs.sketchybar ];
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

        # Put GUI apps where Spotlight can index them.
        #
        # At home.stateVersion 23.11 home-manager defaults to `linkApps`, which
        # populates ~/Applications/Home Manager Apps with *symlinks into the
        # store* -- and Spotlight does not index those, so nothing in
        # home.packages was findable by Spotlight or Raycast (which is itself
        # installed this way). `copyApps` rsyncs real bundles instead.
        #
        # Both lines are required: copyApps asserts !linkApps.enable.
        targets.darwin.linkApps.enable = false;
        targets.darwin.copyApps.enable = true;
      };
  };
}
