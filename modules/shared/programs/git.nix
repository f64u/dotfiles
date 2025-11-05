{ fullName, email, ... }:
{
  programs.git = {
    enable = true;
    ignores = [ "*.swp" ".DS_STORE" ];
    settings = {
      user = {
        name = fullName;
        inherit email;
      };
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
    lfs = {
      enable = true;
    };
  };
}
