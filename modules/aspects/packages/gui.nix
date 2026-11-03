# Cross-platform GUI apps from nixpkgs. macOS-only apps live in
# darwin/desktop.nix. Vendor builds come through brew-nix in
# darwin/casks.nix when nixpkgs lacks the app or builds it unsigned --
# Firefox is a cask because nixpkgs' macOS build carries no Mozilla
# signature, so camera/mic grants and passkeys would not stick.
{
  den.aspects.packages-gui.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Its Electron runtime is shared with vscode, so the marginal cost is
        # small.
        discord
        google-chrome
      ];
    };
}
