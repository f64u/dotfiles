# The `fadyadal` user aspect. Included automatically on every host that
# declares `users.fadyadal` (see modules/den.nix).
{ den, ... }:
{
  # Identity lives on the user entity in modules/den.nix, not here -- see the
  # note there for why `den.schema.user` is the wrong home for it.
  den.aspects.fadyadal = {
    includes = [
      # wheel/networkmanager on NixOS, system.primaryUser on Darwin.
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      den.aspects.packages-base
      den.aspects.packages-development
      # packages-heavy is deliberately not here -- see packages/heavy.nix.

      den.aspects.programs-cli
      den.aspects.git
      den.aspects.neovim
      den.aspects.starship
      den.aspects.tmux
      den.aspects.vscode
      den.aspects.wezterm
      den.aspects.zsh
    ];

    darwin =
      { ... }:
      {
        # nix-darwin only manages users it is told about.
        users.knownUsers = [ "fadyadal" ];
        users.users.fadyadal = {
          uid = 501;
          isHidden = false;
        };
      };

    homeManager =
      { pkgs, ... }:
      {
        home.enableNixpkgsReleaseCheck = false;
        home.packages = [ pkgs.nmap ];
      };
  };
}
