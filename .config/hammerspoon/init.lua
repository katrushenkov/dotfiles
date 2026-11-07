require("hs.ipc")

-- По умолчанию hs.hotkey логирует каждое включение/выключение хоткея, а
-- modal:enter()/exit() на каждом нажатии CapsLock трогает их все — консоль
-- засыпается десятками строк. Ставить до первого bind.
hs.hotkey.setLogLevel("warning")

-- Автоперезагрузка при сохранении .lua в этом каталоге (см. autoreload.lua).
autoreload = require("autoreload")

-- Hyper = зажатый CapsLock (см. hyper_f18.lua). Глобальный — для hs -c.
hyperF18 = require("hyper_f18")
local bindHyper = hyperF18.bind

-- Hyper + цифровой ряд → F1…F12
require("fkeys")

local HOME = os.getenv("HOME")
local OMNIWMCTL = "/opt/homebrew/bin/omniwmctl"

local function bin(name)
	return HOME .. "/.local/bin/" .. name
end

-- Запуск скрипта асинхронно (см. util.task). hs.applescript('do shell script ...')
-- блокирует Lua-поток на всё время работы скрипта (остальные хоткеи при этом
-- мертвы) и падает по таймауту AppleScript-события в 120 секунд.
local util = require("util")
local function run(path, ...)
	util.task(path, { ... })
end

-- Чем показывать popup пикеров: "terminal-picker" (WezTerm) или
-- "terminal-picker-kitty" (kitten panel). Опции и скрипты у обоих одинаковые.
local picker = bin("terminal-picker-kitty")

-- Держать терминал для popup'ов запущенным заранее: окно в уже работающем
-- процессе открывается за десятки мс вместо холодного старта.
run(picker, "--warm")

-- Перезагрузка с подтверждением. Кнопка по умолчанию (Return) — "Отмена",
-- чтобы случайный ⌘F11 + Enter не перезагрузил машину.
hs.hotkey.bind({ "cmd" }, "F11", function()
	hs.focus() -- иначе диалог может открыться под активным окном
	local answer = hs.dialog.blockAlert("Перезагрузить Mac?", "Несохранённые данные в приложениях могут потеряться.",
		"Отмена", "Перезагрузить", "warning")
	if answer == "Перезагрузить" then
		hs.caffeinate.restartSystem()
	end
end)

bindHyper("G", function()
	run(picker, bin("go-datagrip-mac"))
end)

-- Doom Emacs с mac-конфигом: doom-mac задаёт DOOMDIR при запуске.
-- Уже запущен — фокус через OmniWM (см. util.focusEmacs).
bindHyper("E", function()
	if not util.focusEmacs() then run(bin("doom-mac")) end
end)

bindHyper("I", function()
	run(picker, bin("snippets-fzf"))
end)

bindHyper("P", function()
	run(picker, "--clear-after", "45", bin("gopass-fzf"))
end)

-- Раскладки для Hyper+Space и Hyper+B (source ID не зависят от языка системы).
local layouts = { "com.apple.keylayout.US", "com.apple.keylayout.Russian" }

bindHyper("B", function()
	hs.keycodes.currentSourceID(layouts[1])
	-- --no-restore: скрипт сам открывает браузер и владеет фокусом
	run(picker, "--no-restore", bin("bookmarks-web-mac"), "-s")
end)

-- Сначала тег, потом закладка (как Super+Shift+B на Linux)
bindHyper({ "shift" }, "B", function()
	hs.keycodes.currentSourceID(layouts[1])
	run(picker, "--no-restore", bin("bookmarks-web-mac"), "-st")
end)

-- Переключение раскладки напрямую, без системного шортката.
bindHyper("space", function()
	local current = hs.keycodes.currentSourceID()
	hs.keycodes.currentSourceID(current == layouts[1] and layouts[2] or layouts[1])
end)

-- Spotlight (системный ⌘Space, AppleSymbolicHotKeys 64)
bindHyper("D", function()
	hs.eventtap.keyStroke({ "cmd" }, "space", 0)
end)

-- Перенос окна на соседний монитор средствами OmniWM: hs.window:moveToScreen()
-- двигает окно в обход тайлинга, и OmniWM возвращает его или ломает раскладку.
local function omniwm(...)
	run(OMNIWMCTL, "command", ...)
end
bindHyper("Right", function() omniwm("move-to-monitor", "right") end)
bindHyper("Left", function() omniwm("move-to-monitor", "left") end)

-- Перенесены из OmniWM (там Unassigned): ⌘F, ⇧⌘S и ⌥-/⌥= перехватывались
-- глобально и ломали Find, «Сохранить как…» и набор тире.
-- Навигация и ширина колонки повторяются при удержании (последний аргумент true).
bindHyper("F", function() omniwm("toggle-fullscreen") end)
bindHyper("[", function() omniwm("set-container-primary-span", "-10%") end, true)
bindHyper("]", function() omniwm("set-container-primary-span", "+10%") end, true)

bindHyper("J", function() omniwm("switch-workspace", "next") end, true)
bindHyper("K", function() omniwm("switch-workspace", "prev") end, true)
bindHyper("H", function() omniwm("focus", "left") end, true)
bindHyper("L", function() omniwm("focus", "right") end, true)
bindHyper({ "shift" }, "H", function() omniwm("move-column", "left") end, true)
bindHyper({ "shift" }, "L", function() omniwm("move-column", "right") end, true)

-- Hyper+/ — палитра команд OmniWM, Hyper+Shift+/ — поиск по меню приложения
-- (как системный ⌘⇧/). Hyper+M занят под LOOP.
bindHyper("/", function() omniwm("open-command-palette") end)
bindHyper({ "shift" }, "/", function() omniwm("open-menu-anywhere") end)

-- Scratchpad 1: Hyper+S показать/спрятать, Hyper+Shift+S добавить фокусное
-- окно или убрать его оттуда (assign работает как переключатель).
bindHyper("S", function() omniwm("scratchpad", "toggle", "1") end)
bindHyper({ "shift" }, "S", function()
	util.task(OMNIWMCTL, { "query", "windows", "--focused", "--fields", "is-scratchpad", "--format", "json" },
		function(_, out)
			local ok, data = pcall(hs.json.decode, out or "")
			local win = ok and data and data.result and data.result.payload.windows[1]
			if not win then
				hs.alert.show("Scratchpad: нет окна в фокусе")
				return
			end
			omniwm("scratchpad", "assign", "1")
			hs.alert.show(win.isScratchpad and "Scratchpad: окно убрано" or "Scratchpad: окно добавлено")
		end)
end)

-- По bundle ID: имя приложения может зависеть от языка системы и версии.
-- Строка без точки — запуск по имени (bundle ID ещё не известен).
local apps = {
	w = "com.google.Chrome",
	o = "net.kovidgoyal.kitty",
	v = "com.vivaldi.Vivaldi",
	t = "ru.keepcoder.Telegram",
	c = "com.TickTick.task.mac",
	-- TODO(LOOP): приложение не установлено, bundle ID неизвестен — пока по имени.
	-- После установки: osascript -e 'id of app "LOOP"' и вписать ID вместо "LOOP".
	m = "LOOP",
}

for key, app in pairs(apps) do
	bindHyper(key, function()
		local ok
		if app:find("%.") then
			ok = hs.application.launchOrFocusByBundleID(app)
		else
			ok = hs.application.launchOrFocus(app)
		end
		if not ok then hs.alert.show("not installed: " .. app) end
	end)
end

-- Hyper+Return: новое OS-окно в уже запущенном kitty, а не новый процесс
-- (`open -na`). Через remote control: в kitty.conf allow_remote_control
-- socket-only и listen_on ${TMPDIR}kitty-{kitty_pid}. Kitty без сокета
-- (запущен до правки конфига) получает ⌘N — его стандартный new_os_window.
local KITTY = "net.kovidgoyal.kitty"
local KITTEN = "/Applications/kitty.app/Contents/MacOS/kitten"

local function kittySocket(app)
	local path = (os.getenv("TMPDIR") or "/tmp/") .. "kitty-" .. app:pid()
	if hs.fs.attributes(path, "mode") == "socket" then return "unix:" .. path end
end

bindHyper("Return", function()
	local running = hs.application.applicationsForBundleID(KITTY)
	if #running == 0 then
		hs.application.launchOrFocusByBundleID(KITTY) -- сам откроет первое окно
		return
	end
	for _, app in ipairs(running) do
		local sock = kittySocket(app)
		if sock then
			util.task(KITTEN, { "@", "--to", sock, "launch", "--type=os-window", "--cwd=" .. HOME },
				function(code, _, err)
					if code ~= 0 then
						hs.alert.show("kitty launch: " .. ((err or ""):match("[^\n]+") or code))
						return
					end
					-- Окно создано фоновым процессом — фокус ему надо отдать явно.
					app:activate()
				end)
			return
		end
	end
	running[1]:activate()
	hs.eventtap.keyStroke({ "cmd" }, util.key("n"), 0, running[1])
end)

-- Reload не из самого колбэка: он уничтожает Lua-состояние, пока хоткей ещё
-- выполняется и modal Hyper активен. Через таймер колбэк успевает завершиться.
bindHyper("R", function()
	hs.timer.doAfter(0, hs.reload)
end)

-- Hyper+X: сниппеты и быстрые действия (text_chooser.lua, записи — chooser_items.lua).
-- Глобальные — для hs -c.
textChooser = require("text_chooser")
pasteText = textChooser.pasteText

bindHyper("X", textChooser.show)
