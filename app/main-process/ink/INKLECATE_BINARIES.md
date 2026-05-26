# inklecate 二进制 —— 需要手动安装

本 fork **不包含** `inklecate` 编译器的二进制文件（`inklecate_mac`、
`inklecate_win.exe`、`inklecate_linux`），无论是原生版还是
`inkjs-compatible/` 变体都没有。上游 `inkle/inky` 把这些文件存在
Git LFS 里，GitHub 的源码 ZIP 只会包含约 130 字节的 LFS 指针文件；
而把这些指针文件再 push 一次会触发 GitHub 的 LFS pre-receive 钩子，
所以本仓库通过 `.gitignore` 把它们排除掉了。

只有当你想 **从源码运行 Inky** 或 **打包发布版本** 时才需要这些二进制
文件。如果你只是要修改中文翻译 / 语言切换代码，**不需要** 它们。

## 获取方式

挑哪种方便就用哪种：

### 方式 A —— 从 Inky 官方发布包里复制（推荐）

1. 到 <https://github.com/inkle/inky/releases> 下载与你操作系统匹配的
   Inky 发布包（例如 `Inky_windows.zip`）。
2. 解压后在 `resources/app.asar.unpacked/main-process/ink/` 目录里找
   到对应的二进制文件，按下方对应关系复制到本 fork 的相同位置：

   ```text
   inklecate_win.exe            → app/main-process/ink/inklecate_win.exe
   ink/ink-engine-runtime.*     （本仓库已包含）
   inkjs-compatible/inklecate_* → app/main-process/ink/inkjs-compatible/
   ```

   （根据你下载的包，把 `win` 替换为 `mac` 或 `linux`。）

### 方式 B —— 用 LFS 克隆上游仓库

```bash
git lfs install
git clone https://github.com/inkle/inky.git /tmp/inky-upstream
cp /tmp/inky-upstream/app/main-process/ink/inklecate_* \
   app/main-process/ink/
cp /tmp/inky-upstream/app/main-process/ink/inkjs-compatible/inklecate_* \
   app/main-process/ink/inkjs-compatible/
```

任选一种方式完成后，在 `app/` 目录下运行 `npm start`，Inky 就能正常
编译并游玩 ink 脚本了。
