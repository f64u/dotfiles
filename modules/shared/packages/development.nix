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
  ccls
  languagetool
  texlab
  typst
  tinymist
  lua-language-server

  # Specialized tools
  elan
  fstar
  lua5_4
  millet # SML lsp
  ollama
  opam
  qemu
  z3
]
