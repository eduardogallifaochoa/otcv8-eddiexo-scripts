-- load all otui files, order doesn't matter
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local configFiles = g_resources.listDirectoryFiles("/bot/" .. configName .. "/vBot", true, false)
for i, file in ipairs(configFiles) do
  local ext = file:split(".")
  if ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui" then
    g_ui.importStyle(file)
  end
end

-- load private UI styles (optional)
do
  local ok, privateUiFiles = pcall(g_resources.listDirectoryFiles, "/bot/" .. configName .. "/ui", true, false)
  if ok and privateUiFiles then
    for _, file in ipairs(privateUiFiles) do
      local ext = file:split(".")
      if ext[#ext] and (ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui") then
        pcall(g_ui.importStyle, file)
      end
    end
  end
end

local function loadScript(name)
  return dofile("/vBot/" .. name .. ".lua")
end

-- here you can set manually order of scripts
-- libraries should be loaded first
local luaFiles = {
  "main",
  "items",
  "vlib",
  "new_cavebot_lib",
  "configs", -- do not change this and above
  "extras",
  "cavebot",
  "playerlist",
  "BotServer",
  "alarms",
  "Conditions",
  "Equipper",
  "pushmax",
  "combo",
  "HealBot",
  "new_healer",
  "AttackBot", -- last of major modules
  "ingame_editor",
  "Dropper",
  "Containers",
  "quiver_manager",
  "quiver_label",
  "tools",
  "antiRs",
  "equip",
  "exeta",
  "mwall_scrolldown",
  "analyzer",
  "spy_level",
  "supplies",
  "depositer_config",
  "npc_talk",
  "xeno_menu",
  "hold_target",
  "cavebot_control_panel"
}

for i, file in ipairs(luaFiles) do
  loadScript(file)
end

setDefaultTab("Main")
UI.Separator()
UI.Label("Private Scripts:")
UI.Separator()

-- Private loader-based scripts (safe, never crashes the loader).
do
  -- IMPORTANT: in this bot sandbox, `dofile()` resolves paths relative to the current config dir
  -- (e.g. /bot/<profile>/). Passing absolute /bot/<profile>/... can get double-prefixed.
  __druid_toolkit_profile = configName
  local ok, err = pcall(dofile, "bot_loaders/druid_toolkit_loader.lua")
  if not ok then
    print("[_Loader] Failed loading druid toolkit loader: " .. tostring(err))
  end
end

setDefaultTab("Main")
