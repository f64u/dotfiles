# Git tooling: the pager and the TUI. A module of den.aspects.vcs.
{ ... }:
{
  homeManager = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.lazygit.enable = true;
    # Syntax-aware diffs: `git dft`, `jj diff --tool difft`.
    programs.difftastic.enable = true;
    programs.git.settings.alias.dft = "-c diff.external=difft diff";
  };
}
