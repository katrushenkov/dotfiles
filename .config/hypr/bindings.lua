-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { omarchy = "walker -m symbols" })

local sc = os.getenv("HOME") .. "/.local/bin/"

hl.unbind("SUPER + G")
hl.bind("SUPER + G", hl.dsp.exec_cmd(sc .. "go-datagrip"), { description = "Search digital brain" })

hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Toggle window grouping", hl.dsp.group.toggle())

hl.unbind("SUPER + A")
hl.bind("SUPER + A", hl.dsp.exec_cmd(sc .. "linkhandler"), { description = "Linkhandler" })

hl.unbind("SUPER + D")
o.bind("SUPER + D", "Launch apps", "omarchy-shell shell toggle omarchy.launcher \"{}\"")

hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

hl.unbind("SUPER + P")
hl.bind("SUPER + P", hl.dsp.exec_cmd(sc .. "gopass-autotype"), { description = "" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd(sc .. "snippets-yank"), { description = "" })
hl.bind("ALT + Y", hl.dsp.exec_cmd(sc .. "snippets-yank"), { description = "" })
hl.bind("SUPER + I", hl.dsp.exec_cmd(sc .. "snippets-type"), { description = "" })
hl.bind("SUPER + INSERT", hl.dsp.exec_cmd(sc .."snippets-type"), { description = "" })
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd(sc .. "snippets-files"), { description = "" })

hl.bind("SUPER + B", hl.dsp.exec_cmd(sc .."hypr-switch-en ; ~/.local/bin/bookmarks-web -so"), { description = "bookmarks" })

hl.bind("SUPER + F1", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Keybindings" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Command palette" })

hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
hl.bind("SUPER + S", hl.dsp.exec_cmd("~/.local/bin/go-ssh"), { description = "Connect via ssh" })

--hl.bind("SUPER + E", hl.dsp.exec_cmd(sc .. "edit-configs"), { description = "Edit confgs" })

-- hl.bind("SUPER + M", hl.dsp.exec_cmd("mousepad"), { description = "" })
-- hl.bind("SUPER + N", hl.dsp.exec_cmd("$terminal n"), { description = "" })

hl.unbind("SUPER + T")
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"), { description = "Thunar file manager" })

hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })

-- Physical CapsLock+G (remapped via keyd, see /etc/keyd/default.conf: hold
-- CapsLock + G sends the KEY_F13 evdev code, since tapping CapsLock alone
-- still sends Escape). The default xkb keymap maps that keycode to the
-- keysym XF86Tools rather than F13, so we bind on that instead.
hl.bind("XF86Tools", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser (CapsLock+G)" })

-- More CapsLock+<key> chords, same mechanism (see /etc/keyd/default.conf
-- [capsmode] layer). Each keyd layer key sends a distinct evdev F-key code,
-- which the default xkb keymap turns into an XF86 keysym instead of the
-- literal Fxx name. Just replace the TODO command with whatever you want:
hl.bind("XF86Launch5", hl.dsp.exec_cmd("TODO: command for CapsLock+V"), { description = "TODO (CapsLock+V)" })
hl.bind("XF86Launch6", hl.dsp.exec_cmd("TODO: command for CapsLock+T"), { description = "TODO (CapsLock+T)" })
hl.bind("XF86Launch7", hl.dsp.exec_cmd("TODO: command for CapsLock+M"), { description = "TODO (CapsLock+M)" })

hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })

hl.bind("ALT + RETURN", hl.dsp.exec_cmd("pypr toggle term"), { description = "Pypr toggle term" })
hl.bind("ALT + E",      hl.dsp.exec_cmd("omarchy-shell shell toggle local.emojis"), { description = "Emojis" })

-- Move focus with mainMod + [H, L, K, J]
hl.unbind("SUPER + L")
hl.unbind("SUPER + K")
hl.unbind("SUPER + J")
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Focus on left window" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Focus on right window" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Focus on above window" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Focus on below window" })

hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window to the left" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window to the right" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

hl.bind("ALT + J", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("ALT + K", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })

o.bind("SUPER + BACKSLASH", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + grave", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

o.bind("SUPER + Z", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + N", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + ALT + h", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + l", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + k", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + j", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

hl.unbind("SUPER + CTRL + h")
hl.unbind("SUPER + CTRL + l")
o.bind("SUPER + CTRL + l", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + CTRL + h", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

o.bind("ALT + h", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("ALT + l", "Move grouped window focus right", hl.dsp.group.next())

hl.bind("ALT + F", hl.dsp.workspace.toggle_special("firefox"), { description = "Toggle firefox workspace" })
hl.bind("ALT + SHIFT + F", hl.dsp.window.move({ workspace = "special:firefox", follow = false }), { description = "Move window to firefox workspace" })

o.bind("ALT + Right", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("ALT + Left", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })

