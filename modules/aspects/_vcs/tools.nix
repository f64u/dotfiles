# Git tooling: the pager, the TUI and the diff and merge tools. A module of den.aspects.vcs.
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
    # Syntax-aware merges: a git merge driver and `jj resolve`.
    programs.mergiraf = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };
  };
}
