--------->> Rules

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(false)

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

--------------------
--> WINDOW RULES <--
--------------------

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- PiP
hl.window_rule({
    name = "pip",
    match = { title = "Picture(-| )in(-| )[Pp]icture" },
    float = true,
    size = { 600, 300 },
    pin = true,
    move = {"monitor_w - window_w - 80", "monitor_h - window_h - 10"},
})

-- Steam Popups
hl.window_rule({
    name = "steam-popups",
    match = { class = "steam", title = "Steam Settings|Friends List|Players|Game Servers|Recordings & Screenshots" },
    float = true,
    move = { "monitor_w / 2 - window_w / 2", "monitor_h / 2 - window_h / 2"},
    min_size = { 300, 500 },
})

-----------------------
--> WORKSPACE RULES <--
-----------------------

-- Special
hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "kitty",
})

-------------------
--> LAYER RULES <--
-------------------

-- Power Animation
hl.layer_rule({
	name = "power-anim",
	match = { namespace = "power" },
	animation = "popin 87%",
})

-- Notification Animation
hl.layer_rule({
	name = "notif-anim",
	match = { namespace = "notifications" },
	animation = "slide right",
})

hl.layer_rule({
    name = "scp-anim",
    match = { namespace = "selection" },
    animation = "fade"
})

-- Launcher Animation
hl.layer_rule({
	name = "launcher-anim",
	match = { namespace = "launcher" },
	animation = "slide bottom",
})
