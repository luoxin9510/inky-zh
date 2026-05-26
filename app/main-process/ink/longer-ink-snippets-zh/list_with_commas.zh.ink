// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_with_commas.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文。原文针对英文的 ", " 与 " and " 拼接习惯，
//       中文按"、"和"和"对应输出，仅翻译说明性注释 —— 函数体的分隔符也调整为中文标点。

/*
	接收一个 list，并用逗号拼接后打印出来。

	依赖：

		本函数依赖 "pop" 函数。

	用法：

		LIST fruitBowl = (apples), (bananas), (oranges)

		The fruit bowl contains {list_with_commas(fruitBowl)}.
*/

=== function list_with_commas(list)
	{ list:
		{_list_with_commas(list, LIST_COUNT(list))}
	}

=== function _list_with_commas(list, n)
	{pop(list)}{ n > 1:{n == 2:和|、}{_list_with_commas(list, n-1)}}

