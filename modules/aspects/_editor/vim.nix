# Fallback editor, for when the neovim config is broken or absent.
# A module of den.aspects.editor.
{ ... }:
{
  homeManager = { pkgs, ... }: {
    programs.vim = {
      enable = true;
      # Terminal-only. vim-full defaults to a GTK2 GUI on darwin, which 9.2.1164
      # fails to compile (image.c reads `gui.scale`, absent from the GTK2 Gui).
      packageConfigurable = pkgs.vim-full.override { guiSupport = false; };
    };
  };
}
