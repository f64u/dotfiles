{ fullName, email, ... }:
{
  programs.git = {
    enable = true;
    ignores = [ "*.swp" ".DS_STORE" ];
    userName = fullName;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
