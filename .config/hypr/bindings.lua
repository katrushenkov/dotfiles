local sc = os.getenv("HOME") .. "/.local/bin/"

o.rebind("SUPER + G", "Search digital brain", hl.dsp.exec_cmd(sc .. "go-datagrip-tofi"))

hl.unbind("SUPER + SHIFT + G")
o.bind("ALT + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("ALT + SHIFT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))


o.rebind("SUPER + A", "Linkhandler", hl.dsp.exec_cmd(sc .. "linkhandler"))

o.rebind("SUPER + D", "Omarchy menu", "omarchy-menu toggle apps")

o.rebind("SUPER + P", "Gopass autotype", hl.dsp.exec_cmd(sc .. "gopass-autotype"))
o.bind("SUPER + I", "Snippets yank", hl.dsp.exec_cmd(sc .. "snippets-yank"))
o.bind("SUPER + SHIFT + I", "Snippets files" , hl.dsp.exec_cmd(sc .. "snippets-files-tofi"))

o.bind("SUPER + B", "Search bookmarks", hl.dsp.exec_cmd(sc .. "bookmarks-web -s"))
o.rebind("SUPER + SHIFT + B", "Search bookmarks by tag", hl.dsp.exec_cmd(sc .. "bookmarks-web -st"))

o.bind("SUPER + F1", "Keybindings", hl.dsp.exec_cmd("omarchy-menu-keybindings"))
o.bind("SUPER + E", "Command palette", hl.dsp.exec_cmd("omarchy-menu-keybindings"))

hl.unbind("SUPER + ALT + S")
o.rebind("SUPER + S", "Connect via ssh", hl.dsp.exec_cmd(sc .. "go-ssh"))

-- hl.bind("SUPER + E", hl.dsp.exec_cmd(sc .. "edit-configs"), { description = "Edit confgs" })

-- o.bind("SUPER + M", hl.dsp.exec_cmd("mousepad"))
o.bind("SUPER + M", "Floating term", hl.dsp.exec_cmd("omarchy-launch-floating-terminal-with-presentation"))
-- o.bind("SUPER + N", hl.dsp.exec_cmd("$terminal n"))

o.rebind("SUPER + T", "File manager (cwd)", { omarchy = "nautilus-cwd" })

o.rebind("SUPER + W", "Browser", { focus = "vivaldi", launch = "omarchy-launch-browser" })

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
--
o.bind("XF86Launch8", "Emacs (CapsLock+E)",
  "omarchy-launch-or-focus " .. o.shell_quote("^Emacs$") .. " " .. o.shell_quote(o.launch("emacsclient -c -a ''")))
o.bind("XF86Launch9", "TODO (CapsLock+F)", hl.dsp.exec_cmd("TODO: command for CapsLock+F"))
o.bind("F19", "TODO (CapsLock+K)", hl.dsp.exec_cmd("TODO: command for CapsLock+K"))

-- keyd [capsmode]: space = f24 (added). F20-F23 are NOT free like F19 —
-- xkb's inet(evdev) symbols hardcode them to XF86AudioMicMute/TouchpadToggle/
-- TouchpadOn/TouchpadOff ("historical mappings that must not be removed").
-- F20 was tried first and silently triggered mic-mute instead. F24 is the
-- next one that keeps its literal keysym in the base group (confirmed in
-- /usr/share/X11/xkb/symbols/inet) and isn't bound to anything else.
o.bind("F24", "Switch keyboard layout (CapsLock+Space)", hl.dsp.exec_cmd(sc .. "hypr-switch-layout"))

-- keyd [capsmode]: d = shop (F-keys are exhausted; keyd's "prog1-4" are just
-- aliases for f21-f24, so "prog3" silently sent F23 = XF86TouchpadOff).
-- KEY_SHOP maps to XF86Shop in xkb's inet(evdev) and is otherwise unused.
o.bind("XF86Shop", "Command palette (CapsLock+D)", hl.dsp.exec_cmd("omarchy-menu-keybindings"))

-- Spare keycodes for future CapsLock+<key> chords (keysyms verified with
-- `xkbcli compile-keymap`, none bound elsewhere). To use one: add
-- `<letter> = <keyd name>` to [capsmode] in /etc/keyd/default.conf
-- (`keyd check` it, then `sudo keyd reload`) and uncomment the bind here.
--
--   keyd name   evdev code        xkb keysym
--   finance     KEY_FINANCE 219   XF86Finance
--   sport       KEY_SPORT   220   XF86Game
--   connect     KEY_CONNECT 218   XF86Go
--   chat        KEY_CHAT    216   XF86Messenger
--
-- o.bind("XF86Finance", "TODO (CapsLock+?)", hl.dsp.exec_cmd("TODO"))
-- o.bind("XF86Game", "TODO (CapsLock+?)", hl.dsp.exec_cmd("TODO"))
-- o.bind("XF86Go", "TODO (CapsLock+?)", hl.dsp.exec_cmd("TODO"))
-- o.bind("XF86Messenger", "TODO (CapsLock+?)", hl.dsp.exec_cmd("TODO"))

o.bind("ALT + RETURN", "Pypr toggle term", hl.dsp.exec_cmd("pypr toggle term"))

o.bind("ALT + E", "Emojis", hl.dsp.exec_cmd("omarchy-shell shell toggle local.emojis"))

-- Move focus with mainMod + [H, L, K, J]
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.rebind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.rebind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.rebind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("SUPER + BACKSLASH", "Toggle window split", hl.dsp.layout("togglesplit"))

o.bind("SUPER + Z", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + N", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("ALT + SHIFT + h", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("ALT + SHIFT + l", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("ALT + SHIFT + k", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("ALT + SHIFT + j", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

o.rebind("SUPER + CTRL + l", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.rebind("SUPER + CTRL + h", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

o.bind("SUPER + SHIFT + ALT + h", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + l", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + k", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + j", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

o.bind("SUPER + SHIFT + CTRL + l", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))
o.bind("SUPER + SHIFT + CTRL + h", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))

o.bind("ALT + h", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("ALT + l", "Move grouped window focus right", hl.dsp.group.next())

o.bind("ALT + F", "Toggle firefox workspace", hl.dsp.workspace.toggle_special("firefox"))
o.bind("ALT + SHIFT + F", "Move window to firefox workspace", hl.dsp.window.move({ workspace = "special:firefox", follow = false }))

o.bind("ALT + Right", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("ALT + Left", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })

-- Universal paste (SUPER+V) in Emacs: default/hypr/bindings/clipboard.lua
-- sends Ctrl+V to any non-terminal window, but Emacs binds that to
-- scroll-down, not yank, so paste silently did nothing there. Redirect to
-- Ctrl+Shift+V for Emacs windows specifically — bound in
-- ~/.config/doom/config.el to plain `yank', which is the one paste-like
-- command evil leaves alone in every state. Re-checks the terminal branch
-- too (see clipboard.lua) since this replaces the whole binding.
local function send_key_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end
  return false
end

o.rebind("SUPER + V", "Universal paste", function()
  local window = hl.get_active_window()
  if window and window.class == "emacs" then
    send_key_once("CTRL SHIFT", "V")()
  elseif active_window_is_terminal() then
    send_key_once("SHIFT", "Insert")()
  else
    send_key_once("CTRL", "V")()
  end
end)

o.bind("ALT + J", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("ALT + K", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- ALT+J/ALT+K also happen to be org-mode's move-subtree-down/up (M-j/M-k,
-- see evil org bindings in ~/.config/doom/config.el), but that's unreachable
-- here since Hyprland grabs the chord first. Using `SPC m s j`/`SPC m s k`
-- in Emacs instead for now (doesn't need WM forwarding at all). Re-enable
-- this if the localleader path turns out to be too slow:
--
-- o.bind("ALT + J", "Next workspace", function()
--   local window = hl.get_active_window()
--   if window and window.class == "emacs" then
--     send_key_once("ALT", "J")()
--   else
--     hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
--   end
-- end)
--
-- o.bind("ALT + K", "Previous workspace", function()
--   local window = hl.get_active_window()
--   if window and window.class == "emacs" then
--     send_key_once("ALT", "K")()
--   else
--     hl.dispatch(hl.dsp.focus({ workspace = "e-1" }))
--   end
-- end)

