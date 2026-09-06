-- Primary Hyprland configuration for Hyprland 0.55+.
--
-- The legacy hyprland.conf is kept alongside this file as a rollback path for
-- older sessions. Hyprland loads this Lua file when both are present.

local home = os.getenv("HOME") or ""
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local config_dir = config_home .. "/hypr"
local bin_dir = home .. "/.local/bin"

local function load_optional(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        dofile(path)
    end
end

local function shell_quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

-- Keep monitor layouts per-host. The MacBook gets a preferred internal panel;
-- this laptop gets its external-display layout from host/masonlegion/hypr.lua.
load_optional(config_dir .. "/host.lua")

--------------------
---- AUTOSTART -----
--------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("command -v mako >/dev/null 2>&1 && mako")
    hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && command -v cliphist >/dev/null 2>&1 && wl-paste --type text --watch cliphist store")
    hl.exec_cmd("command -v wl-paste >/dev/null 2>&1 && command -v cliphist >/dev/null 2>&1 && wl-paste --type image --watch cliphist store")

    -- Synchronize Waybar/Kitty/Neovim with the selected theme without causing
    -- a reload loop while Hyprland is starting.
    local switcher = shell_quote(bin_dir .. "/theme-switch")
    local state_file = shell_quote(config_home .. "/theme-switch/current")
    hl.exec_cmd("if [ -x " .. switcher .. " ]; then theme=\"$(cat " .. state_file .. " 2>/dev/null || echo obsidian-gold)\"; DOTFILES_THEME_NO_RELOAD=1 " .. switcher .. " \"$theme\"; fi")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,
        col = {
            active_border = { colors = { "rgba(D4A84Fee)", "rgba(E7C97Aee)" }, angle = 45 },
            inactive_border = "rgba(A39A8B99)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        rounding_power = 2,
        active_opacity = 1,
        inactive_opacity = 1,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            -- Lua shadow colors use AARRGGBB numeric notation.
            color = 0xcc0b0b0d,
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    cursor = {
        no_hardware_cursors = 2,
        use_cpu_buffer = 2,
    },
})

-- Preserve the animation feel from the old hyprlang config.
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",   enabled = true, speed = 7,    bezier = "quick" })

----------------
---- INPUT -----
----------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER"
local function exec(command)
    return hl.dsp.exec_cmd(command)
end

hl.bind(main_mod .. " + Q", exec("kitty"))
hl.bind(main_mod .. " + C", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + M", exec(bin_dir .. "/power-menu"))
hl.bind(main_mod .. " + code:51", exec(bin_dir .. "/toggle-lid-sleep"))
hl.bind(main_mod .. " + E", exec("dolphin"))
hl.bind(main_mod .. " + CTRL + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + R", exec("hyprctl reload"))
hl.bind(main_mod .. " + F7", exec(bin_dir .. "/toggle-monitor-mode"))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + D", exec("wofi --show drun"))
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.fullscreen())

hl.bind(main_mod .. " + F1", exec(bin_dir .. "/theme-switch midnight-sapphire"))
hl.bind(main_mod .. " + F2", exec(bin_dir .. "/theme-switch purple-midnight"))
hl.bind(main_mod .. " + F3", exec(bin_dir .. "/theme-switch obsidian-gold"))
hl.bind(main_mod .. " + F4", exec(bin_dir .. "/theme-switch deep-teal-studio"))
hl.bind(main_mod .. " + F5", exec(bin_dir .. "/theme-switch black-white"))
hl.bind(main_mod .. " + F6", exec(bin_dir .. "/theme-switch red-city"))
hl.bind(main_mod .. " + SHIFT + equal", exec(bin_dir .. "/gammastep-toggle"))

hl.bind("Print", exec(bin_dir .. "/screenshot full"))
hl.bind("ALT + Print", exec(bin_dir .. "/screenshot full-clipboard"))
hl.bind("SHIFT + Print", exec(bin_dir .. "/screenshot region"))
hl.bind(main_mod .. " + Print", exec(bin_dir .. "/screenshot window"))
hl.bind(main_mod .. " + ALT + R", exec(bin_dir .. "/record-screen-picker full"))
hl.bind(main_mod .. " + SHIFT + R", exec(bin_dir .. "/record-screen-picker region"))
hl.bind(main_mod .. " + ALT + S", exec(bin_dir .. "/record-screen stop"))
hl.bind(main_mod .. " + SHIFT + V", exec(bin_dir .. "/cliphist-picker"))

hl.bind(main_mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(main_mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(main_mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   exec(bin_dir .. "/brightness-step up"),                 { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec(bin_dir .. "/brightness-step down"),               { locked = true, repeating = true })
hl.bind("F5",                    exec(bin_dir .. "/brightness-step down"),               { locked = true, repeating = true })
hl.bind("F6",                    exec(bin_dir .. "/brightness-step up"),                 { locked = true, repeating = true })

hl.bind("XF86AudioNext",  exec("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  exec("playerctl previous"),   { locked = true })

-- OpenWhispr's optional global toggle. The matching .conf remains for the
-- legacy configuration path.
hl.bind("CTRL + SUPER_L", exec("dbus-send --session --type=method_call --dest=com.openwhispr.App /com/openwhispr/App com.openwhispr.App.Toggle"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "xwayland-empty-popup-minimum-size",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
    },
    size = "360 240",
})

hl.window_rule({
    name = "workspace-kitty",
    match = { class = "^(kitty)$" },
    workspace = 1,
})

hl.window_rule({
    name = "workspace-zen",
    match = { class = "^(zen|Zen|zen-browser)$" },
    workspace = 2,
})

hl.window_rule({
    name = "workspace-spotify",
    match = { class = "^(spotify|Spotify)$" },
    workspace = 6,
})

hl.window_rule({
    name = "motive-license-focus",
    match = { class = "^(optitrackactivationtool\\.exe)$" },
    float = true,
    stay_focused = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

-- Theme colors are applied last so the selected theme overrides the base
-- palette above. It reads ~/.config/theme-switch/current at startup/reload.
load_optional(config_dir .. "/theme.lua")
