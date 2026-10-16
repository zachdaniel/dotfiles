-- The parts of rex-sessionizer that talk to Rex servers, run with `rex do`.
-- Parameters come from the environment:
--
--   ACTION=find PROJECT=~/path WHERE=all|local|other
--       Print the ID of the project's open session: this Mac's first, then
--       the other one's (for WHERE=all).
--   ACTION=sessions [OTHER=1]
--       Print "ID<TAB>label<TAB>project" for each open session.
--   ACTION=projects [OTHER=1]
--       Print "project<TAB>open session ID" for each project. A hidden pane
--       on that Mac rebuilds its project index first (rex-sessionizer --index).
--
-- Projects are paths from ~. Sessions are matched to projects by the records
-- described in rex-sessionizer, which live on the Mac that runs the session
-- and are read through a terminal's list_dir method, like the index.

local TERMINAL = "com.superlogical.terminal"
local STATE = "~/.local/state/rex-sessionizer"

local function env(name)
  local value = os.getenv(name)
  if value == "" then return nil end
  return value
end

local function decode(s)
  return (s:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end))
end

local function other_server()
  local hosts = rex.servers()
  if #hosts ~= 1 then error("expected one other Mac in rex hosts, found " .. #hosts, 0) end
  return rex.server(hosts[1])
end

-- The files in a directory on the block's Mac (none if it's missing), or nil
-- when the block can't list directories
local function files(server, session_id, block_id, path)
  local ok, dir = pcall(server.block.call, TERMINAL, "list_dir", {
    session_id = session_id, block_id = block_id, path = path, files = true, limit = 10000,
  })
  if not (ok and dir) then return nil end
  local names = {}
  for _, entry in ipairs(dir.entries or {}) do
    if entry.file then table.insert(names, entry.name) end
  end
  return names
end

-- { [session ID] = project } from the records in names
local function parse_records(names)
  local records = {}
  for _, name in ipairs(names) do
    local uuid, project = name:match("^(.-)=(.*)$")
    if uuid then records["session:" .. uuid] = decode(project) end
  end
  return records
end

-- The server's open sessions and records, read through any of its terminals.
-- A session's blocks can only be listed once attached to it.
local function sessions_and_records(server)
  local list = server.call("session.list", {})
  local sessions = list and list.sessions or {}
  for _, s in ipairs(sessions) do
    server.call("session.attach", { session_id = s.session_id })
    local blocks = server.call("session.list_blocks", { session_id = s.session_id })
    for _, b in ipairs(blocks and blocks.blocks or {}) do
      local names = files(server, s.session_id, b.block_id, STATE)
      if names then return sessions, parse_records(names) end
    end
  end
  return sessions, {}
end

-- Run command in a hidden terminal on the server (a block that's never placed
-- in a window), wait for it to exit, and return fn(session ID, block ID). A
-- server with no sessions gets a temporary one.
local function in_hidden_terminal(server, command, fn)
  local list = server.call("session.list", {})
  local session_id = list and list.sessions and list.sessions[1] and list.sessions[1].session_id
  local temporary = false
  if not session_id then
    session_id = assert(server.call("session.create", { label = "rex-sessionizer" })).session_id
    temporary = true
  end
  server.call("session.attach", { session_id = session_id })
  local block = assert(server.call("session.new_block", {
    session_id = session_id,
    flavor = TERMINAL .. ".shell",
    options = { command = command, exit = { on_completion = false } },
  }))
  local result
  local ok, err = pcall(function()
    for _ = 1, 200 do
      local process = server.block.call(TERMINAL, "process", { session_id = session_id, block_id = block.block_id })
      if process and process.last_exit ~= nil then break end
      rex.sleep(0.05)
    end
    result = fn(session_id, block.block_id)
  end)
  server.call("block.close", { session_id = session_id, block_id = block.block_id })
  if temporary then server.call("session.destroy", { session_id = session_id }) end
  if not ok then error(err, 0) end
  return result
end

local action = env("ACTION")

if action == "find" then
  local project, where = env("PROJECT"), env("WHERE") or "all"
  local servers = {}
  if where ~= "other" then table.insert(servers, rex) end
  if where ~= "local" then
    for _, host in ipairs(rex.servers()) do
      local ok, server = pcall(rex.server, host)
      if ok then table.insert(servers, server) end
    end
  end
  for _, server in ipairs(servers) do
    local ok, sessions, records = pcall(sessions_and_records, server)
    if ok then
      for _, s in ipairs(sessions) do
        if records[s.session_id] == project then
          print(s.session_id)
          return
        end
      end
    end
  end

elseif action == "sessions" then
  local server = env("OTHER") and other_server() or rex
  local sessions, records = sessions_and_records(server)
  for _, s in ipairs(sessions) do
    print(table.concat({ s.session_id, s.label or "", records[s.session_id] or "" }, "\t"))
  end

elseif action == "projects" then
  local server = env("OTHER") and other_server() or rex
  -- An older script there would take --index for a project, so check first
  local read = in_hidden_terminal(server,
    { "/bin/sh", "-c", 's="$HOME/.dotfiles/scripts/rex-sessionizer"; grep -q -e "^--index)" "$s" && exec "$s" --index' },
    function(session_id, block_id)
      return {
        index = files(server, session_id, block_id, STATE .. "/projects") or {},
        records = parse_records(files(server, session_id, block_id, STATE) or {}),
      }
    end)
  local list = server.call("session.list", {})
  local open = {}
  for _, s in ipairs(list and list.sessions or {}) do
    local project = read.records[s.session_id]
    if project then open[project] = s.session_id end
  end
  for _, name in ipairs(read.index) do
    local project = decode(name)
    print(project .. "\t" .. (open[project] or ""))
  end

else
  error("unknown ACTION " .. tostring(action), 0)
end
