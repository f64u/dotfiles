# Prompt. A module of den.aspects.shell.
{ ... }:
{
  homeManager = {
    programs.starship = {
      enable = true;
      settings = {
        # One `vcs` segment, which shows jj in a colocated repo. `$all` would
        # add the git modules again, so they are off; `vcs` still renders them.
        format = "$username$hostname$localip$shlvl$singularity$kubernetes$nats$directory$vcsh$vcs$all";
        vcs.order = [
          "jj"
          "git"
          "hg"
          "pijul"
          "fossil"
        ];
        git_branch.disabled = true;
        git_commit.disabled = true;
        git_state.disabled = true;
        git_status.disabled = true;
      };
    };
    catppuccin.starship.enable = true;
  };
}
