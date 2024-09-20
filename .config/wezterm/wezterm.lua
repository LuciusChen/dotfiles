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
    max_fps = 100,
}
