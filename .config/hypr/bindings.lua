-- Application bindings.
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"]]), { description = "Terminal" })
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"]]), { description = "Tmux" })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm-app -- nautilus --new-window"), { description = "File manager" })
hl.bind("SUPER + ALT + SHIFT + F", hl.dsp.exec_cmd([[uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"]]), { description = "File manager (cwd)" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus spotify"), { description = "Music" })
hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus-tui cliamp"), { description = "Music TUI" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("omarchy-launch-editor"), { description = "Editor" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("omarchy-launch-tui lazydocker"), { description = "Docker" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"]]), { description = "Signal" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd([[omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"]]), { description = "Obsidian" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm-app -- typora --enable-wayland-ime"), { description = "Typora" })
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd("uwsm-app -- 1password"), { description = "Passwords" })

-- Web app bindings.
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://chatgpt.com"]]), { description = "ChatGPT" })
hl.bind("SUPER + SHIFT + ALT + A", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://grok.com"]]), { description = "Grok" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"]]), { description = "Calendar" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://app.hey.com"]]), { description = "Email" })
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://youtube.com/"]]), { description = "YouTube" })
hl.bind("SUPER + SHIFT + ALT + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"]]), { description = "WhatsApp" })
hl.bind("SUPER + SHIFT + CTRL + G", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"]]), { description = "Google Messages" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd([[omarchy-launch-or-focus-webapp "Google Photos" "https://photos.google.com/"]]), { description = "Google Photos" })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://x.com/"]]), { description = "X" })
hl.bind("SUPER + SHIFT + ALT + X", hl.dsp.exec_cmd([[omarchy-launch-webapp "https://x.com/compose/post"]]), { description = "X Post" })

-- $sc = ~/.local/bin/

-- Add extra bindings below.
-- hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("alacritty -e ssh your-server"), { description = "SSH" })
hl.bind("SUPER + F10", hl.dsp.exec_cmd("gopass show -o ssh-passphrase | wl-copy | wl-paste"), { description = "copy ssh pass" })

hl.bind("ALT + SHIFT + B", hl.dsp.exec_cmd("pkill waybar ; waybar &"), { description = "restart waybar" })
hl.bind("ALT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"), { description = "toggle waybar" })
hl.bind("SUPER + grave", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"), { description = "toggle waybar" })

hl.bind("SUPER + P", hl.dsp.exec_cmd("tessen -d tofi -a autotype"), { description = "" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("tessen -d tofi -a copy"), { description = "" })
hl.bind("SUPER + Y", hl.dsp.exec_cmd("~/.local/bin/snippets-yank"), { description = "" })
hl.bind("ALT + Y", hl.dsp.exec_cmd("~/.local/bin/snippets-yank"), { description = "" })
hl.bind("SUPER + I", hl.dsp.exec_cmd("~/.local/bin/snippets-type"), { description = "" })
hl.bind("SUPER + INSERT", hl.dsp.exec_cmd("~/.local/bin/snippets-type"), { description = "" })
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd("~/.local/bin/snippets-files"), { description = "" })

hl.bind("SUPER + B", hl.dsp.exec_cmd("~/.local/bin/hypr-switch-en ; ~/.local/bin/bookmarks-web -so"), { description = "bookmarks" })
hl.bind("SUPER + D", hl.dsp.exec_cmd("~/.local/bin/tofi_run"), { description = "tofi_run" })

hl.bind("SUPER + F1", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Keybindings" })

hl.unbind("SUPER + G")
hl.bind("SUPER + G", hl.dsp.exec_cmd("~/.local/bin/datagrip-go"), { description = "" })
-- hl.bind("SUPER + C", hl.dsp.exec_cmd("~/.local/bin/go-ssh"), { description = "" })
-- hl.bind("SUPER + E", hl.dsp.exec_cmd("~/.local/bin/tofi-edit"), { description = "" })
-- hl.bind("SUPER + M", hl.dsp.exec_cmd("mousepad"), { description = "" })
-- hl.bind("SUPER + N", hl.dsp.exec_cmd("$terminal nnn"), { description = "" })
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"), { description = "" })

hl.unbind("SUPER + T")
hl.unbind("SUPER + P")

hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })

hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })


hl.bind("ALT + W", hl.dsp.exec_cmd("pypr toggle term"), { description = "pypr toggle term" })
hl.bind("ALT + E", hl.dsp.exec_cmd("~/.local/bin/emoji-paste"), { description = "Emoji paste" })


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

hl.bind("ALT + F", hl.dsp.workspace.toggle_special("firefox"), { description = "Toggle scratchpad" })
hl.bind("ALT + SHIFT + F", hl.dsp.window.move({ workspace = "special:firefox", follow = false }), { description = "Move window to scratchpad" })

-- Overwrite existing bindings with hl.unbind() first if needed.
-- hl.unbind("SUPER + SPACE")
-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })

-- Logitech MX Keys examples:
-- hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("omarchy-capture-screenshot"))
-- hl.bind("SUPER + H", hl.dsp.exec_cmd("voxtype record toggle"))
-- hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"))
