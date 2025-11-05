# Base packages for all systems and users
{ pkgs }:

with pkgs;
let
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
    ps.virtualenv
  ]);
in
[
  # Core terminal and development tools
  comma
  curl
  dos2unix
  fastfetch
  git
  jq
  wget
  uutils-coreutils-noprefix

  # Common libraries
  openssl
  readline
  ncurses

  # Python
  myPython
  uv

  # Core development
  nodejs
  rustup
]
