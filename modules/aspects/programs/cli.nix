# Small CLI tools that only need `enable` + a line or two of config.
{
  den.aspects.programs-cli.homeManager = {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    programs.bat.enable = true;
    programs.btop.enable = true;
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    programs.eza = {
      enable = true;
      icons = "auto";
    };
    programs.fd.enable = true;
    programs.fzf = {
      enable = true;
      # Atuin is sourced after fzf and already owned Ctrl-R; say so explicitly
      # so home-manager stops warning about the conflict. fzf keeps Ctrl-T and
      # Alt-C.
      historyWidget.command = "";
    };
    programs.lazygit.enable = true;
    programs.nh.enable = true;
    programs.ripgrep.enable = true;
    programs.vim.enable = true;
    programs.zoxide.enable = true;
  };
}
