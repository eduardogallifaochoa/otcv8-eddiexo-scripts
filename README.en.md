# otcv8-eddiexo-scripts

Language: **EN** | **ES**: see `README.md`

This repo is my scripts/profile setup for **OTCv8 / vBot**.

Main idea:
- stop pasting huge scripts into the *Ingame Script Editor*
- use a **loader-based** workflow: a tiny stable loader loads real `.lua` files from the repo

Optional donation (if my scripts helped you):
- https://paypal.me/eddielol

## Video (YouTube)

- https://www.youtube.com/watch?v=2BEvy-Cac7M

[![Walkthrough video](https://img.youtube.com/vi/2BEvy-Cac7M/0.jpg)](https://www.youtube.com/watch?v=2BEvy-Cac7M)

## What’s in here

- `vBot/`, `cavebot/`, `targetbot/`: base bot modules/scripts
- `_Loader.lua`: profile entrypoint (loads UI styles + scripts)
- `*_configs/` and `storage/`: configs (server/profile dependent)

## Where does my Lua code go?

Usually:
- put your module in a proper folder (`scripts/`, `bot_loaders/`, `ui/`, etc)
- wire it from `_Loader.lua` (directly or via a loader)

## Goals (if I keep pushing)

Realistically I’ll work on this until **Feb 27, 2026** (Resident Evil Requiem release), but the goals are:

- Make the bot more readable and editable (clean modules).
- UI/Setup windows to edit hotkeys + values without crashes.
- Chat-safe hotkeys (don’t fire while typing).
- Icon context menu (Shift + right click) to edit hotkeys/attributes.
- Tooltips/help for confusing settings.
- Later: a low-code layer + maybe an AI helper.

## Note about paid scripts

No paid/locked scripts should be committed.
If you have private stuff, put it in `private/` (ignored by git).

## Portable single-file Toolkit

- Generated file: `druid_toolkit_single.lua`
- Rebuild command:
```powershell
powershell -ExecutionPolicy Bypass -File tools/build_druid_toolkit_single.ps1
```
- Ingame Script Editor:
```lua
dofile('druid_toolkit_single.lua')
```

## Latest status

- 2026-02-18: functional stable version.
- This is the **last push for now**.
