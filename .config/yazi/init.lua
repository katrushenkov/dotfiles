-- git status signs: off by default, <Space>g switches them on (plugins/on-demand.yazi)
-- Only loads the module (no setup, no fetchers), so that on-demand can enable it later.
require("git")

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end


dofile(os.getenv("HOME") .. "/.config/yazi/bunny.lua")


-- MIME type from the extension database instead of spawning `file` for every listed file;
-- `file` is used only for names the database doesn't know.
-- (The fetcher itself is registered in yazi.toml: upstream's `require("mime-ext"):setup()`
-- silently does nothing on yazi 26.9.1.)
require("mime-ext.local"):setup({ fallback_file1 = true })

-- Hide the preview pane on startup and stop previewers from running while it is hidden;
-- toggle with <Space>p (lazy-preview plugin, wraps toggle-pane)
require("lazy-preview"):entry("min-preview")

-- Синхронизация yank (copy/cut) между инстансами yazi
require("session"):setup({ sync_yanked = true })
