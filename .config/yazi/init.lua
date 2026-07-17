require("yatline"):setup({
--	--theme = my_theme,
--	section_separator = { open = "", close = "" },
--	part_separator = { open = "", close = "" },
--	inverse_separator = { open = "", close = "" },
--	style_a = {
--		fg = "black",
--		bg_mode = {
--			normal = "white",
--			select = "brightyellow",
--			un_set = "brightred",
--		},
--	},
--	style_b = { bg = "brightblack", fg = "brightwhite" },
--	style_c = { bg = "black", fg = "brightwhite" },
--
--	permissions_t_fg = "green",
--	permissions_r_fg = "yellow",
--	permissions_w_fg = "red",
--	permissions_x_fg = "cyan",
--	permissions_s_fg = "white",
--
--	tab_width = 20,
--	tab_use_inverse = false,
--
--	selected = { icon = "󰻭", fg = "yellow" },
--	copied = { icon = "", fg = "green" },
--	cut = { icon = "", fg = "red" },
--
--	total = { icon = "󰮍", fg = "yellow" },
--	succ = { icon = "", fg = "green" },
--	fail = { icon = "", fg = "red" },
--	found = { icon = "󰮕", fg = "blue" },
--	processed = { icon = "󰐍", fg = "green" },
--
--	show_background = true,
--
--	display_header_line = true,
--	display_status_line = true,
--
--	component_positions = { "header", "tab", "status" },
--
--	header_line = {
--		left = {
--			section_a = {
--				{ type = "line", custom = false, name = "tabs", params = { "left" } },
--			},
--			section_b = {},
--			section_c = {},
--		},
--		right = {
--			section_a = {
--				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
--			},
--			section_b = {
--				{ type = "string", custom = false, name = "date", params = { "%X" } },
--			},
--			section_c = {},
--		},
--	},
--
--	status_line = {
--		left = {
--			section_a = {
--				{ type = "string", custom = false, name = "tab_mode" },
--			},
--			section_b = {
--				{ type = "string", custom = false, name = "hovered_size" },
--			},
--			section_c = {
--				{ type = "string", custom = false, name = "hovered_path" },
--				{ type = "coloreds", custom = false, name = "count" },
--			},
--		},
--		right = {
--			section_a = {
--				{ type = "string", custom = false, name = "cursor_position" },
--			},
--			section_b = {
--				{ type = "string", custom = false, name = "cursor_percentage" },
--			},
--			section_c = {
--				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
--				{ type = "coloreds", custom = false, name = "permissions" },
--			},
--		},
--	},
})

require("git"):setup()

require("gvfs"):setup({
	-- (Optional) Allowed keys to select device.
	which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",

	-- (Optional) Save file.
	-- Default: ~/.config/yazi/gvfs.private
	save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",

	-- (Optional) input position. Default: { "top-center", y = 3, w = 60 },
	-- Position, which is a table:
	-- 	`1`: Origin position, available values: "top-left", "top-center", "top-right",
	-- 	     "bottom-left", "bottom-center", "bottom-right", "center", and "hovered".
	--         "hovered" is the position of hovered file/folder
	-- 	`x`: X offset from the origin position.
	-- 	`y`: Y offset from the origin position.
	-- 	`w`: Width of the input.
	-- 	`h`: Height of the input.
	input_position = { "center", y = 0, w = 60 },

	-- (Optional) Select where to save passwords. Default: nil
	-- Available options: "keyring", "pass", or nil
	password_vault = "keyring",

	-- (Optional) Only need if you set password_vault = "pass"
	-- Read the guide at SECURE_SAVED_PASSWORD.md to get your key_grip
	key_grip = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",

	-- (Optional) save password automatically after mounting. Default: false
	save_password_autoconfirm = true,
})

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


dofile(os.getenv("HOME") .. "/.config/yazi/bookmarks.toml")

