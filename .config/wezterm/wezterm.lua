local wezterm = require("wezterm")
local config = wezterm.config_builder()

return {
    color_scheme = "Tokyo Night",
    font = wezterm.font_with_fallback({ { family = "PragmataPro Mono Liga" }, "LXGW WenKai Screen" }),
    font_size = 14,
    hide_tab_bar_if_only_one_tab = true,
    window_decorations = "RESIZE",
    window_background_opacity = 0.5,
    macos_window_background_blur = 20,
    window_padding = {
        left = 12,
        right = 12,
        top = 8,
        bottom = 0,
    },
}
