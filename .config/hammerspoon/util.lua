-- Общие помощники для модулей Hammerspoon.

local M = {}

-- Запущенные задачи держим в таблице до завершения: hs.task без ссылки может
-- собрать GC, пока процесс ещё работает (тогда колбэк не придёт, а долгий
-- процесс вроде popup terminal-picker может быть убит).
local tasks = {}

-- Запустить процесс асинхронно. onDone(exitCode, stdOut, stdErr) — по желанию.
-- Возвращает задачу или nil, если запустить не удалось (показывается alert).
function M.task(path, args, onDone)
	local task
	task = hs.task.new(path, function(...)
		tasks[task] = nil
		if onDone then onDone(...) end
	end, args or {})
	if not task then
		hs.alert.show("not found: " .. path)
		return nil
	end
	tasks[task] = true
	if not task:start() then
		tasks[task] = nil
		hs.alert.show("failed to start: " .. path)
		return nil
	end
	return task
end

-- Коды физических клавиш ANSI US. hs.hotkey/keyStroke по символу ищут код в
-- текущей раскладке: при русской символа нет, и на каждую клавишу в консоль
-- пишется warning (с тем же US-кодом как fallback). Код от раскладки не зависит.
local ANSI = {
	a = 0, s = 1, d = 2, f = 3, h = 4, g = 5, z = 6, x = 7, c = 8, v = 9,
	b = 11, q = 12, w = 13, e = 14, r = 15, y = 16, t = 17,
	["1"] = 18, ["2"] = 19, ["3"] = 20, ["4"] = 21, ["6"] = 22, ["5"] = 23,
	["="] = 24, ["9"] = 25, ["7"] = 26, ["-"] = 27, ["8"] = 28, ["0"] = 29,
	["]"] = 30, o = 31, u = 32, ["["] = 33, i = 34, p = 35, l = 37, j = 38,
	["'"] = 39, k = 40, [";"] = 41, ["\\"] = 42, [","] = 43, ["/"] = 44,
	n = 45, m = 46, ["."] = 47, ["`"] = 50,
}

-- Символ → код клавиши; именованные клавиши ("space", "Return", "f18") и числа
-- возвращаются как есть — они от раскладки не зависят.
function M.key(k)
	if type(k) == "string" and #k == 1 then
		return ANSI[k:lower()] or k
	end
	return k
end

-- Показать запущенный Doom Emacs. false — Emacs не запущен.
-- activate() не переключает workspace OmniWM (Emacs живёт на 2-м по правилу),
-- и окно остаётся невидимым для него: Hyper+F не срабатывает. Фокус через OmniWM.
local OMNIWMCTL = "/opt/homebrew/bin/omniwmctl"
function M.focusEmacs()
	local app = hs.application.get("org.gnu.Emacs")
	if not app then return false end
	app:unhide() -- SPC q на последнем окне прячет Emacs
	app:activate()
	M.task("/bin/sh", { "-c", OMNIWMCTL .. " query windows --bundle-id org.gnu.Emacs --fields id --format tsv"
		.. " | sed -n 2p | cut -f1 | xargs " .. OMNIWMCTL .. " window focus" })
	return true
end

return M
