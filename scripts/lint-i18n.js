#!/usr/bin/env node
// Validates every locale JSON under app/main-process/i18n/:
//   1. parses cleanly,
//   2. reports key-coverage vs the reference locale.
// Coverage <50% fails the build, <80% warns. Writes a markdown summary to
// $GITHUB_STEP_SUMMARY when running under GitHub Actions.
'use strict';

const fs = require('fs');
const path = require('path');

const I18N_DIR = path.join(__dirname, '..', 'app', 'main-process', 'i18n');
// zh-CN is the most complete locale in this fork - use it as the reference key set.
const REFERENCE_LOCALE = 'zh-CN';
const WARN_PCT = 80;
const FAIL_PCT = 50;

function loadJson(file) {
    const raw = fs.readFileSync(file, 'utf8');
    return JSON.parse(raw);
}

function nonEmptyKeyCount(obj) {
    let n = 0;
    for (const k of Object.keys(obj)) {
        const v = obj[k];
        if (typeof v === 'string' && v.length > 0) n++;
        else if (Array.isArray(v) && v.length > 0) n++;
        else if (v && typeof v === 'object' && Object.keys(v).length > 0) n++;
    }
    return n;
}

const summaryLines = [];
function summary(line) {
    summaryLines.push(line);
    console.log(line);
}

let hadFailure = false;

const files = fs.readdirSync(I18N_DIR)
    .filter(f => f.endsWith('.json'))
    .sort();

summary(`# i18n lint report`);
summary('');
summary(`Reference locale: \`${REFERENCE_LOCALE}\``);
summary('');

const parsed = {};
for (const f of files) {
    const full = path.join(I18N_DIR, f);
    try {
        parsed[f] = loadJson(full);
    } catch (e) {
        summary(`- ❌ \`${f}\`: JSON parse error: ${e.message}`);
        hadFailure = true;
    }
}

const refFile = `${REFERENCE_LOCALE}.json`;
if (!parsed[refFile]) {
    summary(`- ❌ Reference locale \`${refFile}\` missing or invalid; cannot compute coverage.`);
    writeSummaryAndExit(1);
}

const refKeys = new Set(Object.keys(parsed[refFile]));
const refTotal = refKeys.size;

summary('');
summary(`| Locale | Keys present | Non-empty | Coverage | Status |`);
summary(`|--------|--------------|-----------|----------|--------|`);

for (const f of files) {
    if (!parsed[f]) continue;
    const obj = parsed[f];
    const present = Object.keys(obj).filter(k => refKeys.has(k)).length;
    const nonEmpty = nonEmptyKeyCount(obj);
    const pct = refTotal === 0 ? 100 : Math.round((nonEmpty / refTotal) * 100);

    let status;
    if (f === refFile) {
        status = '📘 reference';
    } else if (pct < FAIL_PCT) {
        status = `❌ <${FAIL_PCT}% — failing build`;
        hadFailure = true;
    } else if (pct < WARN_PCT) {
        status = `⚠️  <${WARN_PCT}% — incomplete`;
    } else {
        status = '✅';
    }
    summary(`| \`${f}\` | ${present}/${refTotal} | ${nonEmpty}/${refTotal} | ${pct}% | ${status} |`);
}

writeSummaryAndExit(hadFailure ? 1 : 0);

function writeSummaryAndExit(code) {
    const summaryPath = process.env.GITHUB_STEP_SUMMARY;
    if (summaryPath) {
        try { fs.appendFileSync(summaryPath, summaryLines.join('\n') + '\n'); }
        catch (e) { console.error('Failed to write step summary:', e); }
    }
    process.exit(code);
}
