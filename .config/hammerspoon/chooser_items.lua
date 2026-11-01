-- Записи для Hyper+X (text_chooser.lua). Файл перечитывается при каждом
-- открытии chooser'а — reload Hammerspoon не нужен.
--
-- Поля записи:
--   text     заголовок (по нему поиск). Без действия ниже — вставляется он сам.
--   subText  описание (поиск идёт и по нему)
--   id       ключ для счётчика частоты (по умолчанию text)
-- Действие (одно из):
--   paste = "..."            вставить текст
--   shell = "..."            выполнить в login shell (ошибка — alert)
--   open  = "url или путь"   открыть через macOS
--   app   = "bundle.id"      запустить или перейти в приложение
--   fn    = function() end   произвольный Lua
--
-- Плейсхолдеры в paste/open/text: {date} {time} {datetime} {clipboard}
-- {input} или {input:Подсказка} — спросить значение в диалоге.
--
-- Enter — вставить, ⌥Enter — только скопировать, ⇧Enter — набрать посимвольно.
-- (⌥/⇧ действуют на paste/text; fn-записи сами решают, что делать.)

local util = require("util")

local HOME = os.getenv("HOME")
local EMACSCLIENT = "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
local KITTY = "/Applications/kitty.app/Contents/MacOS/kitty"
local NVIM = "/opt/homebrew/bin/nvim"
local OMNIWMCTL = "/opt/homebrew/bin/omniwmctl"
local OMNIWM_ID = "com.barut.OmniWM"

-- Открыть файл в запущенном Doom Emacs (emacsclient) и показать его, как
-- Hyper+E (util.focusEmacs). Emacs не запущен — nvim в новом окне kitty.
local function edit(path)
	path = path:gsub("^~", HOME)
	return function()
		if not hs.application.get("org.gnu.Emacs") then
			util.task(KITTY, { NVIM, path })
			return
		end
		util.task(EMACSCLIENT, { "-n", path }, function(code, _, err)
			if code ~= 0 then
				hs.alert.show("emacsclient: " .. ((err or ""):match("[^\n]+") or code))
				return
			end
			util.focusEmacs()
		end)
	end
end

-- Текст из буфера; nil и alert, если пусто.
local function clipboardText()
	local s = hs.pasteboard.getContents()
	if not s or s == "" then
		hs.alert.show("Буфер пуст")
		return nil
	end
	return s
end

-- Взять текст из буфера, преобразовать f(s) и вставить результат.
-- Буфер после вставки восстанавливается (pasteText), исходный текст в нём остаётся.
local function clip(f)
	return function()
		local s = clipboardText()
		if not s then return end
		local ok, res = pcall(f, s)
		if not ok or not res or res == "" then
			hs.alert.show("Не получилось: " .. tostring(ok and "пустой результат" or res))
			return
		end
		pasteText(res)
	end
end

-- Случайная строка из /dev/urandom без похожих символов (0/O, 1/l/I).
local function password(len)
	local cs = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789"
	local limit = 256 - 256 % #cs -- отбрасываем «хвост», чтобы не было перекоса
	local out = {}
	local f = assert(io.open("/dev/urandom", "rb"))
	while #out < len do
		for b in f:read(len * 2):gmatch(".") do
			local n = b:byte()
			if n < limit and #out < len then
				local i = n % #cs + 1
				out[#out + 1] = cs:sub(i, i)
			end
		end
	end
	f:close()
	return table.concat(out)
end

-- jq по буферу асинхронно (util.task) и вставка результата. Буфер идёт через
-- временный файл: jq читает его аргументом, stdin не нужен.
local function jq(...)
	local args = { ... }
	return function()
		local s = clipboardText()
		if not s then return end
		local tmp = os.tmpname()
		local fh = assert(io.open(tmp, "w"))
		fh:write(s)
		fh:close()
		local argv = { table.unpack(args) }
		argv[#argv + 1] = tmp
		util.task("/usr/bin/jq", argv, function(code, out, err)
			os.remove(tmp)
			if code ~= 0 then
				hs.alert.show("jq: " .. ((err or ""):match("[^\n]+") or code))
				return
			end
			pasteText((out:gsub("\n$", "")))
		end)
	end
end

return {
	{
		text = "text-snippet-insert",
		subText = "",
	},
	--	{
	--		text = "Запрещено: приветствия, лирические отступления, эмоции, оценочные суждения, маркетинговые клише.
	--Разрешено: только факты и логические выводы на их основе.
	--Если данных нет — ответь "Не найдено".
	--При нехватке данных: "Информация отсутствует."
	--Фактологичность: Опирайся только на проверенные данные. Не додумывай и не фантазируй.
	--Обработка незнания: Если ты не знаешь ответа или информации недостаточно для однозначного ответа, ты обязан написать ровно одну фразу: "Данные отсутствуют".
	--Язык: Сухой, технический, без прилагательных, выражающих личное мнение.",
	--		subText = "",
	--	},
	{
		text = "Лучшие regards,\nИмя Фамилия",
		subText = "Подпись",
	},

	-- Текст ---------------------------------------------------------------
	{ text = "Дата", paste = "{date}", subText = "вставить: 2026-11-01" },
	{ text = "Дата и время", paste = "{datetime}", subText = "вставить: 2026-11-01 14:05" },
	{
		text = "Время UTC (ISO 8601)",
		subText = "вставить: 2026-11-01T11:05:00Z",
		fn = function() pasteText(os.date("!%Y-%m-%dT%H:%M:%SZ")) end,
	},
	{ text = "Длинное тире —", paste = "—", subText = "em dash" },
	{ text = "Кавычки-ёлочки «»", paste = "«{clipboard}»", subText = "текст из буфера в «ёлочках»" },
	{
		text = "UUID",
		subText = "вставить случайный uuid v4",
		fn = function() pasteText(hs.host.uuid():lower()) end,
	},
	{
		text = "Пароль 24 символа",
		subText = "сгенерировать и вставить (буквы и цифры)",
		fn = function() pasteText(password(24)) end,
	},

	-- Буфер обмена: преобразовать и вставить -------------------------------
	{
		text = "Вставить без форматирования",
		subText = "буфер как чистый текст",
		fn = clip(function(s) return s end),
	},
	{
		text = "base64 decode",
		subText = "декодировать буфер (k8s Secret и т.п.)",
		fn = clip(function(s) return hs.base64.decode((s:gsub("%s", ""))) end),
	},
	{
		text = "base64 encode",
		subText = "закодировать буфер",
		fn = clip(function(s) return hs.base64.encode(s) end),
	},
	{
		text = "JSON: форматировать",
		subText = "jq . по буферу",
		fn = jq("."),
	},
	{
		text = "JSON: в одну строку",
		subText = "jq -c . по буферу",
		fn = jq("-c", "."),
	},
	{
		text = "URL decode",
		subText = "%D0%BF%D1%80 → пр",
		fn = clip(function(s)
			return (s:gsub("%+", " "):gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
		end),
	},
	{
		text = "URL encode",
		subText = "пр → %D0%BF%D1%80",
		fn = clip(function(s)
			return (s:gsub("[^%w%-_%.~]", function(c) return string.format("%%%02X", c:byte()) end))
		end),
	},

	-- Система ---------------------------------------------------------------
	{
		text = "Заблокировать экран",
		subText = "lock screen",
		fn = function() hs.caffeinate.lockScreen() end,
	},
	{
		text = "Погасить дисплей",
		subText = "pmset displaysleepnow",
		shell = "pmset displaysleepnow",
	},
	{
		text = "Не засыпать (вкл/выкл)",
		subText = "caffeinate: держать дисплей включённым, до reload Hammerspoon",
		fn = function()
			local on = hs.caffeinate.toggle("displayIdle")
			hs.alert.show(on and "Не засыпать: ВКЛ" or "Не засыпать: выкл")
		end,
	},
	{
		text = "Тёмная / светлая тема",
		subText = "переключить appearance macOS",
		fn = function()
			hs.osascript.applescript(
				'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode')
		end,
	},

	-- OmniWM / Hammerspoon / пикеры ----------------------------------------
	{
		text = "OmniWM: перезапустить",
		subText = "помогает, когда окно застряло с isAppHidden",
		fn = function()
			local app = hs.application.get(OMNIWM_ID)
			if app then app:kill() end
			hs.timer.waitUntil(function() return not hs.application.get(OMNIWM_ID) end,
				function() util.task("/usr/bin/open", { "-gb", OMNIWM_ID }) end, 0.2)
		end,
	},
	{
		text = "OmniWM: сменить раскладку workspace",
		subText = "toggle-workspace-layout",
		fn = function() util.task(OMNIWMCTL, { "command", "toggle-workspace-layout" }) end,
	},
	{
		text = "Hammerspoon: консоль",
		subText = "открыть консоль Hammerspoon",
		fn = function() hs.openConsole() end,
	},
	{
		text = "Hammerspoon: перезагрузить",
		subText = "то же, что Hyper+R",
		fn = function() hs.timer.doAfter(0, hs.reload) end,
	},
	{
		text = "Hyper: переприменить CapsLock",
		subText = "hyperF18.reapply() — если CapsLock перестал работать как Hyper",
		fn = function() hyperF18.reapply() end,
	},
	{
		text = "Chooser: сбросить частоту",
		subText = "вернуть исходный порядок пунктов",
		fn = function() textChooser.resetUsage() end,
	},
	{
		text = "Picker: перезапустить kitty keeper",
		subText = "после правки popup.conf или если popup не открывается",
		shell = "pkill -f kitty-quick-access; true",
	},

	-- Конфиги (Emacs, если запущен, иначе nvim в kitty) ---------------------
	{ text = "Конфиг: Hammerspoon init.lua", subText = "edit", fn = edit("~/.config/hammerspoon/init.lua") },
	{ text = "Конфиг: chooser_items.lua", subText = "edit: этот список", fn = edit("~/.config/hammerspoon/chooser_items.lua") },
	{ text = "Конфиг: OmniWM settings.toml", subText = "edit", fn = edit("~/.config/omniwm/settings.toml") },
	{ text = "Конфиг: kitty.conf", subText = "edit", fn = edit("~/.config/kitty/kitty.conf") },
	{
		text = "Конфиг: Doom mac config.el",
		subText = "edit",
		fn = edit("~/.local/src/datagrip/private/configs/doom-mac/config.el"),
	},
}
