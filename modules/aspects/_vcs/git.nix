# A module of den.aspects.vcs. Parametric: den passes the user entity in.
{ lib, ... }:
{ user, ... }:
let
  signs = user.keyed != [ ];
  # Who commits as `id`, and whether it signs: only with a key on this host.
  as =
    id:
    {
      user = {
        inherit (id) email;
      }
      # Literal, not a path into ~/.ssh.
      // lib.optionalAttrs id.hasKey { signingKey = "key::${id.key}"; };
    }
    // lib.optionalAttrs signs {
      commit.gpgSign = id.hasKey;
      tag.gpgSign = id.hasKey;
    };
in
{
  homeManager =
    { config, ... }:
    let
      signersFile = "git/allowed_signers";
    in
    {
      imports = [ ../_ssh/agent.nix ];

      # For `git log --show-signature`; jj reads the setting below.
      xdg.configFile.${signersFile} = lib.mkIf signs {
        text = lib.concatLines (map (id: "${id.email} ${id.key}") user.keyed);
      };

      programs.git = {
        signing = lib.mkIf signs {
          format = "ssh";
          signer = config.sshAgent.keygen;
        };
        enable = true;
        ignores = [
          "*.swp"
          ".DS_Store"
        ];
        settings = lib.mkMerge [
          (as user.primary)
          {
            user.name = user.fullName;
            init.defaultBranch = "main";
            core = {
              editor = "nvim";
              autocrlf = "input";
            };
            pull.rebase = true;
            rebase = {
              autoStash = true;
              autoSquash = true;
              # Moves stacked branches along with the one being rebased.
              updateRefs = true;
            };
            push.autoSetupRemote = true;
            fetch.prune = true;
            branch.sort = "-committerdate";
            diff.algorithm = "histogram";
            # Replays a conflict resolution it has seen before.
            rerere.enabled = true;
            commit.verbose = true;
            help.autocorrect = "prompt";
          }
          (lib.mkIf signs {
            gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/${signersFile}";
          })
        ];
        # The other identities, each inside its own repos.
        includes = lib.concatMap (
          id:
          map (repo: {
            condition = "gitdir:${repo}/";
            contents = as id;
          }) id.repos
        ) user.scoped;
        lfs.enable = true;
      };
    };
}
