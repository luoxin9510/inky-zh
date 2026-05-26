# ink 翻译术语表与策略

本文件沉淀本 fork 在翻译 ink 示例故事（`app/main-process/ink/longer-ink-snippets-zh/`）
与 UI 字符串（`app/main-process/i18n/zh-CN.json`）时使用的术语与翻译策略。
未来的译者请遵循同一约定，以保证全仓库一致性。

## 不译的内容（必须保留英文 / 原样）

以下任何一项擅自中译都会破坏编译或语义：

- **ink 关键字**：`VAR`、`LIST`、`CONST`、`INCLUDE`、`function`、`temp`、
  `ref`、`return`、`true`、`false`、`and`、`or`、`not`、`mod`
- **流程关键字**：`-> DONE`、`-> END`、`->`（divert）、`->->`（tunnel return）、
  `<-`（thread call）、`<>`（glue / 粘连）
- **结构标记**：`==`（knot）、`=`（stitch）、`*`、`+`、`-`（choice / gather）、
  `~`（行内逻辑）、`(label)`（条件分支标签）
- **内置函数 / 全大写名**：`LIST_ALL`、`LIST_MIN`、`LIST_MAX`、`LIST_VALUE`、
  `LIST_COUNT`、`LIST_RANGE`、`LIST_RANDOM`、`LIST_INVERT`、`TURNS_SINCE`、
  `RANDOM`、`SEED_RANDOM`、`FLOOR`、`INT`、`MAX`、`MIN`
- **变量名 / knot 名 / stitch 名 / list 成员名 / 函数名**：保留原标识符，例如
  `bedroomLightState`、`murder_scene`、`pickup_cane`、`MeA1`、`Inventory`
- **divert 目标**：`-> opts`、`-> bet_opts(bets, true)` 中的 `opts`、`bet_opts`
  原样保留——这些是代码里能跳转到的"地址"
- **HTML 标签**：`<b>`、`</b>`、`<i>` 等保留原样
- **角色专有名**：Hooper、Russell、Carstairs、Joe、Half-Orc 等保留英文。
  二战英国背景（The Intercept）、奇幻战团（Sorcery!）等地方色彩在英语原文里
  非常浓，音译反而削弱风味
- **品牌 / 游戏标题**：Inky、ink、inkle、Sorcery!、Overboard!、80 Days、
  Heaven's Vault 一律保留

## 必须中译的内容

- 玩家可见的**叙事散文**（knot/stitch 体内的非 `~` 文本行）
- 玩家可见的**选项文本**（`*` `+` 后方括号 `[...]` 内外的可见文字）
- `// 单行注释` 与 `/* 块注释 */`（教学价值高，帮中文读者理解作者意图）
- 玩家可见的对白引号内文字

## 核心术语映射

| 英文 | 中文译法 | 备注 |
|---|---|---|
| knot | 节点 / Knot | UI 与教程中保留 "节点 Knot" 双语并列；代码内的 knot 名不译 |
| stitch | 支线 / Stitch | 同上 |
| choice | 选项 | 即 `*` / `+` 开头的行 |
| sticky choice | 粘性选项 | `+` 开头，可重复选择 |
| gather | 汇合点 / Gather | 即 `-` 开头的行 |
| divert | 跳转 / Divert | `->` 操作；UI 已用"跳转" |
| weave | 织体 / 编织结构 | 多层 `*` `-` 组成的结构 |
| thread | 线程 / Thread | `<- knot_name` 调用 |
| tunnel | 隧道 / Tunnel | `-> knot ->` + `->->` 返回 |
| list | 列表 / List | ink 的 LIST 类型 |
| read count | 读取次数 | knot/stitch 已被访问的次数 |
| variable text | 变体文本 | `{a|b|c}` 这种切换块 |
| shuffle | 乱序 | `{shuffle:...}` 块 |
| cycle | 轮播 | `{cycle:...}` 块 |
| seen / unseen | 已见 / 未见 | List 状态术语 |

## 翻译风格

- **第一人称**：英文的 `I` 译作"我"；`you`（旁白对玩家说话或角色对玩家说话）
  根据语境译作"你"。Inky 大量使用第二人称 narration，保留这种亲近感。
- **对白引号**：英文用 `'...'`（单引号），中译用中文引号 `"..."` 或保留单引号，
  视上下文连贯性而定；同一文件内保持一致。
- **省略号**：英文 `...` 通常保留 `...`；偶尔可换成中文 `……`，但要避免和 ink
  语法（`...`）混淆——ink 里 `...` 仅出现在选项可见文本中，影响很小。
- **HTML 标签**：`<b>...</b>` 这种格式标签保留原样，包裹住中文即可。
- **数字**：阿拉伯数字保留为数字（"2 个 1"），不要替换成"二个一"；这是
  swindlestones 这类骰子游戏的可读性需要。
- **文化梗**：首次出现的术语（pontoon、swindlestones、Bombe 机、in-tray 等）
  在叙事中用最贴近的中文意译；如确实需要保留原词味道（如 swindlestones 作为
  专有游戏名），首次出现时附译注 `（即骗子骰）`。

## 文件命名与组织

- 中译示例置于 `app/main-process/ink/longer-ink-snippets-zh/`，与原英文目录
  并列；文件名为 `<原名>.zh.ink`（例如 `murder_scene.zh.ink`）。
- 每个 `.zh.ink` 文件顶部加 4 行注释头（见下方模板）。
- 中译 UI 字符串集中在 `app/main-process/i18n/zh-CN.json`。

## 中译文件顶部模板

```ink
// 原作：inkle Ltd.（出处：<原例子的来源，如 The Intercept / Overboard! / Sorcery! / Writing with Ink>）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、变量名、knot 名、divert 目标、人名一律保留英文；
//       仅翻译叙事文本与作者注释。详见 docs/translation-glossary.md。
```

## 验证

每个 `.zh.ink` 翻译完成后至少做：

1. `node --check` 不适用于 .ink 文件，但可以用 `grep -nE '^\s*(VAR|LIST|CONST|->|==|=|~|\*|\+|-|//)' <file>`
   与英文原文 `diff`，**结构行行数必须一致**。
2. 如本机已按 `app/main-process/ink/INKLECATE_BINARIES.md` 安装好 inklecate，
   用真编译器编译一遍，确认无语法错误。
3. 在 Inky 内打开 `.zh.ink` 文件实际游玩一轮，确认选项/分支正常。
