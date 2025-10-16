{ pkgs, ... }:
let
  # For some reason "\u0002" is not natively supported in nix
  # (also this is just ctrl+b (tmux's prefix))
  prefix = (builtins.fromTOML ''b = "\u0002"'').b;
  catppuccin-alacritty = builtins.fetchGit {
    url = "https://github.com/catppuccin/alacritty.git";
    rev = "f6cb5a5c2b404cdaceaff193b9c52317f62c62f7";
  };
in
{
  programs.alacritty =
    {
      enable = false;
      settings = {
        general = {
          live_config_reload = true;
          import = [
            "${catppuccin-alacritty}/catppuccin-mocha.toml"
          ];
        };
        terminal.shell = {
          args = [ "-l" "-c" "tmux attach || tmux -2" ];
          program = "${pkgs.zsh}/bin/zsh";
        };
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
        window = {
          decorations = "Buttonless";
          opacity = 0.7;
          option_as_alt = "OnlyLeft";
          blur = true;
          padding = {
            x = 5;
            y = 2;
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
