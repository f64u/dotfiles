# The shell itself. A module of den.aspects.shell, not an aspect.
{ inputs, lib, ... }:
{
  homeManager = {
    # The single owner of PATH additions -- do not also export PATH from
    # initContent, or the entry lands twice with different precedence.
    #
    # This renders into hm-session-vars.sh, which ~/.zshenv sources for
    # non-login shells and ~/.zprofile for login ones. That file guards itself
    # with __HM_SESS_VARS_SOURCED, so anything long-lived that inherits the
    # flag will hand it to its children and they will skip re-sourcing; see
    # the matching `set-environment -gu` in ./tmux.nix.
    #
    # CAVEAT: prepended, so a uv- or claude-installed shim here shadows a
    # nix-provided binary of the same name.
    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    programs.zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      # The only compinit in the shell; nix-darwin's is off in
      # darwin/shells.nix. `-C` skips compaudit, which walks fpath hunting for
      # writable directories among what are all read-only store symlinks.
      completionInit = ''
        autoload -U compinit
        compinit -C -d "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
      '';
      initContent = ''
        mkdir -p "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

        source ${inputs.catppuccin-zsh-syntax-highlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

        # opam keeps its switches outside the store, so this must be a runtime
        # eval. Guarded so a machine without opam does not pay for it.
        if command -v opam >/dev/null; then
          eval "$(opam env)"
        fi
      '';

      shellAliases = {
        q = "exit";
        n = "nvim";
        idris2 = "rlwrap idris2";
        sml = "rlwrap sml";
      };
    };
  };
}
