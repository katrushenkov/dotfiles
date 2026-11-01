-- Chooser на Hyper+X: сниппеты и быстрые действия из chooser_items.lua.
-- Формат записей, плейсхолдеры и модификаторы описаны в chooser_items.lua.

local util = require("util")

local M = {}

local ITEMS_FILE = hs.configdir .. "/chooser_items.lua"
local USAGE_KEY = "textChooser.usage" -- hs.settings: { [id] = число выборов }

-- Сохранить текущий буфер, вставить текст, затем восстановить.
-- readAllData сохраняет все типы (картинки, файлы, RTF), а не только текст.
-- Сама вставка мгновенная; задержка только перед восстановлением, чтобы
-- приложение успело прочитать буфер по ⌘V. 0.1 с мало: Electron, JetBrains,
-- RDP/VNC читают буфер позже и вставляют уже восстановленный старый.
local RESTORE_DELAY = 0.35

function M.pasteText(text)
	local saved = hs.pasteboard.readAllData()
	hs.pasteboard.setContents(text)
	local ours = hs.pasteboard.changeCount()
	hs.eventtap.keyStroke({ "cmd" }, util.key("v"), 20000)
	hs.timer.doAfter(RESTORE_DELAY, function()
		-- За это время в буфер скопировали что-то ещё — не затирать.
		if hs.pasteboard.changeCount() ~= ours then return end
		if saved and next(saved) then
			hs.pasteboard.writeAllData(saved)
		else
			hs.pasteboard.clearContents()
		end
	end)
end

-- ⇧Enter: набирать, только когда Shift отпущен (потолок 1 с), иначе он
-- примешивается к синтетическим нажатиям.
local function typeWhenShiftReleased(text, tries)
	tries = tries or 50
	if tries <= 0 or not hs.eventtap.checkKeyboardModifiers().shift then
		hs.eventtap.keyStrokes(text)
	else
		hs.timer.doAfter(0.02, function() typeWhenShiftReleased(text, tries - 1) end)
	end
end

local items, prevWin = {}, nil

local function loadItems()
	local ok, res = pcall(dofile, ITEMS_FILE)
	if not ok or type(res) ~= "table" then
		hs.alert.show("chooser_items.lua: " .. tostring(res), 5)
		return items -- оставляем прошлый рабочий список
	end
	return res
end

local function itemId(item)
	return item.id or item.text
end

-- Подставить плейсхолдеры. nil — пользователь отменил {input}.
local function expand(s)
	local cancelled = false
	local out = s:gsub("{(%a+):?([^}]*)}", function(name, arg)
		if cancelled then return nil end
		if name == "date" then return os.date("%Y-%m-%d") end
		if name == "time" then return os.date("%H:%M") end
		if name == "datetime" then return os.date("%Y-%m-%d %H:%M") end
		if name == "clipboard" then return hs.pasteboard.getContents() or "" end
		if name == "input" then
			hs.focus()
			local button, value = hs.dialog.textPrompt("Hyper+X", arg ~= "" and arg or "Значение:", "", "OK", "Отмена")
			if button ~= "OK" then
				cancelled = true
				return nil
			end
			return value
		end
		return nil -- неизвестное имя оставляем как есть
	end)
	if cancelled then return nil end
	-- Диалог забрал фокус — вернуть его окну, где был вызван chooser.
	if out ~= s and prevWin then prevWin:focus() end
	return out
end

local function runShell(cmd)
	util.task(os.getenv("SHELL") or "/bin/zsh", { "-lc", cmd }, function(code, _, err)
		if code ~= 0 then
			hs.alert.show("shell (" .. code .. "): " .. ((err or ""):match("[^\n]+") or cmd), 5)
		end
	end)
end

-- mode: "paste" (Enter), "copy" (⌥Enter), "type" (⇧Enter)
local function deliver(text, mode)
	if mode == "copy" then
		hs.pasteboard.setContents(text)
		hs.alert.show("Скопировано")
	elseif mode == "type" then
		typeWhenShiftReleased(text)
	else
		M.pasteText(text)
	end
end

local function perform(item, mode)
	if item.fn then
		item.fn()
	elseif item.shell then
		if mode == "copy" then return deliver(item.shell, "copy") end
		runShell(item.shell)
	elseif item.open then
		local target = expand(item.open)
		if not target then return end
		if mode == "copy" then return deliver(target, "copy") end
		util.task("/usr/bin/open", { target })
	elseif item.app then
		if not hs.application.launchOrFocusByBundleID(item.app) then
			hs.alert.show("not installed: " .. item.app)
		end
	else
		local text = expand(item.paste or item.text)
		if text then deliver(text, mode) end
	end
end

local function describe(item)
	if item.subText and item.subText ~= "" then return item.subText end
	if item.shell then return "shell: " .. item.shell end
	if item.open then return "open: " .. item.open end
	if item.app then return "app: " .. item.app end
	if item.fn then return "lua" end
	return ""
end

-- Частые сверху; при равенстве — порядок из файла.
local function buildChoices()
	local usage = hs.settings.get(USAGE_KEY) or {}
	local order = {}
	for i, item in ipairs(items) do
		order[#order + 1] = { i = i, n = usage[itemId(item)] or 0 }
	end
	table.sort(order, function(a, b)
		if a.n ~= b.n then return a.n > b.n end
		return a.i < b.i
	end)
	local choices = {}
	for _, o in ipairs(order) do
		local item = items[o.i]
		-- В choices только строки: hs.chooser не хранит функции.
		choices[#choices + 1] = { text = item.text, subText = describe(item), idx = o.i }
	end
	return choices
end

local function bump(item)
	local usage = hs.settings.get(USAGE_KEY) or {}
	local id = itemId(item)
	usage[id] = (usage[id] or 0) + 1
	hs.settings.set(USAGE_KEY, usage)
end

local chooser = hs.chooser.new(function(choice)
	if not choice then return end
	local item = items[choice.idx]
	if not item then return end
	local m = hs.eventtap.checkKeyboardModifiers()
	local mode = m.alt and "copy" or m.shift and "type" or "paste"
	bump(item)
	perform(item, mode)
end)
chooser:searchSubText(true)
M.chooser = chooser

function M.show()
	prevWin = hs.window.focusedWindow()
	items = loadItems()
	chooser:choices(buildChoices())
	chooser:query("")
	chooser:show()
end

-- Сбросить счётчики частоты: hs -c 'textChooser.resetUsage()'
function M.resetUsage()
	hs.settings.clear(USAGE_KEY)
end

return M
