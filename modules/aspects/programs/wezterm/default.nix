{
  den.aspects.programs-wezterm.homeManager =
    { pkgs, ... }:
    {
      programs.wezterm.enable = true;

      # wezterm.lua stays a standalone, lintable Lua file ending in
      # `return config`. replaceVars uses --replace-fail, so dropping the
      # @zsh@ placeholder fails the build rather than silently shipping a
      # broken config.
      xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {
        zsh = "${pkgs.zsh}/bin/zsh";
      };
    };
}
