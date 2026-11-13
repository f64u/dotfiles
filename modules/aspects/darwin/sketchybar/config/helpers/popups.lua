-- Widget popups, one at a time. They otherwise only close when the cursor
-- leaves the bar, which never happens while moving between widgets.
--
-- sketchybar draws a popup on the display with keyboard focus, so a click on
-- another monitor's bar first moves aerospace focus there.
local closers = {}
local pending = nil

local follow_mouse = "m=$(aerospace list-monitors --mouse --format '%{monitor-id}');"
    .. " [ \"$m\" = \"$(aerospace list-monitors --focused --format '%{monitor-id}')\" ]"
    .. " || aerospace focus-monitor \"$m\""

local function close_all(except)
  if pending ~= except then pending = nil end
  for name, close in pairs(closers) do
    if name ~= except then close() end
  end
end

-- One watcher, so the bar can't be left while a popup is still on its way.
-- Hidden items need updates=true to receive events.
local watcher = sbar.add("item", "popups.watcher", { drawing = false, updates = true })
watcher:subscribe("mouse.exited.global",
  function() close_all() end)

return {
  register = function(name, close) closers[name] = close end,

  open = function(name, show)
    close_all(name)
    pending = name
    sbar.exec(follow_mouse, function()
      if pending == name then
        pending = nil
        show()
      end
    end)
  end,
}
