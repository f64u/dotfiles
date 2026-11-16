# A module of den.aspects.vcs. Parametric: den applies it once per user and
# passes the entity in, so identity comes from there rather than from
# home-manager extraSpecialArgs.
{ lib, ... }:
{ user, ... }:
let
  # Only hosts that declare keys sign; elsewhere a missing key would make
  # every commit fail.
  signing = user.signing or null;
in
{
  # For `git log --show-signature`.
  homeManager.xdg.configFile."git/allowed_signers" = lib.mkIf (signing != null) {
    text = lib.concatLines signing.allowedSigners;
  };

  homeManager.programs.git = {
    signing = lib.mkIf (signing != null) {
      format = "ssh";
      inherit (signing) key;
      signByDefault = true;
    };
    enable = true;
    ignores = [
      "*.swp"
      ".DS_Store"
    ];
    settings = {
      user = {
        name = user.fullName;
        email = user.email;
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
    // lib.optionalAttrs (signing != null) {
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
    # The dotfiles repo is personal, so commit to it as the personal identity
    # even on the work host.
    includes = [
      {
        condition = "gitdir:~/dotfiles/";
        contents.user = {
          email = user.personalEmail;
        }
        // lib.optionalAttrs (signing != null) { signingKey = signing.personalKey; };
      }
    ];
    lfs.enable = true;
  };
}
