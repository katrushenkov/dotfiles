-- Delete (move to trash) the currently playing file and go to the next one.
--
-- input.conf:
--   KEY script-message-to delete_current_file delete-file
--       delete immediately
--   KEY script-message-to delete_current_file delete-file CONFIRM_KEY "message"
--       show "message" and delete only if CONFIRM_KEY is pressed within
--       the timeout; any other wait just cancels

local mp = require "mp"
local utils = require "mp.utils"

local CONFIRM_TIMEOUT = 5 -- seconds
local CONFIRM_BINDING = "delete-current-file-confirm"

local pending_timer = nil

local function cancel_confirm()
    if pending_timer then
        pending_timer:kill()
        pending_timer = nil
    end
    mp.remove_key_binding(CONFIRM_BINDING)
end

local function delete_current()
    cancel_confirm()

    local path = mp.get_property("path")
    if not path or path:match("^%a[%w+.-]*://") then
        mp.osd_message("Not a local file, nothing deleted")
        return
    end

    local abs = utils.join_path(mp.get_property("working-directory", ""), path)
    local res = mp.command_native({
        name = "subprocess",
        args = { "gio", "trash", "--", abs },
        playback_only = false,
        capture_stderr = true,
    })

    if res.status ~= 0 then
        mp.osd_message("Delete failed: " .. (res.stderr or res.error_string or "unknown error"), 5)
        return
    end

    mp.osd_message("Moved to trash: " .. mp.get_property("filename", abs), 3)
    -- Removing the current entry advances to the next one (or stops at the end).
    mp.commandv("playlist-remove", "current")
end

mp.register_script_message("delete-file", function(confirm_key, message)
    if not confirm_key or confirm_key == "" then
        delete_current()
        return
    end

    cancel_confirm()
    mp.add_forced_key_binding(confirm_key, CONFIRM_BINDING, delete_current)
    mp.osd_message(message or ("Press " .. confirm_key .. " to delete file"), CONFIRM_TIMEOUT)
    pending_timer = mp.add_timeout(CONFIRM_TIMEOUT, function()
        pending_timer = nil
        mp.remove_key_binding(CONFIRM_BINDING)
        mp.osd_message("Delete cancelled", 1)
    end)
end)

-- Never carry a pending confirmation over to another file.
mp.register_event("start-file", cancel_confirm)
