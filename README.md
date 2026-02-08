# otcv8-eddiexo-scripts

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
