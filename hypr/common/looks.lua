----->>General looks
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(faebd7ff)", "rgba(ffffffff)"}, angle = 45 },
            inactive_border = { colors = {"rgba(faebd7ff)", "rgba(000000ab)"}, angle = 45},
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 6,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.90,
        inactive_opacity = 0.36,

        shadow = {
            enabled      = true,
            range        = 7,
            render_power = 4,
            color        = 0x26faebd7,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.196,
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
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

--Wallpaper
hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})
