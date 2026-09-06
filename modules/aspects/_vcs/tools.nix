# Git tooling: the pager and the TUI. A module of den.aspects.vcs.
{ ... }:
{
  homeManager = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.lazygit.enable = true;
  };
}
