local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "@colorScheme@"
config.font = wezterm.font("RecMonoLinear Nerd Font", { weight = "Regular" })
config.font_size = 19.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- Window styling
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.macos_window_background_blur = 70
config.window_padding = {
  left = 5,
  right = 5,
  top = 2,
  bottom = 2,
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 400
config.cursor_thickness = "0.1cell"

-- Terminal behavior
config.enable_tab_bar = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.term = "wezterm"

-- Enable undercurl
config.underline_thickness = "200%"
config.underline_position = "-2pt"

-- Scrollback
config.scrollback_lines = 10000

-- Selection
config.selection_word_boundary = " \t\n{}[]()\"'`"

-- Key bindings. The tmux ones come from _shell/tmux-keys.nix.
config.keys = {
  -- Tab character
  { key = "]", mods = "CMD", action = wezterm.action.SendString("\t") },
  --@tmuxKeys@
}

-- Auto-launch tmux; default.nix fills in the zsh path.
config.default_prog = { "@zsh@", "-l", "-c", "tmux attach || tmux" }

return config
