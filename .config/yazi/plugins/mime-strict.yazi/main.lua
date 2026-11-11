-- MIME by file extension only: no `file` calls, no reads (for slow mounts like sshfs).
local EXT = {
	-- video
	mp4 = "video/mp4", m4v = "video/mp4", mkv = "video/x-matroska", webm = "video/webm",
	mov = "video/quicktime", avi = "video/x-msvideo", flv = "video/x-flv", wmv = "video/x-ms-wmv",
	mpg = "video/mpeg", mpeg = "video/mpeg", ts = "video/mp2t", m2ts = "video/mp2t", ["3gp"] = "video/3gpp", ogv = "video/ogg",
	-- audio
	mp3 = "audio/mpeg", flac = "audio/flac", ogg = "audio/ogg", opus = "audio/opus", wav = "audio/x-wav",
	m4a = "audio/mp4", aac = "audio/aac", wma = "audio/x-ms-wma",
	-- image
	jpg = "image/jpeg", jpeg = "image/jpeg", png = "image/png", gif = "image/gif", webp = "image/webp",
	bmp = "image/bmp", svg = "image/svg+xml", avif = "image/avif", heic = "image/heic", jxl = "image/jxl", tif = "image/tiff", tiff = "image/tiff",
	-- docs / text
	pdf = "application/pdf", txt = "text/plain", md = "text/markdown", log = "text/plain", srt = "text/plain",
	json = "application/json", nfo = "text/plain", csv = "text/csv", html = "text/html", xml = "text/xml",
	-- archives
	zip = "application/zip", rar = "application/rar", ["7z"] = "application/7z-compressed", tar = "application/tar",
	gz = "application/gzip", xz = "application/xz", zst = "application/zstd", bz2 = "application/bzip2",
	iso = "application/iso9660-image",
}

local M = {}

function M:fetch(job)
	return ya.co(function()
		local updates = {}
		for _, file in ipairs(job.files) do
			local ext = (file.url.ext or ""):lower()
			local mime = EXT[ext] or "application/octet-stream"
			if coroutine.yield(file, { mime }) then
				updates[file.url] = mime
			end
		end
		if next(updates) then
			ya.emit("update_mimes", { updates = updates })
		end
	end)
end

return M
