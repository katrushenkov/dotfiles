// I love the automatic continue when playing a folder of files, but,
// I also sometimes just want to stop playback after the current file
// finished (zZz).
//
// Store the current state for whether to pause in a session variable,
// toggle and next time a file starts it'll be paused. To continue hit
// space and it continues like that until it's untoggled. Just like
// Netflix's "Are you still there?" prompt.
(function (mp) {
    var pause_after_current_file = false;

    mp.add_key_binding("shift+s", function() {
        pause_after_current_file = !pause_after_current_file;
        mp.commandv(
            "show-text",
            "pause after current file: " + pause_after_current_file
        );
    });

    function pause_if_toggled_when_new_file_is_started() {
        if(!pause_after_current_file) return;

        mp.set_property("pause", "yes");
        mp.commandv(
            "show-text",
            "paused because pause after current file is set"
        );
    }

    mp.register_event("start-file", pause_if_toggled_when_new_file_is_started);
})(mp);
