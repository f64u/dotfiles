# Interactive shell tools that need `enable` plus a line or two.
# A module of den.aspects.shell.
#
# `delta` and `lazygit` used to live here; they are git tooling and moved to
# _vcs/tools.nix. `vim` moved to _editor/vim.nix.
{ ... }:
{
  homeManager = {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    programs.bat.enable = true;
    programs.btop.enable = true;
    programs.direnv = {
      enable = true;
      # Caches the flake evaluation, so `cd` into a project with a
      # .envrc stops re-evaluating from scratch every time.
      nix-direnv.enable = true;
      # (zsh/bash integration is on by default via home.shell.)
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
    programs.nh.enable = true;
    programs.ripgrep.enable = true;
    programs.zoxide.enable = true;
  };
}
