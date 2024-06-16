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
  curl
  fastfetch
  gettext
  git
  gnupatch
  rlwrap
  vim
  xcp

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
  #clang_18
  #llvm_18

  # Latex 
  languagetool
  texlab

  # OCaml
  opam

  # Python
  (pdm.override { python3 = python312; })
  poetry
  python312
  python312Packages.ipython
  python312Packages.mypy
  python312Packages.numpy
  python312Packages.pylsp-mypy
  python312Packages.python-lsp-server
  python312Packages.yapf
  python312Packages.virtualenv
  ruff

  elan
  lua5_4
  millet # SML lsp
  nodejs
  rustup
]

