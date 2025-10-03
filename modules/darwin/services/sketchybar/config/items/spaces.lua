local colors = require('colors')
local icons = require('icons')
local settings = require('settings')
local app_icons = require('helpers.app_icons')

local spaces = {}

for i = 1, 10, 1 do
  local display = (i >= 8) and 2 or 1
  local space = sbar.add('item', 'space.' .. i, {
    display = display,
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
    display = display,
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

  space:subscribe('aerospace_workspace_change', function(env)
    local focused_workspace = env.FOCUSED_WORKSPACE
    local selected = focused_workspace and tonumber(focused_workspace) == i
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { border_color = selected and colors.black or colors.bg2 }
    })
    space_bracket:set({
      background = { border_color = selected and colors.grey or colors.bg2 }
    })
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

-- Periodic update every 2 seconds to catch window changes
sbar.add('item', {
  drawing = false,
  update_freq = 2,
  script = 'sketchybar --trigger windows_on_spaces'
})

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

space_window_observer:subscribe('aerospace_workspace_change', function(env)
  local focused_workspace = env.FOCUSED_WORKSPACE
  for i = 1, 10 do
    sbar.exec('aerospace list-windows --workspace ' .. i .. " --format '%{app-name}'", function(apps_output)
        local icon_line = ''
        local no_app = true
        local apps_seen = {}

        for app in string.gmatch(apps_output, '[^\r\n]+') do
          if app and app ~= '' and not apps_seen[app] then
            apps_seen[app] = true
            no_app = false
            local lookup = app_icons[app]
            local icon = ((lookup == nil) and app_icons['Default'] or lookup)
            icon_line = icon_line .. icon
          end
        end

        if no_app then
          icon_line = ' —'
        end

        sbar.animate('tanh', 10, function()
          spaces[i]:set({ label = icon_line })
        end)
      end)
  end
end)

space_window_observer:subscribe('windows_on_spaces', function(env)
  sbar.exec('aerospace list-workspaces --focused', function(focused_ws)
    sbar.trigger('aerospace_workspace_change', { FOCUSED_WORKSPACE = focused_ws:gsub('%s+', '') })
  end)
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
