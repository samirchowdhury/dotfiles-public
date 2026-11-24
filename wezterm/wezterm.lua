local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- Show the active tab's custom name in the wider window title bar too.
wezterm.on("format-window-title", function(tab, pane, tabs)
	local title = tab.tab_title
	if title == "" then
		title = pane.title
	end
	if #tabs > 1 then
		return string.format("[%d/%d] %s", tab.tab_index + 1, #tabs, title)
	end
	return title
end)

config.color_scheme = "rose-pine-moon"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50

-- Left Option sends Alt/Meta (needed for tmux Option bindings); right Option still types special characters.
config.send_composed_key_when_left_alt_is_pressed = false

-- Terminator-style splits (Terminator uses Ctrl+Shift+E/O). Default key bindings are kept.
config.keys = {
	{ key = "e", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- side by side
	{ key = "o", mods = "CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- stacked
	{ key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentPane({ confirm = false }) }, -- close pane
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Rename tab (leave empty for automatic title)",
			action = wezterm.action_callback(function(window, _, title)
				if title ~= nil then
					window:active_tab():set_title(title)
				end
			end),
		}),
	},
}

return config
