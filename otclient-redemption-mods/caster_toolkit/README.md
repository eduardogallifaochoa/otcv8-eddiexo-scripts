# Caster Toolkit (Druid / Sorcerer)

Mod standalone para clients basados en **OTClient Redemption** (ej.
[tibia-eddie-retroclientgod](https://github.com/eduardogallifaochoa/tibia-eddie-retroclientgod)).

No depende del framework de bot de OTCv8 (no usa `CaveBot`/`TargetBot`/`vBot`/`macro()`),
solo usa la API nativa de OTClient Redemption (`g_game`, `g_settings`, `g_keyboard`, `Controller`).
Por eso **no** funciona pegado en el Ingame Script Editor de vBot/OTCv8: es un mod real, con
manifest `.otmod`, que se instala copiando la carpeta a `mods/`.

## Instalacion (plug and play)

1. Copia toda la carpeta `caster_toolkit/` (los 3 archivos: `.otmod`, `.lua`, `.otui`) a la
   carpeta `mods/` de tu client, ej.:
   `<carpeta del client>/mods/caster_toolkit/`
2. Abre el client. El mod carga solo (`autoload: true`), no hace falta tocar nada mas.
3. Va a aparecer un icono nuevo en el top menu (icono de bot). Click para abrir el panel.

## Que hace

- **Auto Heal**: castea un hechizo de cura cuando el HP% baja del umbral configurado
  (cooldown-safe, no spamea el hechizo mas rapido que el cooldown configurado).
- **Emergency Heal**: umbral mas bajo, con su propio hechizo (ej. `exura vita` en Druid),
  tiene prioridad sobre el Auto Heal normal.
- **Auto Haste**: castea un hechizo (ej. `utani hur`) cada X ms mientras este activo.
- **Cure**: hechizo de cura de condicion (ej. `exana pox`), solo manual via hotkey.
- **Hotkeys configurables**: Heal Now, Emergency Heal Now, Haste Now, Cure Now,
  Toggle Auto Heal, Toggle Auto Haste. Se configuran con el boton `Set` (click y presiona la
  tecla) y `Clear` para sacar el bind. `Esc` cancela la captura sin guardar.
- **Vocacion**: selector Druid/Sorcerer que solo define los hechizos default (boton
  "Reset hechizos a defaults"); no pisa hechizos ya editados a mano.
- Todo se guarda en `g_settings` (persiste entre reinicios del client).

## Nota sobre los hechizos default

Los hechizos vienen precargados para un server 7.7-style (`exura gran`, `exura vita`,
`utani hur`, `exana pox`), pero **todos los campos de texto son editables**: si tu server usa
otras palabras o niveles, edita el texto en la ventana y `Guardar`.
