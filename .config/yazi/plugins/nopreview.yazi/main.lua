-- Placeholder previewer/preloader: does not read the file at all.
local M = {}

function M:peek(job)
	local size = job.file.cha.len and ya.readable_size(job.file.cha.len) or "?"
	ya.preview_widget(job, ui.Text({ ui.Line("Preview disabled"):reverse(), ui.Line(""), ui.Line("Size: " .. size) }):area(job.area))
end

function M:seek() end

function M:preload() return true end

return M
