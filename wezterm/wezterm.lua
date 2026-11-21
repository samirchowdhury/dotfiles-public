local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"

-- Left Option sends Alt/Meta (needed for tmux Option bindings); right Option still types special characters.
config.send_composed_key_when_left_alt_is_pressed = false

-- Terminator-style splits (Terminator uses Ctrl+Shift+E/O). Default key bindings are kept.
config.keys = {
	{ key = "e", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- side by side
	{ key = "o", mods = "CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- stacked
	{ key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = false }) }, -- close pane
}

return config
