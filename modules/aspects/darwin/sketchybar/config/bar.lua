local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 40,
  -- Above the auto-hiding menu bar; see items/menubar.lua.
  topmost = "on",
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
})
