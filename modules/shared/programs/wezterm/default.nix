{ pkgs, ... }:
let
  weztermConfig = builtins.readFile ./wezterm.lua;
  # Remove the last line (return config) so we can add more configuration
  configWithoutReturn = builtins.replaceStrings ["return config"] [""] weztermConfig;
in
{
  programs.wezterm =
    {
      enable = true;
      extraConfig = ''
        ${configWithoutReturn}

        -- Auto-launch tmux
        config.default_prog = { '${pkgs.zsh}/bin/zsh', '-l', '-c', 'tmux attach || tmux' }

        return config
      '';
    };
}
