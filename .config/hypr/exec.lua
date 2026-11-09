-- Autostart
-- See https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd('xremap --watch /home/markas/.config/xremap/runescape.yml --device "Razer,BSK V3 PRO Mouse"')
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd('echo "Xft.dpi: 144" | xrdb -merge')

    -- Dark mode
    hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"') -- GTK4 apps
    hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')       -- GTK3 apps
end)
