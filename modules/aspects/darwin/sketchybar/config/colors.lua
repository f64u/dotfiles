-- Catppuccin Mocha, matching the rest of the setup (neovim, tmux, starship,
-- wezterm, zsh syntax highlighting).
--
-- NOTE: these were Macchiato values -- except bar.bg and popup.bg, which were
-- already Mocha's base -- so the bar sat a shade off from every other surface.
return {
  black = 0xff181825,   -- mantle
  white = 0xffcdd6f4,   -- text
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff89b4fa,
  yellow = 0xfff9e2af,
  orange = 0xfffab387,  -- peach
  magenta = 0xffcba6f7, -- mauve
  grey = 0xff9399b2,    -- overlay2
  transparent = 0x00000000,

  bar = {
    bg = 0xff1e1e2e, -- base
    border = 0xff45475a, -- surface1
  },
  popup = {
    bg = 0xff1e1e2e,
    border = 0xffcdd6f4,
  },
  bg1 = 0x60313244, -- surface0, translucent
  bg2 = 0x6045475a, -- surface1, translucent

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
