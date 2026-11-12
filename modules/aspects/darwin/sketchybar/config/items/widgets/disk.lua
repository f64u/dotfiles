local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Free space on the data volume, where everything but the OS lives.
local disk = sbar.add("item", "widgets.disk", {
  position = "right",
  icon = { string = icons.disk },
  label = {
    string = "???G",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
  },
  update_freq = 300,
})

disk:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("df -H /System/Volumes/Data | awk 'NR==2 {print $4, $5}'", function(out)
    local free, used = out:match("(%S+)%s+(%d+)%%")
    used = tonumber(used) or 0
    disk:set({
      label = {
        string = free or "???G",
        color = (used >= 95 and colors.red) or (used >= 85 and colors.orange) or colors.white,
      },
    })
  end)
end)

disk:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Disk Utility'")
end)
