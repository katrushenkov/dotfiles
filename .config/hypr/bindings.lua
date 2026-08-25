local sc = os.getenv("HOME") .. "/.local/bin/"

hl.unbind("SUPER + G")
o.bind("SUPER + G", "Search digital brain", hl.dsp.exec_cmd(sc .. "go-datagrip-tofi"))

hl.unbind("SUPER + SHIFT + G")
o.bind("ALT + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("ALT + SHIFT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))


hl.unbind("SUPER + A")
o.bind("SUPER + A", "Linkhandler", hl.dsp.exec_cmd(sc .. "linkhandler"))

hl.unbind("SUPER + D")
o.bind("SUPER + D", "Omarchy menu", "omarchy-menu toggle apps")

hl.unbind("SUPER + P")
o.bind("SUPER + P", "Gopass autotype", hl.dsp.exec_cmd(sc .. "gopass-autotype"))
o.bind("SUPER + I", "Snippets yank", hl.dsp.exec_cmd(sc .. "snippets-yank"))
o.bind("SUPER + SHIFT + I", "Snippets files" , hl.dsp.exec_cmd(sc .. "snippets-files-tofi"))

o.bind("SUPER + B", "Search bookmarks", hl.dsp.exec_cmd(sc .. "bookmarks-web -s"))
hl.unbind("SUPER + SHIFT + B")
o.bind("SUPER + SHIFT + B", "Search bookmarks by tag", hl.dsp.exec_cmd(sc .. "bookmarks-web -st"))

o.bind("SUPER + F1", "Keybindings", hl.dsp.exec_cmd("omarchy-menu-keybindings"))
o.bind("SUPER + E", "Command palette", hl.dsp.exec_cmd("omarchy-menu-keybindings"))

hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
o.bind("SUPER + S", "Connect via ssh", hl.dsp.exec_cmd(sc .. "go-ssh"))

-- hl.bind("SUPER + E", hl.dsp.exec_cmd(sc .. "edit-configs"), { description = "Edit confgs" })

-- o.bind("SUPER + M", hl.dsp.exec_cmd("mousepad"))
o.bind("SUPER + M"," floating term", hl.dsp.exec_cmd("omarchy-launch-floating-terminal-with-presentation"))
-- o.bind("SUPER + N", hl.dsp.exec_cmd("$terminal n"))

hl.unbind("SUPER + T")
o.bind("SUPER + T", "File manager (cwd)", { omarchy = "nautilus-cwd" })

hl.unbind("SUPER + W")
o.bind("SUPER + W", "Browser", { focus = "vivaldi", launch = "omarchy-launch-browser" })

-- Physical CapsLock+G (remapped via keyd, see /etc/keyd/default.conf: hold
-- CapsLock + G sends the KEY_F13 evdev code, since tapping CapsLock alone
-- still sends Escape). The default xkb keymap maps that keycode to the
-- keysym XF86Tools rather than F13, so we bind on that instead.
o.bind("XF86Tools", "Browser (CapsLock+G)", { focus = "vivaldi", launch = "omarchy-launch-browser" })
o.bind("XF86Launch5", "TODO (CapsLock+V)", { focus = "vivaldi", launch = "omarchy-launch-browser" })

-- More CapsLock+<key> chords, same mechanism (see /etc/keyd/default.conf
-- [capsmode] layer). Each keyd layer key sends a distinct evdev F-key code,
-- which the default xkb keymap turns into an XF86 keysym instead of the
-- literal Fxx name. Just replace the TODO command with whatever you want:
o.bind("XF86Launch6", "Telegram (CapsLock+T)", { focus = "telegram", launch = "Telegram" })
o.bind("XF86Launch7", "TODO (CapsLock+M)", hl.dsp.exec_cmd("TODO: command for CapsLock+M"))

-- keyd [capsmode]: e = f17, f = f18, k = f19 (F19 keeps its literal keysym,
-- unlike F13-F18 which xkb remaps to XF86Tools/XF86LaunchN):
o.bind("XF86Launch8", "TODO (CapsLock+E)", hl.dsp.exec_cmd("TODO: command for CapsLock+E"))
o.bind("XF86Launch9", "TODO (CapsLock+F)", hl.dsp.exec_cmd("TODO: command for CapsLock+F"))
o.bind("F19", "TODO (CapsLock+K)", hl.dsp.exec_cmd("TODO: command for CapsLock+K"))

o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

o.bind("ALT + RETURN", "Pypr toggle term", hl.dsp.exec_cmd("pypr toggle term"))

o.bind("ALT + E", "Emojis", hl.dsp.exec_cmd("omarchy-shell shell toggle local.emojis"))

-- Move focus with mainMod + [H, L, K, J]
hl.unbind("SUPER + L")
hl.unbind("SUPER + K")
hl.unbind("SUPER + J")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("ALT + J", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("ALT + K", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

o.bind("SUPER + BACKSLASH", "Toggle window split", hl.dsp.layout("togglesplit"))

o.bind("SUPER + Z", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + N", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("ALT + SHIFT + h", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("ALT + SHIFT + l", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("ALT + SHIFT + k", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("ALT + SHIFT + j", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

hl.unbind("SUPER + CTRL + h")
hl.unbind("SUPER + CTRL + l")
o.bind("SUPER + CTRL + l", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + CTRL + h", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

o.bind("SUPER + SHIFT + ALT + h", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + l", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + k", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + j", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

o.bind("ALT + h", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("ALT + l", "Move grouped window focus right", hl.dsp.group.next())

o.bind("ALT + F", "Toggle firefox workspace", hl.dsp.workspace.toggle_special("firefox"))
o.bind("ALT + SHIFT + F", "Move window to firefox workspace", hl.dsp.window.move({ workspace = "special:firefox", follow = false }))

o.bind("ALT + Right", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("ALT + Left", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })

