-- Hyper-режим на CapsLock без Hyperkey.app: CapsLock → F18 (hidutil),
-- пока F18 зажат — активен hs.hotkey.modal. Одиночный короткий тап = Escape.
--
-- Синтетических ⌃⌥⇧⌘ нет вовсе, поэтому ничего не «залипает» и хоткеи могут
-- сразу слать ⌘Space и т.п. Цена: Hyper видит только Hammerspoon.
--
-- Требование: System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys →
-- Caps Lock Key = "Caps Lock". Этот слой (HIDKeyboardModifierMappingPairs)
-- применяется раньше UserKeyMapping, и "No Action" глушит клавишу до hidutil.
-- Через hidutil его не переписать.

local util = require("util")

local M = {}

local TAP_TIMEOUT = 0.3 -- дольше удерживали без нажатий — Escape не шлём

-- Записывается per-service (--matching): глобальный --set проигрывает
-- per-device настройкам. Fn → Ctrl дублирует System Settings, чтобы не потерять.
local MATCHING = '{"PrimaryUsagePage":1,"PrimaryUsage":6}'
local MAPPING = '{"UserKeyMapping":['
	.. '{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D},' -- CapsLock → F18
	.. '{"HIDKeyboardModifierMappingSrc":0xFF00000003,"HIDKeyboardModifierMappingDst":0x7000000E4},' -- Fn → Right Ctrl
	.. '{"HIDKeyboardModifierMappingSrc":0xFF0100000003,"HIDKeyboardModifierMappingDst":0x7000000E0}' -- → Left Ctrl
	.. "]}"

local modal = hs.hotkey.modal.new()
local used, pressedAt = false, 0

-- hs.task держим в M: объект без ссылки может собрать GC до завершения.
local function runTask(name, path, args, onDone)
	if M[name] and M[name]:isRunning() then return end
	M[name] = hs.task.new(path, onDone, args)
	M[name]:start()
end

-- CapsLock → "No Action" в System Settings на какой-либо клавиатуре
-- (пара Src 0x700000039 → Dst 0x700000000; порядок полей в ioreg бывает любой).
-- ioreg только по драйверам клавиатур и асинхронно: полный `ioreg -l` тормозил reload.
local CAPS, NO_ACTION = "30064771129", "30064771072"
local function checkSettings()
	-- grep внутри: вывод ioreg ~90 КБ, больше буфера pipe, и hs.task без
	-- streaming-колбэка на нём зависает навсегда.
	runTask("checkTask", "/bin/sh", { "-c", "/usr/sbin/ioreg -r -c AppleHIDKeyboardEventDriverV2 -l -w0"
		.. " | /usr/bin/grep -o 'HIDKeyboardModifierMappingPairs\"=([^)]*)'" },
		function(_, out)
			for pair in (out or ""):gmatch("{[^{}]*MappingSrc[^{}]*}") do
				if pair:find('MappingSrc"=' .. CAPS, 1, true) and pair:find('MappingDst"=' .. NO_ACTION, 1, true) then
					hs.alert.show("Hyper: в System Settings Caps Lock Key = \"No Action\" — верни \"Caps Lock\"", 6)
					return
				end
			end
		end)
end

local function applyMapping()
	runTask("applyTask", "/usr/bin/hidutil", { "property", "--matching", MATCHING, "--set", MAPPING }, checkSettings)
end

-- Любое нажатие во время удержания CapsLock — это не одиночный тап.
local keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function()
	used = true
end)

M.f18 = hs.hotkey.bind({}, "f18", function()
	used, pressedAt = false, hs.timer.secondsSinceEpoch()
	keyTap:start()
	modal:enter()
end, function()
	modal:exit()
	keyTap:stop()
	if not used and hs.timer.secondsSinceEpoch() - pressedAt < TAP_TIMEOUT then
		hs.eventtap.keyStroke({}, "escape", 0)
	end
end)

-- Привязать клавишу к Hyper-режиму: M.bind(key, fn [, rep]) или
-- M.bind(mods, key, fn [, rep]), например M.bind({ "shift" }, "S", fn) —
-- Hyper+Shift+S. rep = true: при удержании fn повторяется с системной
-- частотой автоповтора. used ставим и здесь: eventtap может не увидеть
-- keyDown, который уже съел зарегистрированный хоткей.
function M.bind(mods, key, fn, rep)
	if type(mods) ~= "table" then
		mods, key, fn, rep = {}, mods, key, fn
	end
	local pressed = function()
		used = true
		fn()
	end
	modal:bind(mods, util.key(key), pressed, nil, rep and pressed or nil)
end

M.reapply = applyMapping

-- hidutil-маппинг сбрасывается после сна.
M.wakeWatcher = hs.caffeinate.watcher.new(function(event)
	if event == hs.caffeinate.watcher.systemDidWake then
		applyMapping()
	end
end):start()

-- Новая клавиатура (USB или Bluetooth — hs.usb.watcher BT не видит) приходит
-- новым HID-сервисом без маппинга. Опрашиваем список сервисов клавиатур
-- (hidutil list, ~10 мс) и переприменяем, когда появился незнакомый RegistryID.
local knownServices = nil
local function pollKeyboards()
	runTask("listTask", "/usr/bin/hidutil", { "list", "--matching", MATCHING }, function(_, out)
		local services = (out or ""):match("Services:(.-)Devices:") or ""
		local ids, fresh = {}, false
		-- Колонки: VendorID ProductID LocationID UsagePage Usage RegistryID ...
		for line in services:gmatch("[^\n]+") do
			local id = line:match("^%s*0x%x+%s+0x%x+%s+0x%x+%s+%d+%s+%d+%s+(0x%x+)")
			if id then
				ids[id] = true
				if knownServices and not knownServices[id] then fresh = true end
			end
		end
		knownServices = ids
		if fresh then applyMapping() end
	end)
end
M.keyboardTimer = hs.timer.doEvery(3, pollKeyboards)
pollKeyboards()

applyMapping()

return M
