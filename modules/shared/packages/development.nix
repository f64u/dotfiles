# Development packages that can be enabled per system
{ pkgs }:

with pkgs; [
  # Advanced development tools
  android-tools
  google-cloud-sdk
  postman
  code-cursor
  discord

  # Language servers and tools
  bash-language-server
  ccls
  languagetool
  nil
  lua-language-server
  taplo # toml
  texlab # latex
  typst
  tinymist # typst
  millet # SML

  # Specialized tools
  elan
  fstar
  lua5_1
  lua51Packages.luarocks
  ollama
  opam
  qemu
  z3
  texliveFull

  # Build tools
  autoconf
  cmake
  pkg-config
  tree-sitter
]
