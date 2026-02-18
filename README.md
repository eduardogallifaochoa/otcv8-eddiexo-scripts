# otcv8-eddiexo-scripts

Language: **ES** | **EN**: ver `README.en.md`

Este repo es mi setup de scripts/perfil para **OTCv8 / vBot**.

La idea principal:
- ya no pegar un mega script en el *Ingame Script Editor*
- usar un workflow **loader-based**: loaders chiquitos y estables, y todo lo demas vive en archivos `.lua` dentro del repo

GitHub:
- https://github.com/eduardogallifaochoa/otcv8-eddiexo-scripts

Donacion opcional (si mis scripts te sirvieron):
- https://paypal.me/eddielol

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

Portable single-file (para arrastrar a otros bots):
- archivo generado: `druid_toolkit_single.lua`
- rebuild:
```powershell
powershell -ExecutionPolicy Bypass -File tools/build_druid_toolkit_single.ps1
```
- uso en Ingame Script Editor:
```lua
dofile('druid_toolkit_single.lua')
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
### 2026-02-18

- Se removio `INSPIRACION_NOTES.md` (solo era nota temporal de analisis).
- Se agrego build portable single-file del toolkit:
  - `tools/build_druid_toolkit_single.ps1`
  - `druid_toolkit_single.lua` (autogenerado)
- `scripts/druid_toolkit.lua` ahora acepta OTUI inline (`__druid_toolkit_otui_inline`) para que el single-file funcione sin dependencias externas.
- Se marca este push como **ultimo push por ahora**: estado funcional estable.
### 2026-02-15

- Leader Target Assist (General) simplificado:
  - se elimino `Leader Target Only No Target` (UI + bind + runtime)
  - quedan solo `Leader Target Name` y `Leader Target CD (ms)`
- Hotkeys mas robustas en `Icon Hotkeys` y `Modules`:
  - los campos de hotkey quedaron de solo lectura (no capturan por click)
  - captura de hotkey solo por boton `Set`
  - `Esc` cancela captura sin guardar hotkey accidental
- Fix de estabilidad de popup de captura:
  - guard para evitar `destroy widget ... two times`
  - cierre seguro de ventana antes de abrir nueva captura
- UI layout:
  - `modulesScroll` con margen inferior para que `Leader Target Assist` ya no se corte abajo

### 2026-02-14

- Fix al `_Loader.lua` para no romper cuando falta algun script en `vBot/`:
  - ahora usa `pcall(dofile, ...)`
  - si un archivo no existe, lo salta y loguea `[_Loader] Skipping ...`
- MW ScrollDown integrado mejor en Setup:
  - nueva seccion en `Spells`: `MW Block Check`
  - selector con 3 modos: `Magic Wall`, `Wild Growth`, `Custom ID`
  - campo editable para `Custom ID`
  - `(?)` con explicacion clara del comportamiento
- Limpieza interna del Toolkit:
  - se elimino binding duplicado de MW mode que estaba en refresh
  - ajustes de anchors de botones `(?)` en `Modules` para evitar warnings recursivos en OTUI
- Validacion:
  - `scripts/druid_toolkit.lua` parsea OK (sin error de sintaxis Lua)

### 2026-02-12

- Merge completo con `origin/main` y resolucion de conflictos en Druid Toolkit.
- `Scripts` ahora editable in-game + boton `Save` (escritura al `.lua` cargado).
- Se agregaron/acomodaron botones `(?)` en `Icon Hotkeys` y en `Scripts` (File/Search/Viewer).
- Nuevo modulo `Open BP Minimized` dentro de Toolkit:
  - toggle + hotkey + `Open Script`
  - campo `Backpack Main ID` en General (`0` = usar backpack equipada).
- Guard anti-captura de hotkeys mientras estas en `pageScripts` para permitir escribir normal.
- Se mantuvo el fix de spellwand para no usar sobre containers.

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




