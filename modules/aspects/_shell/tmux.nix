# Multiplexer. A module of den.aspects.shell.
{ ... }:
{
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Session picker: tmux sessions, sesh configs and zoxide directories.
      sessions = pkgs.writeShellScript "tmux-sessions" ''
        export PATH=${
          lib.makeBinPath [
            config.programs.sesh.package
            config.programs.tmux.package
            pkgs.fzf
            pkgs.fd
            pkgs.zoxide
          ]
        }:$PATH
        pick=$(sesh list --icons | fzf --tmux 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list --icons -t)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list --icons -c)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list --icons -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}') || exit 0
        [ -z "$pick" ] || sesh connect "$pick"
      '';

      weztermKeys = import ./tmux-keys.nix {
        sessions = "run-shell ${sessions}";
        urls = "run-shell -b \"${pkgs.tmuxPlugins.fzf-tmux-url}/share/tmux-plugins/fzf-tmux-url/fzf-url.sh '' screen ''\"";
      };
    in
    {
      # The picker above drives it.
      programs.sesh = {
        enable = true;
        enableAlias = false;
        enableTmuxIntegration = false;
      };

      # A running server keeps old plugin paths until it re-reads its config.
      # </dev/null: on a tty, tmux rejects the switch's missing $TERM.
      home.activation.reloadTmux =
        let
          tmux = "${config.programs.tmux.package}/bin/tmux";
        in
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          if ${tmux} list-sessions </dev/null >/dev/null 2>&1; then
            run ${tmux} source-file ${config.xdg.configHome}/tmux/tmux.conf </dev/null \
              || warnEcho "Could not reload tmux"
          fi
        '';

      catppuccin.tmux = {
        enable = true;
        extraConfig = ''
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
          set -g @catppuccin_status_background "none"
          set -g @catppuccin_directory_text " #{s|$HOME|~|;s|/.*/|/…/|:pane_current_path}"

          set -ogq @catppuccin_window_text " #W at #{b:pane_current_path}"
          set -ogq @catppuccin_window_current_text " #W at #{b:pane_current_path}"
        '';
      };

      programs.tmux = {
        enable = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          # prefix-u: pick a URL from the pane (cmd-o in wezterm).
          fzf-tmux-url
          # prefix-F: hint-copy anything on screen.
          fingers
        ];
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 1000000;
        mouse = true;
        keyMode = "vi";

        # A store path: tmux does not expand $SHELL here.
        shell = "${pkgs.zsh}/bin/zsh";

        terminal = "tmux-256color";
        focusEvents = true;
        extraConfig = ''
          # Panes inherit __HM_SESS_VARS_SOURCED from the server and would skip
          # hm-session-vars.sh, losing home.sessionPath. Drop the flag.
          set-environment -gu __HM_SESS_VARS_SOURCED

          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_directory}"
          # No -F: that expands once at load and freezes the session name.
          set -ag status-right "#{E:@catppuccin_status_session}"

          setw -g automatic-rename on
          # tmux 3.8 underlines the current window by default.
          setw -g window-status-current-style default

          set -g detach-on-destroy off  # don't exit from tmux when closing a session
          set -g renumber-windows on    # renumber all windows when any window is closed
          set -g set-clipboard on       # use system clipboard
          set -g status-interval 2      # update status every 2 seconds
          set -g status-left-length 200 # increase status line length
          set -g status-position top    # macOS / darwin style

          set -g prefix2 C-a
          bind C-a send-prefix -2

          # reload configuration
          bind r source-file ~/.config/tmux/tmux.conf

          # Back to defaults first, or every reload appends these again.
          set -su terminal-overrides
          set -su terminal-features
          set-option -ag terminal-overrides ",wezterm*:RGB"
          set-option -ag terminal-overrides ",xterm-256color:RGB"
          set-option -ag terminal-overrides ",tmux-256color:RGB"
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
          set -as terminal-features ',*:usstyle'  # enable undercurl style support
          set -as terminal-features ',wezterm*:RGB'  # enable RGB colors for wezterm

          unbind v
          unbind %
          bind 'v' split-window -c '#{pane_current_path}' -h
          bind '"' split-window -c '#{pane_current_path}' -v
          bind 'h' split-window -c '#{pane_current_path}' -v
          bind c new-window -c '#{pane_current_path}'

          # Popups: jjui in a jj repo or lazygit, a scratch shell, the session
          # picker.
          bind g display-popup -E -w 90% -h 90% -d "#{pane_current_path}" "jj root >/dev/null 2>&1 && exec jjui || exec lazygit"
          bind t display-popup -E -w 80% -h 80% -d "#{pane_current_path}"
          bind T run-shell ${sessions}

          # Modified keys (C-Enter, S-Enter, ...) reach apps that ask for
          # them; images and other passthrough sequences reach the terminal.
          set -s extended-keys on
          set -g allow-passthrough on

          # WezTerm's cmd-keys, see ./tmux-keys.nix.
          ${lib.concatMapStringsSep "\n" (k: ''
            set -s user-keys[${toString k.index}] "\e${k.seq}"
            bind -n User${toString k.index} ${k.run}'') weztermKeys}

          bind Enter copy-mode
          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi C-v send -X rectangle-toggle
          bind -T copy-mode-vi y send -X copy-selection-and-cancel
          bind -T copy-mode-vi H send -X start-of-line
          bind -T copy-mode-vi L send -X end-of-line


          bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt (cmd+w)
        '';
      };
    };
}
