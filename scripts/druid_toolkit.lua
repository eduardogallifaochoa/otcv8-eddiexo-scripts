--==============================================================
-- DRUID TOOLKIT (OTClient / OTCv8 macros)
-- Loaded via: bot_loaders/druid_toolkit_loader.lua
-- UI goal: PvP Scripts style (Main toggle + Setup button) with custom background.png.
--==============================================================

local TAG = "[DruidToolkit] "
local function log(msg) print(TAG .. tostring(msg)) end

storage.druidToolkit = storage.druidToolkit or {}
local cfg = storage.druidToolkit

-- Master enable (Main green/red button)
if cfg.enabled == nil then cfg.enabled = true end

-- Visual toggles
if cfg.hideEffects == nil then cfg.hideEffects = true end
if cfg.hideOrangeTexts == nil then cfg.hideOrangeTexts = true end

-- Defaults / editable settings
cfg.stopKey = cfg.stopKey or "Pause"
cfg.ueSpell = cfg.ueSpell or "exevo gran mas frigo"
cfg.ueRepeat = cfg.ueRepeat or 4
cfg.ueMinMonstersSafe = cfg.ueMinMonstersSafe or 4

cfg.antiParalyzeSpell = cfg.antiParalyzeSpell or "utani gran hur"
cfg.hasteSpell = cfg.hasteSpell or "utani hur"
cfg.healSpell = cfg.healSpell or "exura vita"
cfg.healPercent = cfg.healPercent or 95

cfg.followLeader = cfg.followLeader or "Name"

cfg.hk = cfg.hk or {
  ueNonSafe = "F1",
  ueSafe = "F2",
  superSd = "F3",
  superSdFire = "F4",
  superSdHoly = "F5",
  sioVip = "F6",
}

--==============================================================
-- Helpers
--==============================================================

local function chatTyping()
  return modules
    and modules.game_console
    and modules.game_console.isChatEnabled
    and modules.game_console.isChatEnabled()
end

if not table.contains then
  function table.contains(t, v)
    if type(t) ~= "table" then return false end
    for _, x in ipairs(t) do
      if x == v then return true end
    end
    return false
  end
end

local function safeSetText(widget, text)
  if widget and widget.setText then widget:setText(text) end
end

local function safeSetOn(widget, v)
  if widget and widget.setOn then widget:setOn(v) end
end

local function toggleMacro(m)
  if not m or not m.isOn or not m.setOn then return end
  m.setOn(not m.isOn())
end

local function getHotkey(action)
  return (cfg.hk and cfg.hk[action]) or ""
end

local function setHotkey(action, key)
  if not action or type(action) ~= "string" then return end
  if not key or type(key) ~= "string" or key:len() == 0 then return end
  cfg.hk[action] = key
end

local function isEnabled()
  return cfg.enabled == true
end

-- Forward declarations for icon-driven macros (used by master enable/disable).
local ueNonSafe, ueSafe, superSd, superSdFire, superSdHoly, sioVipMacro

--==============================================================
-- Main UI Row (PvP Scripts style)
--==============================================================

local mainUi = nil

local function setupMainRow()
  setDefaultTab("Main")
  local ui = nil
  pcall(function()
    ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 120
    text: Druid Toolkit

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])
  end)

  if not ui then return nil end
  ui:setId("druid_toolkit_panel")
  return ui
end

--==============================================================
-- Setup Window (custom background.png)
--==============================================================

local dtWindow = nil
local HK_WAITING_FOR = nil

local function dtResolve(win, id)
  if not win then return nil end
  return win[id]
    or (win.recursiveGetChildById and win:recursiveGetChildById(id))
    or (win.getChildById and win:getChildById(id))
end

local function dtShowPage(pageId)
  if not dtWindow then return end
  local pages = { "pageMenu", "pageGeneral", "pageSpells", "pageHotkeys" }
  for _, id in ipairs(pages) do
    local p = dtResolve(dtWindow, id)
    if p and p.hide then p:hide() end
  end
  local page = dtResolve(dtWindow, pageId)
  if page and page.show then page:show() end
end

local function getBotConfigName()
  local cfgName = nil
  if modules and modules.game_bot and modules.game_bot.contentsPanel
    and modules.game_bot.contentsPanel.config
    and modules.game_bot.contentsPanel.config.getCurrentOption
  then
    local opt = modules.game_bot.contentsPanel.config:getCurrentOption()
    if opt and opt.text then cfgName = opt.text end
  end
  return cfgName
end

local function resolveBackgroundPath()
  local candidates = { "background.png" }

  local cfgName = getBotConfigName()
  if cfgName and type(cfgName) == "string" and cfgName:len() > 0 then
    table.insert(candidates, "/bot/" .. cfgName .. "/background.png")
  end
  table.insert(candidates, "/background.png")

  if g_resources and g_resources.fileExists then
    for _, p in ipairs(candidates) do
      if g_resources.fileExists(p) then
        return p
      end
    end
  end
  return nil
end

local function dtRefresh()
  if not dtWindow then return end

  safeSetOn(dtResolve(dtWindow, "enabledSwitch"), isEnabled())
  safeSetOn(dtResolve(dtWindow, "hideEffectsSwitch"), cfg.hideEffects == true)
  safeSetOn(dtResolve(dtWindow, "hideTextsSwitch"), cfg.hideOrangeTexts == true)

  safeSetText(dtResolve(dtWindow, "stopKey"), cfg.stopKey or "")
  safeSetText(dtResolve(dtWindow, "followLeader"), cfg.followLeader or "")

  safeSetText(dtResolve(dtWindow, "ueSpell"), cfg.ueSpell or "")
  safeSetText(dtResolve(dtWindow, "ueRepeat"), tostring(cfg.ueRepeat or 4))
  safeSetText(dtResolve(dtWindow, "antiParalyzeSpell"), cfg.antiParalyzeSpell or "")
  safeSetText(dtResolve(dtWindow, "hasteSpell"), cfg.hasteSpell or "")
  safeSetText(dtResolve(dtWindow, "healSpell"), cfg.healSpell or "")
  safeSetText(dtResolve(dtWindow, "healPercent"), tostring(cfg.healPercent or 95))

  safeSetText(dtResolve(dtWindow, "ueNonSafeKey"), getHotkey("ueNonSafe"))
  safeSetText(dtResolve(dtWindow, "ueSafeKey"), getHotkey("ueSafe"))
  safeSetText(dtResolve(dtWindow, "superSdKey"), getHotkey("superSd"))
  safeSetText(dtResolve(dtWindow, "superSdFireKey"), getHotkey("superSdFire"))
  safeSetText(dtResolve(dtWindow, "superSdHolyKey"), getHotkey("superSdHoly"))
  safeSetText(dtResolve(dtWindow, "sioVipKey"), getHotkey("sioVip"))
end

local function dtApplyEnabledState()
  if not isEnabled() then
    HK_WAITING_FOR = nil
    if ueNonSafe then ueNonSafe.setOn(false) end
    if ueSafe then ueSafe.setOn(false) end
    if superSd then superSd.setOn(false) end
    if superSdFire then superSdFire.setOn(false) end
    if superSdHoly then superSdHoly.setOn(false) end
    if sioVipMacro then sioVipMacro.setOn(false) end
  end
  if mainUi and mainUi.title and mainUi.title.setOn then
    mainUi.title:setOn(isEnabled())
  end
  dtRefresh()
end

local function dtEnsureWindow()
  if dtWindow and dtWindow.show then return true end

  local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
  if not root then
    schedule(200, function() dtEnsureWindow() end)
    return false
  end

  local ok, win = pcall(function()
    return UI and UI.createWindow and UI.createWindow("DruidToolkitSetupWindow", root) or nil
  end)

  if not ok or not win then
    -- In case styles weren't imported for some reason, try importing locally.
    local cfgName = getBotConfigName()
    local candidates = {}
    if cfgName and cfgName:len() > 0 then
      table.insert(candidates, "/bot/" .. cfgName .. "/ui/druid_toolkit.otui")
    end
    table.insert(candidates, "/ui/druid_toolkit.otui")
    for _, p in ipairs(candidates) do
      if g_resources and g_resources.fileExists and g_resources.fileExists(p) then
        pcall(g_ui.importStyle, p)
      end
    end

    ok, win = pcall(function()
      return UI and UI.createWindow and UI.createWindow("DruidToolkitSetupWindow", root) or nil
    end)
    if not ok or not win then
      return false
    end
  end

  dtWindow = win
  dtWindow:hide()

  -- Background
  local bg = dtResolve(dtWindow, "bg")
  local bgPath = resolveBackgroundPath()
  if bg and bgPath and bg.setImageSource then
    pcall(function() bg:setImageSource(bgPath) end)
  end

  -- Close
  local closeButton = dtResolve(dtWindow, "closeButton")
  if closeButton then
    closeButton.onClick = function() dtWindow:hide() end
  end

  -- Menu buttons
  local btnGeneral = dtResolve(dtWindow, "btnGeneral")
  local btnHotkeys = dtResolve(dtWindow, "btnHotkeys")
  local btnIcons = dtResolve(dtWindow, "btnIcons")
  local btnSpells = dtResolve(dtWindow, "btnSpells")

  if btnGeneral then btnGeneral.onClick = function() dtShowPage("pageGeneral") end end
  if btnSpells then btnSpells.onClick = function() dtShowPage("pageSpells") end end
  if btnHotkeys then btnHotkeys.onClick = function() dtShowPage("pageHotkeys") end end
  if btnIcons then btnIcons.onClick = function() dtShowPage("pageHotkeys") end end

  -- Back buttons
  local backGeneral = dtResolve(dtWindow, "backGeneral")
  local backSpells = dtResolve(dtWindow, "backSpells")
  local backHotkeys = dtResolve(dtWindow, "backHotkeys")
  if backGeneral then backGeneral.onClick = function() dtShowPage("pageMenu") end end
  if backSpells then backSpells.onClick = function() dtShowPage("pageMenu") end end
  if backHotkeys then backHotkeys.onClick = function() dtShowPage("pageMenu") end end

  -- General bindings
  local enabledSwitch = dtResolve(dtWindow, "enabledSwitch")
  if enabledSwitch then
    enabledSwitch:setOn(isEnabled())
    enabledSwitch.onClick = function(widget)
      cfg.enabled = not isEnabled()
      widget:setOn(isEnabled())
      dtApplyEnabledState()
    end
  end

  local hideEffectsSwitch = dtResolve(dtWindow, "hideEffectsSwitch")
  if hideEffectsSwitch then
    hideEffectsSwitch:setOn(cfg.hideEffects == true)
    hideEffectsSwitch.onClick = function(widget)
      cfg.hideEffects = not (cfg.hideEffects == true)
      widget:setOn(cfg.hideEffects == true)
    end
  end

  local hideTextsSwitch = dtResolve(dtWindow, "hideTextsSwitch")
  if hideTextsSwitch then
    hideTextsSwitch:setOn(cfg.hideOrangeTexts == true)
    hideTextsSwitch.onClick = function(widget)
      cfg.hideOrangeTexts = not (cfg.hideOrangeTexts == true)
      widget:setOn(cfg.hideOrangeTexts == true)
    end
  end

  local stopKey = dtResolve(dtWindow, "stopKey")
  if stopKey then
    stopKey.onTextChange = function(_, text) cfg.stopKey = text end
  end

  local followLeader = dtResolve(dtWindow, "followLeader")
  if followLeader then
    followLeader.onTextChange = function(_, text) cfg.followLeader = text end
  end

  -- Spells bindings
  local ueSpell = dtResolve(dtWindow, "ueSpell")
  if ueSpell then
    ueSpell.onTextChange = function(_, text) cfg.ueSpell = text end
  end

  local ueRepeat = dtResolve(dtWindow, "ueRepeat")
  if ueRepeat then
    ueRepeat.onTextChange = function(widget, text)
      cfg.ueRepeat = tonumber(text) or 4
      safeSetText(widget, tostring(cfg.ueRepeat))
    end
  end

  local antiParalyzeSpell = dtResolve(dtWindow, "antiParalyzeSpell")
  if antiParalyzeSpell then
    antiParalyzeSpell.onTextChange = function(_, text) cfg.antiParalyzeSpell = text end
  end

  local hasteSpell = dtResolve(dtWindow, "hasteSpell")
  if hasteSpell then
    hasteSpell.onTextChange = function(_, text) cfg.hasteSpell = text end
  end

  local healSpell = dtResolve(dtWindow, "healSpell")
  if healSpell then
    healSpell.onTextChange = function(_, text) cfg.healSpell = text end
  end

  local healPercent = dtResolve(dtWindow, "healPercent")
  if healPercent then
    healPercent.onTextChange = function(widget, text)
      cfg.healPercent = tonumber(text) or 95
      safeSetText(widget, tostring(cfg.healPercent))
    end
  end

  -- Hotkey "Set" binding helper
  local function bindHotkeyRow(actionKey, keyId, setId)
    local keyWidget = dtResolve(dtWindow, keyId)
    local setButton = dtResolve(dtWindow, setId)
    if keyWidget then
      keyWidget.onTextChange = function(_, text) setHotkey(actionKey, text) end
    end
    if setButton then
      setButton.onClick = function()
        HK_WAITING_FOR = actionKey
        safeSetText(keyWidget, "Press...")
      end
    end
  end

  bindHotkeyRow("ueNonSafe", "ueNonSafeKey", "ueNonSafeSet")
  bindHotkeyRow("ueSafe", "ueSafeKey", "ueSafeSet")
  bindHotkeyRow("superSd", "superSdKey", "superSdSet")
  bindHotkeyRow("superSdFire", "superSdFireKey", "superSdFireSet")
  bindHotkeyRow("superSdHoly", "superSdHolyKey", "superSdHolySet")
  bindHotkeyRow("sioVip", "sioVipKey", "sioVipSet")

  dtShowPage("pageMenu")
  dtRefresh()
  return true
end

local function dtOpen()
  if not dtEnsureWindow() then
    schedule(200, function() dtOpen() end)
    return
  end
  dtRefresh()
  dtWindow:show()
  dtWindow:raise()
  dtWindow:focus()
end

-- Build the Main row UI now
mainUi = setupMainRow()
if mainUi and mainUi.title then
  mainUi.title:setOn(isEnabled())
  mainUi.title.onClick = function(widget)
    cfg.enabled = not isEnabled()
    widget:setOn(isEnabled())
    dtApplyEnabledState()
  end
end
if mainUi and mainUi.setup then
  mainUi.setup.onClick = function()
    dtOpen()
  end
end

--==============================================================
-- Features
--==============================================================

-- IDs / constants
local MW_RUNE_ID = 3180
local MW_BLOCK_TILE_ID = 2128
local MW_MARK_KEY = "."

local ENERGY_RING_ID = 3051
local DEFAULT_RING_ID = 3006
local RING_PUT_AT_HP = 85
local RING_REMOVE_AT_HP = 95

local MANA_POTION_ID = 238
local MANA_MIN_PERCENT = 90

local MACHETE_ID = 3308
local WILD_GROWTH_ID = 2130

local SD_RUNE_ID = 3155
local SD_FIRE_RUNE_ID = 12466
local SD_HOLY_RUNE_ID = 12468

local SPELLWAND_ID = 9396
local SPELLWAND_ITEMLIST = {
  3364, 3360, 3414, 3296, 3420, 823,
  3333, 3366, 3302, 3265, 3072, 3284,
  3392, 3428, 3386, 3320, 3281, 3370,
  3079, 3436, 3554, 7402
}

-- Hide effects
onAddThing(function(tile, thing)
  if not isEnabled() then return end
  if not cfg.hideEffects then return end
  if thing and thing.isEffect and thing:isEffect() then
    thing:hide()
  end
end)

-- Hide orange texts
onStaticText(function(_, text)
  if not isEnabled() then return end
  if not cfg.hideOrangeTexts then return end
  if text and not text:find("says:") then
    g_map.cleanTexts()
  end
end)

-- Stop cave/target hotkey
onKeyDown(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end
  if keys ~= (cfg.stopKey or "") then return end

  if not CaveBot or not TargetBot then return end
  if (CaveBot.isOn and CaveBot.isOn()) or (TargetBot.isOn and TargetBot.isOn()) then
    if CaveBot.setOff then CaveBot.setOff() end
    if TargetBot.setOff then TargetBot.setOff() end
  else
    if CaveBot.setOn then CaveBot.setOn() end
    if TargetBot.setOn then TargetBot.setOn() end
  end
end)

-- Anti Paralyze
macro(100, function()
  if not isEnabled() then return end
  if isParalyzed() and (cfg.antiParalyzeSpell or ""):len() > 0 then
    saySpell(cfg.antiParalyzeSpell)
  end
end)

-- Auto Haste
macro(500, function()
  if not isEnabled() then return end
  if not hasHaste() and (cfg.hasteSpell or ""):len() > 0 then
    if saySpell(cfg.hasteSpell) then delay(5000) end
  end
end)

-- Auto Heal
macro(50, function()
  if not isEnabled() then return end
  local hpTrigger = tonumber(cfg.healPercent) or 95
  if hppercent() <= hpTrigger and (cfg.healSpell or ""):len() > 0 then
    say(cfg.healSpell)
  end
end)

-- Ring swap
macro(100, function()
  if not isEnabled() then return end
  if hppercent() <= RING_PUT_AT_HP then
    local ring = findItem(ENERGY_RING_ID)
    if ring then g_game.move(ring, { x = 65535, y = SlotFinger, z = 0 }, 1) end
  elseif hppercent() >= RING_REMOVE_AT_HP then
    local ring = findItem(DEFAULT_RING_ID)
    if ring then g_game.move(ring, { x = 65535, y = SlotFinger, z = 0 }, 1) end
  end
end)

-- Magic wall marker (same logic; gated)
local marked_tiles = {}
local function tablefind(tab, el)
  for index, value in ipairs(tab) do
    if value == el then return index end
  end
  return nil
end

local holdMWMacro = macro(20, function()
  if not isEnabled() then return end
  if #marked_tiles == 0 then return end

  for _, tile in pairs(marked_tiles) do
    if not tile then return end

    if getDistanceBetween(pos(), tile:getPosition()) > 7 then
      table.remove(marked_tiles, tablefind(marked_tiles, tile))
      tile:setText("")
      return
    end

    if tile:getPosition().z ~= posz() then
      table.remove(marked_tiles, tablefind(marked_tiles, tile))
      tile:setText("")
      return
    end

    if tile:canShoot()
      and not isInPz()
      and tile:isWalkable()
      and tile:getText() == "MW"
      and (tile:getTopThing():getId() ~= MW_BLOCK_TILE_ID)
    then
      useWith(MW_RUNE_ID, tile:getTopUseThing())
      return
    end
  end
end)

local resetTimer = 0
local resetTiles = false

onKeyDown(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end
  if keys == MW_MARK_KEY and resetTimer == 0 then resetTimer = now end
end)

onKeyPress(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end

  if keys == MW_MARK_KEY and (now - resetTimer) > 2500 then
    for _, tile in pairs(marked_tiles) do if tile then tile:setText("") end end
    marked_tiles = {}
    resetTiles = true
    resetTimer = 0
  else
    resetTimer = 0
    resetTiles = false
  end
end)

onKeyUp(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end
  if keys ~= MW_MARK_KEY or resetTiles then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  if tile:getText() == "MW" then
    tile:setText("")
    table.remove(marked_tiles, tablefind(marked_tiles, tile))
  else
    tile:setText("MW")
    table.insert(marked_tiles, tile)
  end
end)

-- Faster mana potting
macro(200, function()
  if not isEnabled() then return end
  if manapercent() <= MANA_MIN_PERCENT then
    useWith(MANA_POTION_ID, player)
  end
end)

-- Auto cut Wild Growth
local function getNearTiles(p)
  if type(p) ~= "table" then p = p:getPosition() end
  local tiles = {}
  local dirs = {
    { -1, 1 }, { 0, 1 }, { 1, 1 },
    { -1, 0 },          { 1, 0 },
    { -1, -1 }, { 0, -1 }, { 1, -1 }
  }
  for i = 1, #dirs do
    local tile = g_map.getTile({ x = p.x - dirs[i][1], y = p.y - dirs[i][2], z = p.z })
    if tile then table.insert(tiles, tile) end
  end
  return tiles
end

macro(500, function()
  if not isEnabled() then return end
  local tiles = getNearTiles(pos())
  for _, tile in pairs(tiles) do
    for _, thing in ipairs(tile:getThings()) do
      if thing:getId() == WILD_GROWTH_ID then
        useWith(MACHETE_ID, thing)
        return
      end
    end
  end
end)

-- Open next BP
macro(1000, function()
  if not isEnabled() then return end
  local containers = getContainers()
  for _, container in pairs(containers) do
    if container:getItemsCount() == container:getCapacity() then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() then
          g_game.open(item, container)
          return
        end
      end
    end
  end
end)

-- Stamina item
macro(180000, function()
  if not isEnabled() then return end
  use(11372)
end)

--==============================================================
-- UE + SD + Sio VIP (Icons + Hotkeys)
--==============================================================

ueNonSafe = macro(200, function()
  if not isEnabled() then return end
  if not g_game.isAttacking() then return end
  local rep = tonumber(cfg.ueRepeat) or 4
  local spell = cfg.ueSpell or ""
  if spell:len() == 0 then return end
  for i = 1, rep do say(spell) end
end)
ueNonSafe.setOn(false)

ueSafe = macro(400, function()
  if not isEnabled() then return end
  if not g_game.isAttacking() then return end

  local monsters = 0
  for _, spec in ipairs(getSpectators()) do
    if spec:isMonster() then
      monsters = monsters + 1
    elseif spec:isPlayer() and not spec:isLocalPlayer() then
      return
    end
  end

  local minM = tonumber(cfg.ueMinMonstersSafe) or 4
  if monsters < minM then return end

  local rep = tonumber(cfg.ueRepeat) or 4
  local spell = cfg.ueSpell or ""
  if spell:len() == 0 then return end
  for i = 1, rep do say(spell) end
end)
ueSafe.setOn(false)

superSd = macro(100, function()
  if not isEnabled() then return end
  if not g_game.isAttacking() then return end
  local target = g_game.getAttackingCreature()
  if not target then return end
  useWith(SD_RUNE_ID, target)
  delay(10)
end)
superSd.setOn(false)

superSdFire = macro(150, function()
  if not isEnabled() then return end
  if not g_game.isAttacking() then return end
  local target = g_game.getAttackingCreature()
  if not target then return end
  useWith(SD_FIRE_RUNE_ID, target)
  delay(10)
end)
superSdFire.setOn(false)

superSdHoly = macro(150, function()
  if not isEnabled() then return end
  if not g_game.isAttacking() then return end
  local target = g_game.getAttackingCreature()
  if not target then return end
  useWith(SD_HOLY_RUNE_ID, target)
  delay(10)
end)
superSdHoly.setOn(false)

local sioCfg = {
  hppercent = 70,
  spell = 'exura sio "',
  delay = 1000
}

sioVipMacro = macro(50, function()
  if not isEnabled() then return end
  if not g_game.getVips then return end
  for _, data in pairs(g_game.getVips()) do
    local friendName = data[1]
    local friend = getCreatureByName(friendName)
    if friend then
      local fPos = friend:getPosition()
      local fTile = g_map.getTile(fPos)
      local isReachable = fTile and fTile:canShoot()
      local needHeal = friend:getHealthPercent() <= sioCfg.hppercent
      if isReachable and needHeal then
        delay(sioCfg.delay)
        say(sioCfg.spell .. friendName)
        break
      end
    end
  end
end)
sioVipMacro.setOn(false)

-- Icons (required)
addIcon("dt_UE_NonSafe_Icon", { item = 3161, text = "UE\nNS" }, function(_, isOn)
  if not isEnabled() then ueNonSafe.setOn(false) return end
  ueNonSafe.setOn(isOn)
end)

addIcon("dt_UE_Safe_Icon", { item = 3161, text = "UE\nSAFE" }, function(_, isOn)
  if not isEnabled() then ueSafe.setOn(false) return end
  ueSafe.setOn(isOn)
end)

addIcon("dt_SuperSD_Icon", { item = SD_RUNE_ID, text = "SD" }, function(_, isOn)
  if not isEnabled() then superSd.setOn(false) return end
  superSd.setOn(isOn)
end)

addIcon("dt_SuperSDFire_Icon", { item = SD_FIRE_RUNE_ID, text = "F-SD" }, function(_, isOn)
  if not isEnabled() then superSdFire.setOn(false) return end
  superSdFire.setOn(isOn)
end)

addIcon("dt_SuperSDHoly_Icon", { item = SD_HOLY_RUNE_ID, text = "H-SD" }, function(_, isOn)
  if not isEnabled() then superSdHoly.setOn(false) return end
  superSdHoly.setOn(isOn)
end)

addIcon("dt_SioVIP_Icon", { item = 3160, text = "SIO" }, function(_, isOn)
  if not isEnabled() then sioVipMacro.setOn(false) return end
  sioVipMacro.setOn(isOn)
end)

-- Hotkey capture + toggles (chat-safe)
onKeyDown(function(keys)
  if chatTyping() then return end

  if HK_WAITING_FOR then
    setHotkey(HK_WAITING_FOR, keys)
    HK_WAITING_FOR = nil
    dtRefresh()
    return
  end

  if not isEnabled() then return end

  if keys == getHotkey("ueNonSafe") then toggleMacro(ueNonSafe) return end
  if keys == getHotkey("ueSafe") then toggleMacro(ueSafe) return end
  if keys == getHotkey("superSd") then toggleMacro(superSd) return end
  if keys == getHotkey("superSdFire") then toggleMacro(superSdFire) return end
  if keys == getHotkey("superSdHoly") then toggleMacro(superSdHoly) return end
  if keys == getHotkey("sioVip") then toggleMacro(sioVipMacro) return end
end)

-- Follow (kept)
local leaderPositions = {}
local leaderDirections = {}
local leader = nil
local lastLeaderFloor = nil
local standTime = now

local ROPE_ID = 3003

local FloorChangers = {
  RopeSpots = { Up = { 386 }, Down = {} },
  Use = {
    Up = { 1948, 5542, 16693, 16692, 1723, 7771, 5102, 5111, 5120, 9556, 8259, 5131, 8261, 5122 },
    Down = { 435 }
  }
}

local function distance(pos1, pos2)
  pos2 = pos2 or player:getPosition()
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function handleUse(pos)
  local lastZ = posz()
  if posz() ~= lastZ then return end
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then g_game.use(tile:getTopUseThing()) end
end

local function handleRope(pos)
  local lastZ = posz()
  if posz() ~= lastZ then return end
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then useWith(ROPE_ID, tile:getTopUseThing()) end
end

local floorChangeSelector = {
  RopeSpots = { Up = handleRope, Down = handleRope },
  Use = { Up = handleUse, Down = handleUse }
}

local function executeClosest(possibilities)
  local closest, closestDistance = nil, 999
  for _, data in ipairs(possibilities) do
    local dist = distance(data.pos)
    if dist < closestDistance then
      closest = data
      closestDistance = dist
    end
  end
  if closest then closest.changer(closest.pos) return true end
  return false
end

local function handleFloorChange()
  local range = 1
  local p = player:getPosition()
  local possibleChangers = {}

  for _, dir in ipairs({ "Down", "Up" }) do
    for changer, data in pairs(FloorChangers) do
      for x = -range, range do
        for y = -range, range do
          local tile = g_map.getTile({ x = p.x + x, y = p.y + y, z = p.z })
          if tile and tile:getTopUseThing() then
            if table.find and table.find(data[dir], tile:getTopUseThing():getId()) then
              table.insert(possibleChangers, {
                changer = floorChangeSelector[changer][dir],
                pos = { x = p.x + x, y = p.y + y, z = p.z }
              })
            end
          end
        end
      end
    end
  end

  if #possibleChangers > 0 then return executeClosest(possibleChangers) end
  return false
end

local function levitate(dir)
  turn(dir)
  schedule(200, function()
    say('exani hur "down')
    say('exani hur "up')
  end)
end

local function getStandTime() return now - standTime end

local ultimateFollow = macro(50, function()
  if not isEnabled() then return end
  if not cfg.followLeader or cfg.followLeader:len() == 0 then return end

  if not leader then
    local leaderPos = leaderPositions[posz()]
    if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
      autoWalk(leaderPos, 70, { ignoreNonPathable = true, precision = 0 })
      delay(280)
      return
    end

    if handleFloorChange() then return end
    local dir = leaderDirections[posz()]
    if dir then levitate(dir) end
    return
  end

  local lpos = leader:getPosition()
  local parameters = { ignoreNonPathable = true, precision = 1, ignoreCreatures = true }
  local path = findPath(player:getPosition(), lpos, 40, parameters)
  local dist = getDistanceBetween(player:getPosition(), lpos)

  if dist > 1 and not path then handleFloorChange() return end

  if dist > 2 then
    if getStandTime() > 500 then
      autoWalk(lpos, 40, parameters)
      delay(280)
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not isEnabled() then return end
  if ultimateFollow.isOff() then return end

  if creature:getName() == player:getName() then
    standTime = now
    return
  end

  if not cfg.followLeader or creature:getName():lower() ~= cfg.followLeader:lower() then return end

  if newPos then
    leaderPositions[newPos.z] = newPos
    lastLeaderFloor = newPos.z
    if newPos.z == posz() then leader = creature else leader = nil end
  else
    leader = nil
  end

  if oldPos then
    if newPos and oldPos.z ~= newPos.z then
      leaderDirections[oldPos.z] = creature:getDirection()
    end

    local oldTile = g_map.getTile(oldPos)
    local walkPrecision = 1
    if oldTile and not oldTile:hasCreature() then walkPrecision = 0 end

    autoWalk(oldPos, 40, { ignoreNonPathable = 1, precision = walkPrecision })
  end
end)

onCreatureAppear(function(creature)
  if not isEnabled() then return end
  if ultimateFollow.isOff() then return end
  if creature:getPosition().z ~= posz() then return end

  if cfg.followLeader and creature:getName():lower() == cfg.followLeader:lower() then
    leader = creature
  elseif creature:getName() == player:getName() then
    if lastLeaderFloor and lastLeaderFloor == posz() then
      leader = getCreatureByName(cfg.followLeader)
    end
  end
end)

onCreatureDisappear(function(creature)
  if not isEnabled() then return end
  if ultimateFollow.isOff() then return end
  if creature:getPosition().z == posz() then return end

  if cfg.followLeader and creature:getName():lower() == cfg.followLeader:lower() then
    leader = nil
  elseif creature:getName() == player:getName() and posz() ~= lastLeaderFloor then
    leader = nil
  end
end)

-- Spellwand
macro(1000, function()
  if not isEnabled() then return end
  for _, container in pairs(g_game.getContainers()) do
    for _, item in ipairs(container:getItems()) do
      if table.contains(SPELLWAND_ITEMLIST, item:getId()) then
        useWith(SPELLWAND_ID, item)
        return
      end
    end
  end
end)

log("Loaded.")
