// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_random_subset_of_size.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	从 list 中返回一个不超过给定大小的随机子集。

	若源 list 为空，则返回空 list ()；若可挑元素提前用尽，则返回完整 list。

	依赖：

		需要 "pop_random"。

	用法：

		LIST fruitBowl = (apple), (banana), (melon)

		I put into my bag: {list_random_subset_of_size(fruitBowl, 2)}.



*/

=== function list_random_subset_of_size(sourceList, n)
    { n > 0:
        ~ temp el = pop_random(sourceList)
        { el:
            ~ return el + list_random_subset_of_size(sourceList, n-1)
        }
    }
    ~ return ()
