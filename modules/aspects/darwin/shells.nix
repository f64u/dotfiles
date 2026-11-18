# /etc/shells and the system shell integration snippets.
{
  den.aspects.darwin-shells.darwin = {
    # den's user-shell battery makes nix-darwin rewrite /etc/shells, so list
    # the stock macOS entries too.
    environment.shells = [
      "/bin/bash"
      "/bin/csh"
      "/bin/dash"
      "/bin/ksh"
      "/bin/sh"
      "/bin/tcsh"
      "/bin/zsh"
    ];

    programs = {
      # /etc/zshrc and /etc/bashrc, which load the nix-darwin environment.
      zsh.enable = true;
      bash.enable = true;

      # home-manager owns completion (_shell/zsh.nix). Enabling it here too
      # costs about two seconds per shell startup.
      zsh.enableCompletion = false;
      zsh.enableBashCompletion = false;
    };
  };
}
