-- Hyper + 1…0, -, = → F1…F12.
-- Fn переназначен на Ctrl, а верхний ряд работает как медиаклавиши, поэтому
-- настоящие F-клавиши иначе не нажать. Верхний ряд в hs.hotkey не годится:
-- в медиарежиме он шлёт systemDefined-события, а не коды F1–F12.

local keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" }

for i, key in ipairs(keys) do
	hyperF18.bind(key, function()
		hs.eventtap.keyStroke({}, "f" .. i, 0)
	end)
end
