-- Load SpoonInstall
hs.loadSpoon("SpoonInstall")

-- Set log level
-- hs.logger.defaultLogLevel = "verbose"

-- Configure repositories and update them
-- spoon.SpoonInstall:asyncUpdateAllRepos()
hs.allowAppleScript(true);

-- Load and configure PaperWM
PaperWM = hs.loadSpoon("PaperWM")
PaperWM.default_width = 0.5
PaperWM.swipe_fingers = 4
PaperWM.swipe_gain = 2.0

-- Exclude Stickies from tiling so its windows float
PaperWM.window_filter = PaperWM.window_filter:setAppFilter("Stickies", false)

-- WebKit helper processes ("CleanShot X Web Content", "zoom.us Calendar Web
-- Content", ...) never own windows but stall accessibility queries for ~3s
-- each while hs.window.filter registers running apps. Treat them as non-GUI.
local isGuiApp = hs.window.filter.isGuiApp
hs.window.filter.isGuiApp = function(appname)
  if appname and appname:sub(-12) == " Web Content" then return false end
  return isGuiApp(appname)
end

-- Keep the window filter (and Hammerspoon's global app watcher) running even
-- while PaperWM is stopped. Otherwise PaperWM:stop() tears the watcher down
-- and PaperWM:start() has to re-register every app, which took 20s+.
PaperWM.window_filter:keepActive()

-- move focused window to the active space on the next screen
local function moveWindowToNextScreen()
  local win = hs.window.focusedWindow()
  if not win then return end
  local next_screen = win:screen():next()
  local space_id = hs.spaces.activeSpaceOnScreen(next_screen)
  local index = PaperWM.space.MissionControl:getSpaceIndex(space_id)
  if index then PaperWM.space.moveWindowToSpace(index) end
end

-- PaperWM hotkeys. These are bound inside a modal (below) instead of via
-- PaperWM:bindHotkeys so they can be switched off together with tiling.
local tiling_hotkeys = {
  -- switch to a new focused window in tiled grid (aligned with aerospace)
  focus_left          = { { "cmd", "shift" }, "h" },
  focus_down          = { { "cmd", "shift" }, "j" },
  focus_up            = { { "cmd", "shift" }, "k" },
  focus_right         = { { "cmd", "shift" }, "l" },

  -- move windows around in tiled grid (aligned with aerospace)
  swap_left           = { { "alt", "shift" }, "h" },
  swap_down           = { { "alt", "shift" }, "j" },
  swap_up             = { { "alt", "shift" }, "k" },
  swap_right          = { { "alt", "shift" }, "l" },

  -- join windows (aligned with aerospace)
  slurp_in            = { { "cmd", "alt" }, "i" },
  barf_out            = { { "cmd", "alt" }, "o" },

  -- position and resize focused window
  center_window       = { { "alt", "cmd" }, "c" },
  full_width          = { { "cmd", "shift" }, "return" },
  cycle_width         = { { "alt", "cmd" }, "r" },
  reverse_cycle_width = { { "ctrl", "alt", "cmd" }, "r" },

  -- increase/decrease width (aligned with aerospace resize)
  increase_width      = { { "alt", "shift" }, "=" },
  decrease_width      = { { "alt", "shift" }, "-" },

  -- move the focused window into / out of the tiling layer
  toggle_floating     = { { "alt", "cmd", "shift" }, "escape" },

  -- switch to a new Mission Control space
  switch_space_l      = { { "alt", "cmd" }, "," },
  switch_space_r      = { { "alt", "cmd" }, "." },
  switch_space_1      = { { "alt" }, "1" },
  switch_space_2      = { { "alt" }, "2" },

  -- move focused window to a new space and tile
  move_window_1       = { { "alt", "shift" }, "1" }
}

-- Modal with no trigger key: entered/exited programmatically. Hotkeys bound to
-- it are only active while the modal is entered, i.e. while tiling is running.
local tiling_modal = hs.hotkey.modal.new()
local actions = PaperWM.actions.actions()
for name, spec in pairs(tiling_hotkeys) do
  if actions[name] then
    tiling_modal:bind(spec[1], spec[2], nil, actions[name])
  else
    hs.showError("PaperWM: unknown action '" .. name .. "'")
  end
end
tiling_modal:bind({ "alt", "shift" }, "m", nil, moveWindowToNextScreen)

-- Pause / resume tiling.
-- PaperWM:stop() unsubscribes every window/screen/swipe/mouse watcher so
-- windows are no longer managed; PaperWM:start() re-scans and re-tiles.
local tiling_paused = false

local function startTiling()
  PaperWM:start()
  tiling_modal:enter()
  tiling_paused = false
end

local function pauseTiling()
  tiling_modal:exit()
  PaperWM:stop()
  tiling_paused = true
end

local function toggleTiling()
  if tiling_paused then
    hs.alert.show("Tiling resumed")
    startTiling()
  else
    hs.alert.show("Tiling paused")
    pauseTiling()
  end
end

-- always active, even while paused
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "p", toggleTiling)

startTiling()
