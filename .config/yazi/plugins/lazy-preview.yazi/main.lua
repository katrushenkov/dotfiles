--- @sync entry
--- Preview on demand. While the preview pane is hidden, a catch-all no-op previewer sits in
--- front of all the others, so hovering a file reads nothing. Showing the pane removes it.
--- Wraps toggle-pane: `plugin lazy-preview min-preview` / `plugin lazy-preview max-preview`.

local function gate_off(st)
	for _, id in ipairs(st.ids or {}) do
		rt.plugin.previewers:remove { id = id }
	end
	st.ids = nil
end

local function gate_on(st)
	if st.ids then
		return
	end
	st.ids = {}
	for _, url in ipairs { "*", "*/" } do
		local p = rt.plugin.previewers:insert(1, { url = url, run = "lazy-preview" })
		st.ids[#st.ids + 1] = p.id
	end
end

local function entry(st, job)
	job = type(job) == "string" and { args = { job } } or job

	require("toggle-pane"):entry(job.args[1])

	if rt.mgr.ratio[3] == 0 then
		gate_on(st)
	else
		gate_off(st)
		ya.emit("peek", { force = true })
	end
end

-- The gate itself: reads nothing, draws nothing.
local function peek() end

local function seek() end

return { entry = entry, peek = peek, seek = seek }
