# The interactive shell environment: the shell, its prompt, the multiplexer,
# and the small tools that make it usable.
#
# The pieces under ./_shell are plain modules, not aspects -- nothing ever
# wants tmux without zsh, so they are not independently composable and have no
# business in the flat den.aspects namespace.
{ ... }@args:
{
  den.aspects.shell.includes = [
    (import ./_shell/zsh.nix args)
    (import ./_shell/starship.nix args)
    (import ./_shell/tmux.nix args)
    (import ./_shell/tools.nix args)
  ];
}
