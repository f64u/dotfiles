# Cross-platform GUI apps from nixpkgs. macOS-only ones are in
# darwin/desktop.nix; apps nixpkgs lacks or ships unsigned (Firefox) are
# casks in darwin/casks.nix.
{
  den.aspects.packages-gui.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Shares its Electron runtime with vscode.
        discord
        google-chrome
      ];
    };
}
