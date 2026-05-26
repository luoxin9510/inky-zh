// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 thread_in_tunnel.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、knot / function 名、参数名、divert 目标一律保留英文；仅翻译说明性注释。


/*
	以 tunnel 的形式 thread 进一段流程，并指定返回的目标位置。

	若该内容中的某个选项被选中，那么这些选项应该以 tunnel return (->->) 结尾。

	适合把同一段可选内容"粘贴"到多个位置。

	用法：


	- (opts)
		<- thread_in_tunnel(-> eat_apple, -> opts)
		<- thread_in_tunnel(-> eat_banana, -> get_going)
		*	[ 饿着肚子离开 ]
			-> get_going

	=== get_going
		你离开了。
		-> END

	=== eat_apple
		*	[ 吃一个苹果 ]
			你吃了一个苹果。但没什么用。
			->->

	=== eat_banana
		*	[ 吃一根香蕉 ]
			你吃了一根香蕉。非常满足。
			->->


*/

=== thread_in_tunnel(-> tunnel_to_run, -> place_to_return_to)

    ~ temp entryTurnChoice = TURNS()

    -> tunnel_to_run ->

 	// 如果 tunnel 中包含被选中的选项，回合计数就会增加；
 	// 此时应使用给定的返回点继续流程。
    {entryTurnChoice != TURNS():
        -> place_to_return_to
    }

    // 否则该 tunnel 只是径直走完，那我们就把它当作侧 thread 处理，关掉它。
    -> DONE