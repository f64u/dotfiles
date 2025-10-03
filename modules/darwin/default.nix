{ ... }: {
  imports = [
    ./home.nix
    ./homebrew.nix
    ./services/aerospace
    ./services/sketchybar
  ];
}
