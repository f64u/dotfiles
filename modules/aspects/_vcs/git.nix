# A module of den.aspects.vcs. Parametric: den passes the user entity in.
{ lib, ... }:
{ user, ... }:
let
  ids = import ../_identities.nix lib user;
  signs = ids.keyed != [ ];
  # Literal, not a path into ~/.ssh.
  literal = id: "key::${id.key}";
  signers =
    map (id: "${id.email} ${id.key}") ids.keyed
    ++ lib.concatMap (
      id: map (old: ''${id.email} valid-before="${old.until}" ${old.key}'') id.retired
    ) ids.all;
in
{
  homeManager =
    { config, ... }:
    {
      imports = [ ../_ssh/agent.nix ];

      # For `git log --show-signature`; jj reads it too.
      xdg.configFile."git/allowed_signers" = lib.mkIf (signers != [ ]) {
        text = lib.concatLines signers;
      };

      programs.git = {
        # An identity signs only if it has a key on this host.
        signing = lib.mkIf signs {
          format = "ssh";
          signer = config.sshAgent.keygen;
          key = if ids.primary.key != null then literal ids.primary else null;
          signByDefault = ids.primary.key != null;
        };
        enable = true;
        ignores = [
          "*.swp"
          ".DS_Store"
        ];
        settings = {
          user = {
            name = user.fullName;
            inherit (ids.primary) email;
          };
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
          # Conflicts show the common ancestor; diffs move whole blocks.
          merge.conflictStyle = "zdiff3";
          diff.algorithm = "histogram";
          # Replays a conflict resolution it has seen before.
          rerere.enabled = true;
          commit.verbose = true;
          help.autocorrect = "prompt";
        }
        // lib.optionalAttrs (signers != [ ]) {
          gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
        };
        # The other identities, each inside its own repos.
        includes = lib.concatMap (
          id:
          map (repo: {
            condition = "gitdir:${repo}/";
            contents = {
              user = {
                inherit (id) email;
              }
              // lib.optionalAttrs (id.key != null) { signingKey = literal id; };
            }
            // lib.optionalAttrs signs {
              commit.gpgSign = id.key != null;
              tag.gpgSign = id.key != null;
            }
            // lib.optionalAttrs (id.key != null) {
              # github.com remotes log in as this identity.
              url."git@${id.githubHost}:".insteadOf = "git@github.com:";
            };
          }) id.repos
        ) ids.scoped;
        lfs.enable = true;
      };
    };
}
