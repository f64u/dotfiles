local colors = require('colors')
local icons = require('icons')
local settings = require('settings')
local app_icons = require('helpers.app_icons')

-- Matches aerospace's workspaces 1-9.
local count = 9
local spaces = {}
local focus_setters = {}

for i = 1, count do
  local space = sbar.add('item', 'space.' .. i, {
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
      font = 'sketchybar-app-font:Regular:16.0',
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
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[i] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add('bracket', { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2
    }
  })

  -- Padding space
  sbar.add('item', 'space.padding.' .. i, {
    script = '',
    width = settings.group_paddings,
  })

  local space_popup = sbar.add('item', {
    position = 'popup.' .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  local function set_focused(workspace)
    local selected = tonumber(workspace) == i
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
    })
    space_bracket:set({
      background = { border_color = selected and colors.grey or colors.bg2 }
    })
  end
  focus_setters[i] = set_focused

  space:subscribe('aerospace_workspace_change', function(env)
    set_focused(env.FOCUSED_WORKSPACE)
  end)

  space:subscribe('mouse.clicked', function(env)
    if env.BUTTON == 'other' then
      space_popup:set({ background = { image = 'space.' .. i } })
      space:set({ popup = { drawing = 'toggle' } })
    else
      if env.BUTTON == 'right' then
        -- Aerospace doesn't have a destroy workspace command, skip this
      else
        sbar.exec('aerospace workspace ' .. i)
      end
    end
  end)

  space:subscribe('mouse.exited', function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add('item', {
  drawing = false,
  updates = true,
})

-- NOTE: there used to be a hidden item here with `update_freq = 2` firing
-- `windows_on_spaces`, which fanned out into ten `aerospace list-windows`
-- subprocesses plus ten animations -- about eleven process spawns every two
-- seconds, forever, whether or not anything had changed. Updates are now
-- driven purely by events (see the subscriptions at the bottom of this file).

local spaces_indicator = sbar.add('item', {
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
    string = 'Spaces',
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

-- A single `--all` query covers every workspace, replacing the previous
-- ten-subprocess fan-out.
local function refresh_space_icons()
  sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(output)
    local icon_lines = {}
    local seen = {}

    for line in string.gmatch(output, '[^\r\n]+') do
      -- App names contain spaces, so only the workspace field is anchored.
      -- `[^|%s]+` rather than `%S+`: the latter is greedy and backtracks to
      -- the *last* pipe, so an app name containing `|` split in the wrong
      -- place and the row was silently dropped by tonumber.
      local workspace, app = string.match(line, '^%s*([^|%s]+)%s*|%s*(.-)%s*$')
      local index = tonumber(workspace)

      if index and app and app ~= '' and not seen[workspace .. '\0' .. app] then
        seen[workspace .. '\0' .. app] = true
        local lookup = app_icons[app]
        icon_lines[index] = (icon_lines[index] or '')
            .. ((lookup == nil) and app_icons['Default'] or lookup)
      end
    end

    sbar.animate('tanh', 10, function()
      for i = 1, count do
        spaces[i]:set({ label = icon_lines[i] or '—' })
      end
    end)
  end)
end

-- `aerospace_workspace_change` comes from aerospace's exec-on-workspace-change
-- hook; `windows_on_spaces` from its alt-shift-N bindings; `front_app_switched`
-- catches apps launched or quit without a workspace switch.
--
-- NOTE: the aerospace hook deliberately fires only `aerospace_workspace_change`
-- now. Firing both from there meant every workspace switch ran this refresh
-- twice, since both events land on the same handler.
--
-- If a window closes while the focused app stays put the strip can go briefly
-- stale -- add a hidden item with a slow `update_freq` (30+) triggering
-- `windows_on_spaces` if that bothers you, but not a two-second one.
space_window_observer:subscribe(
  { 'aerospace_workspace_change', 'windows_on_spaces', 'front_app_switched' },
  refresh_space_icons
)

-- Put each space on whichever display aerospace has its workspace on; that
-- moves when a monitor comes or goes. NSScreen ids match sketchybar's.
local function assign_displays()
  sbar.exec("aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}'", function(output)
    for workspace, display in string.gmatch(output, '(%d+)|(%d+)') do
      local i = tonumber(workspace)
      if spaces[i] then
        spaces[i]:set({ display = display })
        sbar.set('space.padding.' .. i, { display = display })
      end
    end
  end)
end

-- Give aerospace a moment to move its workspaces first.
space_window_observer:subscribe('display_change', function()
  sbar.delay(1, assign_displays)
end)

-- Events only arrive on change, so seed the state on (re)load.
assign_displays()
refresh_space_icons()
sbar.exec('aerospace list-workspaces --focused', function(focused)
  for i = 1, count do
    focus_setters[i](focused:match('%S+'))
  end
end)

spaces_indicator:subscribe('swap_menus_and_spaces', function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe('mouse.entered', function(env)
  sbar.animate('tanh', 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = 'dynamic' }
    })
  end)
end)

spaces_indicator:subscribe('mouse.exited', function(env)
  sbar.animate('tanh', 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe('mouse.clicked', function(env)
  sbar.trigger('swap_menus_and_spaces')
end)
