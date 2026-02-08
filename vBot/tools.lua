-- tools tab
setDefaultTab("Tools")

UI.Separator()

if storage.mwallScrollDown == nil then
  storage.mwallScrollDown = true
end

if type(storage.mwallScrollDownHotkey) ~= "string" or storage.mwallScrollDownHotkey:len() == 0 then
  storage.mwallScrollDownHotkey = "F8"
end

if type(storage.mwallScrollDownRuneId) ~= "number" or storage.mwallScrollDownRuneId < 100 then
  storage.mwallScrollDownRuneId = 3180 -- Magic Wall rune
end

-- Ephemeral state; don't persist across reloads.
storage.mwallScrollDownCapturingHotkey = false

local mwUi = setupUI([[
Panel
  height: 36

  Label
    id: label
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    text: MW ScrollDown
    width: 95

  Button
    id: hotkey
    anchors.left: label.right
    anchors.right: toggle.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-right: 4
    height: 17
    text: HK: F8

  Button
    id: toggle
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 45
    height: 17
    text: On

  Label
    id: runeLabel
    anchors.left: parent.left
    anchors.top: label.bottom
    margin-top: 2
    text: Rune ID:
    width: 55

  TextEdit
    id: runeId
    anchors.left: runeLabel.right
    anchors.right: mwPreset.left
    anchors.top: runeLabel.top
    margin-left: 4
    margin-right: 4
    height: 17
    text-align: center

  Button
    id: mwPreset
    anchors.right: wgPreset.left
    anchors.top: runeLabel.top
    margin-right: 4
    width: 30
    height: 17
    text: MW

  Button
    id: wgPreset
    anchors.right: parent.right
    anchors.top: runeLabel.top
    width: 30
    height: 17
    text: WG
]])

local function refreshMwToggleVisual()
  mwUi.toggle:setText(storage.mwallScrollDown and "On" or "Off")
  if mwUi.toggle.setBackgroundColor then
    mwUi.toggle:setBackgroundColor(storage.mwallScrollDown and "#00c000" or "#c00000")
  end
  if mwUi.toggle.setColor then mwUi.toggle:setColor("#ffffff") end
end
refreshMwToggleVisual()

mwUi.toggle.onClick = function(widget)
  storage.mwallScrollDown = not storage.mwallScrollDown
  refreshMwToggleVisual()
end

local function refreshMwHotkeyText()
  mwUi.hotkey:setText("HK: " .. (storage.mwallScrollDownHotkey or ""))
end
refreshMwHotkeyText()

mwUi.hotkey.onClick = function(widget)
  storage.mwallScrollDownCapturingHotkey = true
  widget:setText("Press key...")
end

mwUi.runeId:setText(tostring(storage.mwallScrollDownRuneId))
mwUi.runeId.onTextChange = function(widget, text)
  local n = tonumber(text)
  if not n then
    widget:setText(tostring(storage.mwallScrollDownRuneId))
    return
  end
  storage.mwallScrollDownRuneId = n
end

mwUi.mwPreset.onClick = function()
  storage.mwallScrollDownRuneId = 3180
  mwUi.runeId:setText("3180")
end

mwUi.wgPreset.onClick = function()
  storage.mwallScrollDownRuneId = 3156
  mwUi.runeId:setText("3156")
end

-- Allow scripts to keep the button label in sync when toggled via hotkey.
vBotMWScrollDownToggleButton = mwUi.toggle
vBotMWScrollDownHotkeyButton = mwUi.hotkey

onKeyDown(function(keys)
  if not storage.mwallScrollDownCapturingHotkey then return end
  -- Avoid capturing the mouse wheel as a hotkey.
  if keys == "MouseWheelDown" or keys == "WheelDown" or keys == "ScrollDown" or
     keys == "MouseWheelUp" or keys == "WheelUp" or keys == "ScrollUp" then
    return
  end

  storage.mwallScrollDownCapturingHotkey = false
  if keys == "Escape" then
    refreshMwHotkeyText()
    return
  end

  storage.mwallScrollDownHotkey = keys
  refreshMwHotkeyText()
end)

UI.Separator()
