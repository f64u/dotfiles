# Version control: git, its pager and its TUI.
{ ... }@args:
{
  den.aspects.vcs.includes = [
    (import ./_vcs/git.nix args)
    (import ./_vcs/tools.nix args)
  ];
}
