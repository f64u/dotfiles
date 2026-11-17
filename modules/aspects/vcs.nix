# Version control: git, jj and their tools.
{ ... }@args:
{
  den.aspects.vcs.includes = [
    (import ./_vcs/git.nix args)
    (import ./_vcs/tools.nix args)
    (import ./_vcs/jj.nix args)
  ];
}
