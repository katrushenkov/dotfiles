-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Explicit fractional scales (not "auto"). GDK_SCALE is 1 above so GTK apps
-- don't render 2x on these non-HiDPI panels. DP-1 uses 1.25 because
-- 2560x1440 isn't evenly divisible by 1.2 (Hyprland rounded it to 1.25 anyway).
hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "auto-left", scale = 1.25, transform = 0 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080", position = "auto-right", scale = 1.2, transform = 3 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
