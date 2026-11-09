-- See https://wiki.hypr.land/configuring/core/binds/

local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local OCR4Linux   = "~/.config/OCR4Linux/OCR4Linux.sh --lang jpn"
local osd         = "~/.config/hypr/scripts/osd.sh"

hl.bind(mainMod .. " + RETURN",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",              hl.dsp.window.close())
hl.bind(mainMod .. " + M",              hl.dsp.exit())
hl.bind(mainMod .. " + G",              hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F",              hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + B",      hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")) -- Toggle hide/show waybar
hl.bind(mainMod .. " + SHIFT + E",      hl.dsp.exec_cmd(OCR4Linux))

hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- Move focus with mainMod + arrow keys / hjkl
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))

-- Screenshot
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("Print",                       hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.exec_cmd("hyprshot -m region"))

-- Switch workspaces with mainMod + [0-9] (and numpad)
-- Move active window to a workspace with mainMod + SHIFT + [0-9] (and numpad)
local numpad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior", "KP_Insert" }
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,                hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,        hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + " .. numpad[i],          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. numpad[i],  hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll / tab
hl.bind(mainMod .. " + mouse_down",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",       hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Tab",            hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab",    hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && " .. osd .. " volume"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && " .. osd .. " volume"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && " .. osd .. " volume"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+ && " .. osd .. " brightness"),              { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%- && " .. osd .. " brightness"),              { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Vicinae (launcher)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))

-- Notification center
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- Resize windows
local resize = {
    { "h", "left",  -50,   0 },
    { "l", "right",  50,   0 },
    { "k", "up",      0, -50 },
    { "j", "down",    0,  50 },
}
for _, r in ipairs(resize) do
    local letter, arrow, x, y = table.unpack(r)
    local dsp = hl.dsp.window.resize({ x = x, y = y, relative = true })
    hl.bind(mainMod .. " + SHIFT + " .. letter, dsp, { repeating = true })
    hl.bind(mainMod .. " + SHIFT + " .. arrow,  dsp, { repeating = true })
end

-- Move windows
local move = {
    { "h", "left",  "left"  },
    { "l", "right", "right" },
    { "k", "up",    "up"    },
    { "j", "down",  "down"  },
}
for _, m in ipairs(move) do
    local letter, arrow, direction = table.unpack(m)
    local dsp = hl.dsp.window.move({ direction = direction })
    hl.bind(mainMod .. " + CTRL + " .. letter, dsp)
    hl.bind(mainMod .. " + CTRL + " .. arrow,  dsp)
end

-- Special workspace
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + U",         hl.dsp.workspace.toggle_special("magic"))

-- Device specific (runs in addition to the binds above)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d amdgpu_bl2 set +5% && " .. osd .. " brightness-device amdgpu_bl2"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d amdgpu_bl2 set 5%- && " .. osd .. " brightness-device amdgpu_bl2"))
