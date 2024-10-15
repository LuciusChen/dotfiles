local wezterm = require("wezterm")

wezterm.on("gui-attached", function(domain)
    local mux = wezterm.mux
    local workspace = mux.get_active_workspace()
    for _, window in ipairs(mux.all_windows()) do
        if window:get_workspace() == workspace then
            window:gui_window():maximize()
        end
    end
end)

wezterm.on("window-focus-changed", function(window, pane)
    if window:is_focused() then
        window:maximize()
    end
end)

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({ { family = "PragmataPro Mono Liga" }, "LXGW WenKai Screen" })
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.5
config.macos_window_background_blur = 20
config.window_padding = {
    left = 12,
    right = 12,
    top = 8,
    bottom = 0,
}
config.max_fps = 100

wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm").apply_to_config(config, {
    position = "bottom",
    max_width = 32,
    dividers = "slant_right", -- or "slant_left", "arrows", "rounded", false
    indicator = {
        leader = {
            enabled = true,
            off = " ",
            on = " ",
        },
        mode = {
            enabled = true,
            names = {
                resize_mode = "RESIZE",
                copy_mode = "VISUAL",
                search_mode = "SEARCH",
            },
        },
    },
    tabs = {
        numerals = "arabic", -- or "roman"
        pane_count = "superscript", -- or "subscript", false
        brackets = {
            active = { "", ":" },
            inactive = { "", ":" },
        },
    },
    clock = { -- note that this overrides the whole set_right_status
        enabled = true,
        format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
    },
})

return config
