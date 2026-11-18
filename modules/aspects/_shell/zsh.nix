# The shell itself. A module of den.aspects.shell, not an aspect.
{ ... }:
{
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # `compinit -C` never rebuilds a dump, so drop it on every switch.
      home.activation.resetZcompdump = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f ${config.xdg.cacheHome}/zsh/zcompdump
      '';

      # The only place PATH is extended. Prepended, so a shim here shadows a nix
      # binary of the same name. tmux panes re-source it; see ./tmux.nix.
      home.sessionPath = [
        "$HOME/.local/bin"
      ];

      catppuccin.zsh-syntax-highlighting.enable = true;

      programs.zsh = {
        enable = true;
        autocd = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;

        # The only compinit; nix-darwin's is off in darwin/shells.nix. `-C` skips
        # compaudit, pointless over read-only store paths.
        completionInit = ''
          autoload -U compinit
          mkdir -p "${config.xdg.cacheHome}/zsh"
          compinit -C -d "${config.xdg.cacheHome}/zsh/zcompdump"
          # After compinit, before autosuggestions and syntax highlighting.
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
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
