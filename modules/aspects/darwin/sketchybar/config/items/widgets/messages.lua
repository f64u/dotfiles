local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local island = require("items.island")

-- Dock badges, read with lsappinfo. Each app shows only while it has one.
local apps = { "Slack", "Discord", "WhatsApp", "Messages", "Mail" }
local bundles = {
  Slack = "com.tinyspeck.slackmacgap", Discord = "com.hnc.Discord", WhatsApp = "net.whatsapp.WhatsApp",
  Messages = "com.apple.MobileSMS", Mail = "com.apple.mail",
}
-- Each app's beat on the island.
local tints = {
  Slack = colors.magenta, Discord = colors.lavender, WhatsApp = colors.green,
  Messages = colors.green, Mail = colors.blue,
}

local shelf = {}
for _, app in ipairs(apps) do shelf[#shelf + 1] = { app, bundles[app], tints[app] } end
island.shelf(shelf)
island.watch_hover()

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

local padding = sbar.add("item", "widgets.messages.padding", {
  position = "right",
  width = settings.group_paddings
})

-- The badges would run into the notch, and the shelf shows them there.
island.on_notch(function(notch)
  local display = "all"
  if notch then
    local others = {}
    for d = 1, 16 do
      if d ~= notch then others[#others + 1] = d end
    end
    display = table.concat(others, ",")
  end
  for _, item in pairs(items) do item:set({ display = display }) end
  padding:set({ display = display })
end)

-- Hidden items get no routine updates, so a separate watcher polls.
local watcher = sbar.add("item", {
  drawing = false,
  updates = true,
  update_freq = 3,
})

local query = "for a in '" .. table.concat(apps, "' '") .. "'; do"
    .. " printf '%s|%s\\n' \"$a\" \"$(lsappinfo info -only StatusLabel \"$a\""
    .. " | sed -n 's/.*\"label\"=\"\\([^\"]*\\)\".*/\\1/p')\"; done"

local seen = {}
watcher:subscribe({ "forced", "routine", "system_woke", "front_app_switched" }, function()
  sbar.exec(query, function(out)
    for app, badge in out:gmatch("([^|\n]+)|([^\n]*)") do
      local item = items[app]
      if item then
        -- Slack's badge is a bare "•" for unreads without mentions.
        local count = (badge == "" or badge == "0") and 0 or tonumber(badge) or 0.5
        item:set({ drawing = count > 0, label = badge })
        -- Badge first: an open shelf re-reads them for the new app.
        island.badge(app, count > 0 and badge or "")
        if seen[app] and count > seen[app] then island.message(tints[app], app) end
        seen[app] = count
      end
    end
  end)
end)
