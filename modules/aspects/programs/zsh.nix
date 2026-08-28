{ inputs, lib, ... }:
{
  den.aspects.programs-zsh.homeManager = {
    # `home.sessionPath` lands in hm-session-vars.sh, which ~/.zshenv sources,
    # so non-interactive shells get it too. This used to be an `export PATH=...`
    # in initContent, which only interactive shells read.
    #
    # CAVEAT: these are prepended, so a shim in ~/.local/bin (uv and the claude
    # installer both put things there) shadows a nix-provided binary of the
    # same name. Left as-is because reordering would change which `ruff` /
    # `python3` you get today; worth revisiting.
    #
    # /usr/local/smlnj/bin is where the `smlnj` homebrew cask installs, and is
    # what the `sml` alias below depends on.
    home.sessionPath = [
      "$HOME/.local/bin"
      "/usr/local/smlnj/bin"
    ];

    programs.zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initContent = ''
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

        # rlwrap comes from packages-base; sml from the smlnj cask.
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
