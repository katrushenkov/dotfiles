--- Filter with live preview; <Enter> opens/enters the hovered item and clears the filter.
--- <Esc> closes the prompt but keeps the filter; a second <Esc> clears it.

local hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and { url = h.url, is_dir = h.cha.is_dir } or nil
end)

local function entry()
	local input = ya.input {
		title = "Filter (Enter = open):",
		pos = { "top-center", y = 3, w = 50 },
		realtime = true,
		debounce = 0.05,
	}

	while true do
		local value, event = input:recv()
		if event == 3 then -- typing
			ya.emit("filter_do", { value, smart = true })
		elseif event == 1 then -- submit
			ya.emit("filter_do", { value, smart = true })
			local h = hovered()
			ya.emit("escape", { filter = true })
			if h then
				-- Clearing the filter keeps the same item hovered, so act on the hovered one
				-- (`open` ignores a positional URL on yazi 26.9).
				if h.is_dir then
					ya.emit("enter", {})
				else
					ya.emit("open", { hovered = true })
				end
			end
			break
		else -- cancel / closed: keep the filter (a second <Esc> in the file list clears it)
			break
		end
	end
end

return { entry = entry }
