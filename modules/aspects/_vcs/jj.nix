# Jujutsu, alongside git (repos are colocated). Parametric like ./git.nix.
{ lib, ... }:
{ user, ... }:
let
  signing = user.signing or null;
in
{
  homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.jjui ]; # TUI

      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = user.fullName;
            email = user.email;
          };
          ui = {
            default-command = "log";
            pager = "delta";
            diff-formatter = ":git"; # what delta reads
          };
          # Same identity split as git: personal in the dotfiles repo.
          "--scope" = [
            (
              {
                "--when".repositories = [ "~/dotfiles" ];
                user.email = user.personalEmail;
              }
              // lib.optionalAttrs (signing != null) { signing.key = signing.personalKey; }
            )
          ];
        }
        // lib.optionalAttrs (signing != null) {
          signing = {
            behavior = "own";
            backend = "ssh";
            inherit (signing) key;
            backends.ssh.allowed-signers = "~/.config/git/allowed_signers";
          };
        };
      };
    };
}
