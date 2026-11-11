--- @sync entry
--- Features that cost I/O are off by default and switched on per session with a key:
---   plugin on-demand git      git status signs (runs `git status` for every listed page)
---   plugin on-demand thumbs   background thumbnail cache for the visible page
--- Each call toggles the feature. State lives only in this yazi instance.

-- Same rules as yazi's stock [plugin].preloaders
local PRELOADERS = {
	{ mime = "image/{avif,hei?,jxl}", run = "magick" },
	{ mime = "image/svg+xml", run = "svg" },
	{ mime = "image/*", run = "image" },
	{ mime = "video/*", run = "video" },
	{ mime = "application/pdf", run = "pdf" },
	{ mime = "font/*", run = "font" },
	{ mime = "application/ms-opentype", run = "font" },
}

local FETCHERS = {
	{ group = "git", url = "*", run = "git" },
	{ group = "git", url = "*/", run = "git" },
}

local function notify(what, on)
	ya.notify { title = "On demand", content = what .. (on and ": on" or ": off"), timeout = 2 }
end

local function git(st)
	if st.git then
		for _, id in ipairs(st.git) do
			rt.plugin.fetchers:remove { id = id }
		end
		Linemode:children_remove(st.git_child)
		st.git = nil
		ui.render()
		return notify("Git status", false)
	end

	if not st.git_column then
		-- First use: git.yazi's setup() registers the sign column but doesn't hand it back, and
		-- may only be called once. Capture the column, so it can be removed and re-added.
		local add = Linemode.children_add
		Linemode.children_add = function(self, fn, order)
			st.git_column = { fn, order }
			st.git_child = add(self, fn, order)
			return st.git_child
		end
		require("git"):setup()
		Linemode.children_add = add
	else
		st.git_child = Linemode:children_add(st.git_column[1], st.git_column[2])
	end

	st.git = {}
	for i, f in ipairs(FETCHERS) do
		st.git[i] = rt.plugin.fetchers:insert(1, f).id
	end
	notify("Git status", true)
end

local function thumbs(st)
	if st.thumbs then
		for _, id in ipairs(st.thumbs) do
			rt.plugin.preloaders:remove { id = id }
		end
		st.thumbs = nil
		return notify("Thumbnail cache", false)
	end

	st.thumbs = {}
	for i, p in ipairs(PRELOADERS) do
		st.thumbs[i] = rt.plugin.preloaders:insert(-1, p).id
	end
	notify("Thumbnail cache", true)
end

local function entry(st, job)
	local what = job.args[1]
	if what == "git" then
		git(st)
	elseif what == "thumbs" then
		thumbs(st)
	else
		return ya.notify { title = "On demand", content = "Unknown feature: " .. tostring(what), level = "error", timeout = 5 }
	end
	-- Re-run fetchers/preloaders for the page that is already on screen
	ya.emit("app:resize", {})
end

return { entry = entry }
