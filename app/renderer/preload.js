const i18n = require('./i18n.js');
const { ipcRenderer } = require('electron');

// Properties on `.i18n` elements we keep in sync with the current locale.
const TRANSLATABLE_PROPS = ['innerText', 'title', 'placeholder'];
// Stash the source (English) string on each property the first time we see it,
// so subsequent hot switches translate from the original rather than from the
// already-translated value.
const ORIG_ATTR = (prop) => `data-i18n-orig-${prop.toLowerCase()}`;

function refreshDom() {
    document.querySelectorAll('.i18n').forEach(elem => {
        TRANSLATABLE_PROPS.forEach(prop => {
            const stashAttr = ORIG_ATTR(prop);
            let original = elem.getAttribute(stashAttr);
            if (original === null) {
                // First visit - stash whatever was in the markup as the source.
                if (elem[prop]) {
                    original = elem[prop];
                    elem.setAttribute(stashAttr, original);
                } else {
                    return;
                }
            }
            elem[prop] = i18n._(original);
        });
    });
}

window.addEventListener('DOMContentLoaded', refreshDom);

// Main fires 'i18n-changed' when the user picks a new locale at runtime.
ipcRenderer.on('i18n-changed', () => {
    refreshDom();
});

// Expose for renderer modules that build DOM dynamically and want to opt in
// (and for the hot-switch handler if it lives in this process).
window.refreshI18nDom = refreshDom;

window.platform = process.platform;