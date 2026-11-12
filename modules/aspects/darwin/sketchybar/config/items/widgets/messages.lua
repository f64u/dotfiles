local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Dock badges, read with lsappinfo. Each app shows only while it has one.
local apps = { "Slack", "Discord", "WhatsApp", "Messages", "Mail" }

local items = {}
for _, app in ipairs(apps) do
  items[app] = sbar.add("item", "widgets.messages." .. app, {
    position = "right",
    drawing = false,
    icon = {
      string = app_icons[app] or app_icons["Default"],
      font = "sketchybar-app-font:Regular:14.0",
    },
    label = {
      font = { family = settings.font.numbers },
      color = colors.red,
    },
    click_script = "open -a '" .. app .. "'",
  })
end

sbar.add("bracket", "widgets.messages.bracket", { "/widgets\\.messages\\..*/" }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.messages.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Hidden items get no routine updates, so a separate watcher polls.
local watcher = sbar.add("item", {
  drawing = false,
  updates = true,
  update_freq = 10,
})

local query = "for a in '" .. table.concat(apps, "' '") .. "'; do"
    .. " printf '%s|%s\\n' \"$a\" \"$(lsappinfo info -only StatusLabel \"$a\""
    .. " | sed -n 's/.*\"label\"=\"\\([^\"]*\\)\".*/\\1/p')\"; done"

watcher:subscribe({ "forced", "routine", "system_woke", "front_app_switched" }, function()
  sbar.exec(query, function(out)
    for app, badge in out:gmatch("([^|\n]+)|([^\n]*)") do
      local item = items[app]
      if item then
        -- Slack's badge is a bare "•" for unreads without mentions.
        item:set({ drawing = badge ~= "" and badge ~= "0", label = badge })
      end
    end
  end)
end)
