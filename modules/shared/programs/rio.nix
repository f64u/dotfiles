{ pkgs, ... }:
let
  # For some reason "\u0002" is not natively supported in nix
  # (also this is just ctrl+b (tmux's prefix))
  prefix = (builtins.fromTOML ''b = "\u0002"'').b;
  catppuccin-rio = builtins.fetchGit {
    url = "https://github.com/catppuccin/rio";
    rev = "2aed2a3e545504090edde25591b5e85abad0286f";
  };
  rio-colors = (builtins.fromTOML (builtins.readFile "${catppuccin-rio}/themes/catppuccin-mocha.toml")).colors;
in
{
  programs.rio =
    {
      enable = false;
      settings = {
        editor.program = "nvim";
        colors = rio-colors;
        cursor = {
          blink-interval = 400;
          shape = "beam";
        };
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "-l" "-c" "tmux attach || tmux -2" ];
          # program = "${pkgs.tmux}/bin/tmux";
          # args = [ "new-session" "-c" "~" ];
        };
        fonts = {
          size = 19.0;
          regular = {
            family = "CaskaydiaCove Nerd Font Mono";
            style = "Normal";
          };
        };
        navigation = {
          use-split = false;
          mode = "Plain";
        };
        padding-x = 5;
        option-as-alt = "left";
        selection.save_to_clipboard = true;
        window = {
          decorations = "Buttonless";
          opacity = 0.7;
          blur = true;
        };
        bindings.keys = [
          {
            text = "${prefix}\"";
            key = "e";
            "with" = "super";
          }
          {
            text = "${prefix}v";
            key = "e";
            "with" = "super|shift";
          }
          {
            text = "${prefix}[/";
            key = "f";
            "with" = "super";
          }
          {
            text = "${prefix}g";
            key = "g";
            "with" = "super";
          }
          {
            text = "${prefix}g";
            key = "g";
            "with" = "super|shift";
          }
          {
            text = "${prefix}t";
            key = "j";
            "with" = "super";
          }
          {
            text = "${prefix}s";
            key = "k";
            "with" = "super";
          }
          {
            text = "${prefix}l";
            key = "l";
            "with" = "super";
          }
          {
            text = "${prefix}u";
            key = "o";
            "with" = "super";
          }
          {
            text = "${prefix}c";
            key = "t";
            "with" = "super";
          }
          {
            text = "${prefix}z";
            key = "z";
            "with" = "super";
          }
          {
            text = "${prefix}n";
            key = "tab";
            "with" = "control";
          }
          {
            text = "${prefix}p";
            key = "`";
            "with" = "control";
          }
          {
            text = "${prefix},";
            key = "comma";
            "with" = "super";
          }
          {
            text = "${prefix}f";
            key = "lbracket";
            "with" = "super";
          }
          {
            text = "${prefix}p";
            key = "lbracket";
            "with" = "super|shift";
          }
          {
            text = "\t";
            key = "rbracket";
            "with" = "super";
          }
          {
            text = "n";
            key = "rbracket";
            "with" = "super|shift";
          }
          {
            text = "${prefix}:";
            key = "semicolon";
            "with" = "super";
          }
          {
            text = "${prefix}1";
            key = "1";
            "with" = "super";
          }
          {
            text = "${prefix}2";
            key = "2";
            "with" = "super";
          }
          {
            text = "${prefix}3";
            key = "3";
            "with" = "super";
          }
          {
            text = "${prefix}4";
            key = "4";
            "with" = "super";
          }
          {
            text = "${prefix}5";
            key = "5";
            "with" = "super";
          }
          {
            text = "${prefix}6";
            key = "6";
            "with" = "super";
          }
          {
            text = "${prefix}7";
            key = "7";
            "with" = "super";
          }
          {
            text = "${prefix}8";
            key = "8";
            "with" = "super";
          }
          {
            text = "${prefix}9";
            key = "9";
            "with" = "super";
          }
          {
            text = "${prefix}p";
            key = "0";
            "with" = "super";
          }
        ];
      };
    };
}
