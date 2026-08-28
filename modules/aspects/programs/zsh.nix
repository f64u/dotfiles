{ inputs, lib, ... }:
{
  den.aspects.programs-zsh.homeManager = {
    # sessionPath lands in hm-session-vars.sh, which ~/.zshenv sources, so
    # non-interactive shells get it too.
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
      }
      # `s`-prefixed so none of them shadows a builtin -- `set` did.
      // lib.genAttrs [
        "sra"
        "samun"
        "sset"
        "sanubis"
        "sseshat"
        "shathor"
        "sthoth"
        "smaat"
        "ssekhmet"
      ] (alias: "ssh fady@${lib.removePrefix "s" alias}.cs.uchicago.edu");
    };
  };
}
