# inklecate binaries — manual install required

This fork **does not** ship the `inklecate` compiler binaries (`inklecate_mac`,
`inklecate_win.exe`, `inklecate_linux`) for either the native or
`inkjs-compatible/` variant. Upstream `inkle/inky` stores them in Git LFS, and
GitHub source ZIPs only contain the ~130-byte LFS pointer files. Re-shipping
those pointers triggers GitHub's LFS pre-receive hook on push, so they are
`.gitignore`d here.

You only need these binaries if you want to **run Inky from source** or
**package a release**. Editing the Chinese translation / language-selector
code does not require them.

## How to get them

Pick whichever is easiest:

### Option A — copy from an official Inky release (recommended)

1. Download the Inky build matching your OS from
   <https://github.com/inkle/inky/releases> (e.g. `Inky_windows.zip`).
2. Inside the unzipped release, find the `resources/app.asar.unpacked/main-process/ink/`
   directory. Copy these files into this fork:

   ```text
   inklecate_win.exe            → app/main-process/ink/inklecate_win.exe
   ink/ink-engine-runtime.*     (already present in this repo)
   inkjs-compatible/inklecate_* → app/main-process/ink/inkjs-compatible/
   ```

   (Replace `win` with `mac` / `linux` depending on the release you grabbed.)

### Option B — clone upstream with LFS

```bash
git lfs install
git clone https://github.com/inkle/inky.git /tmp/inky-upstream
cp /tmp/inky-upstream/app/main-process/ink/inklecate_* \
   app/main-process/ink/
cp /tmp/inky-upstream/app/main-process/ink/inkjs-compatible/inklecate_* \
   app/main-process/ink/inkjs-compatible/
```

After either option, `npm start` from `app/` should compile and play ink
scripts normally.
