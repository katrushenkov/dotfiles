-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Explicit scales (not "auto"). GDK_SCALE is 1 above so GTK apps
-- don't render 2x on these non-HiDPI panels.
-- HDMI-A-1 uses 1.2 (1920x1080 divides evenly: 1600x900 logical).
-- Positions are explicit: DP-1 is 2048x1152 logical, rotated HDMI-A-1 is 900x1600,
-- so DP-1 is shifted down by (1600 - 1152) / 2 = 224 to center it vertically.
hl.monitor({ output = "DP-1", mode = "2560x1440@180", position = "0x224", scale = 1.25, transform = 0 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@75", position = "2048x0", scale = 1.2, transform = 3 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
