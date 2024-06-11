{ pkgs }:

with pkgs; [
  # Apps
  discord
  expat
  slack
  spotify
  texliveFull
  wireshark
  zoom-us

  # Terminal stuff
  alacritty
  atuin
  bat
  curl
  eza
  fastfetch
  fd
  fzf
  gettext
  git
  gnupatch
  lazygit
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
  libgit2
  libxml2
  ncurses
  openssl
  readline
  zstd

  # C
  ccls
  clang_18
  llvm_18

  # Coq
  coq
  coqPackages.coq-lsp

  # Latex 
  languagetool

  # OCaml
  dune_3
  opam

  # Python
  (pdm.override { python3 = python312; })
  poetry
  ruff
  (python312.withPackages (p: [
    p.ipython
    p.mypy
    p.pylsp-mypy
    p.python-lsp-server
    p.yapf
  ]))


  lua5_4
  millet # SML lsp
  nodejs
]

