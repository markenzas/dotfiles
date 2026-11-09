-- Environment variables
-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("EDITOR", "nvim")
hl.env("BROWSER", "brave-browser")

hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("HYPRCURSOR_THEME", "BreezeX-Light")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XCURSOR_THEME", "BreezeX-Light")
hl.env("XCURSOR_SIZE", "24")

hl.env("GDK_SCALE", "1.5")
hl.env("PLASMA_USE_QT_SCALING", "1")

-- Qt apps
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- NVIDIA required
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
