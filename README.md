# otcv8-eddiexo-scripts

Language: **ES** | **EN**: ver `README.en.md`

Este repo es mi setup de scripts/perfil para **OTCv8 / vBot**.

La idea principal:
- ya no pegar un mega script en el *Ingame Script Editor*
- usar un workflow **loader-based**: loaders chiquitos y estables, y todo lo demas vive en archivos `.lua` dentro del repo

GitHub:
- https://github.com/eduardogallifaochoa/otcv8-eddiexo-scripts

## Video (YouTube)

- https://www.youtube.com/watch?v=2BEvy-Cac7M

[![Walkthrough video](https://img.youtube.com/vi/2BEvy-Cac7M/0.jpg)](https://www.youtube.com/watch?v=2BEvy-Cac7M)

## Que hay aqui

- `vBot/`, `cavebot/`, `targetbot/`: scripts base del bot
- `_Loader.lua`: entrypoint del profile (carga estilos UI y scripts)
- `bot_loaders/`: loaders estables (pcall around dofile)
- `scripts/`: logica real (ej: `scripts/druid_toolkit.lua`)
- `ui/`: OTUI del setup (ej: `ui/druid_toolkit.otui`)
- carpetas `*_configs/` y `storage/`: configs (depende del server/perfil)

## Druid Toolkit (ejemplo principal)

- Loader: `bot_loaders/druid_toolkit_loader.lua`
- Main: `scripts/druid_toolkit.lua`
- Setup UI: `ui/druid_toolkit.otui`

Snippet (si quieres pegar SOLO una vez en Ingame Script Editor):
```lua
dofile('bot_loaders/druid_toolkit_loader.lua')
```

## Goals (si sigo con esto)

Realisticamente le voy a meter hasta el **27-Feb-2026** (sale Resident Evil Requiem), pero los goals:

- Hacer el bot mas "open" y editable: modulos claros, faciles de leer.
- UI tipo PvP Scripts (caro) pero estable, sin crashes.
- Hotkeys chat-safe (no disparar mientras escribes en chat).
- Context menu en iconos (Shift + right click) para toggles/hotkeys/scripts.
- Tooltips/ayuda para settings no intuitivos.

## Nota sobre scripts comprados

No se suben scripts comprados/bitlocked.
Si tienes cosas privadas, ponlas en `private/` (esta en `.gitignore`).

## Bitacora / Changelog

### 2026-02-10

- Loader-based architecture (adios paste gigante)
  - loader minimo y estable con `pcall(dofile, ...)`
  - el contenido vive en `scripts/`
- Setup UI estable (sin `setupUI(nil)` / sin crash)
  - ventana creada con parent seguro (root)
  - `pcall` + retry cuando UI no esta lista
- UE rework
  - 1 spell + 1 cast count
  - SAFE / NON-SAFE (2 modos)
- Icon registry + sync real
  - icon <-> macro consistente
  - hotkeys togglean y el icon refleja estado
  - badges de hotkey en los iconos
  - "Disable Icon" oculta el icon (no solo opacity)
- Hotkeys
  - Editor Set/Clear
  - CaveBot/TargetBot toggles separados
  - Follow Toggle (solo toggle)
  - chat-safe
- Setup UI polish
  - Tabs + menu + footer signature
  - Scripts viewer con search + scrollbar
  - Modules tab (toggles + hotkeys para modulos)
