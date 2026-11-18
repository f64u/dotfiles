local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Matches aerospace's workspaces 1-9.
local count = 9
local spaces = {}
local focus_setters = {}

for i = 1, count do
  local space = sbar.add("item", "space." .. i, {
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
  })

  spaces[i] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    },
  })

  -- Padding space
  sbar.add("item", "space.padding." .. i, {
    script = "",
    width = settings.group_paddings,
  })

  local function set_focused(workspace)
    local selected = tonumber(workspace) == i
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
    })
    space_bracket:set({
      background = { border_color = selected and colors.grey or colors.bg2 },
    })
  end
  focus_setters[i] = set_focused

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "left" then
      sbar.exec("aerospace workspace " .. i)
    end
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  },
})

-- One `--all` query covers every workspace.
local function refresh_space_icons()
  sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(output)
    local icon_lines = {}
    local seen = {}

    for line in string.gmatch(output, "[^\r\n]+") do
      -- Only the workspace field is anchored: app names contain spaces and `|`.
      local workspace, app = string.match(line, "^%s*([^|%s]+)%s*|%s*(.-)%s*$")
      local index = tonumber(workspace)

      if index and app and app ~= "" and not seen[workspace .. "\0" .. app] then
        seen[workspace .. "\0" .. app] = true
        local lookup = app_icons[app]
        icon_lines[index] = (icon_lines[index] or "") .. ((lookup == nil) and app_icons["Default"] or lookup)
      end
    end

    sbar.animate("tanh", 10, function()
      for i = 1, count do
        spaces[i]:set({ label = icon_lines[i] or "—" })
      end
    end)
  end)
end

-- `aerospace_workspace_change` and `windows_on_spaces` come from aerospace;
-- `front_app_switched` catches apps launched or quit in place.
--
-- Its own item: SbarLua keeps one callback per item and event. One action
-- fires several events, hence the coalescing.
local icon_observer = sbar.add("item", { drawing = false, updates = true })
sbar.add("event", "aerospace_focus_change")
sbar.add("event", "windows_on_spaces")
local pending = 0
icon_observer:subscribe(
  { "aerospace_workspace_change", "aerospace_focus_change", "windows_on_spaces", "front_app_switched" },
  function()
    pending = pending + 1
    local mine = pending
    sbar.delay(0.05, function()
      if mine == pending then
        refresh_space_icons()
      end
    end)
  end
)

-- Put each space on whichever display aerospace has its workspace on; that
-- moves when a monitor comes or goes. NSScreen ids match sketchybar's.
local function assign_displays()
  sbar.exec(
    "aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}'",
    function(output)
      for workspace, display in string.gmatch(output, "(%d+)|(%d+)") do
        local i = tonumber(workspace)
        if spaces[i] then
          spaces[i]:set({ display = display })
          sbar.set("space.padding." .. i, { display = display })
        end
      end
    end
  )
end

-- Give aerospace a moment to move its workspaces first.
space_window_observer:subscribe("display_change", function()
  sbar.delay(1, assign_displays)
end)

-- A switch can bounce back to the workspace just left for ~0.1s. Within
-- 0.3s a change back is held, then aerospace is asked where it settled.
local function set_all(workspace)
  for i = 1, count do
    focus_setters[i](workspace)
  end
end
local current, previous, burst, settling = nil, nil, 0, false
local function show_focused()
  sbar.exec("aerospace list-workspaces --focused", function(focused)
    local ws = focused:match("%S+")
    if ws ~= current then
      previous, current = current, ws
    end
    set_all(ws)
  end)
end
space_window_observer:subscribe("aerospace_workspace_change", function(env)
  local ws = env.FOCUSED_WORKSPACE
  burst = burst + 1
  local mine = burst
  if not (settling and ws == previous) and ws ~= current then
    previous, current = current, ws
    set_all(ws)
  end
  settling = true
  sbar.delay(0.3, function()
    if burst ~= mine then
      return
    end
    settling = false
    show_focused()
  end)
end)

-- Events only arrive on change, so seed the state on (re)load.
assign_displays()
refresh_space_icons()
show_focused()

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
