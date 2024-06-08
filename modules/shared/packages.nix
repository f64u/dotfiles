{ pkgs }:

with pkgs; [

  # Terminal stuff
  alacritty
  atuin
  curl
  eza
  fastfetch
  fd
  fzf
  gettext
  git
  neovim
  nushell
  ripgrep
  rlwrap
  starship
  tmux
  vim
  zoxide

  # Building
  autoconf
  cmake
  pkg-config

  # Common libraries
  cairo
  gnome.adwaita-icon-theme
  gtk3
  gtksourceview
  libxml2
  ncurses
  readline
  zstd

  # C
  ccls
  clang_18
  llvm_18

  # Apps
  discord
  expat
  slack
  spotify
  zoom-us
  wireshark

  # Latex 
  languagetool

  # Python
  poetry
  ruff
  (python312.withPackages (p: [
    p.ipython
    p.mypy
    p.pylsp-mypy
    p.python-lsp-server
    p.yapf
  ]))

  # Other PLs
  lua5_4
  millet # SML lsp
  nodejs
]

