-- Minimal, stable loader for DRUID TOOLKIT.
-- Prefer autoload via _Loader.lua (recommended).
-- If you still want to paste once in the Ingame Script Editor, use a relative path:
--   dofile('bot_loaders/druid_toolkit_loader.lua')

local LOADER_TAG = "[DruidToolkitLoader] "

local function log(msg)
  print(LOADER_TAG .. tostring(msg))
end

-- In this bot sandbox, `_G` may be nil. Use plain globals instead.
if __druid_toolkit_loaded then
  log("Already loaded; skipping.")
  return
end

local function safeDofile(path)
  local ok, res = pcall(dofile, path)
  if ok then
    log("Loaded OK: " .. path)
    return true, res
  end
  log("FAILED: " .. path .. " -> " .. tostring(res))
  return false, res
end

-- Try common mounts. Different OTCv8 builds mount bot profile root differently.
local function candidatePaths()
  local paths = {}

  -- In most bot sandboxes, dofile resolves relative to /bot/<profile>/ already.
  table.insert(paths, "scripts/druid_toolkit.lua")

  -- Last resort: try mounts/relative paths (some builds mount profile root differently).
  table.insert(paths, "/scripts/druid_toolkit.lua")
  return paths
end

local loaded = false
for _, path in ipairs(candidatePaths()) do
  local ok = safeDofile(path)
  if ok then
    loaded = true
    __druid_toolkit_loaded = true
    break
  end
end

if not loaded then
  log("Not loaded. Ensure scripts/druid_toolkit.lua exists in your bot profile folder.")
end
