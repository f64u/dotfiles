# A module of den.aspects.vcs. Parametric: den applies it once per user and
# passes the entity in, so identity comes from there rather than from
# home-manager extraSpecialArgs.
{ ... }:
{ user, ... }:
{
  homeManager.programs.git = {
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
      rebase.autoStash = true;
    };
    # The dotfiles repo is personal, so commit to it as the personal identity
    # even on the work host.
    includes = [
      {
        condition = "gitdir:~/dotfiles/";
        contents.user.email = user.personalEmail;
      }
    ];
    lfs.enable = true;
  };
}
