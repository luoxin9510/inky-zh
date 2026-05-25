# NOTICE

This repository is a **fork** of [inkle/inky](https://github.com/inkle/inky) at
version **0.15.2**. The original work is:

- **Project**: Inky — an editor for the [ink](http://www.inklestudios.com/ink)
  narrative scripting language
- **Original author / copyright holder**: inkle Ltd ( https://www.inklestudios.com )
- **Upstream repository**: https://github.com/inkle/inky
- **Declared license**: MIT — the upstream `app/package.json` declares
  `"license": "MIT"`. (At the time this fork was created the upstream
  repository did not ship a separate `LICENSE` file; the MIT declaration in
  `package.json` is the canonical license statement we are relying on for both
  the upstream code and this fork.)

## Changes in this fork

Compared to upstream `0.15.2`, this fork adds:

1. **In-app language selection** — a `View → Language` menu lets the user pick
   a UI language from any locale shipped in
   `app/main-process/i18n/*.json`. The choice is persisted to the existing
   `view-settings.json` in Electron's `userData` directory and survives across
   restarts. Without a saved choice the app falls back to
   `electron.app.getLocale()` (the original behaviour).
2. **Completed Simplified Chinese (`zh-CN`) translation** — covers ~100% of
   extractable strings, fixes several mistranslations and untranslated
   placeholders present in the upstream `zh-CN.json`.

Files touched:

- `app/main-process/i18n/i18n.js` — added `init()` and `availableLocales()`
- `app/main-process/i18n/zh-CN.json` — translations
- `app/main-process/appmenus.js` — new `Language` submenu
- `app/main-process/main.js` — load persisted language; add `changeLanguage` handler
- `app/main-process/projectWindow.js` — added `language` key to view-settings defaults
- `NOTICE.md`, `README.md` — attribution and fork notes

## License of changes

The changes introduced in this fork are released under the **MIT License**,
matching the upstream `package.json` declaration. By contributing to this fork
or using its modifications you accept that they are made available under the
same terms.

If inkle Ltd. (the original author) requests changes to attribution or wants
this fork taken down, please open an issue on this repository.
