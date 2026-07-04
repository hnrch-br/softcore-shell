----->>General looks
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 20,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(faebd742)", "rgba(00000000)"}, angle = 45 },
            inactive_border = { colors = {"rgba(00000000)", "rgba(faebd742)"}, angle = 45},
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 9,
        rounding_power = 4,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.87,
        inactive_opacity = 0.74,

        shadow = {
            enabled      = true,
            range        = 5,
            render_power = 5,
            color        = 0x47000000,
        },

        blur = {
            enabled   = true,
            size      = 7,
            passes    = 2,
            vibrancy  = 0.160,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
        orientation = "left",
        allow_small_split = false
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        focus_fit_method = 1,
        follow_focus = true
    },
})

--Wallpaper
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        initial_workspace_tracking = 0,
    },
})
