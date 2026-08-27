{
  den.aspects.wezterm.homeManager =
    { pkgs, ... }:
    {
      programs.wezterm.enable = true;

      # wezterm.lua stays a standalone, lintable Lua file that ends in
      # `return config`; @zsh@ is substituted at build time.
      #
      # NOTE: this replaces a `builtins.replaceStrings [ "return config" ] [ "" ]`
      # splice into programs.wezterm.extraConfig. That removed *every*
      # occurrence of the substring (it is also a prefix of `return configs`,
      # `return config_builder`, ...), and silently no-opped if the trailing
      # line ever changed -- producing a Lua syntax error at runtime while
      # `darwin-rebuild switch` still reported success. replaceVars uses
      # --replace-fail, so a missing placeholder fails the build instead.
      xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {
        zsh = "${pkgs.zsh}/bin/zsh";
      };
    };
}
