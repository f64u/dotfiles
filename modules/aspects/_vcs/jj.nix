# Jujutsu, alongside git (repos are colocated). Parametric like ./git.nix.
{ lib, ... }:
{ user, ... }:
let
  ids = import ../_identities.nix lib user;
  signs = ids.keyed != [ ];
  # Sign every commit of mine as written; a keyless identity signs nothing.
  behavior = id: if id.key != null then "own" else "drop";
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
          {
            user = {
              name = user.fullName;
              inherit (ids.primary) email;
            };
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
          (lib.mkIf (ids.scoped != [ ]) {
            "--scope" = map (
              id:
              {
                "--when".repositories = id.repos;
                user.email = id.email;
              }
              // lib.optionalAttrs signs {
                signing = {
                  behavior = behavior id;
                }
                // lib.optionalAttrs (id.key != null) { inherit (id) key; };
              }
            ) ids.scoped;
          })
          (lib.mkIf signs {
            signing = {
              behavior = behavior ids.primary;
              backend = "ssh";
              backends.ssh = {
                allowed-signers = "~/.config/git/allowed_signers";
                program = config.sshAgent.keygen;
              };
            }
            // lib.optionalAttrs (ids.primary.key != null) { inherit (ids.primary) key; };
          })
        ];
      };
    };
}
