-- Extra autostart processes.
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- pypr")
end)
