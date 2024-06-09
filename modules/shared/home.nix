{ config, pkgs, lib, ... }:
let
  name = "Fady Adal";
  user = "fadyadal";
  email = "2masadel@gmail.com";
in
{
  zsh = {
    enable = true;
    plugins = [
      {
        name = "evalcache";
        src = pkgs.fetchFromGitHub {
          owner = "mroth";
          repo = "evalcache";
          rev = "v1.0.2";
          sha256 = "sha256-qzpnGTrLnq5mNaLlsjSA6VESA88XBdN3Ku/YIgLCb28=";
        };
      }
    ];
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      export TERM=xterm-256color

      alias ls='eza --icons'
      alias cp=xcp
      alias q=exit
      alias ghci='TERM=linux ghci'
      alias stack='TERM=linux stack'
      alias idris2='rlwrap idris2'
      alias tg=topgrade
      alias n=nvim
      alias vim=nvim
      alias cd=z
      alias sml='rlwrap sml'
      alias ssh='TERM=xterm-256color ssh'

      source ~/.opam/opam-init/init.zsh

      _evalcache starship init zsh
      _evalcache zoxide init zsh
      _evalcache atuin init zsh --disable-up-arrow

      source ~/.ghcup/env

      servers=(ra amun set anubis seshat hathor thoth maat)
      for server in $servers; do
        alias $server="ssh fady@$server.cs.uchicago.edu"
      done
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ".DS_STORE" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_default_text "#W at #{b:pane_current_path}"
          set -g @catppuccin_window_current_text "#W at #{b:pane_current_path}"
          set -g @catppuccin_window_right_separator_inverse "yes"

          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator " | "

          set -g @catppuccin_window_default_fill "none"

          set -g @catppuccin_window_current_fill "all"

          set -g @catppuccin_status_modules_right "directory session"
          set -g @catppuccin_status_modules_left ""
          set -g @catppuccin_directory_text "#{pane_current_path}"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
          set -g @catppuccin_status_background "default"
        '';
      }
      vim-tmux-navigator
      t-smart-tmux-session-manager
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      extrakto
    ];
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    mouse = true;
    extraConfig = ''
      setw -g pane-base-index 1
      setw -g automatic-rename on

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

      set-option -g default-terminal 'alacritty'
      set-option -sa terminal-features ",alacritty:RGB"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      set-option -g focus-events on

      set-window-option -g mode-key vi

      unbind v 
      unbind %
      bind 'v' split-window -c '#{pane_current_path}' -h
      bind '"' split-window -c '#{pane_current_path}' -v
      bind 'h' split-window -c '#{pane_current_path}' -v
      bind c new-window -c '#{pane_current_path}'
      bind g new-window -n '' -c "#{pane_current_path}" lazygit

      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line


      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt (cmd+w)
    '';
  };

  alacritty =
    let
      # For some reason "\u0002" is not natively supported in nix
      # (also this is just ctrl+b (tmux's prefix))
      prefix = (builtins.fromTOML ''b = "\u0002"'').b;
      catppuccin-alacritty = builtins.fetchGit {
        url = "https://github.com/catppuccin/alacritty.git";
        rev = "94800165c13998b600a9da9d29c330de9f28618e";
      };
      catppuccin-mocha =
        pkgs.stdenv.mkDerivation
          {
            name = "extract-mocha";
            src = catppuccin-alacritty;
            buildCommand = "cp $src/catppuccin-mocha.toml $out";
          };
      catppuccin-mocha-contents = builtins.readFile catppuccin-mocha;
      colors = builtins.fromTOML catppuccin-mocha-contents;
    in
    {
      enable = true;
      settings = colors // {
        live_config_reload = true;
        selection.save_to_clipboard = true;
        cursor = {
          blink_interval = 400;
          thickness = 0.15;
          unfocused_hollow = true;
          style = {
            blinking = "Always";
            shape = "Beam";
          };
        };
        font = {
          size = 19.0;
          normal = {
            family = "CaskaydiaCove Nerd Font Mono";
            style = "Regular";
          };
        };
        shell = {
          args = [ "-l" "-c" "tmux attach || tmux -2" ];
          program = "${pkgs.zsh}/bin/zsh";
        };
        window = {
          decorations = "buttonless";
          dynamic_padding = true;
          opacity = 0.7;
          option_as_alt = "OnlyLeft";
          blur = true;
          padding = {
            x = 5;
            y = 5;
          };
        };
        keyboard.bindings = [
          {
            chars = "${prefix}\"";
            key = "E";
            mods = "Command";
          }
          {
            chars = "${prefix}v";
            key = "E";
            mods = "Command|Shift";
          }
          {
            chars = "${prefix}[/";
            key = "F";
            mods = "Command";
          }
          {
            chars = "${prefix}g";
            key = "G";
            mods = "Command";
          }
          {
            chars = "${prefix}G";
            key = "G";
            mods = "Command|Shift";
          }
          {
            chars = "${prefix}T";
            key = "J";
            mods = "Command";
          }
          {
            chars = "${prefix}s";
            key = "K";
            mods = "Command";
          }
          {
            chars = "${prefix}L";
            key = "L";
            mods = "Command";
          }
          {
            chars = "${prefix}u";
            key = "O";
            mods = "Command";
          }
          {
            chars = "${prefix}c";
            key = "T";
            mods = "Command";
          }
          {
            chars = "${prefix}z";
            key = "Z";
            mods = "Command";
          }
          {
            chars = "${prefix}n";
            key = "Tab";
            mods = "Control";
          }
          {
            chars = "${prefix}p";
            key = "`";
            mods = "Control";
          }
          {
            chars = "${prefix},";
            key = "Comma";
            mods = "Command";
          }
          {
            chars = "${prefix}F";
            key = "LBracket";
            mods = "Command";
          }
          {
            chars = "${prefix}p";
            key = "LBracket";
            mods = "Command|Shift";
          }
          {
            chars = "\t";
            key = "RBracket";
            mods = "Command";
          }
          {
            chars = "n";
            key = "RBracket";
            mods = "Command|Shift";
          }
          {
            chars = "${prefix}:";
            key = "Semicolon";
            mods = "Command";
          }
          {
            chars = "${prefix}1";
            key = "Key1";
            mods = "Command";
          }
          {
            chars = "${prefix}2";
            key = "Key2";
            mods = "Command";
          }
          {
            chars = "${prefix}3";
            key = "Key3";
            mods = "Command";
          }
          {
            chars = "${prefix}4";
            key = "Key4";
            mods = "Command";
          }
          {
            chars = "${prefix}5";
            key = "Key5";
            mods = "Command";
          }
          {
            chars = "${prefix}6";
            key = "Key6";
            mods = "Command";
          }
          {
            chars = "${prefix}7";
            key = "Key7";
            mods = "Command";
          }
          {
            chars = "${prefix}8";
            key = "Key8";
            mods = "Command";
          }
          {
            chars = "${prefix}9";
            key = "Key9";
            mods = "Command";
          }
          {
            chars = "${prefix}P";
            key = "Key0";
            mods = "Command";
          }
        ];
      };
    };
}
