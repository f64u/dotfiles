local settings = require("settings")
local island = require("items.island")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  updates = true,
})

-- Shortened on the notched display, so it stops short of the notch. The
-- cut is estimated before drawing (no flash of the full name), then
-- trimmed further if the estimate was generous.
local notch, edge, active, name = nil, nil, nil, ""
local x, per_char = nil, 8

local function rect()
  local r = front_app:query().bounding_rects["display-" .. notch]
  if r and r.origin[1] > -9999 then return r end
end

-- Shows at most `chars` characters (0 is all of them).
local cut = 0
local function show(chars)
  cut = chars
  front_app:set({ label = { string = name, max_chars = chars } })
end

-- The first fit has nothing to estimate from, so it measures the full name
-- drawn invisibly.
local color = front_app:query().label.color
local function fit()
  local len = utf8.len(name) or #name
  if not notch or active ~= notch then return show(0) end
  local function want()
    local chars = math.floor((edge - 8 - x) / per_char)
    return len <= chars and 0 or math.max(1, chars)
  end
  local blind = x == nil
  if blind then
    front_app:set({ label = { color = 0x00000000 } })
    show(0)
  else
    show(want())
  end
  sbar.delay(0.05, function()
    local r = rect()
    if r then
      x = r.origin[1]
      local shown = cut == 0 and len or math.min(cut, len)
      if r.size[1] > 0 and shown > 0 then per_char = r.size[1] / shown end
      if want() ~= cut then show(want()) end
    end
    if blind then front_app:set({ label = { color = color } }) end
  end)
end

island.on_notch(function(display, left)
  notch, edge = display, left
  sbar.exec("aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}'", function(out)
    active = tonumber(out)
    fit()
  end)
end)

front_app:subscribe("front_app_switched", function(env)
  name = env.INFO
  fit()
end)
-- macOS keeps the last app frontmost on an empty workspace or after its
-- last window closes, so ask aerospace: no focused window means no name.
-- Focus can also move to the other screen this way without macOS noticing.
sbar.add("event", "aerospace_focus_change")
-- Asked once things settle: a switch can bounce through the workspace just
-- left (see spaces.lua). The macOS event above already names the app at
-- once; this catches empty workspaces and closed windows.
local asked = 0
front_app:subscribe({ "aerospace_workspace_change", "aerospace_focus_change" }, function()
  asked = asked + 1
  local mine = asked
  sbar.delay(0.12, function()
  if mine ~= asked then return end
  sbar.exec("aerospace list-windows --focused --format '%{app-name}';"
    .. " aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}'", function(out)
    local app, monitor = out:match("^(.-)\n?(%d+)%s*$")
    if not monitor then return end
    name, active = app, tonumber(monitor)
    fit()
  end)
  end)
end)
-- INFO is the newly active display.
front_app:subscribe("display_change", function(env)
  active = tonumber(env.INFO)
  fit()
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
