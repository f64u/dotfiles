-- The auto-hiding macOS menu bar slides over this bar at the top edge and
-- eats clicks, so bar.lua makes the bar `topmost`. `toggle_menubar` (alt-m)
-- drops it behind the menu bar and back. Flipping `topmost` on hover flaps.

local watcher = sbar.add("item", {
  drawing = false,
  updates = true,
})
sbar.add("event", "toggle_menubar")

local on_top = true

watcher:subscribe("toggle_menubar", function(_)
  on_top = not on_top
  sbar.bar({ topmost = on_top and "on" or "off" })
end)
