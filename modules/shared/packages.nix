{ pkgs }:

with pkgs; let
  myPython = python313.withPackages (ps: [
    ps.distutils
    ps.flit
    ps.ipython
    ps.mypy
    ps.numpy
    ps.pandas
    ps.pip
    ps.pylsp-mypy
    ps.python-lsp-server
    ps.setuptools
    ps.yapf
    ps.virtualenv
  ]);
in
[
  # Apps
  _1password-gui
  code-cursor
  discord
  expat
  nmap
  postman
  slack
  # texliveFull

  # Terminal stuff
  android-tools
  curl
  dos2unix
  fastfetch
  gettext
  git
  gnupatch
  jq
  parallel
  rlwrap
  wget
  # xcp

  # Building
  autoconf
  ccache
  cmake
  pkgconf
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
  uv

  # Typst
  typst
  tinymist

  # Other
  elan
  lua5_4
  millet # SML lsp
  nodejs
  ollama
  opam
  qemu
  rustup
] 

