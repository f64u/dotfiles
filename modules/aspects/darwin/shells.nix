# /etc/shells and the system shell integration snippets.
{
  den.aspects.darwin-shells.darwin = {
    # den's user-shell battery sets environment.shells, which makes nix-darwin
    # take ownership of /etc/shells and rewrite it wholesale. Re-declare the
    # stock macOS entries so the generated file stays a superset.
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
      # Creates /etc/zshrc and /etc/bashrc that load the nix-darwin
      # environment. Without these, a login shell never sees the profile.
      zsh.enable = true;
      bash.enable = true;

      # home-manager owns the completion system (see programs/zsh.nix).
      # Enabling it here too makes every shell run a full compaudit and
      # compdump twice -- roughly two seconds per startup.
      zsh.enableCompletion = false;
      zsh.enableBashCompletion = false;
    };
  };
}
