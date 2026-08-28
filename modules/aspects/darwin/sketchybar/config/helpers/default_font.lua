-- NOTE: "SF Pro" is not a real family. Apple ships SF Pro Text (optical size
-- for UI/body), SF Pro Display (large sizes) and SF Pro Rounded -- asking for
-- plain "SF Pro" silently falls back to the system default. Text is the right
-- one at bar sizes (12-16pt).
return {
  text = "SF Pro Text",
  numbers = "SF Mono",

  -- Unified font style map. Every entry exists in both SF Pro Text and
  -- SF Mono except Black, which SF Mono lacks -- numbers never use it.
  style_map = {
    ["Regular"] = "Regular",
    ["Semibold"] = "Semibold",
    ["Bold"] = "Bold",
    ["Heavy"] = "Heavy",
    ["Black"] = "Black",
  }
}
