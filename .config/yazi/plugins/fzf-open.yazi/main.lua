--- fzf search from cwd; the chosen file is opened directly (a chosen directory is entered).

local cwd = ya.sync(function() return cx.active.current.cwd end)

local function entry()
	local _permit = ui.hide()
	local dir = cwd()

	local child, err = Command("fzf"):cwd(tostring(dir)):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
	if not child then
		return ya.notify { title = "fzf-open", content = "Failed to start fzf: " .. tostring(err), timeout = 5, level = "error" }
	end

	local output = child:wait_with_output()
	if not output or not output.status.success then
		return -- cancelled (Esc / Ctrl-C) or no match
	end

	local target = output.stdout:gsub("[\r\n]+$", "")
	if target == "" then return end

	local url = dir:join(target)
	local cha = fs.cha(url)
	if cha and cha.is_dir then
		ya.emit("cd", { url })
	else
		ya.emit("reveal", { url })
		ya.emit("open", { hovered = true })
	end
end

return { entry = entry }
