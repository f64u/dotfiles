-- The macOS menu bar auto-hides and slides down over this bar whenever the
-- cursor touches the top edge, so a click on a space only landed if it beat
-- the slide. bar.lua makes the bar `topmost` to stop that, which also hides
-- the menu bar for good -- `toggle_menubar` (alt-m in aerospace) drops the
-- bar behind it on demand, and back again.
--
-- A hover delay was tried instead: flipping `topmost` redraws the bar, the
-- redraw fires fresh mouse.entered/exited events, and the bar flapped.

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
