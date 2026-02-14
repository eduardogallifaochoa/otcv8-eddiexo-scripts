--==============================================================
-- DRUID TOOLKIT (OTClient / OTCv8 macros)
-- Loaded via: bot_loaders/druid_toolkit_loader.lua
-- UI goal: PvP Scripts style (Main toggle + Setup button) with custom background.png.
--==============================================================

local TAG = "[DruidToolkit] "
local function log(msg) print(TAG .. tostring(msg)) end

-- Must exist before any config migration uses it.
local function _trim(s)
  if type(s) ~= "string" then return "" end
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end


storage.druidToolkit = storage.druidToolkit or {}
local cfg = storage.druidToolkit

-- Master enable (Main green/red button)
if cfg.enabled == nil then cfg.enabled = true end

-- Visual toggles
if cfg.hideEffects == nil then cfg.hideEffects = true end
if cfg.hideOrangeTexts == nil then cfg.hideOrangeTexts = true end

-- Defaults / editable settings
-- Stop keys (separate, as requested). Migrate from legacy cfg.stopKey if present.
cfg.stopCaveKey = cfg.stopCaveKey or cfg.stopKey or "Pause"
cfg.stopTargetKey = cfg.stopTargetKey or cfg.stopKey or ""
cfg.stopKey = nil
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
  caveToggle = "",
  targetToggle = "",
  toolkitToggle = "F12",
  followToggle = (cfg.hk and cfg.hk.follow) or "F7",
  mwScroll = "",
}
-- Migrate legacy follow key
if cfg.hk.follow and (not cfg.hk.followToggle or _trim(cfg.hk.followToggle) == "") then
  cfg.hk.followToggle = cfg.hk.follow
end
cfg.hk.follow = nil

-- Migrate legacy stop keys (from General page text edits) into hotkey list if empty.
if (not cfg.hk.caveToggle or _trim(cfg.hk.caveToggle) == "") and _trim(cfg.stopCaveKey or ""):len() > 0 then
  cfg.hk.caveToggle = cfg.stopCaveKey
end
if (not cfg.hk.targetToggle or _trim(cfg.hk.targetToggle) == "") and _trim(cfg.stopTargetKey or ""):len() > 0 then
  cfg.hk.targetToggle = cfg.stopTargetKey
end

-- Module toggles (persisted)
cfg.mods = cfg.mods or {}
local function modDefault(k, v)
  if cfg.mods[k] == nil then cfg.mods[k] = v end
end
modDefault("antiParalyze", true)
modDefault("autoHaste", true)
modDefault("autoHeal", true)
modDefault("ringSwap", true)
modDefault("magicWall", true)
modDefault("mwScroll", true)
modDefault("manaPot", true)
modDefault("cutWg", true)
modDefault("stamina", true)
modDefault("spellwand", false) -- safer default: OFF
cfg.mwScrollDelayMs = tonumber(cfg.mwScrollDelayMs) or 250
cfg.mwScrollMagicWallId = tonumber(cfg.mwScrollMagicWallId) or 2128
cfg.mwScrollWildGrowthId = tonumber(cfg.mwScrollWildGrowthId) or 2130
cfg.mwScrollCustomId = tonumber(cfg.mwScrollCustomId) or cfg.mwScrollMagicWallId
cfg.mwScrollBlockMode = cfg.mwScrollBlockMode or "magicwall"

-- Editable UI labels + icon config overrides
cfg.actionNames = cfg.actionNames or {}
cfg.iconItemId = cfg.iconItemId or {}
cfg.iconText = cfg.iconText or {}

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
  if not widget or not widget.setText then return end
  text = tostring(text or "")
  if widget.getText then
    local ok, cur = pcall(widget.getText, widget)
    if ok and cur == text then return end
  end
  widget:setText(text)
end

local function safeSetOn(widget, v)
  if widget and widget.setOn then widget:setOn(v) end
end

local function safeSetButtonActive(widget, isActive)
  if not widget then return end
  if widget.setBackgroundColor then
    pcall(widget.setBackgroundColor, widget, isActive and "#0a7f0a" or "#ffffff12")
  end
  if widget.setColor then
    pcall(widget.setColor, widget, isActive and "#ffffff" or "#e6e6e6")
  end
end

local function toggleMacro(m)
  if not m or not m.isOn or not m.setOn then return end
  m.setOn(not m.isOn())
end


local function _hkEq(a, b)
  return _trim(a):lower() == _trim(b):lower()
end

local function parseHotkeyList(v)
  local out = {}
  if type(v) == "table" then
    for _, x in ipairs(v) do
      local t = _trim(x)
      if t:len() > 0 then table.insert(out, t) end
    end
    return out
  end
  if type(v) ~= "string" then return out end

  -- Accept: "F1", "F1 | Shift+Q", "F1;Shift+Q", "F1\nShift+Q"
  for token in v:gmatch("[^,;|%c]+") do
    token = _trim(token)
    if token:len() > 0 then
      local exists = false
      for _, k in ipairs(out) do
        if _hkEq(k, token) then exists = true break end
      end
      if not exists then table.insert(out, token) end
    end
  end
  return out
end

local function serializeHotkeyList(list, sep)
  sep = sep or ";"
  if type(list) ~= "table" then return "" end
  local out = {}
  for _, x in ipairs(list) do
    local t = _trim(x)
    if t:len() > 0 then table.insert(out, t) end
  end
  return table.concat(out, sep)
end

local function getHotkeyList(action)
  return parseHotkeyList((cfg.hk and cfg.hk[action]) or "")
end

local function getHotkeyDisplay(action)
  return table.concat(getHotkeyList(action), " | ")
end

local function setHotkeySet(action, key)
  if not action or type(action) ~= "string" then return end
  key = _trim(key)
  if key:len() == 0 then return end
  cfg.hk[action] = serializeHotkeyList({ key }, ";")
end

local function addHotkey(action, key)
  if not action or type(action) ~= "string" then return end
  key = _trim(key)
  if key:len() == 0 then return end
  local list = getHotkeyList(action)
  for _, k in ipairs(list) do
    if _hkEq(k, key) then
      cfg.hk[action] = serializeHotkeyList(list, ";")
      return
    end
  end
  table.insert(list, key)
  cfg.hk[action] = serializeHotkeyList(list, ";")
end

local function clearHotkeys(action)
  if not action or type(action) ~= "string" then return end
  cfg.hk[action] = ""
end

local function hotkeyMatches(action, keys)
  keys = _trim(keys)
  if keys:len() == 0 then return false end
  for _, k in ipairs(getHotkeyList(action)) do
    if _hkEq(k, keys) then return true end
  end
  return false
end

local function isEnabled()
  return cfg.enabled == true
end

-- Forward declarations for icon-driven macros (used by master enable/disable).
local ueNonSafe, ueSafe, superSd, superSdFire, superSdHoly, sioVipMacro

-- Action registry (single source of truth for icon <-> macro wiring)
local DT_ACTIONS = {}

local function dtRegisterAction(key, def)
  if type(key) ~= "string" or key:len() == 0 then return end
  if type(def) ~= "table" then def = {} end
  def.key = key

  def.defaultLabel = _trim(def.defaultLabel or def.label or key)
  local customLabel = _trim((cfg.actionNames and cfg.actionNames[key]) or "")
  def.label = (customLabel:len() > 0) and customLabel or def.defaultLabel

  if def.icon then
    if (not def.iconDefaultItem) and def.icon.item and def.icon.item.getItemId then
      local okId, itemId = pcall(def.icon.item.getItemId, def.icon.item)
      if okId then def.iconDefaultItem = tonumber(itemId) or def.iconDefaultItem end
    end
    if (not def.iconDefaultText) and def.icon.text and def.icon.text.getText then
      local okTxt, txt = pcall(def.icon.text.getText, def.icon.text)
      if okTxt and type(txt) == "string" and txt:len() > 0 then
        def.iconDefaultText = txt
      end
    end
  end

  DT_ACTIONS[key] = def
end

local function dtGetAction(key)
  return DT_ACTIONS[key]
end

local function dtGetActionDisplayName(key, fallback)
  local name = _trim((cfg.actionNames and cfg.actionNames[key]) or "")
  if name:len() > 0 then return name end
  local a = DT_ACTIONS[key]
  if a and _trim(a.defaultLabel):len() > 0 then return a.defaultLabel end
  return fallback or key
end

local function dtSetActionDisplayName(key, value)
  if type(key) ~= "string" or key:len() == 0 then return end
  cfg.actionNames = cfg.actionNames or {}
  local name = _trim(value)
  if name:len() == 0 then
    cfg.actionNames[key] = nil
  else
    cfg.actionNames[key] = name
  end
  local a = DT_ACTIONS[key]
  if a then
    a.label = dtGetActionDisplayName(key, a.defaultLabel or key)
  end
end

local function dtApplyActionIconConfig(key)
  local a = dtGetAction(key)
  if not a or not a.icon then return end

  local wantedItem = tonumber((cfg.iconItemId and cfg.iconItemId[key]) or a.iconDefaultItem)
  local wantedText = _trim((cfg.iconText and cfg.iconText[key]) or (a.iconDefaultText or ""))

  if wantedItem and wantedItem > 0 then
    if a.icon.item and a.icon.item.setItemId then
      pcall(a.icon.item.setItemId, a.icon.item, wantedItem)
    elseif a.icon.setItem then
      pcall(a.icon.setItem, a.icon, wantedItem)
    end
  end

  if wantedText:len() > 0 then
    if a.icon.text and a.icon.text.setText then
      pcall(a.icon.text.setText, a.icon.text, wantedText)
    elseif a.icon.setText then
      pcall(a.icon.setText, a.icon, wantedText)
    end
  end
end

local function dtMacroIsOn(m)
  if not m or not m.isOn then return false end
  local ok, v = pcall(m.isOn)
  return ok and v == true
end

local function dtIsActionDisabled(key)
  return cfg.actionDisabled and cfg.actionDisabled[key] == true
end

local function dtApplyActionDisabledVisual(key)
  local a = dtGetAction(key)
  if not a or not a.icon then return end
  local disabled = dtIsActionDisabled(key)

  -- Hide from the GUI when disabled (your request).
  if a.icon.setVisible then
    pcall(a.icon.setVisible, a.icon, not disabled)
  elseif disabled and a.icon.hide then
    pcall(a.icon.hide, a.icon)
  elseif (not disabled) and a.icon.show then
    pcall(a.icon.show, a.icon)
  end

  -- Disabled means always OFF.
  if disabled then
    if a.macro and a.macro.setOn then pcall(a.macro.setOn, false) end
    if a.icon and a.icon.setOn then
      -- Suppress addIcon callback recursion.
      a.icon._dtSuppress = true
      pcall(a.icon.setOn, a.icon, false)
      schedule(0, function()
        if a.icon then a.icon._dtSuppress = nil end
      end)
    end
  end
end

local function dtGetMwScrollMode()
  local mode = _trim(cfg.mwScrollBlockMode or "magicwall"):lower()
  mode = mode:gsub("%s+", "")
  if mode == "mw" or mode == "magicwall" then return "magicwall" end
  if mode == "wg" or mode == "wildgrowth" then return "wildgrowth" end
  if mode == "custom" then return "custom" end
  return "magicwall"
end

local function dtGetMwScrollBlockId()
  local mode = dtGetMwScrollMode()
  if mode == "wildgrowth" then
    return tonumber(cfg.mwScrollWildGrowthId) or 2130
  end
  if mode == "custom" then
    local customId = tonumber(cfg.mwScrollCustomId)
    if customId and customId > 0 then return math.floor(customId) end
    return tonumber(cfg.mwScrollMagicWallId) or 2128
  end
  return tonumber(cfg.mwScrollMagicWallId) or 2128
end

local function dtSetMwScrollMode(mode)
  local m = _trim(mode):lower():gsub("%s+", "")
  if m == "mw" or m == "magicwall" then
    cfg.mwScrollBlockMode = "magicwall"
  elseif m == "wg" or m == "wildgrowth" then
    cfg.mwScrollBlockMode = "wildgrowth"
  else
    cfg.mwScrollBlockMode = "custom"
  end
end

local function dtApplyMwScrollModeButtons()
  if not dtWindow then return end
  local mode = dtGetMwScrollMode()
  safeSetButtonActive(dtResolve(dtWindow, "mwScrollModeMW"), mode == "magicwall")
  safeSetButtonActive(dtResolve(dtWindow, "mwScrollModeWG"), mode == "wildgrowth")
  safeSetButtonActive(dtResolve(dtWindow, "mwScrollModeCustom"), mode == "custom")
end

local function dtRefreshMwScrollModeUi()
  if not dtWindow then return end
  safeSetText(dtResolve(dtWindow, "mwScrollCustomId"), tostring(tonumber(cfg.mwScrollCustomId) or (tonumber(cfg.mwScrollMagicWallId) or 2128)))
  dtApplyMwScrollModeButtons()
end

local function dtSetMwScrollCustomId(text)
  local n = tonumber(text)
  if n and n > 0 then
    cfg.mwScrollCustomId = math.floor(n)
  end
end

local function dtSetActionOn(key, on, source)
  local a = dtGetAction(key)
  if not a then return end
  on = on == true

  if dtIsActionDisabled(key) then
    on = false
  end

  if a.macro and a.macro.setOn then
    pcall(a.macro.setOn, on)
  end

  if a.persist then
    cfg.mods = cfg.mods or {}
    cfg.mods[key] = on
  end

  -- Keep icon state consistent (but avoid recursion with addIcon callback).
  if a.icon and a.icon.setOn and source ~= "icon" then
    a.icon._dtSuppress = true
    pcall(a.icon.setOn, a.icon, on)
    schedule(0, function()
      if a.icon then a.icon._dtSuppress = nil end
    end)
  end
end

local function dtToggleAction(key)
  local a = dtGetAction(key)
  if not a then return end
  if dtIsActionDisabled(key) then return end
  if a.icon and a.icon.onClick then
    -- Keep icon + macro behavior consistent with a real click.
    pcall(function() a.icon:onClick() end)
    return
  end
  local newOn = not dtMacroIsOn(a.macro)
  dtSetActionOn(key, newOn, "hotkey")
end

local function dtEnsureHotkeyBadge(actionKey)
  local a = dtGetAction(actionKey)
  if not a or not a.icon then return end
  if a._dtHotkeyBadge then return end
  if not UI or not UI.createWidget then return end

  -- Create as a child of the icon so it moves with drag/drop.
  local ok, badge = pcall(UI.createWidget, "DtHotkeyBadge", a.icon)
  if not ok or not badge then return end
  a._dtHotkeyBadge = badge
  a._badge = badge

  if badge.setId then pcall(badge.setId, badge, "dt_hkbadge_" .. tostring(actionKey)) end

  -- Don't block clicks on the icon (badge is purely decorative).
  if badge.setPhantom then pcall(badge.setPhantom, badge, true) end
  if badge.setFocusable then pcall(badge.setFocusable, badge, false) end
  if badge.setWidth then pcall(badge.setWidth, badge, 22) end
  if badge.setHeight then pcall(badge.setHeight, badge, 12) end
end

local function dtUpdateHotkeyBadge(actionKey)
  local a = dtGetAction(actionKey)
  if not a or not a.icon then return end
  dtEnsureHotkeyBadge(actionKey)
  local badge = a._dtHotkeyBadge or a._badge
  if not badge or not badge.setText then return end
  local text = getHotkeyDisplay(actionKey)
  text = _trim(text)
  if text:len() == 0 then
    if badge.hide then pcall(badge.hide, badge) end
    return
  end
  -- Keep it compact: show only the first binding.
  local first = parseHotkeyList(text)[1] or text
  first = _trim(first)
  -- Cosmetic compacting for modifiers.
  first = first:gsub("Shift%+", "S+"):gsub("Ctrl%+", "C+"):gsub("Alt%+", "A+")
  safeSetText(badge, first)
  if badge.setWidth then
    local w = 14 + (#first * 7)
    if w < 18 then w = 18 end
    if w > 40 then w = 40 end
    pcall(badge.setWidth, badge, w)
  end
  if badge.show then pcall(badge.show, badge) end
  if badge.raise then pcall(badge.raise, badge) end
end

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

  -- Some OTC builds do not expose children as direct fields; resolve explicitly.
  local function _mainResolve(root, id)
    if not root then return nil end
    return root[id]
      or (root.recursiveGetChildById and root:recursiveGetChildById(id))
      or (root.getChildById and root:getChildById(id))
  end
  ui.title = _mainResolve(ui, "title") or ui.title
  ui.setup = _mainResolve(ui, "setup") or ui.setup
  return ui
end

--==============================================================
-- Setup Window (custom background.png)
--==============================================================

local dtWindow = nil
-- Hotkey capture state: { action = "ueNonSafe" }
local HK_CAPTURE = nil
-- Forward declaration (used by icon context menu)
local dtOpen = nil
local dtRefreshing = false

local function dtResolve(win, id)
  if not win then return nil end
  return win[id]
    or (win.recursiveGetChildById and win:recursiveGetChildById(id))
    or (win.getChildById and win:getChildById(id))
end

local function dtShowPage(pageId)
  if not dtWindow then return end
  local pages = { "pageMenu", "pageGeneral", "pageSpells", "pageModules", "pageHotkeys", "pageScripts", "pageAbout" }
  for _, id in ipairs(pages) do
    local p = dtResolve(dtWindow, id)
    if p and p.hide then p:hide() end
  end
  local page = dtResolve(dtWindow, pageId)
  if page and page.show then page:show() end

  -- Nav active state (cheap "segmented control" highlight)
  local navMap = {
    pageMenu = "navMenu",
    pageGeneral = "navGeneral",
    pageSpells = "navSpells",
    pageModules = "navModules",
    pageHotkeys = "navHotkeys",
    pageScripts = "navScripts",
    pageAbout = "navAbout",
  }
  for pid, navId in pairs(navMap) do
    local b = dtResolve(dtWindow, navId)
    if b and b.setBackgroundColor then
      local active = (pid == pageId)
      pcall(b.setBackgroundColor, b, active and "#ffffff26" or "#ffffff12")
      if b.setColor then pcall(b.setColor, b, active and "#ffffff" or "#e6e6e6") end
    end
  end
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
  dtRefreshing = true

  safeSetOn(dtResolve(dtWindow, "enabledSwitch"), isEnabled())
  safeSetOn(dtResolve(dtWindow, "hideEffectsSwitch"), cfg.hideEffects == true)
  safeSetOn(dtResolve(dtWindow, "hideTextsSwitch"), cfg.hideOrangeTexts == true)

  safeSetText(dtResolve(dtWindow, "stopCaveKey"), getHotkeyDisplay("caveToggle"))
  safeSetText(dtResolve(dtWindow, "stopTargetKey"), getHotkeyDisplay("targetToggle"))
  safeSetText(dtResolve(dtWindow, "toolkitToggleKey"), getHotkeyDisplay("toolkitToggle"))
  safeSetText(dtResolve(dtWindow, "followToggleGeneralKey"), getHotkeyDisplay("followToggle"))
  safeSetText(dtResolve(dtWindow, "followLeader"), cfg.followLeader or "")

  safeSetText(dtResolve(dtWindow, "ueSpell"), cfg.ueSpell or "")
  safeSetText(dtResolve(dtWindow, "ueRepeat"), tostring(cfg.ueRepeat or 4))
  safeSetText(dtResolve(dtWindow, "antiParalyzeSpell"), cfg.antiParalyzeSpell or "")
  safeSetText(dtResolve(dtWindow, "hasteSpell"), cfg.hasteSpell or "")
  safeSetText(dtResolve(dtWindow, "healSpell"), cfg.healSpell or "")
  safeSetText(dtResolve(dtWindow, "healPercent"), tostring(cfg.healPercent or 95))

  safeSetText(dtResolve(dtWindow, "ueNonSafeKey"), getHotkeyDisplay("ueNonSafe"))
  safeSetText(dtResolve(dtWindow, "ueSafeKey"), getHotkeyDisplay("ueSafe"))
  safeSetText(dtResolve(dtWindow, "superSdKey"), getHotkeyDisplay("superSd"))
  safeSetText(dtResolve(dtWindow, "superSdFireKey"), getHotkeyDisplay("superSdFire"))
  safeSetText(dtResolve(dtWindow, "superSdHolyKey"), getHotkeyDisplay("superSdHoly"))
  safeSetText(dtResolve(dtWindow, "sioVipKey"), getHotkeyDisplay("sioVip"))
  safeSetText(dtResolve(dtWindow, "caveToggleKey"), getHotkeyDisplay("caveToggle"))
  safeSetText(dtResolve(dtWindow, "targetToggleKey"), getHotkeyDisplay("targetToggle"))
  safeSetText(dtResolve(dtWindow, "followToggleKey"), getHotkeyDisplay("followToggle"))
  safeSetText(dtResolve(dtWindow, "caveToggleLabel"), dtGetActionDisplayName("caveToggle", "CaveBot (Toggle)"))
  safeSetText(dtResolve(dtWindow, "targetToggleLabel"), dtGetActionDisplayName("targetToggle", "TargetBot (Toggle)"))
  safeSetText(dtResolve(dtWindow, "ueNonSafeLabel"), dtGetActionDisplayName("ueNonSafe", "UE (NON-SAFE)"))
  safeSetText(dtResolve(dtWindow, "ueSafeLabel"), dtGetActionDisplayName("ueSafe", "UE (SAFE)"))
  safeSetText(dtResolve(dtWindow, "superSdLabel"), dtGetActionDisplayName("superSd", "Super SD"))
  safeSetText(dtResolve(dtWindow, "superSdFireLabel"), dtGetActionDisplayName("superSdFire", "Super SD Fire"))
  safeSetText(dtResolve(dtWindow, "superSdHolyLabel"), dtGetActionDisplayName("superSdHoly", "Super Holy SD"))
  safeSetText(dtResolve(dtWindow, "sioVipLabel"), dtGetActionDisplayName("sioVip", "Sio VIP"))
  safeSetText(dtResolve(dtWindow, "followToggleLabel"), dtGetActionDisplayName("followToggle", "Follow (Toggle)"))
  dtRefreshMwScrollModeUi()

  -- Modules switches + hotkeys (persisted)
  safeSetOn(dtResolve(dtWindow, "modAntiParalyzeSwitch"), cfg.mods and cfg.mods.antiParalyze == true)
  safeSetOn(dtResolve(dtWindow, "modAutoHasteSwitch"), cfg.mods and cfg.mods.autoHaste == true)
  safeSetOn(dtResolve(dtWindow, "modAutoHealSwitch"), cfg.mods and cfg.mods.autoHeal == true)
  safeSetOn(dtResolve(dtWindow, "modRingSwapSwitch"), cfg.mods and cfg.mods.ringSwap == true)
  safeSetOn(dtResolve(dtWindow, "modMagicWallSwitch"), cfg.mods and cfg.mods.magicWall == true)
  safeSetOn(dtResolve(dtWindow, "mwScrollSpellSwitch"), cfg.mods and cfg.mods.mwScroll == true)
  safeSetOn(dtResolve(dtWindow, "modManaPotSwitch"), cfg.mods and cfg.mods.manaPot == true)
  safeSetOn(dtResolve(dtWindow, "modCutWgSwitch"), cfg.mods and cfg.mods.cutWg == true)
  safeSetOn(dtResolve(dtWindow, "modStaminaSwitch"), cfg.mods and cfg.mods.stamina == true)
  safeSetOn(dtResolve(dtWindow, "modSpellwandSwitch"), cfg.mods and cfg.mods.spellwand == true)

  safeSetText(dtResolve(dtWindow, "modAntiParalyzeKey"), getHotkeyDisplay("antiParalyze"))
  safeSetText(dtResolve(dtWindow, "modAutoHasteKey"), getHotkeyDisplay("autoHaste"))
  safeSetText(dtResolve(dtWindow, "modAutoHealKey"), getHotkeyDisplay("autoHeal"))
  safeSetText(dtResolve(dtWindow, "modRingSwapKey"), getHotkeyDisplay("ringSwap"))
  safeSetText(dtResolve(dtWindow, "modMagicWallKey"), getHotkeyDisplay("magicWall"))
  safeSetText(dtResolve(dtWindow, "mwScrollSpellKey"), getHotkeyDisplay("mwScroll"))
  safeSetText(dtResolve(dtWindow, "modManaPotKey"), getHotkeyDisplay("manaPot"))
  safeSetText(dtResolve(dtWindow, "modCutWgKey"), getHotkeyDisplay("cutWg"))
  safeSetText(dtResolve(dtWindow, "modStaminaKey"), getHotkeyDisplay("stamina"))
  safeSetText(dtResolve(dtWindow, "modSpellwandKey"), getHotkeyDisplay("spellwand"))

  -- Keep icon hotkey badges + disabled visuals in sync.
  for k, a in pairs(DT_ACTIONS) do
    if a and a.icon then
      dtApplyActionIconConfig(k)
      dtUpdateHotkeyBadge(k)
      dtApplyActionDisabledVisual(k)
    end
  end

  dtRefreshing = false
end

local function dtApplyEnabledState()
  if not isEnabled() then
    HK_CAPTURE = nil
    if ueNonSafe then ueNonSafe.setOn(false) end
    if ueSafe then ueSafe.setOn(false) end
    if superSd then superSd.setOn(false) end
    if superSdFire then superSdFire.setOn(false) end
    if superSdHoly then superSdHoly.setOn(false) end
    if sioVipMacro then sioVipMacro.setOn(false) end

    for k, _ in pairs(DT_ACTIONS) do
      dtSetActionOn(k, false, "system")
    end
  else
    -- Restore persisted module states when re-enabled.
    for k, a in pairs(DT_ACTIONS) do
      if a and a.persist then
        local want = cfg.mods and cfg.mods[k] == true
        dtSetActionOn(k, want, "system")
      end
    end
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

  -- Close
  local closeButton = dtResolve(dtWindow, "closeButton")
  if closeButton then
    closeButton.onClick = function() dtWindow:hide() end
  end

  -- Menu buttons
  local btnGeneral = dtResolve(dtWindow, "btnGeneral")
  local btnIcons = dtResolve(dtWindow, "btnIcons")
  local btnSpellsMenu = dtResolve(dtWindow, "btnSpellsMenu")
  local btnModules = dtResolve(dtWindow, "btnModules")
  local btnScriptsMenu = dtResolve(dtWindow, "btnScriptsMenu")
  local btnAbout = dtResolve(dtWindow, "btnAbout")

  if btnGeneral then btnGeneral.onClick = function() dtShowPage("pageGeneral") end end
  if btnIcons then btnIcons.onClick = function() dtShowPage("pageHotkeys") end end
  if btnSpellsMenu then btnSpellsMenu.onClick = function() dtShowPage("pageSpells") end end
  if btnModules then btnModules.onClick = function() dtShowPage("pageModules") end end
  if btnScriptsMenu then btnScriptsMenu.onClick = function() dtShowPage("pageScripts") end end
  if btnAbout then btnAbout.onClick = function() dtShowPage("pageAbout") end end

  -- Back buttons
  local backGeneral = dtResolve(dtWindow, "backGeneral")
  local backSpells = dtResolve(dtWindow, "backSpells")
  local backModules = dtResolve(dtWindow, "backModules")
  local backHotkeys = dtResolve(dtWindow, "backHotkeys")
  local backScripts = dtResolve(dtWindow, "backScripts")
  local backAbout = dtResolve(dtWindow, "backAbout")
  if backGeneral then backGeneral.onClick = function() dtShowPage("pageMenu") end end
  if backSpells then backSpells.onClick = function() dtShowPage("pageMenu") end end
  if backModules then backModules.onClick = function() dtShowPage("pageMenu") end end
  if backHotkeys then backHotkeys.onClick = function() dtShowPage("pageMenu") end end
  if backScripts then backScripts.onClick = function() dtShowPage("pageMenu") end end
  if backAbout then backAbout.onClick = function() dtShowPage("pageMenu") end end

  -- Nav bar (always visible)
  do
    local navMenu = dtResolve(dtWindow, "navMenu")
    local navGeneral = dtResolve(dtWindow, "navGeneral")
    local navSpells = dtResolve(dtWindow, "navSpells")
    local navModules = dtResolve(dtWindow, "navModules")
    local navHotkeys = dtResolve(dtWindow, "navHotkeys")
    local navScripts = dtResolve(dtWindow, "navScripts")
    local navAbout = dtResolve(dtWindow, "navAbout")
    if navMenu then navMenu.onClick = function() dtShowPage("pageMenu") end end
    if navGeneral then navGeneral.onClick = function() dtShowPage("pageGeneral") end end
    if navSpells then navSpells.onClick = function() dtShowPage("pageSpells") end end
    if navModules then navModules.onClick = function() dtShowPage("pageModules") end end
    if navHotkeys then navHotkeys.onClick = function() dtShowPage("pageHotkeys") end end
    if navScripts then navScripts.onClick = function() dtShowPage("pageScripts") end end
    if navAbout then navAbout.onClick = function() dtShowPage("pageAbout") end end
  end

  -- About: repo button
  do
    local aboutRepo = dtResolve(dtWindow, "aboutRepo")
    if aboutRepo then
      aboutRepo.onClick = function()
        if g_platform and g_platform.openUrl then
          g_platform.openUrl("https://github.com/eduardogallifaochoa/otcv8-eddiexo-scripts")
        end
      end
    end
  end

  -- Icon Hotkeys: Manage Icons popup (re-enable hidden icons)
  do
    local manageIcons = dtResolve(dtWindow, "manageIcons")
    if manageIcons then
      manageIcons.onClick = function()
        local menu = g_ui.createWidget("PopupMenu")
        menu:setGameMenu(true)
        menu:addSeparator()
        for k, a in pairs(DT_ACTIONS) do
          if a and a.icon then
            local disabled = dtIsActionDisabled(k)
            local label = (disabled and "[Show] " or "[Hide] ") .. (a.label or k)
            menu:addOption(label, function()
              cfg.actionDisabled = cfg.actionDisabled or {}
              cfg.actionDisabled[k] = not disabled
              dtSetActionOn(k, false, "system")
              dtApplyActionDisabledVisual(k)
              dtRefresh()
            end, "")
          end
        end
        menu:display(g_window.getMousePosition())
      end
    end
  end

  -- Action rename / icon config helpers (right-click or help button)
  local function dtOpenActionScript(actionKey)
    local a = dtGetAction(actionKey)
    if not a then return end
    dtShowPage("pageScripts")
    if dtWindow and dtWindow._dtLoadScript then
      pcall(dtWindow._dtLoadScript, (a.script or "scripts/druid_toolkit.lua"))
    end
    if a.scriptQuery and dtWindow and dtWindow._dtScriptFind then
      schedule(40, function()
        if dtWindow and dtWindow._dtScriptFind then
          pcall(dtWindow._dtScriptFind, a.scriptQuery, true)
        end
      end)
    end
  end

  local function dtPromptText(title, initial, onSave)
    local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
    if not root then return end

    local ok, w = pcall(function()
      return setupUI([[
MainWindow
  id: dtPromptWindow
  text: Druid Toolkit
  size: 360 130
  draggable: true
  @onEscape: self:destroy()

  Label
    id: promptTitle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 18
    margin-left: 14
    margin-right: 14
    text-align: center
    text: Edit

  TextEdit
    id: promptInput
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: promptTitle.bottom
    margin-top: 10
    margin-left: 14
    margin-right: 14
    height: 24

  Button
    id: promptCancel
    anchors.right: parent.horizontalCenter
    anchors.bottom: parent.bottom
    margin-right: 6
    margin-bottom: 10
    width: 80
    text: Cancel

  Button
    id: promptSave
    anchors.left: parent.horizontalCenter
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-bottom: 10
    width: 80
    text: Save
]], root)
    end)
    if not ok or not w then return end

    local t = dtResolve(w, "promptTitle")
    local input = dtResolve(w, "promptInput")
    local cancelBtn = dtResolve(w, "promptCancel")
    local saveBtn = dtResolve(w, "promptSave")

    safeSetText(t, title or "Edit")
    safeSetText(input, tostring(initial or ""))

    if cancelBtn then
      cancelBtn.onClick = function() if w and w.destroy then w:destroy() end end
    end

    local function doSave()
      local value = input and input.getText and input:getText() or ""
      if onSave then pcall(onSave, value) end
      if w and w.destroy then w:destroy() end
      dtRefresh()
    end

    if saveBtn then saveBtn.onClick = doSave end
    if input then input.onEnter = doSave end

    if w.show then w:show() end
    if w.raise then w:raise() end
    if w.focus then w:focus() end
    if input and input.focus then input:focus() end
  end

  local function dtOpenActionToolsMenu(actionKey, mousePos)
    local a = dtGetAction(actionKey)
    if not a then return end

    local menu = g_ui.createWidget("PopupMenu")
    menu:setGameMenu(true)

    menu:addOption("Rename", function()
      dtPromptText("Label for " .. (a.defaultLabel or actionKey), dtGetActionDisplayName(actionKey, a.defaultLabel or actionKey), function(v)
        dtSetActionDisplayName(actionKey, v)
      end)
    end, "")

    if a.icon then
      menu:addOption("Set Icon ID", function()
        local current = tostring((cfg.iconItemId and cfg.iconItemId[actionKey]) or a.iconDefaultItem or "")
        dtPromptText("Icon ID for " .. dtGetActionDisplayName(actionKey, a.defaultLabel or actionKey), current, function(v)
          local n = tonumber(_trim(v))
          if n and n > 0 then
            cfg.iconItemId[actionKey] = n
          else
            cfg.iconItemId[actionKey] = nil
          end
        end)
      end, "")

      menu:addOption("Set Icon Text", function()
        local current = tostring((cfg.iconText and cfg.iconText[actionKey]) or a.iconDefaultText or "")
        dtPromptText("Icon text for " .. dtGetActionDisplayName(actionKey, a.defaultLabel or actionKey), current, function(v)
          local txt = _trim(v)
          if txt:len() > 0 then
            cfg.iconText[actionKey] = txt
          else
            cfg.iconText[actionKey] = nil
          end
        end)
      end, "")

      menu:addOption("Reset Icon", function()
        if cfg.iconItemId then cfg.iconItemId[actionKey] = nil end
        if cfg.iconText then cfg.iconText[actionKey] = nil end
        dtRefresh()
      end, "")
    end

    menu:addOption("Open Script", function()
      dtOpenActionScript(actionKey)
    end, "")

    menu:display(mousePos or g_window.getMousePosition())
  end

  local function bindActionNameWidget(actionKey, labelId, helpId)
    local nameWidget = dtResolve(dtWindow, labelId)
    local helpWidget = dtResolve(dtWindow, helpId)

    if nameWidget then
      if nameWidget.setTooltip then
        pcall(nameWidget.setTooltip, nameWidget, "Right-click: Tools (rename/icon). Double click: Open Script.")
      end
      if nameWidget.onTextChange then
        nameWidget.onTextChange = function(_, text)
          if dtRefreshing then return end
          dtSetActionDisplayName(actionKey, text)
        end
      end

      nameWidget.onDoubleClick = function()
        dtOpenActionScript(actionKey)
      end

      nameWidget.onMouseRelease = function(_, mousePos, mouseButton)
        if mouseButton == 2 then
          dtOpenActionToolsMenu(actionKey, mousePos)
          return true
        end
        return false
      end
    end

    if helpWidget then
      helpWidget.onClick = function()
        dtOpenActionToolsMenu(actionKey, g_window.getMousePosition())
      end
    end
  end
  local function dtShowHelpPopup(text, mousePos)
    local msg = _trim(text)
    if msg:len() == 0 then return end
    local menu = g_ui.createWidget("PopupMenu")
    menu:setGameMenu(true)
    menu:addOption(msg, function() end, "")
    menu:display(mousePos or g_window.getMousePosition())
  end

  local function bindHelpButton(helpId, text)
    local w = dtResolve(dtWindow, helpId)
    if not w then return end
    if w.setTooltip then pcall(w.setTooltip, w, text) end
    w.onClick = function(_, mousePos)
      dtShowHelpPopup(text, mousePos)
    end
  end

  bindHelpButton("enabledHelp", "Enable or disable the entire Druid Toolkit.")
  bindHelpButton("toolkitToggleHelp", "Global hotkey to toggle the whole toolkit (example: F12).")
  bindHelpButton("hideEffectsHelp", "Hide visual effects on screen.")
  bindHelpButton("hideTextsHelp", "Hide orange floating texts.")
  bindHelpButton("stopCaveHelp", "Hotkey to pause/resume only CaveBot.")
  bindHelpButton("stopTargetHelp", "Hotkey to pause/resume only TargetBot.")
  bindHelpButton("followToggleGeneralHelp", "Hotkey to toggle Follow Leader.")
  bindHelpButton("followLeaderHelp", "Exact player name you want to follow.")

  bindHelpButton("ueSpellHelp", "UE spell used by SAFE and NON-SAFE modes.")
  bindHelpButton("ueRepeatHelp", "How many times UE is cast when triggered.")
  bindHelpButton("antiParalyzeSpellHelp", "Spell used to remove paralyze.")
  bindHelpButton("hasteSpellHelp", "Automatic haste spell.")
  bindHelpButton("healSpellHelp", "Automatic heal spell.")
  bindHelpButton("healPercentHelp", "HP percent threshold to trigger Auto Heal.")

  bindHelpButton("modAntiParalyzeHelp", "Anti Paralyze module: toggle + hotkey + Open Script.")
  bindHelpButton("modAutoHasteHelp", "Auto Haste module: toggle + hotkey + Open Script.")
  bindHelpButton("modAutoHealHelp", "Auto Heal module: toggle + hotkey + Open Script.")
  bindHelpButton("modRingSwapHelp", "Ring Swap (Immortal) module. Energy and normal ring IDs are configurable in script.")
  bindHelpButton("modMagicWallHelp", "Magic Wall Hold module.")
  bindHelpButton("mwScrollSpellHelp", "MW ScrollDown module toggle and hotkey. Scroll down on map to cast.")
  bindHelpButton("mwScrollTargetHelp", "Choose MW ScrollDown block check: Magic Wall (2128), Wild Growth (2130), or Custom ID.")
  bindHelpButton("modManaPotHelp", "Faster Mana Potting module.")
  bindHelpButton("modCutWgHelp", "Auto Cut Wild Growth module.")
  bindHelpButton("modStaminaHelp", "Stamina Item module.")
  bindHelpButton("modSpellwandHelp", "Spellwand module.")

  bindHelpButton("manageIconsHelp", "Re-enable icons hidden with Disable Icon.")
  bindHelpButton("scriptFileHelp", "Lua file path to load/save in this editor. You can also edit directly in Files.")
  bindHelpButton("scriptSearchHelp", "Search text inside the loaded script.")
  bindHelpButton("scriptSaveHelp", "Save in-game editor changes. You can also edit the lua directly in Files.")
  bindHelpButton("scriptViewerHelp", "In-game editor for the loaded script. Use Save to persist changes.")
  bindHelpButton("aboutRepoHelp", "Open the project GitHub repository.")
  bindHelpButton("navHelp", "Navigation tabs: Menu, General, Spells, Modules, Icon Hotkeys, Scripts and About.")
  bindHelpButton("menuLeftHelp", "Shortcuts to frequently used sections.")
  bindHelpButton("menuRightHelp", "General settings and project about.")
  bindHelpButton("backGeneralHelp", "Return to main menu.")
  bindHelpButton("backSpellsHelp", "Return to main menu.")
  bindHelpButton("backModulesHelp", "Return to main menu.")
  bindHelpButton("backHotkeysHelp", "Return to main menu.")
  bindHelpButton("backScriptsHelp", "Return to main menu.")
  bindHelpButton("backAboutHelp", "Return to main menu.")
  bindHelpButton("modulesHintHelp", "Enable/disable modules, assign hotkeys and open each script.")
  bindHelpButton("hkHintHelp", "Rename actions, assign hotkeys and customize icons.")
  bindHelpButton("scriptStatusHelp", "Shows loading status and search results.")
  bindHelpButton("closeHelp", "Close setup window; does not disable the toolkit.")
  bindHelpButton("btnIconsHelp", "Open Icon Hotkeys to assign keys and configure icons.")
  bindHelpButton("btnSpellsMenuHelp", "Open Spells to edit spells and thresholds.")
  bindHelpButton("btnModulesHelp", "Open Modules for toggles, hotkeys and Open Script.")
  bindHelpButton("btnScriptsMenuHelp", "Open Scripts to load and search inside lua files.")
  bindHelpButton("btnGeneralHelp", "Open General with global toolkit settings.")
  bindHelpButton("btnAboutHelp", "Open About with project information.")

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

  local stopCaveKey = dtResolve(dtWindow, "stopCaveKey")
  if stopCaveKey then
    stopCaveKey.onTextChange = function(_, text)
      if dtRefreshing then return end
      setHotkeySet("caveToggle", text)
    end
  end

  local stopTargetKey = dtResolve(dtWindow, "stopTargetKey")
  local toolkitToggleKey = dtResolve(dtWindow, "toolkitToggleKey")
  if toolkitToggleKey then
    toolkitToggleKey.onTextChange = function(_, text)
      if dtRefreshing then return end
      setHotkeySet("toolkitToggle", text)
    end
  end

  local followToggleGeneralKey = dtResolve(dtWindow, "followToggleGeneralKey")
  if followToggleGeneralKey then
    followToggleGeneralKey.onTextChange = function(_, text)
      if dtRefreshing then return end
      setHotkeySet("followToggle", text)
    end
  end

  if stopTargetKey then
    stopTargetKey.onTextChange = function(_, text)
      if dtRefreshing then return end
      setHotkeySet("targetToggle", text)
    end
  end

  local followLeader = dtResolve(dtWindow, "followLeader")
  if followLeader then
    followLeader.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.followLeader = text
    end
  end

  -- Spells bindings
  local ueSpell = dtResolve(dtWindow, "ueSpell")
  if ueSpell then
    ueSpell.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.ueSpell = text
    end
  end

  local ueRepeat = dtResolve(dtWindow, "ueRepeat")
  if ueRepeat then
    ueRepeat.onTextChange = function(widget, text)
      if dtRefreshing then return end
      cfg.ueRepeat = tonumber(text) or 4
    end
  end

  local antiParalyzeSpell = dtResolve(dtWindow, "antiParalyzeSpell")
  if antiParalyzeSpell then
    antiParalyzeSpell.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.antiParalyzeSpell = text
    end
  end

  local hasteSpell = dtResolve(dtWindow, "hasteSpell")
  if hasteSpell then
    hasteSpell.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.hasteSpell = text
    end
  end

  local healSpell = dtResolve(dtWindow, "healSpell")
  if healSpell then
    healSpell.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.healSpell = text
    end
  end

  local healPercent = dtResolve(dtWindow, "healPercent")
  if healPercent then
    healPercent.onTextChange = function(widget, text)
      if dtRefreshing then return end
      cfg.healPercent = tonumber(text) or 95
    end
  end

  local mwScrollCustomId = dtResolve(dtWindow, "mwScrollCustomId")
  if mwScrollCustomId then
    mwScrollCustomId.onTextChange = function(_, text)
      if dtRefreshing then return end
      dtSetMwScrollCustomId(text)
      dtRefreshMwScrollModeUi()
    end
  end

  local mwScrollModeMW = dtResolve(dtWindow, "mwScrollModeMW")
  if mwScrollModeMW then
    mwScrollModeMW.onClick = function()
      if dtRefreshing then return end
      dtSetMwScrollMode("magicwall")
      dtRefreshMwScrollModeUi()
    end
  end

  local mwScrollModeWG = dtResolve(dtWindow, "mwScrollModeWG")
  if mwScrollModeWG then
    mwScrollModeWG.onClick = function()
      if dtRefreshing then return end
      dtSetMwScrollMode("wildgrowth")
      dtRefreshMwScrollModeUi()
    end
  end

  local mwScrollModeCustom = dtResolve(dtWindow, "mwScrollModeCustom")
  if mwScrollModeCustom then
    mwScrollModeCustom.onClick = function()
      if dtRefreshing then return end
      dtSetMwScrollMode("custom")
      dtRefreshMwScrollModeUi()
    end
  end

  -- Modules switches
  local function bindModuleSwitch(actionKey, switchId)
    local sw = dtResolve(dtWindow, switchId)
    if not sw then return end
    sw.onClick = function(widget)
      if dtRefreshing then return end
      local newOn = not (cfg.mods and cfg.mods[actionKey] == true)
      dtSetActionOn(actionKey, newOn, "ui")
      if widget and widget.setOn then widget:setOn(newOn) end
      dtRefresh()
    end
  end

  bindModuleSwitch("antiParalyze", "modAntiParalyzeSwitch")
  bindModuleSwitch("autoHaste", "modAutoHasteSwitch")
  bindModuleSwitch("autoHeal", "modAutoHealSwitch")
  bindModuleSwitch("ringSwap", "modRingSwapSwitch")
  bindModuleSwitch("magicWall", "modMagicWallSwitch")
  bindModuleSwitch("mwScroll", "mwScrollSpellSwitch")
  bindModuleSwitch("manaPot", "modManaPotSwitch")
  bindModuleSwitch("cutWg", "modCutWgSwitch")
  bindModuleSwitch("stamina", "modStaminaSwitch")
  bindModuleSwitch("spellwand", "modSpellwandSwitch")

  -- Scripts viewer/editor (load, edit, save)
  do
    local scriptFile = dtResolve(dtWindow, "scriptFile")
    local scriptLoad = dtResolve(dtWindow, "scriptLoad")
    local scriptSave = dtResolve(dtWindow, "scriptSave")
    local scriptContent = dtResolve(dtWindow, "scriptContent")
    local scriptScrollbar = dtResolve(dtWindow, "scriptScrollbar")
    local scriptSearch = dtResolve(dtWindow, "scriptSearch")
    local scriptFind = dtResolve(dtWindow, "scriptFind")
    local scriptNext = dtResolve(dtWindow, "scriptNext")
    local scriptStatus = dtResolve(dtWindow, "scriptStatus")

    local scriptSearchState = { query = "", lastPos = 0 }
    local scriptTextLen = 0
    local scriptDirty = false
    local scriptLoadingText = false

    local function syncScriptScrollbar()
      if not scriptScrollbar or not scriptScrollbar.setMinimum or not scriptScrollbar.setMaximum then return end
      if scriptContent and scriptContent.getText then
        local ok, txt = pcall(scriptContent.getText, scriptContent)
        if ok and type(txt) == "string" then scriptTextLen = #txt else scriptTextLen = 0 end
      end
      pcall(scriptScrollbar.setMinimum, scriptScrollbar, 0)
      pcall(scriptScrollbar.setMaximum, scriptScrollbar, math.max(0, scriptTextLen))
      if scriptScrollbar.setValue then pcall(scriptScrollbar.setValue, scriptScrollbar, 0) end
    end

    local function updateScriptScrollLenFromText(text)
      scriptTextLen = type(text) == "string" and #text or 0
      if scriptScrollbar and scriptScrollbar.setMaximum then
        pcall(scriptScrollbar.setMaximum, scriptScrollbar, math.max(0, scriptTextLen))
      end
    end

    -- Prefer native binding when available; fallback to a coarse cursor-jump hack.
    local nativeBound = false
    if scriptContent and scriptScrollbar and scriptContent.setVerticalScrollBar then
      nativeBound = pcall(scriptContent.setVerticalScrollBar, scriptContent, scriptScrollbar) == true
    end
    if (not nativeBound) and scriptScrollbar then
      scriptScrollbar.onValueChange = function(_, value)
        if not scriptContent or not scriptContent.setCursorPos then return end
        local v = tonumber(value) or 0
        if v < 0 then v = 0 end
        if v > scriptTextLen then v = scriptTextLen end
        pcall(scriptContent.setCursorPos, scriptContent, v)
      end
    end

    if scriptContent and scriptContent.setEditable then
      pcall(function() scriptContent:setEditable(true) end)
    end
    if scriptContent then
      scriptContent.onTextChange = function(_, text)
        updateScriptScrollLenFromText(text)
        if scriptLoadingText then return end
        scriptDirty = true
        safeSetText(scriptStatus, "Edited (unsaved).")
      end
    end

    local function toResourcePath(rel)
      if type(rel) ~= "string" then return nil end
      rel = rel:gsub("\\", "/")
      rel = _trim(rel)
      if rel:len() == 0 then return nil end
      if rel:sub(1, 1) == "/" then return rel end

      local cfgName = getBotConfigName() or __druid_toolkit_profile
      if cfgName and type(cfgName) == "string" and cfgName:len() > 0 then
        return "/bot/" .. cfgName .. "/" .. rel
      end
      return "/" .. rel
    end

    local function readResource(path)
      if not path then return nil, "missing path" end
      if g_resources and g_resources.readFileContents then
        local ok, data = pcall(g_resources.readFileContents, path)
        if ok then return data end
      end
      if readFileContents then
        local ok, data = pcall(readFileContents, path)
        if ok then return data end
      end
      return nil, "unable to read"
    end

    local function writeResource(path, data)
      if not path then return false, "missing path" end
      data = type(data) == "string" and data or ""
      if g_resources and g_resources.writeFileContents then
        local ok, err = pcall(g_resources.writeFileContents, path, data)
        if ok then return true end
      end
      if writeFileContents then
        local ok, err = pcall(writeFileContents, path, data)
        if ok then return true end
      end
      return false, "unable to write"
    end

    local function loadNow()
      if not scriptContent or not scriptContent.setText then return end
      local rel = scriptFile and scriptFile.getText and scriptFile:getText() or "scripts/druid_toolkit.lua"
      local res = toResourcePath(rel)
      local data, err = readResource(res)
      if not data then
        scriptLoadingText = true
        scriptContent:setText("Failed loading: " .. tostring(rel) .. "\n(" .. tostring(err) .. ")")
        scriptLoadingText = false
        scriptDirty = false
        safeSetText(scriptStatus, "Load failed.")
        return
      end
      scriptLoadingText = true
      scriptContent:setText(data)
      scriptLoadingText = false
      syncScriptScrollbar()
      scriptSearchState.lastPos = 0
      scriptDirty = false
      safeSetText(scriptStatus, "Loaded: " .. tostring(rel))
    end

    local function saveNow()
      if not scriptContent or not scriptContent.getText then return end
      local rel = scriptFile and scriptFile.getText and scriptFile:getText() or "scripts/druid_toolkit.lua"
      local res = toResourcePath(rel)
      local text = scriptContent:getText() or ""
      local ok, err = writeResource(res, text)
      if not ok then
        safeSetText(scriptStatus, "Save failed: " .. tostring(err))
        return
      end
      scriptDirty = false
      safeSetText(scriptStatus, "Saved: " .. tostring(rel))
    end

    if scriptLoad then scriptLoad.onClick = loadNow end
    if scriptSave then scriptSave.onClick = saveNow end
    -- Expose for icon context menu (safe no-op if widgets aren't available).
    dtWindow._dtLoadScript = function(rel)
      if scriptFile and scriptFile.setText and type(rel) == "string" then
        scriptFile:setText(rel)
      end
      loadNow()
    end
    dtWindow._dtSaveScript = saveNow

    local function tryHighlightMatch(s, e)
      if not scriptContent then return end
      -- Different OTC builds expose different methods; probe safely.
      if scriptContent.setCursorPos then pcall(scriptContent.setCursorPos, scriptContent, e) end
      if scriptContent.setSelection then pcall(scriptContent.setSelection, scriptContent, s, e) end
      if scriptContent.select then pcall(scriptContent.select, scriptContent, s, e) end
      if scriptContent.focus then pcall(scriptContent.focus, scriptContent) end
      if scriptScrollbar and scriptScrollbar.setValue then
        pcall(scriptScrollbar.setValue, scriptScrollbar, e)
      end
    end

    local function doFind(reset)
      if not scriptContent or not scriptContent.getText then return end
      local q = scriptSearch and scriptSearch.getText and scriptSearch:getText() or ""
      q = _trim(q)
      if q:len() == 0 then
        safeSetText(scriptStatus, "Empty search.")
        scriptSearchState.query = ""
        scriptSearchState.lastPos = 0
        return
      end

      local text = scriptContent:getText() or ""
      local hay = text:lower()
      local needle = q:lower()

      local startAt = 1
      if not reset and scriptSearchState.query == needle and scriptSearchState.lastPos > 0 then
        startAt = scriptSearchState.lastPos + 1
      end

      local s, e = hay:find(needle, startAt, true)
      if not s then
        if startAt > 1 then
          -- wrap
          s, e = hay:find(needle, 1, true)
        end
      end

      if not s then
        safeSetText(scriptStatus, "Not found: " .. q)
        scriptSearchState.query = needle
        scriptSearchState.lastPos = 0
        return
      end

      scriptSearchState.query = needle
      scriptSearchState.lastPos = e
      safeSetText(scriptStatus, "Found (pos " .. tostring(s) .. ").")
      tryHighlightMatch(s, e)
    end

    if scriptFind then scriptFind.onClick = function() doFind(true) end end
    if scriptNext then scriptNext.onClick = function() doFind(false) end end

    dtWindow._dtScriptFind = function(query, reset)
      if scriptSearch and scriptSearch.setText and type(query) == "string" then
        scriptSearch:setText(query)
      end
      doFind(reset ~= false)
    end
  end
  -- Modules: Open Script buttons (jump to exact macro block)
  local function bindModuleOpen(openId, query)
    local openBtn = dtResolve(dtWindow, openId)
    if not openBtn then return end
    openBtn.onClick = function()
      dtShowPage("pageScripts")
      if dtWindow and dtWindow._dtLoadScript then
        pcall(dtWindow._dtLoadScript, "scripts/druid_toolkit.lua")
      end
      if query and dtWindow and dtWindow._dtScriptFind then
        schedule(40, function()
          if dtWindow and dtWindow._dtScriptFind then
            pcall(dtWindow._dtScriptFind, query, true)
          end
        end)
      end
    end
  end

  bindModuleOpen("modAntiParalyzeOpen", "antiParalyzeMacro = macro")
  bindModuleOpen("modAutoHasteOpen", "autoHasteMacro = macro")
  bindModuleOpen("modAutoHealOpen", "autoHealMacro = macro")
  bindModuleOpen("modRingSwapOpen", "ringSwapMacro = macro")
  bindModuleOpen("modMagicWallOpen", "holdMWMacro = macro")
  bindModuleOpen("mwScrollSpellOpen", "dtTryMWScrollDown")
  bindModuleOpen("modManaPotOpen", "manaPotMacro = macro")
  bindModuleOpen("modCutWgOpen", "cutWgMacro = macro")
  bindModuleOpen("modStaminaOpen", "staminaMacro = macro")
  bindModuleOpen("modSpellwandOpen", "spellwandMacro = macro")

  -- Hotkey binding helper: Set / Clear
  local function bindHotkeyRow(actionKey, keyId, setId, clearId)
    local keyWidget = dtResolve(dtWindow, keyId)
    local setButton = dtResolve(dtWindow, setId)
    local clearButton = dtResolve(dtWindow, clearId)

    if keyWidget then
      keyWidget.onTextChange = function(widget, text)
        if dtRefreshing then return end
        local normalized = serializeHotkeyList(parseHotkeyList(text), ";")
        cfg.hk[actionKey] = normalized
      end
    end

    local function startCapture()
      HK_CAPTURE = { action = actionKey }
      safeSetText(keyWidget, "Press...")
    end

    if setButton then
      setButton.onClick = function() startCapture() end
    end
    if clearButton then
      clearButton.onClick = function()
        clearHotkeys(actionKey)
        dtRefresh()
      end
    end
  end

  bindHotkeyRow("caveToggle", "caveToggleKey", "caveToggleSet", "caveToggleClear")
  bindHotkeyRow("targetToggle", "targetToggleKey", "targetToggleSet", "targetToggleClear")
  bindHotkeyRow("antiParalyze", "modAntiParalyzeKey", "modAntiParalyzeSet", "modAntiParalyzeClear")
  bindHotkeyRow("autoHaste", "modAutoHasteKey", "modAutoHasteSet", "modAutoHasteClear")
  bindHotkeyRow("autoHeal", "modAutoHealKey", "modAutoHealSet", "modAutoHealClear")
  bindHotkeyRow("ringSwap", "modRingSwapKey", "modRingSwapSet", "modRingSwapClear")
  bindHotkeyRow("magicWall", "modMagicWallKey", "modMagicWallSet", "modMagicWallClear")
  bindHotkeyRow("mwScroll", "mwScrollSpellKey", "mwScrollSpellSet", "mwScrollSpellClear")
  bindHotkeyRow("manaPot", "modManaPotKey", "modManaPotSet", "modManaPotClear")
  bindHotkeyRow("cutWg", "modCutWgKey", "modCutWgSet", "modCutWgClear")
  bindHotkeyRow("stamina", "modStaminaKey", "modStaminaSet", "modStaminaClear")
  bindHotkeyRow("spellwand", "modSpellwandKey", "modSpellwandSet", "modSpellwandClear")
  bindHotkeyRow("ueNonSafe", "ueNonSafeKey", "ueNonSafeSet", "ueNonSafeClear")
  bindHotkeyRow("ueSafe", "ueSafeKey", "ueSafeSet", "ueSafeClear")
  bindHotkeyRow("superSd", "superSdKey", "superSdSet", "superSdClear")
  bindHotkeyRow("superSdFire", "superSdFireKey", "superSdFireSet", "superSdFireClear")
  bindHotkeyRow("superSdHoly", "superSdHolyKey", "superSdHolySet", "superSdHolyClear")
  bindHotkeyRow("sioVip", "sioVipKey", "sioVipSet", "sioVipClear")
  bindHotkeyRow("followToggle", "followToggleKey", "followToggleSet", "followToggleClear")

  -- Editable action labels + per-action tools menu
  bindActionNameWidget("caveToggle", "caveToggleLabel", "caveToggleHelp")
  bindActionNameWidget("targetToggle", "targetToggleLabel", "targetToggleHelp")
  bindActionNameWidget("ueNonSafe", "ueNonSafeLabel", "ueNonSafeHelp")
  bindActionNameWidget("ueSafe", "ueSafeLabel", "ueSafeHelp")
  bindActionNameWidget("superSd", "superSdLabel", "superSdHelp")
  bindActionNameWidget("superSdFire", "superSdFireLabel", "superSdFireHelp")
  bindActionNameWidget("superSdHoly", "superSdHolyLabel", "superSdHolyHelp")
  bindActionNameWidget("sioVip", "sioVipLabel", "sioVipHelp")
  bindActionNameWidget("followToggle", "followToggleLabel", "followToggleHelp")
  dtShowPage("pageMenu")
  dtRefresh()
  return true
end

dtOpen = function()
  if not dtEnsureWindow() then
    schedule(200, function() dtOpen() end)
    return
  end
  dtRefresh()
  dtWindow:show()
  dtWindow:raise()
  dtWindow:focus()
end

local function dtBindMainUi(ui)
  if not ui then return false end
  if ui.title and ui.title.setOn then
    ui.title:setOn(isEnabled())
    ui.title.onClick = function(widget)
      cfg.enabled = not isEnabled()
      if widget and widget.setOn then widget:setOn(isEnabled()) end
      dtApplyEnabledState()
    end
  end
  if ui.setup then
    ui.setup.onClick = function() dtOpen() end
  end
  return ui.title ~= nil and ui.setup ~= nil
end

local function dtMainUiAlive()
  if not mainUi then return false end
  if mainUi.getParent then
    local ok, parent = pcall(mainUi.getParent, mainUi)
    return ok and parent ~= nil
  end
  return true
end

local function dtEnsureMainUi(tryN)
  if dtMainUiAlive() then
    dtBindMainUi(mainUi)
    return true
  end

  mainUi = setupMainRow()
  if mainUi then
    dtBindMainUi(mainUi)
    if dtMainUiAlive() then return true end
  end

  tryN = (tonumber(tryN) or 0) + 1
  if tryN <= 25 then
    schedule(200, function() dtEnsureMainUi(tryN) end)
  else
    log("Main row not ready after retries (will be created on next reload).")
  end
  return false
end

-- Build the Main row UI with retries (some clients initialize Main tab slightly later).
dtEnsureMainUi(0)
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

-- Stop CaveBot / TargetBot hotkeys (handled in the main onKeyDown at bottom)

-- Anti Paralyze
local antiParalyzeMacro
antiParalyzeMacro = macro(100, function()
  if not isEnabled() then return end
  if antiParalyzeMacro.isOff() then return end
  if isParalyzed() and (cfg.antiParalyzeSpell or ""):len() > 0 then
    saySpell(cfg.antiParalyzeSpell)
  end
end)

-- Auto Haste
local autoHasteMacro
autoHasteMacro = macro(500, function()
  if not isEnabled() then return end
  if autoHasteMacro.isOff() then return end
  if not hasHaste() and (cfg.hasteSpell or ""):len() > 0 then
    if saySpell(cfg.hasteSpell) then delay(5000) end
  end
end)

-- Auto Heal
local autoHealMacro
autoHealMacro = macro(50, function()
  if not isEnabled() then return end
  if autoHealMacro.isOff() then return end
  local hpTrigger = tonumber(cfg.healPercent) or 95
  if hppercent() <= hpTrigger and (cfg.healSpell or ""):len() > 0 then
    say(cfg.healSpell)
  end
end)

-- Ring swap
local ringSwapMacro
ringSwapMacro = macro(100, function()
  if not isEnabled() then return end
  if ringSwapMacro.isOff() then return end
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

local holdMWMacro
holdMWMacro = macro(20, function()
  if not isEnabled() then return end
  if holdMWMacro.isOff() then return end
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

-- MW ScrollDown integration (from mwall_scrolldown essence)
local MW_SCROLL_DELAY_MS = tonumber(cfg.mwScrollDelayMs) or 250
cfg.mwScrollDelayMs = MW_SCROLL_DELAY_MS
local mwScrollLastUse = 0

local function dtIsWheelDownKey(keys)
  return keys == "MouseWheelDown" or keys == "WheelDown" or keys == "ScrollDown"
end

local function dtTryMWScrollDown()
  if not holdMWMacro or holdMWMacro.isOff() then return false end
  if not (cfg.mods and cfg.mods.mwScroll == true) then return false end
  if now - mwScrollLastUse < MW_SCROLL_DELAY_MS then return false end

  local tile = getTileUnderCursor()
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() or not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  local blockId = dtGetMwScrollBlockId()
  if blockId and blockId > 0 and top and top.getId and top:getId() == blockId then return false end

  mwScrollLastUse = now
  useWith(MW_RUNE_ID, top or tile:getGround() or tile)
  return true
end

do
  local mapPanel = modules.game_interface and modules.game_interface.getMapPanel and modules.game_interface.getMapPanel()
  if mapPanel and not mapPanel._dtMwScrollInstalled then
    mapPanel._dtMwScrollInstalled = true
    mapPanel._dtMwScrollPrev = mapPanel.onMouseWheel
    mapPanel.onMouseWheel = function(widget, mousePos, dir)
      local isDown = (dir == 2 or dir == -1)
      if isDown and (not chatTyping()) and isEnabled() then
        if dtTryMWScrollDown() then
          return true
        end
      end
      if mapPanel._dtMwScrollPrev then
        return mapPanel._dtMwScrollPrev(widget, mousePos, dir)
      end
      return false
    end
  end
end

onKeyDown(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end
  if not dtIsWheelDownKey(keys) then return end
  dtTryMWScrollDown()
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
local manaPotMacro
manaPotMacro = macro(200, function()
  if not isEnabled() then return end
  if manaPotMacro.isOff() then return end
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

local cutWgMacro
cutWgMacro = macro(500, function()
  if not isEnabled() then return end
  if cutWgMacro.isOff() then return end
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

-- Stamina item
local staminaMacro
staminaMacro = macro(180000, function()
  if not isEnabled() then return end
  if staminaMacro.isOff() then return end
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
local iconUeNonSafe = addIcon("dt_UE_NonSafe_Icon", { item = 3161, text = "UE\nNS" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("ueNonSafe") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("ueNonSafe", false, "icon")
    return
  end
  dtSetActionOn("ueNonSafe", isOn, "icon")
end)

local iconUeSafe = addIcon("dt_UE_Safe_Icon", { item = 3161, text = "UE\nSAFE" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("ueSafe") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("ueSafe", false, "icon")
    return
  end
  dtSetActionOn("ueSafe", isOn, "icon")
end)

local iconSuperSd = addIcon("dt_SuperSD_Icon", { item = SD_RUNE_ID, text = "SD" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("superSd") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("superSd", false, "icon")
    return
  end
  dtSetActionOn("superSd", isOn, "icon")
end)

local iconSuperSdFire = addIcon("dt_SuperSDFire_Icon", { item = SD_FIRE_RUNE_ID, text = "F-SD" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("superSdFire") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("superSdFire", false, "icon")
    return
  end
  dtSetActionOn("superSdFire", isOn, "icon")
end)

local iconSuperSdHoly = addIcon("dt_SuperSDHoly_Icon", { item = SD_HOLY_RUNE_ID, text = "H-SD" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("superSdHoly") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("superSdHoly", false, "icon")
    return
  end
  dtSetActionOn("superSdHoly", isOn, "icon")
end)

local iconSioVip = addIcon("dt_SioVIP_Icon", { item = 3160, text = "SIO" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if (not isEnabled()) or dtIsActionDisabled("sioVip") then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    dtSetActionOn("sioVip", false, "icon")
    return
  end
  dtSetActionOn("sioVip", isOn, "icon")
end)

local caveToggleMacro = {
  isOn = function()
    return CaveBot and CaveBot.isOn and CaveBot.isOn() or false
  end,
  setOn = function(v)
    if not CaveBot then return end
    if v then
      if CaveBot.setOn then CaveBot.setOn() end
    else
      if CaveBot.setOff then CaveBot.setOff() end
    end
  end
}

local mwScrollToggleMacro = {
  isOn = function()
    return cfg.mods and cfg.mods.mwScroll == true
  end,
  setOn = function(v)
    cfg.mods = cfg.mods or {}
    cfg.mods.mwScroll = (v == true)
  end
}

local targetToggleMacro = {
  isOn = function()
    return TargetBot and TargetBot.isOn and TargetBot.isOn() or false
  end,
  setOn = function(v)
    if not TargetBot then return end
    if v then
      if TargetBot.setOn then TargetBot.setOn() end
    else
      if TargetBot.setOff then TargetBot.setOff() end
    end
  end
}

local iconCaveToggle = addIcon("dt_CaveToggle_Icon", { item = 3156, text = "CAVE" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if not isEnabled() then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    return
  end
  if CaveBot then
    if isOn then if CaveBot.setOn then CaveBot.setOn() end else if CaveBot.setOff then CaveBot.setOff() end end
  end
end)

local iconTargetToggle = addIcon("dt_TargetToggle_Icon", { item = 3155, text = "TAR" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  if not isEnabled() then
    if icon and icon.setOn then
      icon._dtSuppress = true
      pcall(icon.setOn, icon, false)
      schedule(0, function() if icon then icon._dtSuppress = nil end end)
    end
    return
  end
  if TargetBot then
    if isOn then if TargetBot.setOn then TargetBot.setOn() end else if TargetBot.setOff then TargetBot.setOff() end end
  end
end)

local iconAntiParalyze = addIcon("dt_AntiParalyze_Icon", { item = 3147, text = "A-P" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("antiParalyze", isOn, "icon")
end)

local iconAutoHaste = addIcon("dt_AutoHaste_Icon", { item = 3079, text = "HST" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("autoHaste", isOn, "icon")
end)

local iconAutoHeal = addIcon("dt_AutoHeal_Icon", { item = 3160, text = "HEAL" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("autoHeal", isOn, "icon")
end)

local iconRingSwap = addIcon("dt_RingSwap_Icon", { item = 3051, text = "RING" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("ringSwap", isOn, "icon")
end)

local iconMagicWall = addIcon("dt_MagicWall_Icon", { item = 3180, text = "MW" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("magicWall", isOn, "icon")
end)

local iconManaPot = addIcon("dt_ManaPot_Icon", { item = 238, text = "MANA" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("manaPot", isOn, "icon")
end)

local iconCutWg = addIcon("dt_CutWg_Icon", { item = 3308, text = "CUT" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("cutWg", isOn, "icon")
end)

local iconStamina = addIcon("dt_Stamina_Icon", { item = 11372, text = "STA" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("stamina", isOn, "icon")
end)

local iconSpellwand = addIcon("dt_Spellwand_Icon", { item = SPELLWAND_ID, text = "SW" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("spellwand", isOn, "icon")
end)

local iconFollow = addIcon("dt_Follow_Icon", { item = 3031, text = "FLW" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("followToggle", isOn, "icon")
end)
-- Register actions for hotkeys + context menu + sync.
dtRegisterAction("caveToggle", {
  label = "CaveBot (Toggle)",
  macro = caveToggleMacro,
  icon = iconCaveToggle,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "CaveBot / TargetBot toggles",
  setupPage = "pageHotkeys",
})
dtRegisterAction("targetToggle", {
  label = "TargetBot (Toggle)",
  macro = targetToggleMacro,
  icon = iconTargetToggle,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "CaveBot / TargetBot toggles",
  setupPage = "pageHotkeys",
})
dtRegisterAction("ueNonSafe", {
  label = "UE (NON-SAFE)",
  macro = ueNonSafe,
  icon = iconUeNonSafe,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "ueNonSafe = macro",
  setupPage = "pageSpells",
})
dtRegisterAction("ueSafe", {
  label = "UE (SAFE)",
  macro = ueSafe,
  icon = iconUeSafe,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "ueSafe = macro",
  setupPage = "pageSpells",
})
dtRegisterAction("superSd", {
  label = "Super SD",
  macro = superSd,
  icon = iconSuperSd,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "superSd = macro",
})
dtRegisterAction("superSdFire", {
  label = "Super SD Fire",
  macro = superSdFire,
  icon = iconSuperSdFire,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "superSdFire = macro",
})
dtRegisterAction("superSdHoly", {
  label = "Super Holy SD",
  macro = superSdHoly,
  icon = iconSuperSdHoly,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "superSdHoly = macro",
})
dtRegisterAction("sioVip", {
  label = "Sio VIP",
  macro = sioVipMacro,
  icon = iconSioVip,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "sioVipMacro = macro",
})

-- Shift + RightClick on icon: per-action context menu (registry-driven)
local DT_ACTION_UI = {
  caveToggle = { keyId = "caveToggleKey" },
  targetToggle = { keyId = "targetToggleKey" },
  ueNonSafe = { keyId = "ueNonSafeKey" },
  ueSafe = { keyId = "ueSafeKey" },
  superSd = { keyId = "superSdKey" },
  superSdFire = { keyId = "superSdFireKey" },
  superSdHoly = { keyId = "superSdHolyKey" },
  sioVip = { keyId = "sioVipKey" },
  followToggle = { keyId = "followToggleGeneralKey" },
}

local function dtIsShiftDown()
  if not g_keyboard then return false end
  if g_keyboard.isShiftPressed then
    local ok, v = pcall(g_keyboard.isShiftPressed)
    if ok then return v == true end
  end
  if not g_keyboard.isKeyPressed then return false end
  return g_keyboard.isKeyPressed("Shift") or g_keyboard.isKeyPressed("LShift") or g_keyboard.isKeyPressed("RShift")
end

local function dtStartHotkeyCapture(actionKey)
  if not actionKey then return end
  local a = dtGetAction(actionKey)
  local targetPage = (a and a.setupPage) or "pageHotkeys"
  dtOpen()
  dtShowPage(targetPage)
  HK_CAPTURE = { action = actionKey }
  local ids = DT_ACTION_UI[actionKey]
  local keyWidget = ids and dtResolve(dtWindow, ids.keyId) or nil
  safeSetText(keyWidget, "Press...")
end

local function dtOpenScriptViewer(relPath, query)
  dtOpen()
  dtShowPage("pageScripts")
  if dtWindow and dtWindow._dtLoadScript then
    pcall(dtWindow._dtLoadScript, relPath or "scripts/druid_toolkit.lua")
  end
  if query and dtWindow and dtWindow._dtScriptFind then
    schedule(50, function()
      if dtWindow and dtWindow._dtScriptFind then pcall(dtWindow._dtScriptFind, query, true) end
    end)
  end
end

local function dtAttachIconContextMenu(actionKey)
  local a = dtGetAction(actionKey)
  if not a or not a.icon or a.icon._dtContextAttached then return end
  a.icon._dtContextAttached = true

  local orig = a.icon.onMouseRelease
  a.icon.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == 2 and dtIsShiftDown() then
      local menu = g_ui.createWidget("PopupMenu")
      menu:setGameMenu(true)

      menu:addOption("Toggle", function()
        if not isEnabled() then return end
        dtToggleAction(actionKey)
      end, "")

      if a.setupPage then
        menu:addOption("Setup...", function()
          dtOpen()
          dtShowPage(a.setupPage)
        end, "")
      end

      menu:addOption("Hotkey: Set", function() dtStartHotkeyCapture(actionKey) end, "")
      menu:addOption("Hotkey: Clear", function()
        clearHotkeys(actionKey)
        dtRefresh()
      end, "")

      menu:addOption("Open Script", function()
        dtOpenScriptViewer((a.script or "scripts/druid_toolkit.lua"), a.scriptQuery)
      end, "")

      -- Per-action hide/disable (hides icon from GUI; re-enable via Setup -> Icon Hotkeys -> Manage Icons)
      if not dtIsActionDisabled(actionKey) then
        menu:addOption("Disable Icon", function()
          cfg.actionDisabled = cfg.actionDisabled or {}
          cfg.actionDisabled[actionKey] = true
          dtSetActionOn(actionKey, false, "system")
          dtApplyActionDisabledVisual(actionKey)
          dtRefresh()
        end, "")
      end

      menu:display(mousePos)
      return true
    end

    if orig then return orig(widget, mousePos, mouseButton) end
    return false
  end
end

for k, a in pairs(DT_ACTIONS) do
  dtAttachIconContextMenu(k)
  if a and a.icon then
    dtApplyActionIconConfig(k)
    dtUpdateHotkeyBadge(k)
    dtApplyActionDisabledVisual(k)
  end
end

-- Hotkey capture + toggles (chat-safe)
onKeyDown(function(keys)
  if chatTyping() then return end

  if HK_CAPTURE and HK_CAPTURE.action then
    setHotkeySet(HK_CAPTURE.action, keys)
    HK_CAPTURE = nil
    dtRefresh()
    return
  end

  if hotkeyMatches("toolkitToggle", keys) then
    cfg.enabled = not isEnabled()
    dtApplyEnabledState()
    return
  end

  if not isEnabled() then return end

  -- CaveBot / TargetBot toggles (separate)
  if hotkeyMatches("caveToggle", keys) and CaveBot then
    if CaveBot.isOn and CaveBot.isOn() then
      if CaveBot.setOff then CaveBot.setOff() end
    else
      if CaveBot.setOn then CaveBot.setOn() end
    end
    return
  end
  if hotkeyMatches("targetToggle", keys) and TargetBot then
    if TargetBot.isOn and TargetBot.isOn() then
      if TargetBot.setOff then TargetBot.setOff() end
    else
      if TargetBot.setOn then TargetBot.setOn() end
    end
    return
  end

  -- Modules hotkeys (persisted)
  if hotkeyMatches("antiParalyze", keys) then dtToggleAction("antiParalyze") return end
  if hotkeyMatches("autoHaste", keys) then dtToggleAction("autoHaste") return end
  if hotkeyMatches("autoHeal", keys) then dtToggleAction("autoHeal") return end
  if hotkeyMatches("ringSwap", keys) then dtToggleAction("ringSwap") return end
  if hotkeyMatches("magicWall", keys) then dtToggleAction("magicWall") return end
  if hotkeyMatches("mwScroll", keys) then dtToggleAction("mwScroll") return end
  if hotkeyMatches("manaPot", keys) then dtToggleAction("manaPot") return end
  if hotkeyMatches("cutWg", keys) then dtToggleAction("cutWg") return end
  if hotkeyMatches("stamina", keys) then dtToggleAction("stamina") return end
  if hotkeyMatches("spellwand", keys) then dtToggleAction("spellwand") return end

  if hotkeyMatches("ueNonSafe", keys) then dtToggleAction("ueNonSafe") return end
  if hotkeyMatches("ueSafe", keys) then dtToggleAction("ueSafe") return end
  if hotkeyMatches("superSd", keys) then dtToggleAction("superSd") return end
  if hotkeyMatches("superSdFire", keys) then dtToggleAction("superSdFire") return end
  if hotkeyMatches("superSdHoly", keys) then dtToggleAction("superSdHoly") return end
  if hotkeyMatches("sioVip", keys) then dtToggleAction("sioVip") return end
  if hotkeyMatches("followToggle", keys) then
    if dtGetAction("followToggle") then
      dtToggleAction("followToggle")
    elseif ultimateFollow then
      toggleMacro(ultimateFollow)
    end
    return
  end
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

local ultimateFollow
ultimateFollow = macro(50, function()
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

-- Follow is hotkey-driven; keep it off by default.
ultimateFollow.setOn(false)
dtRegisterAction("followToggle", {
  label = "Follow Leader",
  macro = ultimateFollow,
  icon = iconFollow,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "ultimateFollow = macro",
  setupPage = "pageGeneral",
})

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
local spellwandMacro
spellwandMacro = macro(1000, function()
  if not isEnabled() then return end
  if spellwandMacro.isOff() then return end
  for _, container in pairs(g_game.getContainers()) do
    for _, item in ipairs(container:getItems()) do
      local itemIsContainer = item.isContainer and item:isContainer()
      if (not itemIsContainer) and table.contains(SPELLWAND_ITEMLIST, item:getId()) then
        useWith(SPELLWAND_ID, item)
        return
      end
    end
  end
end)

-- Apply persisted module states (first load)
antiParalyzeMacro.setOn(cfg.mods.antiParalyze == true)
autoHasteMacro.setOn(cfg.mods.autoHaste == true)
autoHealMacro.setOn(cfg.mods.autoHeal == true)
ringSwapMacro.setOn(cfg.mods.ringSwap == true)
holdMWMacro.setOn(cfg.mods.magicWall == true)
manaPotMacro.setOn(cfg.mods.manaPot == true)
cutWgMacro.setOn(cfg.mods.cutWg == true)
staminaMacro.setOn(cfg.mods.stamina == true)
spellwandMacro.setOn(cfg.mods.spellwand == true)

-- Register module actions (UI + hotkeys; persisted)
dtRegisterAction("antiParalyze", {
  label = "Anti Paralyze",
  macro = antiParalyzeMacro,
  icon = iconAntiParalyze,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "antiParalyzeMacro = macro",
  setupPage = "pageSpells",
})
dtRegisterAction("autoHaste", {
  label = "Auto Haste",
  macro = autoHasteMacro,
  icon = iconAutoHaste,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "autoHasteMacro = macro",
  setupPage = "pageSpells",
})
dtRegisterAction("autoHeal", {
  label = "Auto Heal",
  macro = autoHealMacro,
  icon = iconAutoHeal,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "autoHealMacro = macro",
  setupPage = "pageSpells",
})
dtRegisterAction("ringSwap", {
  label = "Ring Swap (Immortal)",
  macro = ringSwapMacro,
  icon = iconRingSwap,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "ringSwapMacro = macro",
  setupPage = "pageModules",
})
dtRegisterAction("magicWall", {
  label = "Magic Wall (Hold)",
  macro = holdMWMacro,
  icon = iconMagicWall,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "holdMWMacro = macro",
  setupPage = "pageModules",
})
dtRegisterAction("mwScroll", {
  label = "MW ScrollDown",
  macro = mwScrollToggleMacro,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "dtTryMWScrollDown",
  setupPage = "pageSpells",
})
dtRegisterAction("manaPot", {
  label = "Faster Mana Potting",
  macro = manaPotMacro,
  icon = iconManaPot,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "manaPotMacro = macro",
  setupPage = "pageModules",
})
dtRegisterAction("cutWg", {
  label = "Auto Cut Wild Growth",
  macro = cutWgMacro,
  icon = iconCutWg,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "cutWgMacro = macro",
  setupPage = "pageModules",
})
dtRegisterAction("stamina", {
  label = "Stamina Item",
  macro = staminaMacro,
  icon = iconStamina,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "staminaMacro = macro",
  setupPage = "pageModules",
})
dtRegisterAction("spellwand", {
  label = "Spellwand",
  macro = spellwandMacro,
  icon = iconSpellwand,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "spellwandMacro = macro",
  setupPage = "pageModules",
})

-- Final sync after all actions are registered (including follow + modules).
for k, a in pairs(DT_ACTIONS) do
  dtAttachIconContextMenu(k)
  if a and a.icon then
    dtApplyActionIconConfig(k)
    dtUpdateHotkeyBadge(k)
    dtApplyActionDisabledVisual(k)
  end
end
log("Loaded.")






