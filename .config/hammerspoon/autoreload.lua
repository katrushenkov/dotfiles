-- Перезагрузка конфига при сохранении .lua-файлов в ~/.config/hammerspoon.
--
-- Перед reload каждый изменённый файл проверяется loadfile(): с синтаксической
-- ошибкой конфиг не перезагружается (остаётся рабочий старый), а показывается
-- alert. Ошибки времени выполнения так не поймать — их видно в консоли.
-- chooser_items.lua пропускаем: text_chooser и так перечитывает его при открытии.

local M = {}

local DEBOUNCE = 0.5 -- редакторы пишут файл в несколько шагов (swap, rename)
local SKIP = { ["chooser_items.lua"] = true }

local pending = {}

local function check()
	for path in pairs(pending) do
		-- Файл мог быть удалён/переименован (swap-файлы nvim) — тогда не проверяем.
		if hs.fs.attributes(path) then
			local ok, err = loadfile(path)
			if not ok then
				pending = {}
				hs.alert.show("Hammerspoon: ошибка, reload отменён\n" .. tostring(err), 8)
				return
			end
		end
	end
	pending = {}
	hs.reload()
end

local timer = hs.timer.delayed.new(DEBOUNCE, check)

M.watcher = hs.pathwatcher.new(hs.configdir, function(paths)
	local changed = false
	for _, path in ipairs(paths) do
		local name = path:match("[^/]+$") or ""
		if name:match("%.lua$") and not SKIP[name] then
			pending[path] = true
			changed = true
		end
	end
	if changed then timer:start() end
end):start()

return M
