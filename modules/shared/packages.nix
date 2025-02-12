{ pkgs }:

with pkgs; let
  myPython = python312.withPackages (ps: [
    ps.ipython
    ps.mypy
    ps.numpy
    ps.pylsp-mypy
    ps.python-lsp-server
    ps.yapf
    ps.virtualenv
  ]);
in
[
  # Apps
  discord
  expat
  nmap
  postman
  slack
  spotify
  texliveFull
  zoom-us

  # Terminal stuff
  curl
  fastfetch
  gettext
  git
  gnupatch
  jq
  parallel
  rlwrap
  xcp

  # Building
  autoconf
  cmake
  pkg-config
  tree-sitter

  # Common libraries
  cairo
  adwaita-icon-theme
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

  # Python
  myPython
  poetry
  ruff

  # Typst
  typst
  tinymist

  # Other
  elan
  lua5_4
  millet # SML lsp
  nodejs
  opam
  rustup
] 

