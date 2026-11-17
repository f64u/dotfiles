# Jujutsu, alongside git (repos are colocated). Parametric like ./git.nix.
{ lib, ... }:
{ user, ... }:
let
  ids = import ../_identities.nix lib user;
  scoped = lib.filter (id: id.repos != [ ]) ids.scoped;
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
          }
          # The other identities, each inside its own repos.
          (lib.mkIf (scoped != [ ]) {
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
            ) scoped;
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
