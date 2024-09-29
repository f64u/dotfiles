local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'CaskaydiaCove Nerd Font Mono'


config.enable_tab_bar = false


return config
