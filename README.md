# otcv8-eddiexo-scripts

<<<<<<< HEAD
Language: **ES** | **EN**: see `README.en.md`

Este repo es mi setup de scripts/perfil para **OTCv8 / vBot**.

La idea principal:
- ya no pegar un mega script en el *Ingame Script Editor*
- usar un workflow **loader-based**: loaders chiquitos y estables, y todo lo demas vive en archivos `.lua` dentro del repo

## Video (YouTube)

- https://www.youtube.com/watch?v=2BEvy-Cac7M

[![Walkthrough video](https://img.youtube.com/vi/2BEvy-Cac7M/0.jpg)](https://www.youtube.com/watch?v=2BEvy-Cac7M)

## Que hay aqui

- `vBot/`, `cavebot/`, `targetbot/`: scripts base del bot
- `_Loader.lua`: entrypoint del perfil (carga estilos UI y scripts)
- carpetas `*_configs/` y `storage/`: configs (depende del server/perfil)

## Donde va mi codigo

En general:
- si estas trabajando en un modulo: ponlo en su folder (`scripts/`, `bot_loaders/`, `ui/`, etc)
- si estas en modo profile de vBot: normalmente todo termina colgando de `_Loader.lua`

## Goals (si sigo con esto)

Realisticamente le voy a meter hasta el **27-Feb-2026** (sale Resident Evil Requiem), pero los goals:

- Hacer el bot mas "open" y editable: modulos claros, faciles de leer.
- Botones/UI que abran el Setup y permitan editar hotkeys/valores sin crashear.
- Hotkeys que no disparen mientras estas escribiendo en chat.
- Context menu en iconos (Shift + right click) para editar hotkeys/atributos.
- Tooltips/ayuda para settings no intuitivos (ej: "UE repeat").
- A futuro: un layer low-code (condiciones/acciones en lenguaje humano) y tal vez un helper/AI.

## Nota sobre scripts comprados

No se suben scripts comprados/bitlocked.
Si tienes cosas privadas, ponlas en `private/` (esta en `.gitignore`).
=======
My personal OTCv8 bot profile repo.

Goal: stop pasting a giant Lua blob in the Ingame Script Editor and instead use a stable loader + real files in the repo. Also: build a "paid-script vibe" Setup UI (PvP Scripts style) but fully editable/open-source.

Video (me explaining what I'm doing here):
`https://www.youtube.com/watch?v=2BEvy-Cac7M`

GitHub:
`https://github.com/eduardogallifaochoa/otcv8-eddiexo-scripts`

## How It Works

- This repo is meant to live inside your OTCv8 bot profiles folder as:
  - `.../bot/otcv8-eddiexo-scripts/`
- OTCv8 loads `_Loader.lua` for the selected bot profile.
- `_Loader.lua` loads vBot modules + then safely loads my private scripts via `bot_loaders/*`.

### Druid Toolkit (main example)

- Loader: `bot_loaders/druid_toolkit_loader.lua`
- Main script: `scripts/druid_toolkit.lua`
- Setup UI style: `ui/druid_toolkit.otui`

If you *really* want a single snippet to paste once in Ingame Script Editor:
```lua
dofile('bot_loaders/druid_toolkit_loader.lua')
```

## Features (Druid Toolkit)

- Main "Druid Toolkit" row on `Main` tab:
  - Green/Red toggle (master enable)
  - `Setup` button opens the custom window
- Custom Setup window:
  - Menu + tabs
  - Spells/settings with tooltips
  - Icon hotkeys editor (chat-safe)
  - Scripts viewer with search + scrollbar
  - Shift + RightClick context menu on icons:
    - Toggle
    - Setup (only when relevant)
    - Hotkey Set/Clear
    - Open Script (jumps to the right part of the file)
    - Disable Icon (hide it)
  - Footer signature

## Bitacora / Changelog

### 2026-02-10

- Implemented loader-based architecture:
  - Stable minimal loader with `pcall(dofile, ...)`
  - No more manual huge-paste workflow for Druid Toolkit
- Built Druid Toolkit as repo files:
  - `scripts/druid_toolkit.lua` holds real logic
  - `ui/druid_toolkit.otui` holds the Setup UI
- Fixed the original UI crash pattern (nil widget/parent) by:
  - Always creating windows with a safe root parent
  - Wrapping UI creation in `pcall`
  - Retrying when UI isn't ready yet
- Reworked UE section:
  - One UE spell + one repeat count
  - Two modes only: SAFE / NON-SAFE
- Added icon registry + sync:
  - Single source of truth for icon <-> macro
  - Hotkeys toggle macros and keep icon state consistent
  - Hotkey badges (F1/F2/...) displayed on icons
- Added hotkey setup window:
  - Set/Clear
  - Chat-safe (no firing while typing)
- UI polish pass:
  - PvP Scripts-like menu/tabs
  - Footer signature
  - Scripts page got a real scrollbar + search

>>>>>>> d4ff5c9 (Druid Toolkit: hotkeys (cave/target/follow) + badge anchors + scripts scrollbar)
