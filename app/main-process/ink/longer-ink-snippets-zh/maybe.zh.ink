// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 maybe.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	让选项随机变化的快捷函数

	用法：

		*	{maybe()} [询问关于苹果的事]
		*	{maybe()} [询问关于橙子的事]
		*	{maybe()} [询问关于香蕉的事]


*/

=== function maybe(list)
	~ return RANDOM(1, 3) == 1

