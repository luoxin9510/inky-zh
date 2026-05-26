const electron = require('electron');
const BrowserWindow = electron.BrowserWindow;
const fs = require('fs');
const path = require("path");
const i18n = require('./i18n/i18n.js');

const electronWindowOptions = {
  width: 1000,
  height: 650,
  minWidth: 700,
  minHeight: 300,
  title: "Documentation",
  autoHideMenuBar: true
};

var documentationWindow = null;

// Pick window.<locale>.html if it has been built for the current locale,
// otherwise fall back to the default English window.html.
function resolveDocumentationFile() {
  const docsDir = path.join(__dirname, '..', 'renderer', 'documentation');
  const locale = i18n.currentLocale;
  if (locale) {
    const localized = path.join(docsDir, 'window.' + locale + '.html');
    if (fs.existsSync(localized)) {
      return localized;
    }
  }
  return path.join(docsDir, 'window.html');
}

function DocumentationWindow(theme) {
	electronWindowOptions.theme = theme;
  var w = new BrowserWindow(electronWindowOptions);
  w.loadURL("file://" + resolveDocumentationFile());

  // w.webContents.openDevTools();

  w.webContents.on("did-finish-load", () => {
    w.webContents.send("change-theme", theme);
    w.setMenu(null);
    w.show();
  });

  this.browserWindow = w;

  w.on("close", () => {
    documentationWindow = null;
  });
}

DocumentationWindow.openDocumentation = function (theme) {

  if( documentationWindow == null ) {
    documentationWindow = new DocumentationWindow(theme);
  }
  return documentationWindow;
}


DocumentationWindow.changeTheme = function (theme) {
  if( documentationWindow != null ) {
    documentationWindow.browserWindow.webContents.send("change-theme", theme);
  }
}

exports.DocumentationWindow = DocumentationWindow;
