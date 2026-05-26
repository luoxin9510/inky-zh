// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_item_is_member_of.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	某个 list 条目是否源自某个特定的 list？传入 () 时返回 false。

	用法：

	LIST Fruits = apple, banana, melon
	LIST Veggies = carrot, cucumber

	~ temp x = apple
	I eat the {list_item_is_member_of(x, Fruits):fruit|vegetable}.

*/

=== function list_item_is_member_of(k, list)
   	~ return k && LIST_ALL(list) ? k