# Prompt. A module of den.aspects.shell.
{ ... }:
{
  homeManager = {
    programs.starship = {
      enable = true;
      settings = {
        # One version-control segment through `vcs`, which shows jj's view
        # of a colocated repo instead of git's detached HEAD. `$all` would
        # add the git modules again, so they are off there; `vcs` still
        # renders them in plain git repos.
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
