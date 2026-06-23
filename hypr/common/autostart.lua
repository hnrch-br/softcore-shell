----->>Autostart
hl.on("hyprland.start", function () 
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("qs")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store")
  hl.exec_cmd("hyprctl setcursor clay-dark 24")
end)

