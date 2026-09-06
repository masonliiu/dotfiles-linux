-- Theme bridge for Hyprland's Lua configuration.
-- The shell theme-switch command still writes theme.conf for the legacy path;
-- this file reads the shared state file for the Lua path.

local home = os.getenv("HOME") or ""
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local state_file = config_home .. "/theme-switch/current"

local current = "obsidian-gold"
local file = io.open(state_file, "r")
if file then
    current = (file:read("*l") or current):gsub("%s+$", "")
    file:close()
end

local themes = {
    ["black-white"] = {
        active = { "rgba(F2B9A6ee)", "rgba(A8B3D9ee)" },
        inactive = "rgba(70789A99)",
        angle = 45,
        shadow = 0xcc090c17,
    },
    ["deep-teal-studio"] = {
        active = { "rgba(35C8C8ee)", "rgba(A7E9DDee)" },
        inactive = "rgba(5E8C9499)",
        angle = 45,
        shadow = 0xcc041014,
    },
    ["midnight-sapphire"] = {
        active = { "rgba(69A9FFee)", "rgba(9FCCFFee)" },
        inactive = "rgba(4F679499)",
        angle = 45,
        shadow = 0xcc040916,
    },
    ["obsidian-gold"] = {
        active = { "rgba(D4A84Fee)", "rgba(E7C97Aee)" },
        inactive = "rgba(A39A8B99)",
        angle = 45,
        shadow = 0xcc0b0b0d,
    },
    ["purple-midnight"] = {
        active = { "rgba(CDA6FFee)", "rgba(F3A7D8ee)" },
        inactive = "rgba(5F4F83aa)",
        angle = 40,
        shadow = 0xcc080616,
        border_size = 3,
    },
    ["red-city"] = {
        active = { "rgba(E33434ee)", "rgba(CBCFD6ee)" },
        inactive = "rgba(7B7F8799)",
        angle = 45,
        shadow = 0xcc060608,
    },
}

local theme = themes[current] or themes["obsidian-gold"]

hl.config({
    general = {
        border_size = theme.border_size or 2,
        col = {
            active_border = { colors = theme.active, angle = theme.angle },
            inactive_border = theme.inactive,
        },
    },
    decoration = {
        active_opacity = 1,
        inactive_opacity = 1,
        shadow = {
            color = theme.shadow,
        },
    },
})
