// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_prev_next.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	在带有数值的 list 里，要拿到"下一个相邻的值"可能有些棘手 —— 它未必等于当前值 + 1。

	比如：

	LIST ComboMultipliers = (one = 1), (two = 2), (five = 5), (ten = 10), (twenty = 20), (hundred = 100)

	one + 1 == two

	但

	two + 1 == ()，因为不存在对应数值 "3" 的 list 条目。

	下面这两个函数让我们能相对于当前条目找到 list 中的上一个 / 下一个值；若当前条目已是最大 / 最小值，则分别返回 ()。

	因此：
	LIST_PREV(five) == two
	LIST_NEXT(ten) == twenty

	以及

	LIST_PREV(one) = ()
	LIST_NEXT(hundred) = ()

*/

=== function LIST_PREV(listValue)
	// 返回不在"从当前值到最大值"这一范围内的最大值
    ~ return LIST_MAX(LIST_INVERT(LIST_RANGE(LIST_ALL(listValue),  listValue, LIST_MAX(LIST_ALL(listValue)))))

=== function LIST_NEXT(listValue)
	// 返回不在"从最小值到当前值"这一范围内的最小值
    ~ return LIST_MIN(LIST_INVERT(LIST_RANGE(LIST_ALL(listValue),  LIST_MIN(LIST_ALL(listValue)), listValue)))