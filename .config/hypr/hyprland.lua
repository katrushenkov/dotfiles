-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- App -> workspace slot (1-10) on a preferred monitor. Workspaces are per
-- monitor (default/hypr/monitor-workspaces.lua), so the real workspace id is
-- computed from the monitor's block. If the preferred monitor isn't connected
-- (e.g. on the laptop), the app goes to the same slot on the primary screen:
-- the built-in panel, or else the first monitor. Rules are re-synced whenever
-- monitors change, so the same file works on every machine.
local app_workspaces = {
  { class = "emacs",                slot = 1, monitor = "Xiaomi Corporation Mi Monitor" },
  { class = "vivaldi.*",            slot = 2, monitor = "Xiaomi Corporation Mi Monitor" },
  { class = "org.omarchy.herdr",    slot = 3, monitor = "Xiaomi Corporation Mi Monitor" },
  { class = "org.telegram.desktop", slot = 4 }, -- primary screen everywhere
}

local function primary_monitor(monitors)
  for _, m in ipairs(monitors) do
    if m.name:match("^eDP") or m.name:match("^LVDS") or m.name:match("^DSI") then
      return m
    end
  end
  table.sort(monitors, function(a, b) return a.id < b.id end)
  return monitors[1]
end

local function sync_app_workspaces(gone)
  local monitors = {}
  for _, m in ipairs(hl.get_monitors()) do
    if not m.is_mirror and m.name ~= gone then
      monitors[#monitors + 1] = m
    end
  end

  for i, app in ipairs(app_workspaces) do
    local target = nil
    if app.monitor then
      for _, m in ipairs(monitors) do
        if (m.description or ""):find(app.monitor, 1, true) then
          target = m
        end
      end
    end
    target = target or primary_monitor(monitors)

    local id = target and o.workspaces.workspace_id(target, app.slot) or app.slot
    -- A window rule naming a workspace that doesn't exist yet creates it on the
    -- focused monitor, so pin the workspace itself to the target monitor.
    if target then
      hl.workspace_rule({ workspace = tostring(id), monitor = target.name })
    end
    hl.window_rule({
      name = "personal-app-workspace-" .. i,
      enabled = true,
      match = { class = app.class },
      workspace = tostring(id),
    })
  end
end

sync_app_workspaces()
hl.on("hyprland.start", function() sync_app_workspaces() end)
hl.on("config.reloaded", function() sync_app_workspaces() end)
hl.on("monitor.added", function() sync_app_workspaces() end)
hl.on("monitor.removed", function(monitor)
  local name = monitor and monitor.name
  hl.timer(function() sync_app_workspaces(name) end, { type = "oneshot", timeout = 1 })
end)

-- go-datagrip-tofi: open its terminal floating, centered, at 80% of the screen.
o.window("org.omarchy.datagrip-go", { float = true, center = true, size = { "(monitor_w*0.8)", "(monitor_h*0.8)" } })

-- NVIDIA: GTK4's default Vulkan renderer draws black windows (Transmission, Nautilus); use OpenGL.
hl.env("GSK_RENDERER", "ngl")
