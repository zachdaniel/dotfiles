local wezterm = require("wezterm")
local sessionizer = require("sessionizer")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font Mono")
config.hide_tab_bar_if_only_one_tab = true

config.leader = { key = 'a', mods = 'CTRL'}

config.keys = {
  { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.open) }
}

return config
