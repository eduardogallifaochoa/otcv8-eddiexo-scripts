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
  followToggle = (cfg.hk and cfg.hk.follow) or "F7",
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

local function toggleMacro(m)
  if not m or not m.isOn or not m.setOn then return end
  m.setOn(not m.isOn())
end

local function _trim(s)
  if type(s) ~= "string" then return "" end
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
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
  DT_ACTIONS[key] = def
end

local function dtGetAction(key)
  return DT_ACTIONS[key]
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
  end
  if a._dtHotkeyBadge and a._dtHotkeyBadge.setVisible then
    pcall(a._dtHotkeyBadge.setVisible, a._dtHotkeyBadge, not disabled)
  elseif a._badge and a._badge.setVisible then
    pcall(a._badge.setVisible, a._badge, not disabled)
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

  local parent = a.icon.getParent and a.icon:getParent() or nil
  if not parent then return end

  local ok, badge = pcall(UI.createWidget, "DtHotkeyBadge", parent)
  if not ok or not badge then return end
  a._dtHotkeyBadge = badge
  a._badge = badge

  if badge.setId then pcall(badge.setId, badge, "dt_hkbadge_" .. tostring(actionKey)) end

  -- Don't block clicks on the icon (badge is purely decorative).
  if badge.setPhantom then pcall(badge.setPhantom, badge, true) end
  if badge.setFocusable then pcall(badge.setFocusable, badge, false) end
  if badge.setWidth then pcall(badge.setWidth, badge, 22) end
  if badge.setHeight then pcall(badge.setHeight, badge, 12) end
  if badge.setMarginRight then pcall(badge.setMarginRight, badge, 1) end
  if badge.setMarginTop then pcall(badge.setMarginTop, badge, 1) end

  if badge.addAnchor and a.icon.getId then
    local iconId = a.icon:getId()
    if iconId and iconId:len() > 0 then
      pcall(function()
        if badge.breakAnchors then badge:breakAnchors() end
        badge:addAnchor(AnchorRight, iconId, AnchorRight)
        badge:addAnchor(AnchorTop, iconId, AnchorTop)
      end)
    end
  end
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
  local pages = { "pageMenu", "pageGeneral", "pageSpells", "pageHotkeys", "pageScripts", "pageAbout" }
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

  -- Keep icon hotkey badges + disabled visuals in sync.
  for k, a in pairs(DT_ACTIONS) do
    if a and a.icon then
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
  local btnScriptsMenu = dtResolve(dtWindow, "btnScriptsMenu")
  local btnAbout = dtResolve(dtWindow, "btnAbout")

  if btnGeneral then btnGeneral.onClick = function() dtShowPage("pageGeneral") end end
  if btnIcons then btnIcons.onClick = function() dtShowPage("pageHotkeys") end end
  if btnSpellsMenu then btnSpellsMenu.onClick = function() dtShowPage("pageSpells") end end
  if btnScriptsMenu then btnScriptsMenu.onClick = function() dtShowPage("pageScripts") end end
  if btnAbout then btnAbout.onClick = function() dtShowPage("pageAbout") end end

  -- Back buttons
  local backGeneral = dtResolve(dtWindow, "backGeneral")
  local backSpells = dtResolve(dtWindow, "backSpells")
  local backHotkeys = dtResolve(dtWindow, "backHotkeys")
  local backScripts = dtResolve(dtWindow, "backScripts")
  local backAbout = dtResolve(dtWindow, "backAbout")
  if backGeneral then backGeneral.onClick = function() dtShowPage("pageMenu") end end
  if backSpells then backSpells.onClick = function() dtShowPage("pageMenu") end end
  if backHotkeys then backHotkeys.onClick = function() dtShowPage("pageMenu") end end
  if backScripts then backScripts.onClick = function() dtShowPage("pageMenu") end end
  if backAbout then backAbout.onClick = function() dtShowPage("pageMenu") end end

  -- Nav bar (always visible)
  do
    local navMenu = dtResolve(dtWindow, "navMenu")
    local navGeneral = dtResolve(dtWindow, "navGeneral")
    local navSpells = dtResolve(dtWindow, "navSpells")
    local navHotkeys = dtResolve(dtWindow, "navHotkeys")
    local navScripts = dtResolve(dtWindow, "navScripts")
    local navAbout = dtResolve(dtWindow, "navAbout")
    if navMenu then navMenu.onClick = function() dtShowPage("pageMenu") end end
    if navGeneral then navGeneral.onClick = function() dtShowPage("pageGeneral") end end
    if navSpells then navSpells.onClick = function() dtShowPage("pageSpells") end end
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

  -- Scripts viewer (read-only)
  do
    local scriptFile = dtResolve(dtWindow, "scriptFile")
    local scriptLoad = dtResolve(dtWindow, "scriptLoad")
    local scriptContent = dtResolve(dtWindow, "scriptContent")
    local scriptScrollbar = dtResolve(dtWindow, "scriptScrollbar")
    local scriptSearch = dtResolve(dtWindow, "scriptSearch")
    local scriptFind = dtResolve(dtWindow, "scriptFind")
    local scriptNext = dtResolve(dtWindow, "scriptNext")
    local scriptStatus = dtResolve(dtWindow, "scriptStatus")

    local scriptSearchState = { query = "", lastPos = 0 }
    local scriptTextLen = 0

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

    if scriptScrollbar then
      scriptScrollbar.onValueChange = function(_, value)
        if not scriptContent or not scriptContent.setCursorPos then return end
        local v = tonumber(value) or 0
        if v < 0 then v = 0 end
        if v > scriptTextLen then v = scriptTextLen end
        pcall(scriptContent.setCursorPos, scriptContent, v)
      end
    end

    if scriptContent and scriptContent.setEditable then
      pcall(function() scriptContent:setEditable(false) end)
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

    local function loadNow()
      if not scriptContent or not scriptContent.setText then return end
      local rel = scriptFile and scriptFile.getText and scriptFile:getText() or "scripts/druid_toolkit.lua"
      local res = toResourcePath(rel)
      local data, err = readResource(res)
      if not data then
        scriptContent:setText("Failed loading: " .. tostring(rel) .. "\n(" .. tostring(err) .. ")")
        safeSetText(scriptStatus, "Load failed.")
        return
      end
      scriptContent:setText(data)
      syncScriptScrollbar()
      scriptSearchState.lastPos = 0
      safeSetText(scriptStatus, "")
    end

    if scriptLoad then scriptLoad.onClick = loadNow end
    -- Expose for icon context menu (safe no-op if widgets aren't available).
    dtWindow._dtLoadScript = function(rel)
      if scriptFile and scriptFile.setText and type(rel) == "string" then
        scriptFile:setText(rel)
      end
      loadNow()
    end

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
  bindHotkeyRow("ueNonSafe", "ueNonSafeKey", "ueNonSafeSet", "ueNonSafeClear")
  bindHotkeyRow("ueSafe", "ueSafeKey", "ueSafeSet", "ueSafeClear")
  bindHotkeyRow("superSd", "superSdKey", "superSdSet", "superSdClear")
  bindHotkeyRow("superSdFire", "superSdFireKey", "superSdFireSet", "superSdFireClear")
  bindHotkeyRow("superSdHoly", "superSdHolyKey", "superSdHolySet", "superSdHolyClear")
  bindHotkeyRow("sioVip", "sioVipKey", "sioVipSet", "sioVipClear")
  bindHotkeyRow("followToggle", "followToggleKey", "followToggleSet", "followToggleClear")

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

-- Stop CaveBot / TargetBot hotkeys (handled in the main onKeyDown at bottom)

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

-- Register actions for hotkeys + context menu + sync.
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
  ueNonSafe = { keyId = "ueNonSafeKey" },
  ueSafe = { keyId = "ueSafeKey" },
  superSd = { keyId = "superSdKey" },
  superSdFire = { keyId = "superSdFireKey" },
  superSdHoly = { keyId = "superSdHolyKey" },
  sioVip = { keyId = "sioVipKey" },
  follow = { keyId = "followToggleKey" },
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
  dtOpen()
  dtShowPage("pageHotkeys")
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

  if hotkeyMatches("ueNonSafe", keys) then dtToggleAction("ueNonSafe") return end
  if hotkeyMatches("ueSafe", keys) then dtToggleAction("ueSafe") return end
  if hotkeyMatches("superSd", keys) then dtToggleAction("superSd") return end
  if hotkeyMatches("superSdFire", keys) then dtToggleAction("superSdFire") return end
  if hotkeyMatches("superSdHoly", keys) then dtToggleAction("superSdHoly") return end
  if hotkeyMatches("sioVip", keys) then dtToggleAction("sioVip") return end
  if hotkeyMatches("followToggle", keys) then
    if dtGetAction("follow") then
      dtToggleAction("follow")
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

-- Follow is hotkey-driven; keep it off by default.
ultimateFollow.setOn(false)
dtRegisterAction("follow", {
  label = "Follow Leader",
  macro = ultimateFollow,
  icon = nil,
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
