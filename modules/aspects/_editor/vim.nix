# Fallback editor, for when the neovim config is broken or absent.
# A module of den.aspects.editor.
{ ... }:
{
  homeManager = { pkgs, ... }: {
    programs.vim = {
      enable = true;
      # No GUI: vim-full's GTK2 build fails to compile on darwin (9.2.1164).
      packageConfigurable = pkgs.vim-full.override { guiSupport = false; };
    };
  };
}
