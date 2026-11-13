-- swayimg config (Lua, swayimg >= 5). Defaults: /usr/share/swayimg/example.lua

-- q: exit, in every mode (Esc still works too)
for _, mode in ipairs({ swayimg.viewer, swayimg.gallery, swayimg.slideshow }) do
  mode.on_key("q", function()
    swayimg.exit()
  end)
end

-- Shift+c: shrink the current image to 50% resolution, overwriting the original
local function shell_quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function file_size(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local size = f:seek("end")
  f:close()
  return size
end

local function human(bytes)
  if not bytes then return "?" end
  local units = { "B", "KB", "MB", "GB" }
  local i = 1
  while bytes >= 1024 and i < #units do
    bytes = bytes / 1024
    i = i + 1
  end
  return string.format(i == 1 and "%d %s" or "%.1f %s", bytes, units[i])
end

local function compress(mode, reload)
  local img = mode.get_image()
  if not img or not img.path then return end
  local path = img.path
  local q = shell_quote(path)
  local before = file_size(path)
  local ok = os.execute("magick " .. q .. " -resize 50% " .. q)
  local name = path:match("[^/]+$")
  if ok then
    local after = file_size(path)
    os.execute("notify-send -a swayimg 'Сжато 50%' " ..
      shell_quote(name .. ": " .. human(before) .. " → " .. human(after)) .. " &")
    if reload then reload() end
  else
    os.execute("notify-send -u critical -a swayimg 'Не удалось сжать' " .. shell_quote(name) .. " &")
  end
end

swayimg.viewer.on_key("Shift+c", function()
  compress(swayimg.viewer, swayimg.viewer.reload)
end)
swayimg.gallery.on_key("Shift+c", function()
  compress(swayimg.gallery)
end)
