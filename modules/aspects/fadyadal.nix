# The `fadyadal` user aspect, included on every host that declares the user.
{ den, ... }:
{
  den.aspects.fadyadal = {
    includes = [
      # wheel/networkmanager on NixOS, system.primaryUser on Darwin.
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      den.aspects.packages-base
      den.aspects.packages-development
      den.aspects.packages-gui
      # packages-heavy is deliberately not here -- see packages/heavy.nix.

      den.aspects.shell
      den.aspects.editor
      den.aspects.ssh
      den.aspects.vcs
      den.aspects.terminal
    ];
  };
}
