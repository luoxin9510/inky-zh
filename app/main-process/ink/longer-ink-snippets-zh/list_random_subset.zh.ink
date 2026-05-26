// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 list_random_subset.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名一律保留英文；仅翻译说明性注释。

/*
	从 list 中返回一个随机子集。

	若源 list 为空，则返回空 list ()。即便不空，也有可能恰好返回 ()！

	依赖：

		需要 "pop"。

	用法：

		LIST fruitBowl = (apple), (banana), (melon)

		I put into my bag: {list_random_subset(fruitBowl)}.



*/

=== function list_random_subset(sourceList)
    ~ temp el = pop(sourceList)
    {el:
        { RANDOM(0,1) == 0:
            ~ el = ()
        }
        ~ return el + list_random_subset(sourceList)
    }
    ~ return ()