{ pkgs }:

with pkgs; [
  alacritty
  aldente
  atuin
  autoconf
  cairo
  ccls
  clang_18
  cmake
  curl
  discord
  expat
  eza
  fastfetch
  fd
  fzf
  gettext
  git
  gnome.adwaita-icon-theme
  gtk3
  gtksourceview
  languagetool
  libxml2
  llvm_18
  lua5_4
  millet
  ncurses
  neofetch
  neovim
  nodejs
  pkg-config
  poetry
  pyenv
  readline
  ripgrep
  rlwrap
  slack
  spotify
  starship
  tmux
  vim
  # FIXME: Breaks builds because qtmultimedia fails to compile
  #wireshark
  zoom-us
  zoxide
  zstd
]

