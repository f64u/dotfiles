# Jujutsu, alongside git (repos are colocated). Parametric like ./git.nix.
{ lib, ... }:
{ user, ... }:
let
  signs = user.keyed != [ ];
  # Who commits as `id`. A key signs every commit of mine as written.
  as =
    id:
    {
      user.email = id.email;
    }
    // lib.optionalAttrs signs {
      signing = {
        behavior = if id.hasKey then "own" else "drop";
      }
      // lib.optionalAttrs id.hasKey { inherit (id) key; };
    };
in
{
  homeManager =
    { config, pkgs, ... }:
    {
      imports = [ ../_ssh/agent.nix ];

      home.packages = [ pkgs.jjui ]; # TUI

      programs.jujutsu = {
        enable = true;
        settings = lib.mkMerge [
          (as user.primary)
          {
            user.name = user.fullName;
            ui = {
              default-command = "log";
              pager = "delta";
              diff-formatter = ":git"; # what delta reads
            };
            aliases = {
              # Move the nearest bookmark up to @-.
              tug = [
                "bookmark"
                "advance"
              ];
              # Syntax-aware diff; delta can't read difft's output.
              dft = [
                "diff"
                "--tool"
                "difft"
                "--config"
                "ui.pager=less -FRX"
              ];
              retrunk = [
                "rebase"
                "-o"
                "trunk()"
              ];
            };
            revsets.bookmark-advance-to = "@-";
            # Pushed commits are immutable.
            revset-aliases."immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
            git.private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
          }
          # The other identities, each inside its own repos.
          (lib.mkIf (user.scoped != [ ]) {
            "--scope" = map (id: { "--when".repositories = id.repos; } // as id) user.scoped;
          })
          (lib.mkIf signs {
            signing = {
              backend = "ssh";
              backends.ssh = {
                allowed-signers = config.programs.git.settings.gpg.ssh.allowedSignersFile;
                program = config.sshAgent.keygen;
              };
            };
          })
        ];
      };
    };
}
