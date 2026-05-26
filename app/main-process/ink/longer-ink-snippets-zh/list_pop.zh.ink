// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_pop.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	从 list 中取走最底部的元素并返回，同时修改该 list。

	若源 list 为空，则返回空 list ()。

	用法：

	LIST fruitBowl = (apple), (banana), (melon)

	I eat the {pop(fruitBowl)}. Now the bowl contains {fruitBowl}.

*/

=== function pop(ref _list)
    ~ temp el = LIST_MIN(_list)
    ~ _list -= el
    ~ return el