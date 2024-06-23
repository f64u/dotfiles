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
  myPython
  (pdm.override { python3 = myPython; })
  poetry
  ruff

  elan
  lua5_4
  millet # SML lsp
  nodejs
  rustup
] 

