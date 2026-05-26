// Build localized documentation: scans app/resources/Documentation/ for any
// WritingWithInk.<locale>.md files and runs createDocumentnavigation.js +
// markdown-html for each. Invoked from package.json postinstall after the
// default English build is done.
//
// Run from the `app/` directory (npm postinstall does this).

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const docDir = path.join(process.cwd(), 'resources', 'Documentation');
const outDir = path.join(process.cwd(), 'renderer', 'documentation');
const cssPath = path.join('resources', 'Documentation', 'documentation.css');

const RE = /^WritingWithInk\.([A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})?)\.md$/;

let entries;
try {
    entries = fs.readdirSync(docDir);
} catch (e) {
    console.log('No documentation directory found at ' + docDir + ', skipping localized docs.');
    process.exit(0);
}

const locales = entries
    .map(name => { const m = name.match(RE); return m ? m[1] : null; })
    .filter(Boolean);

if (locales.length === 0) {
    console.log('No localized WritingWithInk.<locale>.md files found - skipping localized docs build.');
    process.exit(0);
}

for (const locale of locales) {
    console.log('Building localized documentation for ' + locale + '...');
    const mdPath = path.join('resources', 'Documentation', 'WritingWithInk.' + locale + '.md');
    const outPath = path.join('renderer', 'documentation', 'embedded.' + locale + '.html');

    // 1) Sidebar nav (window.<locale>.html)
    execFileSync(process.execPath,
        [path.join('..', 'build', 'createDocumentnavigation.js'), locale],
        { stdio: 'inherit' });

    // 2) Rendered markdown (embedded.<locale>.html)
    // Re-use the markdown-html binary from node_modules.
    const isWin = process.platform === 'win32';
    const mdHtmlBin = path.join('node_modules', '.bin', isWin ? 'markdown-html.cmd' : 'markdown-html');
    execFileSync(mdHtmlBin,
        [mdPath, '-s', cssPath, '-o', outPath],
        { stdio: 'inherit', shell: isWin });
}

console.log('Localized documentation built for: ' + locales.join(', '));
