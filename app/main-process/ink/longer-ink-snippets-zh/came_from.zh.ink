// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 came_from.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	测试流程是否在本回合经过了某个特定的 gather。

	用法：

	- (welcome)
		"欢迎！"
	- (opts)
		*	{came_from(->welcome)}
			"也欢迎你！"
		*	"呃，什么？"
			-> opts
		*	"我们能不能继续？"

*/

=== function came_from(-> x)
    ~ return TURNS_SINCE(x) == 0