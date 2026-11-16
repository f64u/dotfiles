# WezTerm shortcuts that drive tmux. Plain data, imported by ./tmux.nix and
# ../_terminal/wezterm: WezTerm sends each key as the private escape
# sequence `seq`, and tmux binds that as a user key. No prefix involved.
{
  sessions ? "",
  urls ? "",
}:
let
  cwd = ''-c "#{pane_current_path}"'';
  key = key: mods: run: { inherit key mods run; };
  keys = [
    (key "e" "CMD" "split-window -v ${cwd}")
    (key "e" "CMD|SHIFT" "split-window -h ${cwd}")
    (key "t" "CMD" "new-window ${cwd}")
    (key "z" "CMD" "resize-pane -Z")
    # Search back through the scrollback.
    (key "f" "CMD"
      ''copy-mode \; command-prompt -T search -p "(search up)" { send-keys -X search-backward -- "%%" }''
    )
    # Scroll to top / back to the bottom.
    (key "g" "CMD" ''copy-mode \; send-keys -X history-top'')
    (key "g" "CMD|SHIFT" ''if-shell -F "#{pane_in_mode}" { send-keys -X cancel }'')
    (key "j" "CMD" sessions)
    (key "k" "CMD" "choose-tree -Zs")
    # Bare C-l is vim-tmux-navigator's.
    (key "l" "CMD" "send-keys C-l")
    (key "o" "CMD" urls)
    (key "," "CMD" ''command-prompt -I "#W" { rename-window "%%" }'')
    (key ";" "CMD" "command-prompt")
    (key "[" "CMD" "choose-tree -Zw")
    (key "[" "CMD|SHIFT" "previous-window")
    (key "]" "CMD|SHIFT" "next-window")
    (key "Tab" "CTRL" "next-window")
    (key "`" "CTRL" "previous-window")
  ]
  ++ builtins.genList (n: key (toString (n + 1)) "CMD" "select-window -t :=${toString (n + 1)}") 9;
in
builtins.genList (
  i:
  builtins.elemAt keys i
  // {
    index = i;
    seq = "[${toString (7700 + i)}~";
  }
) (builtins.length keys)
