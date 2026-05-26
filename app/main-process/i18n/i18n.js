const electron = require('electron');
const fs = require('fs');
const path = require('path');

class i18n {
    constructor() {
        this.currentLocale = null;
        this.msgs = {}

        electron.ipcMain.on('i18n._', (event, msgid) => {
            event.returnValue = this._(msgid);
        });
    }

    // Broadcast an 'i18n-changed' event to every BrowserWindow so renderers
    // can re-translate their DOM without a process restart.
    broadcastLocaleChange() {
        const wins = electron.BrowserWindow.getAllWindows();
        for (const w of wins) {
            try { w.webContents.send('i18n-changed', this.currentLocale); }
            catch (e) { /* window may be closing - ignore */ }
        }
    }

    // Called from main.js once user prefs are loaded.
    // `preferredLocale` overrides the OS locale when set.
    init(preferredLocale) {
        const locale = preferredLocale || electron.app.getLocale();
        this.switch(locale);
    }

    // Locale codes for every <locale>.json file shipped under this directory.
    availableLocales() {
        return fs.readdirSync(__dirname)
            .filter(f => f.endsWith('.json'))
            .map(f => path.basename(f, '.json'));
    }

    _(msgid) {
        if (!(msgid in this.msgs) || !this.msgs[msgid].length) {
            this.msgs[msgid] = msgid;
        }
        return this.msgs[msgid];
    }

    switch(lang) {
        this.currentLocale = lang;
        const file = path.join(__dirname, `${lang}.json`)
        if (fs.existsSync(file)) {
            try {
                // bust require cache so repeated switches re-read disk
                delete require.cache[require.resolve(file)];
                this.msgs = require(file);
            } catch (e) {
                // Corrupted JSON or read error - fall back to English source strings.
                console.error(`i18n: failed to load locale file ${file}:`, e);
                this.msgs = {};
            }
        } else {
            // English source strings are the fallback - clear table so _() returns msgid.
            this.msgs = {};
        }
    }
}

module.exports = new i18n();
