local wezterm = require('wezterm')

local config = wezterm.config_builder()

-- Appearance
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font('RecMonoLinear Nerd Font', { weight = 'Regular' })
config.font_size = 19.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Window styling
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.7
config.macos_window_background_blur = 70
config.window_padding = {
  left = 5,
  right = 5,
  top = 2,
  bottom = 2,
}

-- Cursor
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 400
config.cursor_thickness = '0.1cell'

-- Terminal behavior
config.enable_tab_bar = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.term = 'wezterm'

-- Enable undercurl
config.underline_thickness = '200%'
config.underline_position = '-2pt'

-- Scrollback
config.scrollback_lines = 10000

-- Selection
config.selection_word_boundary = " \t\n{}[]()\"'`"

-- Tmux prefix
local prefix = '\x02'  -- Ctrl+B

-- Key bindings
config.keys = {
  -- Tmux split horizontal
  { key = 'e', mods = 'CMD', action = wezterm.action.SendString(prefix .. '"') },
  -- Tmux split vertical
  { key = 'e', mods = 'CMD|SHIFT', action = wezterm.action.SendString(prefix .. 'v') },
  -- Tmux search
  { key = 'f', mods = 'CMD', action = wezterm.action.SendString(prefix .. '[/') },
  -- Tmux scroll to top
  { key = 'g', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'g') },
  -- Tmux scroll to bottom
  { key = 'g', mods = 'CMD|SHIFT', action = wezterm.action.SendString(prefix .. 'G') },
  -- Tmux resize mode
  { key = 'j', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'T') },
  -- Tmux choose session
  { key = 'k', mods = 'CMD', action = wezterm.action.SendString(prefix .. 's') },
  -- Tmux clear screen
  { key = 'l', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'L') },
  -- Tmux url hint
  { key = 'o', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'u') },
  -- Tmux new window
  { key = 't', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'c') },
  -- Tmux zoom pane
  { key = 'z', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'z') },
  -- Tmux next window
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.SendString(prefix .. 'n') },
  -- Tmux previous window
  { key = '`', mods = 'CTRL', action = wezterm.action.SendString(prefix .. 'p') },
  -- Tmux rename window
  { key = ',', mods = 'CMD', action = wezterm.action.SendString(prefix .. ',') },
  -- Tmux fzf windows
  { key = '[', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'F') },
  -- Tmux previous window (alt)
  { key = '[', mods = 'CMD|SHIFT', action = wezterm.action.SendString(prefix .. 'p') },
  -- Tab character
  { key = ']', mods = 'CMD', action = wezterm.action.SendString('\t') },
  -- Next window
  { key = ']', mods = 'CMD|SHIFT', action = wezterm.action.SendString('n') },
  -- Tmux command prompt
  { key = ';', mods = 'CMD', action = wezterm.action.SendString(prefix .. ':') },
  -- Tmux window 1-9
  { key = '1', mods = 'CMD', action = wezterm.action.SendString(prefix .. '1') },
  { key = '2', mods = 'CMD', action = wezterm.action.SendString(prefix .. '2') },
  { key = '3', mods = 'CMD', action = wezterm.action.SendString(prefix .. '3') },
  { key = '4', mods = 'CMD', action = wezterm.action.SendString(prefix .. '4') },
  { key = '5', mods = 'CMD', action = wezterm.action.SendString(prefix .. '5') },
  { key = '6', mods = 'CMD', action = wezterm.action.SendString(prefix .. '6') },
  { key = '7', mods = 'CMD', action = wezterm.action.SendString(prefix .. '7') },
  { key = '8', mods = 'CMD', action = wezterm.action.SendString(prefix .. '8') },
  { key = '9', mods = 'CMD', action = wezterm.action.SendString(prefix .. '9') },
  -- Tmux plugins menu
  { key = '0', mods = 'CMD', action = wezterm.action.SendString(prefix .. 'P') },
}

-- Auto-launch tmux (will be set by nix)
-- config.default_prog is configured in default.nix

return config
