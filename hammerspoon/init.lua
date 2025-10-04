-- Load SpoonInstall
hs.loadSpoon("SpoonInstall")

-- Configure repositories and update them
spoon.SpoonInstall:asyncUpdateAllRepos()

-- Load and configure PaperWM
PaperWM = hs.loadSpoon("PaperWM")
PaperWM.swipe_fingers = 3
PaperWM.swipe_gain = 2.0
PaperWM:bindHotkeys({
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
})
PaperWM:start()
