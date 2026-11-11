--- fzf search from cwd; the chosen file is opened directly (a chosen directory is entered).

local cwd = ya.sync(function() return cx.active.current.cwd end)

-- True once the file at `path` is hovered and its MIME type is known. Right after `reveal`
-- the entry is only a placeholder; the MIME fetcher skips those, and `open` on one does nothing.
local ready = ya.sync(function(_, path)
	local h = cx.active.current.hovered
	return h ~= nil and tostring(h.url) == path and h:mime() ~= nil
end)

local function entry()
	local permit = ui.hide()
	local dir = cwd()

	local child, err = Command("fzf"):cwd(tostring(dir)):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
	if not child then
		permit:drop()
		return ya.notify { title = "fzf-open", content = "Failed to start fzf: " .. tostring(err), timeout = 5, level = "error" }
	end

	local output = child:wait_with_output()
	-- Give the terminal back explicitly. Otherwise it is held until Lua garbage-collects the
	-- permit, and the blocking $EDITOR opener below waits for it indefinitely.
	permit:drop()
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
		-- `ya.emit` takes ownership of `url`, so keep the path as a string first.
		local path = tostring(url)
		ya.emit("reveal", { url })
		-- Wait (up to 2s) until the revealed file is really loaded, then open it.
		for _ = 1, 100 do
			if ready(path) then
				break
			end
			ya.sleep(0.02)
		end
		ya.emit("open", { hovered = true })
	end
end

return { entry = entry }
