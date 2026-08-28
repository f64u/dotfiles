{ inputs, lib, ... }:
{
  den.aspects.programs-zsh.homeManager = {
    # `home.sessionPath` lands in hm-session-vars.sh, which ~/.zshenv sources,
    # so non-interactive shells get it too. This used to be an `export PATH=...`
    # in initContent, which only interactive shells read.
    #
    # CAVEAT: this is prepended, so a shim in ~/.local/bin (uv and the claude
    # installer both put things there) shadows a nix-provided binary of the
    # same name. Left as-is because reordering would change which `ruff` /
    # `python3` you get today; worth revisiting.
    #
    # NOTE: /usr/local/smlnj/bin is gone -- smlnj comes from nixpkgs now, so
    # the `sml` alias below resolves through the profile.
    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    programs.zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      # This is the *only* compinit in the shell -- nix-darwin's is turned off
      # in darwin/shells.nix.
      #
      # `-d <dump>` names the cache explicitly, and `-C` skips compaudit, the
      # security check that walks every fpath entry looking for
      # group/world-writable directories. It was 85% of function time at
      # startup, and it is checking paths that are all read-only nix store
      # symlinks -- there is nothing for it to find.
      completionInit = ''
        autoload -U compinit
        compinit -C -d "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
      '';
      initContent = ''
        mkdir -p "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

        source ${inputs.catppuccin-zsh-syntax-highlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh

        # opam manages its switches outside the store, so this has to be a
        # runtime eval. Guarded so a machine without opam does not pay for it.
        if command -v opam >/dev/null; then
          eval "$(opam env)"
        fi
      '';

      # NOTE: `mksudo` used to live in initContent. It was macOS-only
      # (dseditgroup, the admin group) and ran `su tomasadal` -- an account
      # that does not exist on this machine -- so it could never have worked.

      shellAliases = {
        q = "exit";
        n = "nvim";

        # rlwrap and smlnj both come from the nix package set.
        idris2 = "rlwrap idris2";
        sml = "rlwrap sml";
      }
      # `s`-prefixed on purpose: these were bare hostnames, and one of them --
      # `set` -- shadowed the zsh builtin, so any `set -o` / `set -x` in an
      # interactive shell became an ssh attempt.
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
