# A module of den.aspects.terminal.
{ ... }:
{
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.catppuccin) flavor;
    in
    {
      programs.wezterm.enable = true;

      # wezterm.lua stays a standalone, lintable Lua file ending in
      # `return config`. replaceVars uses --replace-fail, so dropping the
      # @zsh@ placeholder fails the build rather than silently shipping a
      # broken config.
      xdg.configFile."wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {
        zsh = "${pkgs.zsh}/bin/zsh";
        # Lands after a `--` comment marker, hence the leading newline.
        tmuxKeys = lib.concatMapStrings (
          k:
          "\n  { key = '${k.key}', mods = '${k.mods}', action = wezterm.action.SendString('\\x1b${k.seq}') },"
        ) (import ../../_shell/tmux-keys.nix { });
        colorScheme = "Catppuccin ${lib.toUpper (lib.substring 0 1 flavor)}${lib.substring 1 (-1) flavor}";
      };
    };
}
