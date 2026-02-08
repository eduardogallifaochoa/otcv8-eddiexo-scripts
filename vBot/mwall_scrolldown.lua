-- Magic Wall on scroll-down (style inspired by the PvP scripts pack).
-- Cast MW on the tile under the cursor when scrolling down.
-- Toggle via Tools UI or: storage.mwallScrollDown = true/false (persisted).

local MIN_DELAY_MS = 250

local lastUse = 0
local lastToggle = 0

if storage.mwallScrollDown == nil then
  storage.mwallScrollDown = true
end

if type(storage.mwallScrollDownHotkey) ~= "string" or storage.mwallScrollDownHotkey:len() == 0 then
  storage.mwallScrollDownHotkey = "F8"
end

if type(storage.mwallScrollDownRuneId) ~= "number" or storage.mwallScrollDownRuneId < 100 then
  storage.mwallScrollDownRuneId = 3180
end

local function isWheelDownKey(keys)
  return keys == "MouseWheelDown" or keys == "WheelDown" or keys == "ScrollDown"
end

local function castMwOnTile(tile)
  if not tile then return end
  if isInPz() then return end
  if not tile:canShoot() or not tile:isWalkable() then return end
  -- Avoid wasting rune if there's already a MW on the tile (same check used in extras.lua).
  local top = tile:getTopUseThing()
  if top and top:getId() == 2130 then return end
  local runeId = tonumber(storage.mwallScrollDownRuneId) or 3180
  useWith(runeId, top or tile)
end

local function handleWheelDown()
  castMwOnTile(getTileUnderCursor())
end

-- Prefer mouse wheel event on the map panel (most reliable), but keep key fallback.
do
  local mapPanel = modules.game_interface and modules.game_interface.getMapPanel and modules.game_interface.getMapPanel()
  if mapPanel then
    local prev = mapPanel.onMouseWheel
    mapPanel.onMouseWheel = function(widget, mousePos, dir)
      if not storage.mwallScrollDown then
        return prev and prev(widget, mousePos, dir)
      end
      if now - lastUse < MIN_DELAY_MS then
        return prev and prev(widget, mousePos, dir)
      end

      if dir == 2 then
        lastUse = now
        handleWheelDown()
        return true
      end

      return prev and prev(widget, mousePos, dir)
    end
  end
end

onKeyDown(function(keys)
  if storage.mwallScrollDownCapturingHotkey then return end
  if keys == storage.mwallScrollDownHotkey then
    if now - lastToggle < 300 then return end
    lastToggle = now
    storage.mwallScrollDown = not storage.mwallScrollDown
    if vBotMWScrollDownToggleButton then
      vBotMWScrollDownToggleButton:setText(storage.mwallScrollDown and "On" or "Off")
      if vBotMWScrollDownToggleButton.setBackgroundColor then
        vBotMWScrollDownToggleButton:setBackgroundColor(storage.mwallScrollDown and "#00c000" or "#c00000")
      end
      if vBotMWScrollDownToggleButton.setColor then vBotMWScrollDownToggleButton:setColor("#ffffff") end
    end
    return
  end

  if not storage.mwallScrollDown then return end
  if not isWheelDownKey(keys) then return end
  if now - lastUse < MIN_DELAY_MS then return end
  lastUse = now
  return handleWheelDown()
end)
