----->> Windows and Workspaces

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

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Firefox PiP
hl.window_rule({
    name = "pip-firefox",
    match = { class = "firefox" },
    match = { title = "Picture in Picture" },
    float = true,
    size = { 300, 200 },
})

-- Fuzzle Animation
hl.layer_rule({
	name = "fuzzel-anim",
	match = { namespace = "launcher" },
	animation = "slide buttom",
})
-- Mako
hl.layer_rule({
	name = "mako-anim",
	match = { namespace = "notifications" },
	animation = "slide right",
})

-- Power Animation
hl.layer_rule({
	name = "power-anim",
	match = { namespace = "power" },
	animation = "popin 87%",
})

hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "kitty",
})
