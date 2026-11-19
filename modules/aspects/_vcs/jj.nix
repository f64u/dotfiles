# Jujutsu, alongside git (repos are colocated). Parametric like ./git.nix.
{ lib, ... }:
{ user, ... }:
let
  signs = user.keyed != [ ];
  # Who commits as `id`. A key signs what is pushed.
  as =
    id:
    {
      user.email = id.email;
    }
    // lib.optionalAttrs signs {
      revsets.git-sign-on-push = if id.hasKey then "~signed() & mine()" else "none()";
    }
    // lib.optionalAttrs id.hasKey { signing.key = id.key; };
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
            fix.tools = lib.mapAttrs (_: f: {
              command = [ (lib.getExe f.package) ] ++ f.stdin;
              patterns = map (g: "glob:'**/${g}'") f.files;
            }) (import ../../_formatters.nix pkgs);
            git.private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
          }
          # The other identities, each inside its own repos.
          (lib.mkIf (user.scoped != [ ]) {
            "--scope" = map (id: { "--when".repositories = id.repos; } // as id) user.scoped;
          })
          (lib.mkIf signs {
            signing = {
              # Commits stay unsigned until pushed. The shell prompt runs jj,
              # which would otherwise sign a new snapshot after every edit.
              behavior = "drop";
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
