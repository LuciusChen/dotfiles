local wezterm = require("wezterm")
local config = wezterm.config_builder()

return {
    color_scheme = "Tokyo Night",
    font = wezterm.font_with_fallback({ { family = "PragmataPro Mono Liga" }, "LXGW WenKai Screen" }),
    font_size = 14,
    enable_tab_bar = false,
    window_decorations = "NONE",
    window_padding = {
        left = 12,
        right = 12,
        top = 8,
        bottom = 0,
    },
}
