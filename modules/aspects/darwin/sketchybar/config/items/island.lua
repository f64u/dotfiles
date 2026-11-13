-- A wordless island: an outline that hugs the notch and shows what just
-- happened through length, colour and motion only.
--
-- The outline is one rounded rectangle centred on the bar's top edge, so
-- only its lower half (sides, corners, bottom) shows. Two masks in the bar's
-- colour hide what isn't revealed yet: progress runs from the bottom centre
-- out along the bottom, round the corners and up the sides.
local colors = require("colors")
local settings = require("settings")

-- macOS reports the notch's edges (helpers/notch), but not its corner
-- curve; 8pt matches the 14" MacBook Pro by eye.
local radius = 8
local gap, stroke = 0, 2
local bar_height = settings.bar_height

-- Filled in from the notch helper.
local g = nil

sbar.bar({ notch_width = 0 })

-- Raised by the item's y_offset, not the background's: sketchybar places a
-- background with unsigned maths, so one taller than the bar would wrap
-- around and draw off screen.
local hug = sbar.add("item", "island.hug", {
  position = "center",
  drawing = false,
  y_offset = bar_height / 2,
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
    border_width = stroke,
    corner_radius = radius + gap + stroke,
  },
})

-- A mask is a fixed window whose fill is a text background, resized inside
-- it: resizing a window can show it blank for a frame, and an item's own
-- background offset would grow the window.
local fill = { color = colors.bar.bg, border_width = 0, corner_radius = 0, height = bar_height }
local function mask(name, position, fill_first)
  local spacer = { string = "", width = 0, padding_left = 0, padding_right = 0, color = colors.transparent }
  local filled = { string = "", width = 0, padding_left = 0, padding_right = 0, color = colors.transparent,
    background = fill }
  return sbar.add("item", name, {
    position = position,
    drawing = false,
    padding_left = 0,
    padding_right = 0,
    background = { drawing = false },
    icon = fill_first and filled or spacer,
    label = fill_first and spacer or filled,
  })
end
local left = mask("island.mask.left", "q", true)
local right = mask("island.mask.right", "e", false)

local function configure(display, origin, width, notch_left, notch_right, notch_height)
  -- The notch is centred on the screen; macOS's side areas aren't quite
  -- symmetric round it (665/850 on a 1512pt screen), so only trust the width.
  local center = width / 2
  local half = (notch_right - notch_left) / 2 + gap + stroke
  local R = radius + gap + stroke
  local depth = notch_height + gap + stroke
  local w = math.floor(2 * half + 0.5)
  g = {
    center = center,
    -- Progress runs along three legs: out along the bottom, round the
    -- corners (by their horizontal extent), then up the sides.
    bottom = half - R,
    reach = half - stroke - 1,
    depth = depth,
    outer_left = math.floor(center - half) - 1,
    outer_right = math.ceil(center + half) + 1,
    -- Where q/e items start with notch_width = 0.
    anchor = width // 2,
    display = display,
    origin = origin,
    notch_width = notch_right - notch_left,
    notch_height = notch_height,
  }
  g.legs = { g.bottom, g.reach, g.reach + depth }
  hug:set({
    display = display,
    width = w,
    -- Centre items centre on the screen; the notch may sit off it.
    padding_left = math.floor(center - half + 0.5) - (width - w) // 2,
    padding_right = 0,
    background = { height = 2 * depth },
  })
  -- Each mask covers one half of the outline.
  g.cl, g.cr = math.floor(center + 0.5), math.floor(center)
  left:set({
    display = display,
    width = g.cl - g.outer_left,
    padding_right = g.anchor - g.cl,
  })
  right:set({
    display = display,
    width = g.outer_right - g.cr,
    padding_left = g.cr - g.anchor,
  })
end

-- The masks for progress `s` (in points along the legs): each fill stops
-- `x` from the centre, and covers from the top of the bar down to `h`.
-- sketchybar reads numbers as text, so 7e-15 would become 7: round first.
local function place(s)
  local x, h
  if s <= g.legs[2] then
    x, h = s, bar_height
  else
    -- Fully open sideways: the masks become columns over the sides,
    -- shrinking upwards. Their inner edge stays under the notch.
    x, h = g.reach, g.depth - (s - g.legs[2])
  end
  h = math.floor(h + 0.5)
  local y = (bar_height - h) // 2
  local xl = math.floor(g.center - x + 0.5) - g.outer_left
  local xr = math.floor(g.center + x + 0.5) - g.cr
  -- A height of 0 means "full height" to sketchybar; 1pt at the screen's
  -- top edge is invisible.
  h = math.max(1, h)
  left:set({ icon = { width = xl, background = { height = h, y_offset = y } } })
  right:set({
    icon = { width = xr },
    label = { width = g.outer_right - g.cr - xr, background = { height = h, y_offset = y } },
  })
end

local progress = 0
local function reveal(p)
  progress = p
  place(p * g.legs[3])
end

local token = 0
local function all(props)
  for _, item in ipairs({ hug, left, right }) do item:set(props) end
end

-- Returns nil when there's no notch to hug.
local function show(color)
  if not g then return nil end
  token = token + 1
  hug:set({ background = { border_color = color } })
  return token
end

-- Moves progress to `to` over `seconds`, then calls `done`. Each leg is
-- one native animation, so both masks move together on every frame.
local function sweep(mine, to, seconds, done)
  local total = g.legs[3]
  local from, target = progress * total, to * total
  local stops = {}
  for _, b in ipairs(g.legs) do
    if (b - from) * (b - target) < 0 then stops[#stops + 1] = b end
  end
  if target < from then table.sort(stops, function(m, n) return m > n end) end
  stops[#stops + 1] = target

  local t, at = 0, from
  for _, stop in ipairs(stops) do
    local share = math.abs(stop - at) / math.max(1e-9, math.abs(target - from))
    local frames = math.max(1, math.floor(seconds * share * 60 + 0.5))
    sbar.delay(t, function()
      if token ~= mine then return end
      progress = stop / total
      sbar.animate("linear", frames, function() place(stop) end)
    end)
    t, at = t + frames / 60, stop
  end
  sbar.delay(t, function()
    if token == mine and done then done() end
  end)
end

local function fade(mine, after)
  sbar.delay(after, function()
    if token ~= mine then return end
    sbar.animate("sin", 30, function()
      hug:set({ background = { border_color = colors.transparent } })
    end)
    sbar.delay(0.6, function()
      if token == mine then reveal(0) end
    end)
  end)
end

local island = {}

-- The shelf: unread messages as app icons in a rounded bump that drops out
-- of the notch, on hover or briefly when one arrives. It's the hug's popup,
-- lifted so its top hides behind the notch; the outline, in the app's
-- colour, runs round the notch and on round the bump.
local shelf_height, slot = 36, 32
local shelf = { apps = {}, items = {}, badges = {}, tints = {}, shown = nil, inside = false, peek = 0, token = nil }

-- `t` of `color` over the bar, opaque: the popup sits over the bar.
local function tint(color, t)
  local function ch(c, s) return (c >> s) & 0xff end
  local out = 0xff000000
  for _, s in ipairs({ 16, 8, 0 }) do
    out = out | (math.floor(ch(colors.bar.bg, s) * (1 - t) + ch(color, s) * t + 0.5) << s)
  end
  return out
end

hug:set({
  popup = {
    align = "center",
    horizontal = true,
    blur_radius = 0,
    background = { border_width = stroke, shadow = { drawing = false } },
  },
})

local function spacer(name)
  return sbar.add("item", name, {
    position = "popup." .. hug.name,
    padding_left = 0,
    padding_right = 0,
    icon = { drawing = false },
    label = { drawing = false },
  })
end
local pad_left, pad_right = spacer("island.shelf.pad.left"), nil

-- `apps` is a list of { name, bundle id, colour }.
function island.shelf(apps)
  for _, app in ipairs(apps) do
    shelf.apps[#shelf.apps + 1] = app[1]
    shelf.tints[app[1]] = app[3]
    shelf.items[app[1]] = sbar.add("item", "island.shelf." .. app[1], {
      position = "popup." .. hug.name,
      drawing = false,
      padding_left = 0,
      padding_right = 0,
      icon = {
        string = "",
        width = slot,
        padding_left = 0,
        padding_right = 0,
        background = { drawing = true, color = colors.transparent, image = { string = "app." .. app[2], scale = 0.7 } },
      },
      label = {
        padding_left = 0,
        padding_right = 6,
        font = { family = settings.font.numbers, style = "Bold", size = 11.0 },
        color = colors.white,
      },
      click_script = "open -a '" .. app[1] .. "'",
    })
  end
  pad_right = spacer("island.shelf.pad.right")
end

-- Closed, the bump sits wholly behind the notch.
local function shelf_offset(open)
  return -bar_height - (open and 0 or shelf_height)
end

local function shelf_close()
  if not shelf.shown then return end
  shelf.shown = nil
  sbar.animate("sin", 12, function()
    hug:set({ popup = { y_offset = shelf_offset(false) } })
  end)
  local mine = shelf.token
  sbar.delay(0.25, function()
    if not shelf.shown then hug:set({ popup = { drawing = false } }) end
  end)
  if mine and token == mine then fade(mine, 0.1) end
end

-- Shows `names` (those with a badge) in the first one's colour.
-- sketchybar draws popups only on the display with keyboard focus, so
-- elsewhere it calls `skipped` instead.
local function shelf_open(names, skipped)
  if not g or #names == 0 then return end
  sbar.exec("aerospace list-monitors --focused --format '%{monitor-appkit-nsscreen-screens-id}'", function(out)
    if not g or tonumber(out) ~= g.display then
      if skipped then skipped() end
      return
    end
    local color = shelf.tints[names[1]] or colors.white
    local show_ = {}
    for _, n in ipairs(names) do show_[n] = true end
    for _, n in ipairs(shelf.apps) do
      shelf.items[n]:set({ drawing = show_[n] == true, y_offset = -(g.notch_height // 2) })
    end
    -- Round at the bottom: the radius is half the part below the notch.
    local pad = 8
    pad_left:set({ width = pad })
    pad_right:set({ width = pad })
    local was_open = shelf.shown ~= nil
    shelf.shown = names

    -- The outline round the notch, in the same colour.
    local mine = show(color)
    shelf.token = mine
    sweep(mine, 1, was_open and 0 or 0.2)

    hug:set({
      popup = {
        height = g.notch_height + shelf_height,
        background = {
          color = tint(color, 0.18),
          border_color = color,
          corner_radius = shelf_height // 2,
        },
      },
    })
    if not was_open then
      hug:set({ popup = { y_offset = shelf_offset(false), drawing = true } })
    end
    sbar.delay(was_open and 0 or 0.15, function()
      if shelf.shown ~= names then return end
      sbar.animate("sin", 15, function()
        hug:set({ popup = { y_offset = shelf_offset(true) } })
      end)
    end)
  end)
end

local function unread()
  local names = {}
  for _, n in ipairs(shelf.apps) do
    if (shelf.badges[n] or "") ~= "" then names[#names + 1] = n end
  end
  return names
end

function island.badge(name, badge)
  local item = shelf.items[name]
  if item and shelf.badges[name] ~= badge then
    shelf.badges[name] = badge
    item:set({ label = badge })
  end
end

-- Hover: the mouse may cross from the notch onto the shelf, so leaving
-- either waits a moment before closing.
local function hover(inside)
  shelf.inside = inside
  if inside then
    -- A peek shows one app; hovering shows them all.
    local names = unread()
    if not shelf.shown or #shelf.shown < #names then shelf_open(names) end
    return
  end
  sbar.delay(0.3, function()
    if not shelf.inside then shelf_close() end
  end)
end

-- Length is the level.
function island.volume(percent)
  local mine = show(colors.white)
  if not mine then return end
  sweep(mine, percent / 100, 0.15, function() fade(mine, 1.0) end)
end

-- Plugging in wraps the notch in green; unplugging unwinds it in grey.
function island.power(charging)
  if charging then
    local mine = show(colors.green)
    if not mine then return end
    reveal(0)
    sweep(mine, 1, 0.7, function() fade(mine, 0.5) end)
  else
    local mine = show(colors.grey)
    if not mine then return end
    reveal(1)
    sweep(mine, 0, 0.7, function() fade(mine, 0) end)
  end
end

-- Two beats of `color` along the bottom edge.
local function beats(color)
  local mine = show(colors.with_alpha(color, 0.25))
  if not mine then return end
  reveal(g.bottom / g.legs[3])
  local steps = { { color, 0 }, { colors.with_alpha(color, 0.25), 0.3 }, { color, 0.55 } }
  for _, b in ipairs(steps) do
    sbar.delay(b[2], function()
      if token ~= mine then return end
      sbar.animate("tanh", 12, function() hug:set({ background = { border_color = b[1] } }) end)
    end)
  end
  fade(mine, 1.3)
end

-- A peek at the app on the shelf, outlined in its colour; beats when the
-- shelf can't show.
function island.message(color, name)
  if not name or not g then return beats(color) end
  -- Already open: just take in the new app.
  if shelf.shown then return shelf_open(unread()) end
  shelf.peek = shelf.peek + 1
  local peek = shelf.peek
  shelf_open({ name }, function() beats(color) end)
  sbar.delay(2.5, function()
    if shelf.peek == peek and not shelf.inside then shelf_close() end
  end)
end

function island.watch_hover()
  hug:subscribe("mouse.entered", function() hover(true) end)
  hug:subscribe("mouse.exited", function() hover(false) end)
  for _, item in pairs(shelf.items) do
    item:subscribe("mouse.entered", function() hover(true) end)
    item:subscribe("mouse.exited", function() hover(false) end)
  end
  for _, item in ipairs({ pad_left, pad_right }) do
    item:subscribe("mouse.entered", function() hover(true) end)
    item:subscribe("mouse.exited", function() hover(false) end)
  end
end

-- Called with the notched display and the island's left edge in global
-- coordinates, as bounding_rects reports them (or nil), whenever they change.
local listeners = {}
function island.on_notch(fn) listeners[#listeners + 1] = fn end

-- Only a notched display has an island; the first one wins.
-- display_change also fires when focus moves between displays, so only an
-- actual change resets the island.
local last = nil
local function find_notch()
  sbar.exec("$CONFIG_DIR/helpers/notch/bin/notch", function(out)
    local d, o, w, l, r, h = out:match("(%d+) (-?[%d.]+) ([%d.]+) ([%d.]+) ([%d.]+) ([%d.]+)")
    local key = d and table.concat({ d, o, w, l, r, h }, " ") or ""
    if key == last then return end
    last = key
    token = token + 1
    if d then
      configure(tonumber(d), tonumber(o), tonumber(w), tonumber(l), tonumber(r), tonumber(h))
      reveal(0)
      hug:set({ background = { border_color = colors.transparent } })
      -- Always drawn, transparent when idle: showing an item mid-event
      -- would draw the outline a frame before the masks over it.
      all({ drawing = true })
    else
      g = nil
      all({ drawing = false })
    end
    for _, fn in ipairs(listeners) do fn(g and g.display, g and g.origin + g.outer_left) end
  end)
end

local watcher = sbar.add("item", { drawing = false, updates = true })
watcher:subscribe("display_change", function() sbar.delay(1, find_notch) end)
find_notch()

return island
