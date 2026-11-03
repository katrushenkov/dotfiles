-- Scale, resolution and arrangement are set from the monitor panel in the top
-- bar, as are refresh rate and rotation, and saved for each monitor in
-- ~/.local/state/omarchy/monitors/settings. This file is for what the panel
-- doesn't cover, and it loads after Omarchy's defaults. A choice made in the
-- panel still wins for that monitor, unless the panel's choices are switched
-- off below.
--
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Ignore the monitor panel's saved choices, so this file alone sets every
-- monitor, such as to keep the same setup in your dotfiles across machines.
-- The panel's changes then last only until Hyprland reloads. With the panel
-- off, match a monitor by its description rather than the port it's in:
-- hl.monitor({ output = "desc:Dell Inc. DELL U2723QE", mode = "preferred", position = "auto", scale = 1.5 })
-- omarchy_monitor_panel_settings = false

-- Scale every monitor without a choice of its own (Omarchy picks "auto").
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.6 })

-- GTK and XWayland scale, a whole number (Omarchy sets 2 until a scale is
-- chosen in the panel, then follows the lowest monitor scale).
-- hl.env("GDK_SCALE", "1")

-- Keep a monitor off, such as the phantom output an Apple 6K XDR can show.
-- hl.monitor({ output = "DP-3", disabled = true })

-- Run a mode the panel doesn't offer: a resolution below 1080p or of another
-- shape, a fast rate at a resolution other than the current one, or a scale
-- outside its presets.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "auto", scale = 1.5 })

-- 10-bit color.
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, bitdepth = 10 })

-- Variable refresh rate (0 = off, 1 = always, 2 = fullscreen only).
-- hl.config({ misc = { vrr = 0 } })

-- Per-host setup: these dotfiles are shared between machines.
local f = io.open("/etc/hostname")
local hostname = f and f:read("*l") or ""
if f then f:close() end

if hostname == "mi" then
  -- Laptop, built-in eDP-1 only: Omarchy defaults (scale auto, GDK_SCALE
  -- follows the panel). Nothing to override.
else
  -- Desktop dual-monitor setup.
  -- Explicit scales (not "auto"). GDK_SCALE is 1 so GTK apps
  -- don't render 2x on these non-HiDPI panels.
  -- HDMI-A-1 uses 1.2 (1920x1080 divides evenly: 1600x900 logical).
  -- Positions are explicit: DP-1 is 2048x1152 logical, rotated HDMI-A-1 is 900x1600,
  -- so DP-1 is shifted down by (1600 - 1152) / 2 = 224 to center it vertically.
  hl.env("GDK_SCALE", "1")
  hl.monitor({ output = "DP-1", mode = "2560x1440@180", position = "0x224", scale = 1.25, transform = 0 })
  hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@75", position = "2048x0", scale = 1.2, transform = 3 })
end
