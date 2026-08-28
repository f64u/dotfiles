# /etc/shells and the system shell integration snippets.
{
  den.aspects.darwin-shells.darwin = {
    # den's user-shell battery sets environment.shells, which makes nix-darwin
    # take ownership of /etc/shells and rewrite it wholesale. Re-declare the
    # stock macOS entries so the generated file stays a superset of the
    # original.
    #
    # NOTE: the Homebrew-installed fish/nu/pwsh entries that used to be here
    # are gone -- none of those shells is installed by this config, so
    # /etc/shells was advertising paths that do not exist.
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

      # The completion system is initialised by home-manager's zsh module
      # instead -- see programs/zsh.nix.
      #
      # Leaving both on meant /etc/zshrc:23 and ~/.zshrc:8 each ran a bare
      # `compinit`, so the full compaudit + compdump happened twice on every
      # single shell start. That was ~218k of the 220k lines in an `-x` trace
      # and about 2 seconds of the 2.2s startup.
      zsh.enableCompletion = false;
      zsh.enableBashCompletion = false;
    };
  };
}
