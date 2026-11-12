local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Same shape as cpu and ram, but a level rather than a trend: the plot is
-- filled to how full the data volume is, labelled with what's free.
local width = 42

local disk = sbar.add("graph", "widgets.disk", width, {
  position = "right",
  graph = { color = colors.lavender },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.disk },
  label = {
    string = "???G",
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
  update_freq = 300,
})

disk:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("df -H /System/Volumes/Data | awk 'NR==2 {print $4, $5}'", function(out)
    local free, used = out:match("(%S+)%s+(%d+)%%")
    used = tonumber(used)
    if not used then return end

    -- Refill every column so the level is flat from the first sample.
    local samples = {}
    for i = 1, width do samples[i] = used / 100. end
    disk:push(samples)
    disk:set({
      graph = {
        color = (used >= 95 and colors.red) or (used >= 85 and colors.orange) or colors.lavender,
      },
      label = free,
    })
  end)
end)

disk:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Disk Utility'")
end)
