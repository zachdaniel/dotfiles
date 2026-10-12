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

-- move focused window to the active space on the next screen.
-- PaperWM.space.moveWindowToSpace drags the window in Mission Control (macOS
-- blocks moving windows between spaces directly), which is slow and leaves
-- PaperWM's state out of sync when the drag misses. Moving the frame onto the
-- other display lands it in that display's active space without any of that.
local function moveWindowToNextScreen()
  local win = hs.window.focusedWindow()
  if not win then return end
  local next_screen = win:screen():next()
  local target_space = hs.spaces.activeSpaceOnScreen(next_screen)

  local tiled = PaperWM.state.isTiled(win:id())
  if tiled then PaperWM.floating.toggleFloating(win) end -- untile, retile old space
  win:moveToScreen(next_screen, false, true, 0)
  if not tiled then return end

  -- re-tile once macOS reports the window on its new space. On timeout the
  -- window is re-tiled wherever it ended up rather than left floating.
  local deadline = hs.timer.secondsSinceEpoch() + 1
  hs.timer.waitUntil(function()
    return hs.spaces.windowSpaces(win)[1] == target_space or hs.timer.secondsSinceEpoch() > deadline
  end, function() PaperWM.floating.toggleFloating(win) end, 0.05)
end

-- focus the frontmost window on the next screen
local function focusNextScreen()
  local win = hs.window.focusedWindow()
  local screen = (win and win:screen() or hs.mouse.getCurrentScreen()):next()

  -- off-strip windows overhang the neighbouring display, so trust PaperWM's
  -- state over w:screen() for tiled windows. State is empty while paused, so
  -- this falls back to w:screen().
  local tiled_here = {}
  for _, column in ipairs(PaperWM.state.windowList(hs.spaces.activeSpaceOnScreen(screen))) do
    for _, w in ipairs(column) do tiled_here[w:id()] = true end
  end

  for _, w in ipairs(hs.window.orderedWindows()) do -- front to back
    local id = w:id()
    if tiled_here[id] or (not PaperWM.state.isTiled(id) and w:screen() == screen) then
      w:focus()
      return
    end
  end
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
hs.hotkey.bind({ "cmd", "shift" }, "m", focusNextScreen)
hs.hotkey.bind({ "alt", "shift" }, "m", moveWindowToNextScreen)

startTiling()
