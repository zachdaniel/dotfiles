-- Rex configuration. Apply changes with `rex config reload`.

local TERMINAL = "com.superlogical.terminal"
local SHELL = "com.superlogical.terminal.shell"
local HOME = os.getenv("HOME")

local function shell_quote(s)
  return "'" .. (s:gsub("'", [['\'']])) .. "'"
end

--------------------------------------------------------------------------------
-- Navigation: nvim window -> Rex pane -> macOS window
--
-- cmd+shift+hjkl first asks nvim (when it's the foreground program) to move
-- between its windows, then moves between Rex panes, and at the edge of the
-- Rex window hands off to Hammerspoon, which moves to the neighbouring PaperWM
-- window. Hammerspoon turns off its own cmd+shift+hjkl while Rex is frontmost
-- so the keys reach Rex.
--------------------------------------------------------------------------------

local VIM_KEYS = { left = "h", down = "j", up = "k", right = "l" }
local EPSILON = 1e-6

-- nvim listens here when started inside Rex (see nvim/init.lua)
local function nvim_socket(block_id)
  return "/tmp/nvim-rex-" .. (block_id:gsub("^block:", "")) .. ".sock"
end

-- Ask nvim to move; true if it did. Only asks when nvim is the foreground
-- program, so a suspended nvim isn't moved behind the shell's back.
local function nvim_navigate(block_id, direction)
  local proc = rex.block.call(TERMINAL, "process", { block_id = block_id })
  local fg = proc and proc.foreground
  if not (fg and fg.name == "nvim" and fg.path) then return false end

  -- alarm bounds the wait, so a busy nvim can't hang the key
  local cmd = string.format(
    "/usr/bin/perl -e 'alarm shift; exec @ARGV' 1 %s --server %s --remote-expr %s 2>/dev/null",
    shell_quote(fg.path),
    shell_quote(nvim_socket(block_id)),
    shell_quote("v:lua.RexNavigate('" .. VIM_KEYS[direction] .. "')")
  )
  local pipe = io.popen(cmd)
  if not pipe then return false end
  local out = pipe:read("*a")
  pipe:close()
  return out:match("^1") ~= nil
end

local function find_rect(node, block_id)
  if node == nil then return nil end
  if node.block_id == block_id then return node.rect end
  if node.split then
    return find_rect(node.split.before, block_id) or find_rect(node.split.after, block_id)
  end
end

-- Whether no pane lies beside block_id in direction. Tiled layouts fill the
-- window, so a pane has a neighbour on every side it doesn't share with the
-- window. A zoomed pane is at every edge; a floating one is never, and the app
-- moves focus within Rex.
local function at_edge(block_id, direction)
  local view = rex.session.view{}
  for _, win in ipairs(view and view.windows or {}) do
    for _, layer in ipairs(win.layers or {}) do
      local rect = layer.kind == "tiled" and find_rect(layer.layout, block_id)
      if rect then
        if win.zoomed_block_id then return true end
        local x, y, w, h = rect[1], rect[2], rect[3], rect[4]
        if direction == "left" then return x <= EPSILON end
        if direction == "right" then return x + w >= 1 - EPSILON end
        if direction == "up" then return y <= EPSILON end
        return y + h >= 1 - EPSILON
      end
    end
  end
  return false
end

local function focus_macos_window(direction)
  os.execute("/usr/bin/open -g " .. shell_quote("hammerspoon://paperwm?action=focus_" .. direction) .. " &")
end

rex.action{
  name = "navigate",
  title = "Navigate",
  description = "Move focus to the nvim window, Rex pane, or macOS window in a direction",
  args = { direction = "string" },
  run = function(ctx, args)
    local direction = args.direction
    if not VIM_KEYS[direction] then error("direction must be left, down, up, or right", 0) end

    local block_id = ctx.block_id
    if block_id and nvim_navigate(block_id, direction) then return end

    if block_id and at_edge(block_id, direction) then
      focus_macos_window(direction)
    else
      rex.client.queue("pane.focus", { direction = direction })
    end
  end,
}

for direction, key in pairs(VIM_KEYS) do
  rex.bind("cmd+shift+" .. key, "navigate", { direction = direction })
end

--------------------------------------------------------------------------------
-- Hosts: the other Macs' Rex servers, over the personal tailnet. Each Mac skips
-- its own entry, recognised by Rex's "<local hostname>-rex" node name.
-- rex-sessionizer looks for project sessions on these too.
--------------------------------------------------------------------------------

local HOSTS = {
  { label = "laptop", endpoint = "zachs-macbook-pro-2-rex.tailfa0854.ts.net" },
  { label = "mini", endpoint = "zachs-mac-mini-rex.tailfa0854.ts.net" },
}

local function local_hostname()
  local pipe = io.popen("/usr/sbin/scutil --get LocalHostName 2>/dev/null")
  if not pipe then return "" end
  local name = pipe:read("*l") or ""
  pipe:close()
  return name:lower()
end

local own_node = local_hostname() .. "-rex."
for _, host in ipairs(HOSTS) do
  if host.endpoint:sub(1, #own_node) ~= own_node then
    rex.host{ label = host.label, endpoint = host.endpoint }
  end
end

--------------------------------------------------------------------------------
-- Projects: one session per project, picked with fzf in a temporary split
-- below the focused pane (it closes when fzf exits). Floating layers would be
-- nicer, but the app doesn't focus them or draw them opaque yet. The Raycast
-- "Switch Project" command runs the same script.
--------------------------------------------------------------------------------

rex.action{
  name = "open_project",
  title = "Open Project…",
  description = "Pick a project and switch to its session, creating it if needed",
  run = function(ctx)
    -- REX_CLIENT tells the script which app to switch: the one that pressed
    -- the key, which may be on another Mac
    local command = { HOME .. "/.dotfiles/scripts/rex-sessionizer" }
    if ctx.client_id then
      table.insert(command, 1, "REX_CLIENT=" .. ctx.client_id)
      table.insert(command, 1, "/usr/bin/env")
    end
    local _, err = rex.session.new_split{
      anchor_block_id = ctx.block_id,
      direction = "vertical",
      side = "after",
      ratio = 0.5,
      focus = true,
      layout = rex.layout.block{
        flavor = SHELL,
        options = { command = command },
      },
    }
    if err then error(err, 0) end
  end,
}

rex.bind("cmd+o", "open_project")
