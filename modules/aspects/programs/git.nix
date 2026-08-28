# Parametric aspect: reads identity from the user entity instead of
# home-manager extraSpecialArgs.
{
  den.aspects.programs-git =
    { user, ... }:
    {
      homeManager.programs.git = {
        enable = true;
        ignores = [
          "*.swp"
          ".DS_Store" # was ".DS_STORE" -- matching is case-sensitive
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
        lfs.enable = true;
      };
    };
}
