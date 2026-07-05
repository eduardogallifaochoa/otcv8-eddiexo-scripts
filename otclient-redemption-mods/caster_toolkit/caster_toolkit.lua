-- Caster Toolkit (Druid / Sorcerer) para OTClient Redemption (tibia-eddie-retroclientgod)
-- Standalone: no depende del framework de bot de OTCv8 (CaveBot/TargetBot/vBot/macro()),
-- solo usa la API nativa de este client (g_game, g_settings, g_keyboard, Controller).

local SPELL_DEFAULTS = {
    druid = {
        heal = 'exura gran',
        emergencyHeal = 'exura vita',
        haste = 'utani hur',
        cure = 'exana pox'
    },
    sorcerer = {
        heal = 'exura gran',
        emergencyHeal = 'exura gran',
        haste = 'utani hur',
        cure = 'exana pox'
    }
}

local HOTKEY_ACTIONS = { 'healNow', 'emergencyHealNow', 'hasteNow', 'cureNow', 'toggleAutoHeal', 'toggleAutoHaste' }

local HOTKEY_WIDGET_PREFIX = {
    healNow = 'hkHealNow',
    emergencyHealNow = 'hkEmergencyHealNow',
    hasteNow = 'hkHasteNow',
    cureNow = 'hkCureNow',
    toggleAutoHeal = 'hkToggleAutoHeal',
    toggleAutoHaste = 'hkToggleAutoHaste'
}

local DEFAULT_HOTKEYS = {
    healNow = 'F1',
    emergencyHealNow = 'F2',
    hasteNow = 'F3',
    cureNow = 'F4',
    toggleAutoHeal = 'Ctrl+F1',
    toggleAutoHaste = 'Ctrl+F3'
}

-- ---------------------------------------------------------------------------
-- Estado del modulo
-- ---------------------------------------------------------------------------

local window = nil
local topButton = nil
local capturingAction = nil

local settings = {}

local lastHealCast = 0
local lastEmergencyCast = 0
local hasteEvent = nil

CasterToolkitController = Controller:new()

-- ---------------------------------------------------------------------------
-- Persistencia (g_settings)
-- ---------------------------------------------------------------------------

local function loadSettings()
    settings.vocation = g_settings.get('castertoolkit_vocation', 'druid')
    if SPELL_DEFAULTS[settings.vocation] == nil then
        settings.vocation = 'druid'
    end
    local defaults = SPELL_DEFAULTS[settings.vocation]

    settings.autoHealEnabled = g_settings.getBoolean('castertoolkit_autoheal_enabled', false)
    settings.autoHealThreshold = g_settings.getNumber('castertoolkit_autoheal_threshold', 70)
    settings.autoHealSpell = g_settings.get('castertoolkit_autoheal_spell', defaults.heal)
    settings.autoHealCooldown = g_settings.getNumber('castertoolkit_autoheal_cooldown', 1000)

    settings.emergencyEnabled = g_settings.getBoolean('castertoolkit_emergency_enabled', false)
    settings.emergencyThreshold = g_settings.getNumber('castertoolkit_emergency_threshold', 35)
    settings.emergencySpell = g_settings.get('castertoolkit_emergency_spell', defaults.emergencyHeal)
    settings.emergencyCooldown = g_settings.getNumber('castertoolkit_emergency_cooldown', 1000)

    settings.autoHasteEnabled = g_settings.getBoolean('castertoolkit_autohaste_enabled', false)
    settings.autoHasteSpell = g_settings.get('castertoolkit_autohaste_spell', defaults.haste)
    settings.autoHasteInterval = g_settings.getNumber('castertoolkit_autohaste_interval', 4000)

    settings.cureSpell = g_settings.get('castertoolkit_cure_spell', defaults.cure)

    settings.hotkeys = {}
    for _, action in ipairs(HOTKEY_ACTIONS) do
        settings.hotkeys[action] = g_settings.get('castertoolkit_hotkey_' .. action, DEFAULT_HOTKEYS[action])
    end
end

local function saveSettings()
    g_settings.set('castertoolkit_vocation', settings.vocation)

    g_settings.set('castertoolkit_autoheal_enabled', settings.autoHealEnabled)
    g_settings.set('castertoolkit_autoheal_threshold', settings.autoHealThreshold)
    g_settings.set('castertoolkit_autoheal_spell', settings.autoHealSpell)
    g_settings.set('castertoolkit_autoheal_cooldown', settings.autoHealCooldown)

    g_settings.set('castertoolkit_emergency_enabled', settings.emergencyEnabled)
    g_settings.set('castertoolkit_emergency_threshold', settings.emergencyThreshold)
    g_settings.set('castertoolkit_emergency_spell', settings.emergencySpell)
    g_settings.set('castertoolkit_emergency_cooldown', settings.emergencyCooldown)

    g_settings.set('castertoolkit_autohaste_enabled', settings.autoHasteEnabled)
    g_settings.set('castertoolkit_autohaste_spell', settings.autoHasteSpell)
    g_settings.set('castertoolkit_autohaste_interval', settings.autoHasteInterval)

    g_settings.set('castertoolkit_cure_spell', settings.cureSpell)

    for _, action in ipairs(HOTKEY_ACTIONS) do
        g_settings.set('castertoolkit_hotkey_' .. action, settings.hotkeys[action])
    end

    g_settings.save()
end

-- ---------------------------------------------------------------------------
-- Casting helpers
-- ---------------------------------------------------------------------------

local function say(text)
    if not text or text == '' then
        return
    end
    if not g_game.isOnline() then
        return
    end
    g_game.talk(text)
end

local function canCast(lastCastTime, cooldown)
    return g_clock.millis() - lastCastTime >= (cooldown or 1000)
end

local function castHealNow()
    say(settings.autoHealSpell)
end

local function castEmergencyHealNow()
    say(settings.emergencySpell)
end

local function castHasteNow()
    say(settings.autoHasteSpell)
end

local function castCureNow()
    say(settings.cureSpell)
end

-- ---------------------------------------------------------------------------
-- Auto Heal / Emergency Heal (disparado por onHealthChange, cooldown-safe)
-- ---------------------------------------------------------------------------

local function onHealthChange(player, health, maxHealth)
    if not settings.autoHealEnabled and not settings.emergencyEnabled then
        return
    end
    if not health or not maxHealth or maxHealth <= 0 then
        return
    end

    local hpPercent = math.floor((health * 100) / maxHealth)

    if settings.emergencyEnabled and hpPercent <= settings.emergencyThreshold then
        if canCast(lastEmergencyCast, settings.emergencyCooldown) then
            say(settings.emergencySpell)
            lastEmergencyCast = g_clock.millis()
            lastHealCast = lastEmergencyCast
        end
        return
    end

    if settings.autoHealEnabled and hpPercent <= settings.autoHealThreshold then
        if canCast(lastHealCast, settings.autoHealCooldown) then
            say(settings.autoHealSpell)
            lastHealCast = g_clock.millis()
        end
    end
end

-- ---------------------------------------------------------------------------
-- Auto Haste (loop por intervalo, independiente del HP)
-- ---------------------------------------------------------------------------

local function stopAutoHaste()
    if hasteEvent then
        removeEvent(hasteEvent)
        hasteEvent = nil
    end
end

local function startAutoHaste()
    stopAutoHaste()
    if not settings.autoHasteEnabled then
        return
    end
    hasteEvent = cycleEvent(function()
        say(settings.autoHasteSpell)
    end, math.max(1000, settings.autoHasteInterval))
end

-- ---------------------------------------------------------------------------
-- Toggles (usados por hotkeys y por el checkbox de la UI)
-- ---------------------------------------------------------------------------

local function toggleAutoHeal()
    settings.autoHealEnabled = not settings.autoHealEnabled
    if window then
        window.autoHealEnabled:setChecked(settings.autoHealEnabled)
    end
    saveSettings()
end

local function toggleAutoHaste()
    settings.autoHasteEnabled = not settings.autoHasteEnabled
    if window then
        window.hasteEnabled:setChecked(settings.autoHasteEnabled)
    end
    startAutoHaste()
    saveSettings()
end

local HOTKEY_CALLBACKS = {
    healNow = castHealNow,
    emergencyHealNow = castEmergencyHealNow,
    hasteNow = castHasteNow,
    cureNow = castCureNow,
    toggleAutoHeal = toggleAutoHeal,
    toggleAutoHaste = toggleAutoHaste
}

-- ---------------------------------------------------------------------------
-- Hotkeys (bind/unbind reales sobre g_keyboard)
-- ---------------------------------------------------------------------------

local function unbindHotkey(action)
    local keyCombo = settings.hotkeys[action]
    if not keyCombo or keyCombo == '' then
        return
    end
    pcall(function()
        g_keyboard.unbindKeyPress(keyCombo, HOTKEY_CALLBACKS[action])
    end)
end

local function bindHotkey(action)
    local keyCombo = settings.hotkeys[action]
    if not keyCombo or keyCombo == '' then
        return
    end
    local ok = pcall(function()
        g_keyboard.bindKeyPress(keyCombo, HOTKEY_CALLBACKS[action])
    end)
    if not ok then
        print('[CasterToolkit] No se pudo bindear el hotkey de ' .. action .. ': ' .. tostring(keyCombo))
    end
end

local function bindAllHotkeys()
    for _, action in ipairs(HOTKEY_ACTIONS) do
        bindHotkey(action)
    end
end

local function unbindAllHotkeys()
    for _, action in ipairs(HOTKEY_ACTIONS) do
        unbindHotkey(action)
    end
end

-- ---------------------------------------------------------------------------
-- Captura de hotkeys desde la UI (Set / Clear), estilo client_options/keybins.lua
-- ---------------------------------------------------------------------------

function startCapture(action)
    if not window then
        return
    end
    capturingAction = action
    local widgetId = HOTKEY_WIDGET_PREFIX[action] .. 'Current'
    window[widgetId]:setText(tr('Presiona una tecla...'))
    window:grabKeyboard()
end

function onWindowKeyDown(widget, keyCode, keyboardModifiers)
    if not capturingAction then
        return false
    end

    local action = capturingAction
    capturingAction = nil
    window:ungrabKeyboard()

    local widgetId = HOTKEY_WIDGET_PREFIX[action] .. 'Current'

    if keyCode == KeyEscape then
        window[widgetId]:setText(settings.hotkeys[action] ~= '' and settings.hotkeys[action] or tr('Ninguna'))
        return true
    end

    local keyCombo = determineKeyComboDesc(keyCode, keyboardModifiers)

    unbindHotkey(action)
    settings.hotkeys[action] = keyCombo
    bindHotkey(action)
    window[widgetId]:setText(keyCombo)
    saveSettings()

    return true
end

function clearHotkey(action)
    unbindHotkey(action)
    settings.hotkeys[action] = ''
    if window then
        window[HOTKEY_WIDGET_PREFIX[action] .. 'Current']:setText(tr('Ninguna'))
    end
    saveSettings()
end

-- ---------------------------------------------------------------------------
-- Sincronizacion UI <-> settings
-- ---------------------------------------------------------------------------

local function refreshWindowFromSettings()
    if not window then
        return
    end

    window.vocationCombo:setCurrentOptionByData(settings.vocation)

    window.autoHealEnabled:setChecked(settings.autoHealEnabled)
    window.autoHealThreshold:setValue(settings.autoHealThreshold)
    window.autoHealSpell:setText(settings.autoHealSpell)
    window.autoHealCooldown:setValue(settings.autoHealCooldown)

    window.emergencyEnabled:setChecked(settings.emergencyEnabled)
    window.emergencyThreshold:setValue(settings.emergencyThreshold)
    window.emergencySpell:setText(settings.emergencySpell)
    window.emergencyCooldown:setValue(settings.emergencyCooldown)

    window.hasteEnabled:setChecked(settings.autoHasteEnabled)
    window.autoHasteSpell:setText(settings.autoHasteSpell)
    window.autoHasteInterval:setValue(settings.autoHasteInterval)

    window.cureSpell:setText(settings.cureSpell)

    for _, action in ipairs(HOTKEY_ACTIONS) do
        local key = settings.hotkeys[action]
        window[HOTKEY_WIDGET_PREFIX[action] .. 'Current']:setText(key ~= '' and key or tr('Ninguna'))
    end
end

function onSave()
    if not window then
        return
    end

    settings.vocation = window.vocationCombo:getCurrentOption().data

    settings.autoHealEnabled = window.autoHealEnabled:isChecked()
    settings.autoHealThreshold = window.autoHealThreshold:getValue()
    settings.autoHealSpell = window.autoHealSpell:getText()
    settings.autoHealCooldown = window.autoHealCooldown:getValue()

    settings.emergencyEnabled = window.emergencyEnabled:isChecked()
    settings.emergencyThreshold = window.emergencyThreshold:getValue()
    settings.emergencySpell = window.emergencySpell:getText()
    settings.emergencyCooldown = window.emergencyCooldown:getValue()

    settings.autoHasteEnabled = window.hasteEnabled:isChecked()
    settings.autoHasteSpell = window.autoHasteSpell:getText()
    settings.autoHasteInterval = window.autoHasteInterval:getValue()

    settings.cureSpell = window.cureSpell:getText()

    saveSettings()
    startAutoHaste()
end

function onResetSpells()
    if not window then
        return
    end
    local vocation = window.vocationCombo:getCurrentOption().data
    local defaults = SPELL_DEFAULTS[vocation]

    window.autoHealSpell:setText(defaults.heal)
    window.emergencySpell:setText(defaults.emergencyHeal)
    window.autoHasteSpell:setText(defaults.haste)
    window.cureSpell:setText(defaults.cure)
end

function toggle()
    if not window then
        return
    end

    if window:isVisible() then
        window:hide()
        if topButton then
            topButton:setOn(false)
        end
    else
        refreshWindowFromSettings()
        window:show()
        window:raise()
        window:focus()
        if topButton then
            topButton:setOn(true)
        end
    end
end

-- ---------------------------------------------------------------------------
-- Lifecycle del Controller (evento de HP atado a la sesion de juego)
-- ---------------------------------------------------------------------------

function CasterToolkitController:onGameStart()
    self:registerEvents(LocalPlayer, {
        onHealthChange = onHealthChange
    })
end

-- ---------------------------------------------------------------------------
-- Entry points del .otmod
-- ---------------------------------------------------------------------------

function init()
    loadSettings()

    window = g_ui.displayUI('caster_toolkit')
    window:hide()
    connect(window, {
        onKeyDown = onWindowKeyDown
    })

    window.vocationCombo:addOption('Druid', 'druid')
    window.vocationCombo:addOption('Sorcerer', 'sorcerer')

    topButton = modules.client_topmenu.addTopRightToggleButton('casterToolkitButton', tr('Caster Toolkit'),
        '/images/topbuttons/bot', toggle)

    bindAllHotkeys()
    startAutoHaste()

    -- Los widgets dentro del ScrollablePanel todavia no estan indexados en el
    -- mismo tick en que se crea la ventana (patron comun en este client, ver
    -- addEvent en UISpinBox:onStyleApply), asi que se difiere un tick.
    addEvent(function()
        if not window then
            return
        end
        window.saveButton.onClick = onSave
        window.resetSpellsButton.onClick = onResetSpells
        refreshWindowFromSettings()
    end)

    CasterToolkitController:init()
end

function terminate()
    CasterToolkitController:terminate()

    stopAutoHaste()
    unbindAllHotkeys()

    if topButton then
        topButton:destroy()
        topButton = nil
    end

    if window then
        disconnect(window, {
            onKeyDown = onWindowKeyDown
        })
        window:destroy()
        window = nil
    end
end
