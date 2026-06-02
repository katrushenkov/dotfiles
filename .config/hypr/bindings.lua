local sc = os.getenv("HOME") .. "/.local/bin"

-- Application bindings.
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"]]), { description = "Tmux" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus-tui cliamp"), { description = "Music TUI" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("omarchy-launch-tui lazydocker"), { description = "Docker" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"]]), { description = "Signal" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"]]), { description = "Obsidian" })

hl.unbind("SUPER + A")
hl.bind("SUPER + A", hl.dsp.exec_cmd(sc .. "/linkhandler"), { description = "Linkhandler" })

hl.bind("ALT + SHIFT + B", hl.dsp.exec_cmd("pkill waybar ; waybar &"), { description = "Restart waybar" })
hl.bind("ALT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"), { description = "Toggle waybar" })

hl.bind("SUPER + grave", hl.dsp.exec_cmd(sc .. "/ksm/flat-menu"), { description = "Omarchy flat menu" })

hl.unbind("SUPER + P")
hl.bind("SUPER + P", hl.dsp.exec_cmd("tessen -d tofi -a autotype"), { description = "" })
-- hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("tessen -d tofi -a copy"), { description = "" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("walker -m menus:gopass"), { description = "" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd(sc .. "/snippets-yank"), { description = "" })
hl.bind("ALT + Y", hl.dsp.exec_cmd(sc .. "/snippets-yank"), { description = "" })
hl.bind("SUPER + I", hl.dsp.exec_cmd(sc .. "/snippets-type"), { description = "" })
hl.bind("SUPER + INSERT", hl.dsp.exec_cmd(sc .."/snippets-type"), { description = "" })
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd(sc .. "/snippets-files"), { description = "" })

hl.bind("SUPER + B", hl.dsp.exec_cmd(sc .."/hypr-switch-en ; ~/.local/bin/bookmarks-web -so"), { description = "bookmarks" })
hl.bind("SUPER + D", hl.dsp.exec_cmd(sc .. "/tofi_run"), { description = "tofi_run" })

hl.bind("SUPER + F1", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Keybindings" })

-- hl.unbind("SUPER + G")
-- hl.bind("SUPER + G", hl.dsp.exec_cmd(sc .. "/datagrip-go"), { description = "" })

hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
hl.bind("SUPER + S", hl.dsp.exec_cmd("~/.local/bin/go-ssh"), { description = "Connect via ssh" })

hl.bind("SUPER + E", hl.dsp.exec_cmd(sc .. "/edit-configs"), { description = "Edit confgs" })
-- hl.bind("SUPER + M", hl.dsp.exec_cmd("mousepad"), { description = "" })
-- hl.bind("SUPER + N", hl.dsp.exec_cmd("$terminal nnn"), { description = "" })

hl.unbind("SUPER + T")
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"), { description = "Thunar file manager" })

hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })

hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })

hl.bind("ALT + RETURN", hl.dsp.exec_cmd("pypr toggle term"), { description = "Pypr toggle term" })
hl.bind("ALT + E",      hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"), { description = "Emoji yank" })

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

hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("ALT + J", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("ALT + K", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })

-- hl.bind("ALT + F", hl.dsp.workspace.toggle_special("firefox"), { description = "Toggle scratchpad" })
-- hl.bind("ALT + SHIFT + F", hl.dsp.window.move({ workspace = "special:firefox", follow = false }), { description = "Move window to scratchpad" })

-- Overwrite existing bindings with hl.unbind() first if needed.
-- hl.unbind("SUPER + SPACE")
-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })

-- hl.bind("SUPER + H", hl.dsp.exec_cmd("voxtype record toggle"))

o.bind("ALT + Right", "Volume up", "omarchy-swayosd-client --output-volume raise", { locked = true, repeating = true })
o.bind("ALT + Left", "Volume down", "omarchy-swayosd-client --output-volume lower", { locked = true, repeating = true })

o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
