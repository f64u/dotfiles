local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- helpers/event_providers/ram_load fires "ram_update" every 2 seconds.
sbar.exec("killall ram_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/ram_load/bin/ram_load ram_update 2.0")

-- Used share of memory, coloured by the kernel's pressure level
-- (1 normal, 2 warning, 4 critical) rather than by the number itself.
local level_colors = { ["1"] = colors.green, ["2"] = colors.orange, ["4"] = colors.red }

-- Swap rate, drawn over the graph's top-left while pages are moving; swap
-- size alone lingers long after the pressure that caused it. Added before
-- the graph so it anchors at the graph's right edge; zero net width
-- (padding_left = -padding_right) shifts it left without moving neighbours.
local swap = sbar.add("item", "widgets.swap", {
  position = "right",
  drawing = false,
  width = 0,
  padding_left = -31,
  padding_right = 31,
  y_offset = 4,
  icon = {
    string = icons.swap,
    font = { size = 9.0 },
    padding_left = 0,
    padding_right = 2,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    width = 26,
    align = "left",
    padding_left = 0,
    padding_right = 0,
  },
})

-- Wider than cpu's so the swap rate and percentage both fit on top.
local ram = sbar.add("graph", "widgets.ram", 64, {
  position = "right",
  graph = { color = colors.green },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.ram },
  label = {
    string = "??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6,
})

local function human(bytes)
  for _, unit in ipairs({ "", "k", "M", "G" }) do
    if bytes < 1000 or unit == "G" then
      return string.format(bytes < 10 and unit ~= "" and "%.1f%s" or "%.0f%s", bytes, unit)
    end
    bytes = bytes / 1000
  end
end

ram:subscribe("ram_update", function(env)
  local used = tonumber(env.used_percent)
  ram:push({ used / 100. })
  ram:set({
    graph = { color = level_colors[env.pressure_level] or colors.green },
    label = used .. "%",
  })

  local rate = tonumber(env.swap_rate) or 0
  local color = rate >= 10e6 and colors.red or colors.orange
  swap:set({
    drawing = rate > 0,
    icon = { color = color },
    label = { string = human(rate), color = color },
  })
end)

ram:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)
