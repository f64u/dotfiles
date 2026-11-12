local colors = require("colors")
local settings = require("settings")

require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")

-- cpu, ram and disk share one pill.
require("items.widgets.cpu")
require("items.widgets.ram")
require("items.widgets.disk")
sbar.add("bracket", "widgets.system.bracket", { "widgets.cpu", "widgets.swap", "widgets.ram", "widgets.disk" }, {
  background = { color = colors.bg1 }
})
sbar.add("item", "widgets.system.padding", {
  position = "right",
  width = settings.group_paddings
})

require("items.widgets.messages")
