local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "/opt/homebrew/bin/fd"
local dev = "/Users/zachdaniel/dev/ash"
local alembic = "/Users/zachdaniel/dev/alembic"
local root = "/Users/zachdaniel"

local open = io.open

local function ever_opened(path)
  local file = open("/Users/zachdaniel/.config/ever-opened-projects.txt")
  if not file then return false end
  for line in file:lines() do
    if line == path then
      file:close()
      return true -- Found a matching line
    end
  end

  file:close()
  return false
end

-- from https://github.com/wez/wezterm/discussions/4796
M.open = function(window, pane)
local projects = {}
	local home = os.getenv("HOME") .. "/"

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		".git$",
		"--max-depth=2",
		"--prune",
		dev,
		alembic,
    root
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

  if stdout == "" then
    return
  end

	-- define variables from from file paths extractions and
	-- fill table with results
	for line in stdout:gmatch("([^\n]*)\n?") do
		-- create label from file path
		local project = line:gsub("/.git.*", "")
		project = project:gsub("/$", "")
		local label = project:gsub(home, "")

		-- extract id. Used for workspace name
		local _, _, id = string.find(project, ".*/(.+)")
		id = id:gsub(".git", "") -- bare repo dirs typically end in .git, remove if so.

    if ever_opened(project) then
      table.insert(projects, { label = tostring(label), id = tostring(id) })
    end

	end

  table.sort(projects, function(a, b)
    return #a < #b
  end)

	-- update previous_workspace before changing to new workspace.
	wezterm.GLOBAL.previous_workspace = window:active_workspace()
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(
						act.SwitchToWorkspace({
							name = id,
							spawn = { cwd = home .. label, args = {"/opt/homebrew/bin/nvim"} },
						}),
						pane
					)
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

return M
