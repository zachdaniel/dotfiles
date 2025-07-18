local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local my_schema = {
  sessionizer.FdSearch "~/dev", -- Searches for git repos in ~/my_projects
}

config.keys = {
  { key = "s", mods = "CMD", action = sessionizer.show(my_schema) },
}

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28
--
-- -- or, changing the font size and color scheme.
-- config.font_size = 10
-- config.color_scheme = 'AdventureTime'

-- Finally, return the configuration to wezterm:
return config
