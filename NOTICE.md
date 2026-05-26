# 出处说明（NOTICE）

本仓库是 [inkle/inky](https://github.com/inkle/inky) 在版本 **0.15.2**
上的 **fork**。原作品信息：

- **项目**：Inky —— [ink](http://www.inklestudios.com/ink) 叙事脚本语言
  的官方编辑器
- **原作者 / 版权持有方**：inkle Ltd.（ https://www.inklestudios.com ）
- **上游仓库**：https://github.com/inkle/inky
- **声明的许可证**：MIT —— 上游 `app/package.json` 里声明了
  `"license": "MIT"`。（本 fork 创建时，上游仓库并未单独提供 `LICENSE`
  文件；`package.json` 中的 MIT 声明是我们对上游代码和本 fork 共同依据
  的权威许可证声明。）

## 本 fork 的改动

相对于上游 `0.15.2`，本 fork 增加了以下内容：

1. **应用内语言切换** —— 在 `View → Language`（中文界面下为
   `视图 → 语言`）下提供一个子菜单，让用户从
   `app/main-process/i18n/*.json` 中任选一种 UI 语言。所选语言会被写入
   Electron `userData` 目录下已有的 `view-settings.json`，重启后仍生效。
   未设置时回退到 `electron.app.getLocale()`（与上游行为一致）。
2. **完整的简体中文（`zh-CN`）翻译** —— 覆盖约 100% 可提取字符串，
   并修正了上游 `zh-CN.json` 中若干错译和遗漏占位符。
3. **《Writing with ink》文档的简体中文翻译**
   （`WritingWithInk.zh-CN.md`，约 3400 行）。所有 ink 代码块按原文
   逐字保留；英文标题原样保留，中文翻译以斜体小标题形式出现在其下方，
   这样每个 anchor ID 与文档内部交叉引用都能继续指向英文源文档。
   文档窗口会在当前 locale 有对应翻译时自动加载本地化 HTML，否则回退
   到英文版。

涉及修改 / 新增的文件：

- `app/main-process/i18n/i18n.js` —— 新增 `init()` 与 `availableLocales()`
- `app/main-process/i18n/zh-CN.json` —— UI 翻译
- `app/main-process/appmenus.js` —— 新增 `Language` 子菜单
- `app/main-process/main.js` —— 启动时加载持久化的语言；新增
  `changeLanguage` 处理逻辑
- `app/main-process/projectWindow.js` —— 在 view-settings 默认值中加入
  `language` 字段
- `app/main-process/documentationWindow.js` —— 当存在
  `window.<locale>.html` 时优先加载本地化文档
- `app/package.json` —— `postinstall` 在英文版文档生成之后，自动构建
  本地化文档
- `build/createDocumentnavigation.js` —— 接受可选的 locale 参数，用于
  生成 `window.<locale>.html`
- `build/buildLocalizedDocs.js` —— 新增；扫描所有
  `WritingWithInk.<locale>.md` 并依次跑构建管线
- `app/resources/Documentation/WritingWithInk.zh-CN.md` —— 简体中文翻译
- `NOTICE.md`、`README.md` —— 署名与 fork 说明

## 改动部分的许可证

本 fork 引入的所有改动以 **MIT 许可证** 发布，与上游 `package.json` 中
的声明一致。你为本 fork 贡献代码或使用其改动，即视为接受同样的许可
条款。

如 inkle Ltd.（原作者）希望我们调整署名方式，或希望本 fork 下架，
请在本仓库 issues 中告知，我们会配合处理。

---

## 欢迎翻译贡献

欢迎补充 **繁体中文（zh-TW）** 及其他语言。当前仅 zh-CN / fi-FI / ru-RU
随包发布，繁体中文菜单项已移除以避免显示无对应翻译的死键。

参与方式：见 README 的「为 Inky 贡献翻译」章节，或在
[GitHub Issues](https://github.com/luoxin9510/inky-zh/issues) 中开
issue 协调。
