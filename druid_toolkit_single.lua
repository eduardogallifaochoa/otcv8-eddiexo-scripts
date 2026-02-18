-- AUTO-GENERATED FILE. DO NOT EDIT BY HAND.
-- Build command:
--   powershell -ExecutionPolicy Bypass -File tools/build_druid_toolkit_single.ps1
--
-- Portable single-file Druid Toolkit:
-- 1) Copy this file into any bot profile folder.
-- 2) Run from Ingame Script Editor with:
--    dofile('druid_toolkit_single.lua')

__druid_toolkit_otui_inline = [==[
DtHelpButton < Button
  width: 22
  height: 20
  text: ?
  font: verdana-11px-rounded
  color: #ffffff
  text-align: center
  background-color: #00000088
  border-width: 1
  border-color: #ffffff44

  $hover:
    background-color: #000000aa
    border-color: #ffffff88
DtNavButton < Button
  font: verdana-11px-rounded
  color: #e6e6e6
  background-color: #ffffff12
  border-width: 1
  border-color: #ffffff26

  $hover:
    background-color: #ffffff18

DtCard < Panel
  padding: 10
  image-source: /images/ui/panel_flat
  image-border: 6
  background-color: #00000066
  border-width: 1
  border-color: #ffffff22

DtCardScroll < ScrollablePanel
  padding: 10
  image-source: /images/ui/panel_flat
  image-border: 6
  background-color: #00000066
  border-width: 1
  border-color: #ffffff22

DtHotkeyBadge < Label
  background-color: alpha
  font: terminus-10px
  color: #ffffff
  text-align: center
  text-offset: 1 0
  focusable: false
  anchors.right: parent.right
  anchors.top: parent.top
  margin-right: 1
  margin-top: 1


DruidToolkitSetupWindow < MainWindow
  id: dtSetupWindow
  !text: tr('Druid Toolkit')
  size: 920 600
  padding: 12
  draggable: true
  @onEscape: self:hide()

  Panel
    id: content
    anchors.fill: parent
    padding: 10

    Label
      id: header
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 20
      text-align: center
      text: [Setup]
      font: verdana-11px-rounded
      color: #ffaa00

    HorizontalSeparator
      id: sepTop
      anchors.top: header.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 6

    Panel
      id: navBar
      anchors.top: sepTop.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 22
      margin-top: 8
      padding: 3
      image-source: /images/ui/panel_flat
      image-border: 6
      background-color: #00000055
      border-width: 1
      border-color: #ffffff22
      layout:
        type: horizontalBox
        fit-children: false
        spacing: 0

      DtNavButton
        id: navMenu
        width: 70
        height: 20
        text: Menu
        margin-right: 6

      DtNavButton
        id: navGeneral
        width: 80
        height: 20
        text: General
        margin-right: 6

      DtNavButton
        id: navSpells
        width: 70
        height: 20
        text: Spells
        margin-right: 6

      DtNavButton
        id: navModules
        width: 80
        height: 20
        text: Modules
        margin-right: 6

      DtNavButton
        id: navHotkeys
        width: 110
        height: 20
        text: Icon Hotkeys
        margin-right: 6

      DtNavButton
        id: navScripts
        width: 70
        height: 20
        text: Scripts

      DtNavButton
        id: navAbout
        width: 70
        height: 20
        text: About


      DtHelpButton
        id: navHelp
        width: 22
        height: 20
        text: ?
        tooltip: Quick setup tab navigation.
    Panel
      id: pages
      anchors.top: navBar.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: sepBottom.top
      margin-top: 10
      margin-bottom: 10

      Panel
        id: pageMenu
        anchors.fill: parent

        Label
          id: menuLeftTitle
          anchors.top: parent.top
          anchors.left: parent.left
          width: 300
          text-align: center
          text: Shortcuts
          font: verdana-11px-rounded
          color: #ffffff


        DtHelpButton
          id: menuLeftHelp
          anchors.left: menuLeftTitle.right
          anchors.verticalCenter: menuLeftTitle.verticalCenter
          margin-left: 6
          width: 22
          height: 20
          text: ?
          tooltip: Atajos rapidos a las secciones mas usadas.
        Label
          id: menuRightTitle
          anchors.top: parent.top
          anchors.right: parent.right
          width: 300
          text-align: center
          text: Settings
          font: verdana-11px-rounded
          color: #ffffff


        DtHelpButton
          id: menuRightHelp
          anchors.right: parent.right
          anchors.verticalCenter: menuRightTitle.verticalCenter
          width: 22
          height: 20
          text: ?
          tooltip: General toolkit settings.
        DtCard
          id: menuLeft
          anchors.top: menuLeftTitle.bottom
          anchors.left: parent.left
          anchors.bottom: parent.bottom
          width: 300
          margin-top: 12
          layout:
            type: verticalBox
            fit-children: false
            spacing: 10

          Button
            id: btnIcons
            height: 34
            text: Icon Hotkeys

          DtHelpButton
            id: btnIconsHelp
            height: 18
            tooltip: Open Icon Hotkeys to assign keys and icon settings.

          Button
            id: btnSpellsMenu
            height: 34
            text: Spells

          DtHelpButton
            id: btnSpellsMenuHelp
            height: 18
            tooltip: Open Spells to configure spell values.

          Button
            id: btnModules
            height: 34
            text: Modules

          DtHelpButton
            id: btnModulesHelp
            height: 18
            tooltip: Open Modules for toggles, hotkeys, and Open Script.

          Button
            id: btnScriptsMenu
            height: 34
            text: Scripts

          DtHelpButton
            id: btnScriptsMenuHelp
            height: 18
            tooltip: Open Scripts viewer with search.

        DtCard
          id: menuRight
          anchors.top: menuRightTitle.bottom
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          width: 300
          margin-top: 12
          layout:
            type: verticalBox
            fit-children: false
            spacing: 10

          Button
            id: btnGeneral
            height: 34
            text: General

          DtHelpButton
            id: btnGeneralHelp
            height: 18
            tooltip: Open global toolkit settings.

          Button
            id: btnAbout
            height: 34
            text: About

          DtHelpButton
            id: btnAboutHelp
            height: 18
            tooltip: Open project and repository info.

      Panel
        id: pageGeneral
        anchors.fill: parent

        Label
          id: generalTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [General]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backGeneral
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backGeneralHelp
          anchors.left: backGeneral.right
          anchors.verticalCenter: backGeneral.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        DtCardScroll
          id: generalScroll
          anchors.top: generalTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 12
          margin-left: 8
          margin-right: 8
          margin-bottom: 26
          layout:
            type: verticalBox
            fit-children: false
            spacing: 8

          Panel
            id: rowEnabled
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Toolkit Enabled
              width: 170

            BotSwitch
              id: enabledSwitch
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 100
              text-align: center
              text: Enabled


            DtHelpButton
              id: enabledHelp
              anchors.right: enabledSwitch.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Prende/apaga TODO el Druid Toolkit.
          Panel
            id: rowHideEffects
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Hide Effects
              width: 170

            BotSwitch
              id: hideEffectsSwitch
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 100
              text-align: center
              text: On


            DtHelpButton
              id: hideEffectsHelp
              anchors.right: hideEffectsSwitch.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hide visual effects.
          Panel
            id: rowHideTexts
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Hide Orange Texts
              width: 170

            BotSwitch
              id: hideTextsSwitch
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 100
              text-align: center
              text: On


            DtHelpButton
              id: hideTextsHelp
              anchors.right: hideTextsSwitch.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hide orange floating texts.
          Panel
            id: rowStopKey
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Stop CaveBot Key
              width: 170

            DtHelpButton
              id: stopCaveHelp
              anchors.right: stopCaveKey.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to pause/resume CaveBot. Example: Pause or F10.

            TextEdit
              id: stopCaveKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 140
              height: 20
              tooltip: Hotkey to pause/resume only CaveBot (example: Pause).

          Panel
            id: rowStopTargetKey
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Stop TargetBot Key
              width: 170

            DtHelpButton
              id: stopTargetHelp
              anchors.right: stopTargetKey.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to pause/resume TargetBot. Example: Pause or F11.

            TextEdit
              id: stopTargetKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 140
              height: 20
              tooltip: Hotkey to pause/resume only TargetBot (example: Pause).

          Panel
            id: rowToolkitToggleKey
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Toolkit Toggle Key
              width: 170

            DtHelpButton
              id: toolkitToggleHelp
              anchors.right: toolkitToggleKey.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Global hotkey to enable/disable the whole toolkit (example: F12).

            TextEdit
              id: toolkitToggleKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 140
              height: 20
              tooltip: Hotkey global del toolkit (ej: F12).

          Panel
            id: rowFollowToggleGeneralKey
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Follow Toggle Key
              width: 170

            DtHelpButton
              id: followToggleGeneralHelp
              anchors.right: followToggleGeneralKey.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Follow Leader.

            TextEdit
              id: followToggleGeneralKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 140
              height: 20
              tooltip: Hotkey to toggle Follow Leader.

          Panel
            id: rowFollowLeader
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Follow Leader
              width: 170

            DtHelpButton
              id: followLeaderHelp
              anchors.right: followLeader.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Enter exact leader name to follow (example: Ada Wong).

            TextEdit
              id: followLeader
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 220
              height: 20
              tooltip: Nombre del player a seguir (Follow macro).


          Panel
            id: rowLeaderTargetName
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Leader Target Name
              width: 170

            DtHelpButton
              id: leaderTargetNameHelp
              anchors.right: leaderTargetName.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Player name used by Leader Target Assist missile detection.

            TextEdit
              id: leaderTargetName
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 220
              height: 20
              tooltip: Exact leader name for Leader Target Assist.

          Panel
            id: rowLeaderTargetCooldown
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Leader Target CD (ms)
              width: 170

            DtHelpButton
              id: leaderTargetCooldownHelp
              anchors.right: leaderTargetCooldown.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Minimum milliseconds between target switches (anti-flicker).

            TextEdit
              id: leaderTargetCooldown
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 140
              height: 20
              tooltip: Switch cooldown in milliseconds (example: 200).

      Panel
        id: pageSpells
        anchors.fill: parent

        Label
          id: spellsTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [Spells]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backSpells
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backSpellsHelp
          anchors.left: backSpells.right
          anchors.verticalCenter: backSpells.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        DtCardScroll
          id: spellsScroll
          anchors.top: spellsTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 12
          margin-left: 8
          margin-right: 8
          margin-bottom: 26
          layout:
            type: verticalBox
            fit-children: false
            spacing: 8

          Panel
            id: rowUeSpell
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: UE Spell
              width: 170

            DtHelpButton
              id: ueSpellHelp
              anchors.right: ueSpell.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Enter the exact UE spell (example: exevo gran mas frigo).

            TextEdit
              id: ueSpell
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 360
              height: 20
              font: terminus-10px
              tooltip: El texto exacto del UE (ej: exevo gran mas frigo).

          Panel
            id: rowUeRepeat
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: UE Cast Count
              width: 170

            TextEdit
              id: ueRepeat
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 80
              height: 20
              font: terminus-10px
              tooltip: How many times UE is cast per activation.

            DtHelpButton
              id: ueRepeatHelp
              anchors.right: ueRepeat.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 24
              height: 20
              text-align: center
              text: ?
              color: #cccccc
              background-color: #00000066
              border-width: 1
              border-color: #ffffff22
              focusable: true
              tooltip: Cuantas veces se dice el UE cuando se activa (SAFE/NS).

          Panel
            id: rowAntiParalyze
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Anti Paralyze
              width: 170

            DtHelpButton
              id: antiParalyzeSpellHelp
              anchors.right: antiParalyzeSpell.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Spell para quitar paralyze cuando estas paralizado.

            TextEdit
              id: antiParalyzeSpell
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 360
              height: 20
              font: terminus-10px
              tooltip: Spell to remove paralyze (cast only while paralyzed).

          Panel
            id: rowHaste
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Auto Haste
              width: 170

            DtHelpButton
              id: hasteSpellHelp
              anchors.right: hasteSpell.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Haste spell when haste is not active.

            TextEdit
              id: hasteSpell
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 360
              height: 20
              font: terminus-10px
              tooltip: Haste spell (cast only if haste is missing).

          Panel
            id: rowHealSpell
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Auto Heal Spell
              width: 170

            DtHelpButton
              id: healSpellHelp
              anchors.right: healSpell.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: Heal spell used when HP% <= Auto Heal %.

            TextEdit
              id: healSpell
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 360
              height: 20
              font: terminus-10px
              tooltip: Heal spell (cast when HP% <= Auto Heal %).
          Panel
            id: rowHealPct
            height: 22

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Auto Heal %
              width: 170

            DtHelpButton
              id: healPercentHelp
              anchors.right: healPercent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 22
              text: ?
              tooltip: HP percent threshold that triggers Auto Heal.

            TextEdit
              id: healPercent
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 80
              height: 20
              font: terminus-10px
              tooltip: HP percent threshold that triggers Auto Heal (example: 95).

          Panel
            id: rowMwScrollSpell
            height: 28

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: MW ScrollDown
              width: 170

            BotSwitch
              id: mwScrollSpellSwitch
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            DtHelpButton
              id: mwScrollSpellHelp
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 401
              width: 22
              height: 22
              text: ?
              tooltip: ON enables WheelDown/hotkey casting. Mode buttons below can still cast once manually.

            TextEdit
              id: mwScrollSpellKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 245
              width: 150
              height: 22
              font: terminus-10px
              tooltip: Hotkey to toggle MW ScrollDown ON/OFF (example: F12).

            Button
              id: mwScrollSpellClear
              anchors.right: mwScrollSpellSwitch.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 55
              height: 22
              text: Clear

            Button
              id: mwScrollSpellSet
              anchors.right: mwScrollSpellClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: mwScrollSpellOpen
              anchors.right: mwScrollSpellSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open


          Panel
            id: rowMwScrollTarget
            height: 28

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: MW/WG Cast Mode
              width: 170

            DtHelpButton
              id: mwScrollTargetHelp
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 419
              width: 22
              height: 22
              text: ?
              tooltip: Select what to cast/check. Magic Wall and Wild Growth also cast once when clicked.

            Button
              id: mwScrollModeMW
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 313
              width: 100
              height: 22
              text: Magic Wall
              tooltip: Use Magic Wall (rune 3180, block check 2128). Click to cast once.

            Button
              id: mwScrollModeWG
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 209
              width: 100
              height: 22
              text: Wild Growth
              tooltip: Use Wild Growth (rune 3156, block check 2130). Click to cast once.

            Button
              id: mwScrollModeCustom
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 127
              width: 78
              height: 22
              text: Custom ID
              tooltip: Use the Custom rune ID from the field at the right. Click to cast once.

            TextEdit
              id: mwScrollCustomId
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 120
              height: 22
              font: terminus-10px
              text: 2128
              tooltip: Custom rune item ID used in Custom mode (example: 3156).

          Panel
            id: rowMwHoldMark
            height: 28

            Label
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Hold Mark Key
              width: 170

            DtHelpButton
              id: mwHoldMarkHelp
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 209
              width: 22
              height: 22
              text: ?
              tooltip: Key used to mark tiles for Hold (short press mark/unmark, hold 2.5s clear all). Example: .

            TextEdit
              id: mwHoldMarkKey
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 180
              height: 22
              font: terminus-10px
              tooltip: Hold mark key (example: . or F9).

      Panel
        id: pageModules
        anchors.fill: parent

        Label
          id: modulesTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [Modules]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backModules
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backModulesHelp
          anchors.left: backModules.right
          anchors.verticalCenter: backModules.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        Label
          id: modulesHint
          anchors.top: modulesTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          margin-top: 8
          height: 16
          text-align: center
          text: Toggle modules + assign hotkeys (chat-safe).
          color: #cccccc


        DtHelpButton
          id: modulesHintHelp
          anchors.right: parent.right
          anchors.verticalCenter: modulesHint.verticalCenter
          margin-right: 8
          width: 22
          height: 18
          text: ?
          tooltip: In Modules you can toggle modules, assign hotkeys, and open each script.
        DtCardScroll
          id: modulesScroll
          anchors.top: modulesHint.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 12
          margin-left: 8
          margin-right: 8
          margin-bottom: 26
          layout:
            type: verticalBox
            fit-children: false
            spacing: 10

          Panel
            id: rowModAntiParalyze
            height: 28

            BotSwitch
              id: modAntiParalyzeSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modAntiParalyzeSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Anti Paralyze

            DtHelpButton
              id: modAntiParalyzeHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Anti Paralyze. Example: F1.

            TextEdit
              id: modAntiParalyzeKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modAntiParalyzeClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modAntiParalyzeSet
              anchors.right: modAntiParalyzeClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modAntiParalyzeOpen
              anchors.right: modAntiParalyzeSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModAutoHaste
            height: 28

            BotSwitch
              id: modAutoHasteSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modAutoHasteSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Auto Haste

            DtHelpButton
              id: modAutoHasteHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Auto Haste. Example: F2.

            TextEdit
              id: modAutoHasteKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modAutoHasteClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modAutoHasteSet
              anchors.right: modAutoHasteClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modAutoHasteOpen
              anchors.right: modAutoHasteSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModAutoHeal
            height: 28

            BotSwitch
              id: modAutoHealSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modAutoHealSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Auto Heal

            DtHelpButton
              id: modAutoHealHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Auto Heal. Example: F3.

            TextEdit
              id: modAutoHealKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modAutoHealClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modAutoHealSet
              anchors.right: modAutoHealClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modAutoHealOpen
              anchors.right: modAutoHealSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModRingSwap
            height: 28

            BotSwitch
              id: modRingSwapSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modRingSwapSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Ring Swap (Immortal)
              tooltip: Energy Ring ID = 3051 | Normal Ring ID = 3006.

            DtHelpButton
              id: modRingSwapHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Ring Swap (Immortal).

            TextEdit
              id: modRingSwapKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modRingSwapClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modRingSwapSet
              anchors.right: modRingSwapClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modRingSwapOpen
              anchors.right: modRingSwapSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModMagicWall
            height: 28

            BotSwitch
              id: modMagicWallSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modMagicWallSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Wall Hold (MW/WG)

            DtHelpButton
              id: modMagicWallHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Wall Hold (cast follows MW/WG mode from Spells).

            TextEdit
              id: modMagicWallKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modMagicWallClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modMagicWallSet
              anchors.right: modMagicWallClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modMagicWallOpen
              anchors.right: modMagicWallSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open


          Panel
            id: rowModManaPot
            height: 28

            BotSwitch
              id: modManaPotSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modManaPotSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Faster Mana Potting

            DtHelpButton
              id: modManaPotHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Faster Mana Potting.

            TextEdit
              id: modManaPotKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modManaPotClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modManaPotSet
              anchors.right: modManaPotClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modManaPotOpen
              anchors.right: modManaPotSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModCutWg
            height: 28

            BotSwitch
              id: modCutWgSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modCutWgSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Auto Cut Wild Growth

            DtHelpButton
              id: modCutWgHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Auto Cut Wild Growth.

            TextEdit
              id: modCutWgKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modCutWgClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modCutWgSet
              anchors.right: modCutWgClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modCutWgOpen
              anchors.right: modCutWgSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModStamina
            height: 28

            BotSwitch
              id: modStaminaSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modStaminaSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Stamina Item

            DtHelpButton
              id: modStaminaHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Stamina Item.

            TextEdit
              id: modStaminaKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modStaminaClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modStaminaSet
              anchors.right: modStaminaClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modStaminaOpen
              anchors.right: modStaminaSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

          Panel
            id: rowModSpellwand
            height: 28

            BotSwitch
              id: modSpellwandSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modSpellwandSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Spellwand

            DtHelpButton
              id: modSpellwandHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey to toggle Spellwand.

            TextEdit
              id: modSpellwandKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modSpellwandClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modSpellwandSet
              anchors.right: modSpellwandClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modSpellwandOpen
              anchors.right: modSpellwandSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open


          Panel
            id: rowModLeaderTarget
            height: 28

            BotSwitch
              id: modLeaderTargetSwitch
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              text: On

            Label
              anchors.left: modLeaderTargetSwitch.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              width: 170
              text: Leader Target Assist

            DtHelpButton
              id: modLeaderTargetHelp
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 256
              width: 22
              height: 22
              text: ?
              tooltip: Missile-based assist: attacks what your leader attacks.

            TextEdit
              id: modLeaderTargetKey
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 286
              margin-right: 169
              height: 22
              font: terminus-10px

            Button
              id: modLeaderTargetClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: modLeaderTargetSet
              anchors.right: modLeaderTargetClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

            Button
              id: modLeaderTargetOpen
              anchors.right: modLeaderTargetSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 52
              height: 22
              text: Open

      Panel
        id: pageHotkeys
        anchors.fill: parent

        Label
          id: hkTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [Icon Hotkeys]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backHotkeys
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backHotkeysHelp
          anchors.left: backHotkeys.right
          anchors.verticalCenter: backHotkeys.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        Label
          id: hkHint
          anchors.top: hkTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          margin-top: 8
          text-align: center
          text: Set replaces, Clear removes, Esc cancels capture (chat-safe).
          color: #cccccc


        DtHelpButton
          id: hkHintHelp
          anchors.right: parent.right
          anchors.verticalCenter: hkHint.verticalCenter
          margin-right: 8
          width: 22
          height: 18
          text: ?
          tooltip: Icon Hotkeys: rename actions and configure hotkeys/icons.
        Button
          id: manageIcons
          anchors.top: hkHint.bottom
          anchors.right: parent.right
          width: 110
          height: 18
          margin-top: 6
          text: Manage Icons

        DtHelpButton
          id: manageIconsHelp
          anchors.right: manageIcons.left
          anchors.verticalCenter: manageIcons.verticalCenter
          margin-right: 6
          width: 22
          height: 22
          text: ?

        DtCard
          id: hkScroll
          anchors.top: manageIcons.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 10
          margin-left: 8
          margin-right: 8
          margin-bottom: 26

          Panel
            id: rowCaveToggle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 28

            TextEdit
              id: caveToggleLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: CaveBot (Toggle)
              width: 180
              color: #ffffff

            DtHelpButton
              id: caveToggleHelp
              anchors.left: caveToggleLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de CaveBot Toggle.

            TextEdit
              id: caveToggleKey
              anchors.left: caveToggleHelp.right
              anchors.right: caveToggleSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: caveToggleClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: caveToggleSet
              anchors.right: caveToggleClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowTargetToggle
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: targetToggleLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: TargetBot (Toggle)
              width: 180
              color: #ffffff

            DtHelpButton
              id: targetToggleHelp
              anchors.left: targetToggleLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de TargetBot Toggle.

            TextEdit
              id: targetToggleKey
              anchors.left: targetToggleHelp.right
              anchors.right: targetToggleSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: targetToggleClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: targetToggleSet
              anchors.right: targetToggleClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowUeNonSafe
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: ueNonSafeLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: UE (NON-SAFE)
              width: 180
              color: #ffaa00

            DtHelpButton
              id: ueNonSafeHelp
              anchors.left: ueNonSafeLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de UE NON-SAFE.

            TextEdit
              id: ueNonSafeKey
              anchors.left: ueNonSafeHelp.right
              anchors.right: ueNonSafeSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: ueNonSafeClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: ueNonSafeSet
              anchors.right: ueNonSafeClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowUeSafe
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: ueSafeLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: UE (SAFE)
              width: 180
              color: #00c000

            DtHelpButton
              id: ueSafeHelp
              anchors.left: ueSafeLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de UE SAFE.

            TextEdit
              id: ueSafeKey
              anchors.left: ueSafeHelp.right
              anchors.right: ueSafeSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: ueSafeClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: ueSafeSet
              anchors.right: ueSafeClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowSuperSd
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: superSdLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Super SD
              width: 180
              color: #ffffff

            DtHelpButton
              id: superSdHelp
              anchors.left: superSdLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de Super SD.

            TextEdit
              id: superSdKey
              anchors.left: superSdHelp.right
              anchors.right: superSdSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: superSdClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: superSdSet
              anchors.right: superSdClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowSuperSdFire
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: superSdFireLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Super SD Fire
              width: 180
              color: #ff4513

            DtHelpButton
              id: superSdFireHelp
              anchors.left: superSdFireLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de Super SD Fire.

            TextEdit
              id: superSdFireKey
              anchors.left: superSdFireHelp.right
              anchors.right: superSdFireSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: superSdFireClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: superSdFireSet
              anchors.right: superSdFireClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowSuperSdHoly
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: superSdHolyLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Super Holy SD
              width: 180
              color: #88e3dd

            DtHelpButton
              id: superSdHolyHelp
              anchors.left: superSdHolyLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de Super Holy SD.

            TextEdit
              id: superSdHolyKey
              anchors.left: superSdHolyHelp.right
              anchors.right: superSdHolySet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: superSdHolyClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: superSdHolySet
              anchors.right: superSdHolyClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowSioVip
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: sioVipLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Sio VIP
              width: 180
              color: #3895D3

            DtHelpButton
              id: sioVipHelp
              anchors.left: sioVipLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de Sio VIP.

            TextEdit
              id: sioVipKey
              anchors.left: sioVipHelp.right
              anchors.right: sioVipSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: sioVipClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: sioVipSet
              anchors.right: sioVipClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

          Panel
            id: rowFollowToggle
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: followToggleLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Follow (Toggle)
              width: 180
              color: #ffffff

            DtHelpButton
              id: followToggleHelp
              anchors.left: followToggleLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Tools de Follow Toggle.

            TextEdit
              id: followToggleKey
              anchors.left: followToggleHelp.right
              anchors.right: followToggleSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: followToggleClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: followToggleSet
              anchors.right: followToggleClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set


          Panel
            id: rowLeaderTarget
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 28

            TextEdit
              id: leaderTargetLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Leader Target
              width: 180
              color: #ffffff

            DtHelpButton
              id: leaderTargetHelp
              anchors.left: leaderTargetLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 22
              text: ?
              tooltip: Hotkey for Leader Target Assist toggle.

            TextEdit
              id: leaderTargetKey
              anchors.left: leaderTargetHelp.right
              anchors.right: leaderTargetSet.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 22
              font: terminus-10px

            Button
              id: leaderTargetClear
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 55
              height: 22
              text: Clear

            Button
              id: leaderTargetSet
              anchors.right: leaderTargetClear.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 46
              height: 22
              text: Set

      Panel
        id: pageScripts
        anchors.fill: parent

        Label
          id: scriptsTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [Scripts]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backScripts
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backScriptsHelp
          anchors.left: backScripts.right
          anchors.verticalCenter: backScripts.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        DtCard
          id: scriptsScroll
          anchors.top: scriptsTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 12
          margin-left: 8
          margin-right: 8
          Panel
            id: rowScriptFile
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 22

            Label
              id: scriptFileLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: File
              width: 60


            DtHelpButton
              id: scriptFileHelp
              anchors.left: scriptFileLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 20
              text: ?
              tooltip: Lua file path to load in this viewer.
            TextEdit
              id: scriptFile
              anchors.left: prev.right
              anchors.right: scriptLoad.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 20
              font: terminus-10px
              text: scripts/druid_toolkit.lua
              tooltip: Ruta relativa dentro del profile (ej: scripts/druid_toolkit.lua).

            Button
              id: scriptLoad
              anchors.right: scriptSave.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 70
              height: 20
              text: Load

            DtHelpButton
              id: scriptSaveHelp
              anchors.right: scriptLoad.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 6
              width: 22
              height: 20
              text: ?
              tooltip: You can edit here and save. You can also edit the .lua directly in Files.

            Button
              id: scriptSave
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 70
              height: 20
              text: Save

          Panel
            id: rowScriptSearch
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10
            height: 22

            Label
              id: scriptSearchLabel
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              text: Search
              width: 60


            DtHelpButton
              id: scriptSearchHelp
              anchors.left: scriptSearchLabel.right
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 6
              width: 22
              height: 20
              text: ?
              tooltip: Search text inside the loaded script.
            TextEdit
              id: scriptSearch
              anchors.left: prev.right
              anchors.right: scriptFind.left
              anchors.verticalCenter: parent.verticalCenter
              margin-left: 8
              margin-right: 8
              height: 20
              font: terminus-10px
              tooltip: Search text inside the file (case-insensitive).

            Button
              id: scriptFind
              anchors.right: scriptNext.left
              anchors.verticalCenter: parent.verticalCenter
              margin-right: 4
              width: 60
              height: 20
              text: Find

            Button
              id: scriptNext
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              width: 60
              height: 20
              text: Next

          Label
            id: scriptStatus
            anchors.top: prev.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 8
            height: 16
            text: ""
            color: #cccccc


          DtHelpButton
            id: scriptStatusHelp
            anchors.left: parent.left
            anchors.top: scriptStatus.bottom
            margin-top: 4
            width: 22
            height: 16
            text: ?
            tooltip: Load and search status inside the script.
          Panel
            id: scriptContentBox
            anchors.top: prev.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            margin-top: 10

            DtHelpButton
              id: scriptViewerHelp
              anchors.top: parent.top
              anchors.left: parent.left
              margin-top: 4
              margin-left: 4
              width: 22
              height: 20
              text: ?
              tooltip: In-game editor. You can also edit the .lua directly in Files.

            TextEdit
              id: scriptContent
              anchors.top: scriptViewerHelp.bottom
              anchors.left: parent.left
              anchors.bottom: parent.bottom
              anchors.right: scriptScrollbar.left
              margin-top: 6
              margin-right: 8
              text-wrap: false
              multiline: true
              font: terminus-10px
              tooltip: In-game editor for the loaded script. Use Save to store changes.

            VerticalScrollBar
              id: scriptScrollbar
              anchors.top: parent.top
              anchors.bottom: parent.bottom
              anchors.right: parent.right
              width: 14
              pixels-scroll: true
              step: 200

      Panel
        id: pageAbout
        anchors.fill: parent

        Label
          id: aboutTitle
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          height: 20
          text-align: center
          text: [About]
          font: verdana-11px-rounded
          color: #ffffff

        Button
          id: backAbout
          anchors.top: parent.top
          anchors.left: parent.left
          width: 60
          height: 18
          text: Back


        DtHelpButton
          id: backAboutHelp
          anchors.left: backAbout.right
          anchors.verticalCenter: backAbout.verticalCenter
          margin-left: 6
          width: 22
          height: 18
          text: ?
          tooltip: Return to main menu.
        DtCardScroll
          id: aboutScroll
          anchors.top: aboutTitle.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          margin-top: 12
          margin-left: 8
          margin-right: 8
          margin-bottom: 26
          layout:
            type: verticalBox
            fit-children: false
            spacing: 10

          Label
            id: aboutText
            text: "Druid Toolkit: loader-based bot scripts for OTCv8.\n\nTip: use VSCode or Notepad++ for cleaner editing.\nVSCode Copilot/AI helps a lot if you are not a coder yet."
            text-wrap: true
            multiline: true
            color: #dddddd

          Button
            id: aboutRepo
            height: 26
            text: "GitHub Repo (Open Source)"


          DtHelpButton
            id: aboutRepoHelp
            height: 20
            width: 22
            text: ?
            tooltip: Open the open-source repository on GitHub.
          Label
            id: aboutRepoUrl
            text: "github.com/eduardogallifaochoa/otcv8-eddiexo-scripts"
            color: #cccccc

          Button
            id: aboutDonate
            height: 26
            text: "Optional donation (if my scripts helped you)"

          DtHelpButton
            id: aboutDonateHelp
            height: 20
            width: 22
            text: ?
            tooltip: Optional support link (PayPal donation).

          Label
            id: aboutDonateUrl
            text: "paypal.me/eddielol"
            color: #cccccc
    HorizontalSeparator
      id: sepBottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: footer.top
      margin-bottom: 22

    Panel
      id: footer
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      height: 26
      padding-left: 8
      padding-right: 8
      image-source: /images/ui/panel_flat
      image-border: 6
      background-color: #00000033
      border-width: 1
      border-color: #ffffff18

      Label
        id: signature
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text-align: left
        text: "Eduardo Gallifa Scripts  |  eddiexo discord for more"
        font: verdana-11px-rounded
        color: #ff2b2b
        opacity: 0.75

      Button
        id: closeButton
        !text: tr('Close')
        font: cipsoftFont
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        size: 55 21












      DtHelpButton
        id: closeHelp
        anchors.right: closeButton.left
        anchors.verticalCenter: closeButton.verticalCenter
        margin-right: 6
        width: 22
        height: 20
        text: ?
        tooltip: Close setup window (does not disable modules).



]==]

local __druid_toolkit_source = [==[
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
cfg.leaderTargetName = cfg.leaderTargetName or cfg.followLeader or "Name"
cfg.leaderTargetSwitchCooldownMs = tonumber(cfg.leaderTargetSwitchCooldownMs) or 200

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
  leaderTarget = "",
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
modDefault("leaderTarget", false) -- safer default: OFF
cfg.mwScrollDelayMs = tonumber(cfg.mwScrollDelayMs) or 250
cfg.mwScrollMagicWallId = tonumber(cfg.mwScrollMagicWallId) or 2128
cfg.mwScrollWildGrowthId = tonumber(cfg.mwScrollWildGrowthId) or 2130
cfg.mwScrollMagicWallRuneId = tonumber(cfg.mwScrollMagicWallRuneId) or 3180
cfg.mwScrollWildGrowthRuneId = tonumber(cfg.mwScrollWildGrowthRuneId) or 3156
cfg.mwScrollCustomId = tonumber(cfg.mwScrollCustomId) or cfg.mwScrollWildGrowthRuneId
if cfg.mwScrollCustomId == cfg.mwScrollMagicWallId or cfg.mwScrollCustomId == cfg.mwScrollWildGrowthId then
  cfg.mwScrollCustomId = cfg.mwScrollWildGrowthRuneId
end
cfg.mwScrollBlockMode = cfg.mwScrollBlockMode or "magicwall"
cfg.mwHoldMarkKey = _trim(cfg.mwHoldMarkKey or ".")
if cfg.mwHoldMarkKey:len() == 0 then cfg.mwHoldMarkKey = "." end

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
local leaderTargetToggleMacro

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

local function dtGetMwScrollCastId()
  local mode = dtGetMwScrollMode()
  if mode == "wildgrowth" then
    return tonumber(cfg.mwScrollWildGrowthRuneId) or 3156
  end
  if mode == "custom" then
    local customId = tonumber(cfg.mwScrollCustomId)
    if customId and customId > 0 then return math.floor(customId) end
    return tonumber(cfg.mwScrollWildGrowthRuneId) or 3156
  end
  return tonumber(cfg.mwScrollMagicWallRuneId) or 3180
end

local function dtGetMwScrollBlockCheckId()
  local mode = dtGetMwScrollMode()
  if mode == "wildgrowth" then
    return tonumber(cfg.mwScrollWildGrowthId) or 2130
  end
  if mode == "custom" then
    return nil
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
  safeSetText(dtResolve(dtWindow, "mwScrollCustomId"), tostring(tonumber(cfg.mwScrollCustomId) or (tonumber(cfg.mwScrollWildGrowthRuneId) or 3156)))
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
local dtHotkeyCaptureWindow = nil
-- Forward declaration (used by icon context menu)
local dtOpen = nil
local dtTryMWScrollDown = nil
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
  safeSetText(dtResolve(dtWindow, "leaderTargetName"), cfg.leaderTargetName or "")
  safeSetText(dtResolve(dtWindow, "leaderTargetCooldown"), tostring(tonumber(cfg.leaderTargetSwitchCooldownMs) or 200))

  safeSetText(dtResolve(dtWindow, "ueSpell"), cfg.ueSpell or "")
  safeSetText(dtResolve(dtWindow, "ueRepeat"), tostring(cfg.ueRepeat or 4))
  safeSetText(dtResolve(dtWindow, "antiParalyzeSpell"), cfg.antiParalyzeSpell or "")
  safeSetText(dtResolve(dtWindow, "hasteSpell"), cfg.hasteSpell or "")
  safeSetText(dtResolve(dtWindow, "healSpell"), cfg.healSpell or "")
  safeSetText(dtResolve(dtWindow, "healPercent"), tostring(cfg.healPercent or 95))
  safeSetText(dtResolve(dtWindow, "mwHoldMarkKey"), cfg.mwHoldMarkKey or ".")

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
  safeSetText(dtResolve(dtWindow, "leaderTargetKey"), getHotkeyDisplay("leaderTarget"))
  safeSetText(dtResolve(dtWindow, "leaderTargetLabel"), dtGetActionDisplayName("leaderTarget", "Leader Target"))
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
  safeSetOn(dtResolve(dtWindow, "modLeaderTargetSwitch"), cfg.mods and cfg.mods.leaderTarget == true)

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
  safeSetText(dtResolve(dtWindow, "modLeaderTargetKey"), getHotkeyDisplay("leaderTarget"))

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
    if HK_CAPTURE and HK_CAPTURE.window and HK_CAPTURE.window.hide then
      pcall(HK_CAPTURE.window.hide, HK_CAPTURE.window)
    end
    HK_CAPTURE = nil
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
    -- In case styles weren't imported for some reason, try inline first, then local files.
    if type(__druid_toolkit_otui_inline) == "string" and __druid_toolkit_otui_inline:len() > 0 then
      pcall(g_ui.loadUIFromString, __druid_toolkit_otui_inline)
    end

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
  -- About: links
  do
    local aboutRepo = dtResolve(dtWindow, "aboutRepo")
    if aboutRepo then
      aboutRepo.onClick = function()
        if g_platform and g_platform.openUrl then
          g_platform.openUrl("https://github.com/eduardogallifaochoa/otcv8-eddiexo-scripts")
        end
      end
    end

    local aboutDonate = dtResolve(dtWindow, "aboutDonate")
    if aboutDonate then
      aboutDonate.onClick = function()
        if g_platform and g_platform.openUrl then
          g_platform.openUrl("https://paypal.me/eddielol")
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



  local function dtCancelHotkeyCapture(refreshUi)
    local cap = HK_CAPTURE
    HK_CAPTURE = nil
    if cap and cap.window and cap.window.hide and not cap.window._dtDestroyed then
      pcall(cap.window.hide, cap.window)
    end
    if refreshUi ~= false then dtRefresh() end
  end

  local function dtOpenHotkeyCapturePrompt(actionKey, keyWidget)
    if HK_CAPTURE then
      dtCancelHotkeyCapture(false)
    end

    local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget() or nil
    if not root then
      HK_CAPTURE = { action = actionKey, keyWidget = keyWidget }
      return
    end

    local w = dtHotkeyCaptureWindow
    if not (w and w.show) then
      local ok, newW = pcall(function()
        return setupUI([[
MainWindow
  id: dtHotkeyCaptureWindow
  text: Druid Toolkit
  size: 330 140
  draggable: true


  Label
    id: hkTitle
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 16
    margin-left: 12
    margin-right: 12
    text-align: center
    text: Hotkey Capture

  Label
    id: hkAction
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: hkTitle.bottom
    margin-top: 6
    margin-left: 12
    margin-right: 12
    text-align: center
    text: Action

  Label
    id: hkValue
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: hkAction.bottom
    margin-top: 8
    margin-left: 12
    margin-right: 12
    text-align: center
    text: Press any key...

  Button
    id: hkCancel
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-left: 12
    margin-bottom: 10
    width: 70
    text: Cancel

  Button
    id: hkClear
    anchors.left: hkCancel.right
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-bottom: 10
    width: 70
    text: Clear

  Button
    id: hkSave
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-right: 12
    margin-bottom: 10
    width: 70
    text: Save
]], root)
      end)

      if not ok or not newW then
        HK_CAPTURE = { action = actionKey, keyWidget = keyWidget }
        return
      end
      w = newW
      dtHotkeyCaptureWindow = w
    end

    local a = dtGetAction(actionKey)
    local actionLabel = dtGetActionDisplayName(actionKey, (a and a.defaultLabel) or actionKey)

    local title = dtResolve(w, "hkTitle")
    local actionText = dtResolve(w, "hkAction")
    local valueText = dtResolve(w, "hkValue")
    local cancelBtn = dtResolve(w, "hkCancel")
    local clearBtn = dtResolve(w, "hkClear")
    local saveBtn = dtResolve(w, "hkSave")

    safeSetText(title, "[Hotkey]")
    safeSetText(actionText, "<" .. tostring(actionLabel or actionKey) .. ">")
    safeSetText(valueText, "[Press any key...]")

    HK_CAPTURE = {
      action = actionKey,
      keyWidget = keyWidget,
      window = w,
      valueText = valueText,
      pending = nil,
    }

    if not w._dtBound then
      w._dtBound = true

      w.onDestroy = function()
        w._dtDestroyed = true
        if dtHotkeyCaptureWindow == w then
          dtHotkeyCaptureWindow = nil
        end
        if HK_CAPTURE and HK_CAPTURE.window == w then
          HK_CAPTURE.window = nil
        end
      end

      if cancelBtn then
        cancelBtn.onClick = function()
          dtCancelHotkeyCapture(true)
        end
      end

      if clearBtn then
        clearBtn.onClick = function()
          if HK_CAPTURE and HK_CAPTURE.action then
            clearHotkeys(HK_CAPTURE.action)
          end
          dtCancelHotkeyCapture(true)
        end
      end

      if saveBtn then
        saveBtn.onClick = function()
          if HK_CAPTURE and HK_CAPTURE.action and HK_CAPTURE.pending and _trim(HK_CAPTURE.pending):len() > 0 then
            setHotkeySet(HK_CAPTURE.action, HK_CAPTURE.pending)
          end
          dtCancelHotkeyCapture(true)
        end
      end
    end

    if w.show then w:show() end
    if w.raise then w:raise() end
    if w.focus then w:focus() end
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
  bindHelpButton("leaderTargetNameHelp", "Exact leader name used by Leader Target Assist missile detection.")
  bindHelpButton("leaderTargetCooldownHelp", "Switch cooldown in milliseconds to avoid flicker.")

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
  bindHelpButton("modMagicWallHelp", "Wall Hold module (casts MW/WG based on Spells mode).")
  bindHelpButton("mwScrollSpellHelp", "MW ScrollDown toggle/hotkey. ON enables wheel/hotkey casts; mode buttons can cast once manually.")
  bindHelpButton("mwScrollTargetHelp", "Pick cast mode: Magic Wall, Wild Growth, or Custom rune ID.")
  bindHelpButton("mwHoldMarkHelp", "Key used to mark tiles for Hold (short press mark, hold 2.5s clear).")
  bindHelpButton("modManaPotHelp", "Faster Mana Potting module.")
  bindHelpButton("modCutWgHelp", "Auto Cut Wild Growth module.")
  bindHelpButton("modStaminaHelp", "Stamina Item module.")
  bindHelpButton("modSpellwandHelp", "Spellwand module.")
  bindHelpButton("modLeaderTargetHelp", "Leader Target Assist module (missile-based).")

  bindHelpButton("manageIconsHelp", "Re-enable icons hidden with Disable Icon.")
  bindHelpButton("scriptFileHelp", "Lua file path to load/save in this editor. You can also edit directly in Files.")
  bindHelpButton("scriptSearchHelp", "Search text inside the loaded script.")
  bindHelpButton("scriptSaveHelp", "Save in-game editor changes. You can also edit the lua directly in Files.")
  bindHelpButton("scriptViewerHelp", "In-game editor for the loaded script. Use Save to persist changes.")
  bindHelpButton("aboutRepoHelp", "Open the project GitHub repository.")
  bindHelpButton("aboutDonateHelp", "Optional PayPal donation link if the scripts helped you.")
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
  bindHelpButton("hkHintHelp", "Rename actions, assign hotkeys and customize icons. Press Esc or click Cancel to abort key capture.")
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


  local leaderTargetName = dtResolve(dtWindow, "leaderTargetName")
  if leaderTargetName then
    leaderTargetName.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.leaderTargetName = text
    end
  end

  local leaderTargetCooldown = dtResolve(dtWindow, "leaderTargetCooldown")
  if leaderTargetCooldown then
    leaderTargetCooldown.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.leaderTargetSwitchCooldownMs = tonumber(text) or 200
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

  local mwHoldMarkKey = dtResolve(dtWindow, "mwHoldMarkKey")
  if mwHoldMarkKey then
    mwHoldMarkKey.onTextChange = function(_, text)
      if dtRefreshing then return end
      cfg.mwHoldMarkKey = _trim(text)
      if cfg.mwHoldMarkKey:len() == 0 then cfg.mwHoldMarkKey = "." end
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
      if dtTryMWScrollDown then dtTryMWScrollDown(true) end
    end
  end

  local mwScrollModeWG = dtResolve(dtWindow, "mwScrollModeWG")
  if mwScrollModeWG then
    mwScrollModeWG.onClick = function()
      if dtRefreshing then return end
      dtSetMwScrollMode("wildgrowth")
      dtRefreshMwScrollModeUi()
      if dtTryMWScrollDown then dtTryMWScrollDown(true) end
    end
  end

  local mwScrollModeCustom = dtResolve(dtWindow, "mwScrollModeCustom")
  if mwScrollModeCustom then
    mwScrollModeCustom.onClick = function()
      if dtRefreshing then return end
      dtSetMwScrollMode("custom")
      dtRefreshMwScrollModeUi()
      if dtTryMWScrollDown then dtTryMWScrollDown(true) end
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
  bindModuleSwitch("leaderTarget", "modLeaderTargetSwitch")

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
  bindModuleOpen("modLeaderTargetOpen", "-- Leader Target Assist")

  -- Hotkey binding helper: Set / Clear
  local function bindHotkeyRow(actionKey, keyId, setId, clearId, usePopupCapture)
    local keyWidget = dtResolve(dtWindow, keyId)
    local setButton = dtResolve(dtWindow, setId)
    local clearButton = dtResolve(dtWindow, clearId)

    if keyWidget then
      if keyWidget.setReadOnly then pcall(keyWidget.setReadOnly, keyWidget, true) end
      if keyWidget.setEditable then pcall(keyWidget.setEditable, keyWidget, false) end
      if keyWidget.setFocusable then pcall(keyWidget.setFocusable, keyWidget, false) end
      keyWidget.onTextChange = nil
      keyWidget.onClick = function() return true end
      keyWidget.onDoubleClick = function() return true end
      keyWidget.onMousePress = function() return true end
      keyWidget.onMouseRelease = function() return true end
      keyWidget.onKeyPress = function() return true end
      keyWidget.onKeyDown = function() return true end
    end

    local function startCapture()
      if usePopupCapture == true then
        dtOpenHotkeyCapturePrompt(actionKey, keyWidget)
      else
        HK_CAPTURE = { action = actionKey, keyWidget = keyWidget }
      end
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

  bindHotkeyRow("caveToggle", "caveToggleKey", "caveToggleSet", "caveToggleClear", true)
  bindHotkeyRow("targetToggle", "targetToggleKey", "targetToggleSet", "targetToggleClear", true)
  bindHotkeyRow("antiParalyze", "modAntiParalyzeKey", "modAntiParalyzeSet", "modAntiParalyzeClear", true)
  bindHotkeyRow("autoHaste", "modAutoHasteKey", "modAutoHasteSet", "modAutoHasteClear", true)
  bindHotkeyRow("autoHeal", "modAutoHealKey", "modAutoHealSet", "modAutoHealClear", true)
  bindHotkeyRow("ringSwap", "modRingSwapKey", "modRingSwapSet", "modRingSwapClear", true)
  bindHotkeyRow("magicWall", "modMagicWallKey", "modMagicWallSet", "modMagicWallClear", true)
  bindHotkeyRow("mwScroll", "mwScrollSpellKey", "mwScrollSpellSet", "mwScrollSpellClear", true)
  bindHotkeyRow("manaPot", "modManaPotKey", "modManaPotSet", "modManaPotClear", true)
  bindHotkeyRow("cutWg", "modCutWgKey", "modCutWgSet", "modCutWgClear", true)
  bindHotkeyRow("stamina", "modStaminaKey", "modStaminaSet", "modStaminaClear", true)
  bindHotkeyRow("spellwand", "modSpellwandKey", "modSpellwandSet", "modSpellwandClear", true)
  bindHotkeyRow("leaderTarget", "modLeaderTargetKey", "modLeaderTargetSet", "modLeaderTargetClear", true)

  bindHotkeyRow("ueNonSafe", "ueNonSafeKey", "ueNonSafeSet", "ueNonSafeClear", true)
  bindHotkeyRow("ueSafe", "ueSafeKey", "ueSafeSet", "ueSafeClear", true)
  bindHotkeyRow("superSd", "superSdKey", "superSdSet", "superSdClear", true)
  bindHotkeyRow("superSdFire", "superSdFireKey", "superSdFireSet", "superSdFireClear", true)
  bindHotkeyRow("superSdHoly", "superSdHolyKey", "superSdHolySet", "superSdHolyClear", true)
  bindHotkeyRow("sioVip", "sioVipKey", "sioVipSet", "sioVipClear", true)
  bindHotkeyRow("followToggle", "followToggleKey", "followToggleSet", "followToggleClear", true)
  bindHotkeyRow("leaderTarget", "leaderTargetKey", "leaderTargetSet", "leaderTargetClear", true)

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
  bindActionNameWidget("leaderTarget", "leaderTargetLabel", "leaderTargetHelp")

  dtWindow._dtOpenHotkeyCapturePrompt = dtOpenHotkeyCapturePrompt
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
local WG_RUNE_ID = 3156
local MW_BLOCK_TILE_ID = 2128

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

    local castId = dtGetMwScrollCastId()
    local blockId = dtGetMwScrollBlockCheckId()
    local topThing = tile:getTopThing()
    local topId = topThing and topThing.getId and topThing:getId() or nil

    if tile:canShoot()
      and not isInPz()
      and tile:isWalkable()
      and tile:getText() == "MW"
      and castId and castId > 0
      and (not blockId or topId ~= blockId)
    then
      useWith(castId, tile:getTopUseThing())
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

local function dtGetMwHoldMarkKey()
  local key = _trim(cfg.mwHoldMarkKey or ".")
  if key:len() == 0 then return "." end
  return key
end

dtTryMWScrollDown = function(forceCast)
  if not isEnabled() then return false end
  if not forceCast and not (cfg.mods and cfg.mods.mwScroll == true) then return false end
  if now - mwScrollLastUse < MW_SCROLL_DELAY_MS then return false end

  local tile = getTileUnderCursor()
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() or not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  local castId = dtGetMwScrollCastId()
  if not castId or castId <= 0 then return false end
  local blockId = dtGetMwScrollBlockCheckId()
  if blockId and blockId > 0 and top and top.getId and top:getId() == blockId then return false end

  mwScrollLastUse = now
  useWith(castId, top or tile:getGround() or tile)
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
  if _hkEq(keys, dtGetMwHoldMarkKey()) and resetTimer == 0 then resetTimer = now end
end)

onKeyPress(function(keys)
  if chatTyping() then return end
  if not isEnabled() then return end

  if _hkEq(keys, dtGetMwHoldMarkKey()) and (now - resetTimer) > 2500 then
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
  if (not _hkEq(keys, dtGetMwHoldMarkKey())) or resetTiles then return end

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

local iconLeaderTarget = addIcon("dt_LeaderTarget_Icon", { item = 3447, text = "LTA" }, function(icon, isOn)
  if icon and icon._dtSuppress then return end
  dtSetActionOn("leaderTarget", isOn, "icon")
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
  followToggle = { keyId = "followToggleKey" },
  leaderTarget = { keyId = "leaderTargetKey" },
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
  local ids = DT_ACTION_UI[actionKey]
  local keyWidget = ids and dtResolve(dtWindow, ids.keyId) or nil
  if dtWindow and dtWindow._dtOpenHotkeyCapturePrompt then
    dtWindow._dtOpenHotkeyCapturePrompt(actionKey, keyWidget)
  else
    HK_CAPTURE = { action = actionKey, keyWidget = keyWidget }
  end
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
    local keyName = tostring(keys or "")
    local keyLower = keyName:lower()

    if keyLower == "escape" or keyLower == "esc" then
      local cap = HK_CAPTURE
      HK_CAPTURE = nil
      if cap and cap.window and cap.window.hide and not cap.window._dtDestroyed then
        pcall(cap.window.hide, cap.window)
      end
      dtRefresh()
      return
    end

    if HK_CAPTURE.window then
      HK_CAPTURE.pending = keyName
      if HK_CAPTURE.valueText then
        safeSetText(HK_CAPTURE.valueText, "[" .. keyName .. "]")
      end
      return
    end

    setHotkeySet(HK_CAPTURE.action, keyName)
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
  if hotkeyMatches("leaderTarget", keys) then dtToggleAction("leaderTarget") return end

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

-- Leader Target Assist (missile-based)
local leaderTargetLockedId = nil
local leaderTargetLastSwitchAt = 0

leaderTargetToggleMacro = {
  isOn = function()
    return cfg.mods and cfg.mods.leaderTarget == true
  end,
  setOn = function(v)
    cfg.mods = cfg.mods or {}
    cfg.mods.leaderTarget = (v == true)
  end
}

local function ltNameEq(a, b)
  if not a or not b then return false end
  return tostring(a):lower() == tostring(b):lower()
end

local function ltIsFriend(name)
  if not name or type(name) ~= "string" then return false end
  if not storage or not storage.playerList or not storage.playerList.friendList then return false end
  local list = storage.playerList.friendList
  if table.find then
    return table.find(list, name, true) ~= nil
  end
  for _, n in ipairs(list) do
    if ltNameEq(n, name) then return true end
  end
  return false
end

local function ltCanSwitchNow()
  local cd = tonumber(cfg.leaderTargetSwitchCooldownMs) or 200
  if cd < 0 then cd = 0 end
  return (now - leaderTargetLastSwitchAt) >= cd
end

local function ltTryAttack(targetCreature)
  if not targetCreature or not targetCreature.isCreature or not targetCreature:isCreature() then return end
  if not targetCreature.getId then return end

  local tid = targetCreature:getId()
  if not tid then return end
  if leaderTargetLockedId == tid then return end

  local myTarget = g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
  if myTarget and myTarget.getId and myTarget:getId() == tid then
    leaderTargetLockedId = tid
    return
  end

  if not ltCanSwitchNow() then return end
  if not g_game or not g_game.attack then return end

  g_game.attack(targetCreature)
  leaderTargetLockedId = tid
  leaderTargetLastSwitchAt = now
end

onMissle(function(missle)
  if not isEnabled() then return end
  if not (cfg.mods and cfg.mods.leaderTarget == true) then return end

  local leaderName = _trim(cfg.leaderTargetName or cfg.followLeader or "")
  if leaderName:len() == 0 then return end
  if not missle then return end

  local srcPos = missle.getSource and missle:getSource() or nil
  local dstPos = missle.getDestination and missle:getDestination() or nil
  if not srcPos or not dstPos then return end
  if srcPos.z ~= posz() then return end

  local fromTile = g_map.getTile(srcPos)
  local toTile = g_map.getTile(dstPos)
  if not fromTile or not toTile then return end

  local fromCreatures = fromTile.getCreatures and fromTile:getCreatures() or {}
  local toCreatures = toTile.getCreatures and toTile:getCreatures() or {}
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local shooter = fromCreatures[1]
  local target = toCreatures[1]
  if not shooter or not target then return end
  if shooter == target then return end

  local shooterName = shooter.getName and shooter:getName() or ""
  if not ltNameEq(shooterName, leaderName) then return end

  local targetName = target.getName and target:getName() or ""
  if ltNameEq(targetName, leaderName) then return end
  if ltIsFriend(targetName) then return end

  ltTryAttack(target)
end)

onCreatureDisappear(function(creature)
  if not creature or not creature.getId then return end
  if leaderTargetLockedId and creature:getId() == leaderTargetLockedId then
    leaderTargetLockedId = nil
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
leaderTargetToggleMacro.setOn(cfg.mods.leaderTarget == true)

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
  label = "Wall Hold (MW/WG)",
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

dtRegisterAction("leaderTarget", {
  label = "Leader Target",
  macro = leaderTargetToggleMacro,
  icon = iconLeaderTarget,
  persist = true,
  script = "scripts/druid_toolkit.lua",
  scriptQuery = "-- Leader Target Assist",
  setupPage = "pageGeneral",
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


]==]

local __ok, __err = pcall(function()
  local __chunk, __loadErr = load(__druid_toolkit_source, 'scripts/druid_toolkit.lua')
  if not __chunk then error(__loadErr) end
  __chunk()
end)

if not __ok then
  print('[DruidToolkitSingle] FAILED: ' .. tostring(__err))
else
  print('[DruidToolkitSingle] Loaded.')
end

__druid_toolkit_source = nil
