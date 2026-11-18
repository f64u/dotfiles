# The interactive shell: zsh, prompt, multiplexer and small tools.
#
# ./_shell holds plain modules, not aspects: nothing wants tmux without zsh.
{ ... }@args:
{
  den.aspects.shell.includes = [
    (import ./_shell/zsh.nix args)
    (import ./_shell/starship.nix args)
    (import ./_shell/tmux.nix args)
    (import ./_shell/tools.nix args)
    (import ./_shell/claude.nix args)
  ];
}
