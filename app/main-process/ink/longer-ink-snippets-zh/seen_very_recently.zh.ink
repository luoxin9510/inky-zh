// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 seen_very_recently.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、function 名、参数名、divert 目标一律保留英文；仅翻译说明性注释。

/*
	测试流程是否"非常近期"地经过了某个 gather —— 即最近 3 个回合之内。

	用法：

	- (welcome)
		"欢迎！"
	- (opts)
		*	{seen_very_recently(->welcome)}
			"抱歉，你好，是的。"
		+	"呃，什么？"
			-> opts
		*	"我们能不能继续？"

*/

=== function seen_very_recently(-> x)
    ~ return TURNS_SINCE(x) >= 0 && TURNS_SINCE(x) <= 3