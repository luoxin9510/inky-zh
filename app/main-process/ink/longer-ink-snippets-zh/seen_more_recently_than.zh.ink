// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 seen_more_recently_than.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、function 名、参数名、divert 目标一律保留英文；仅翻译说明性注释。

/*
	测试流程是否相对另一处 divert，更近期地到达了某个 divert。

	若我们从未到达过第一个 divert，则返回 false。
	若我们从未到达过第二个 divert，则返回 true。

	这在判断"我们在本场景里是否做过 X"时尤其有用。

	用法：

	- (start_of_scene)
		"欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			"你好！"

		+	{ not seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			["你好！"]
			我想开口说话，却一个字也吐不出来！
			-> opts


	=== cough_politely(-> go_to)
		*	(cough) [礼貌地咳一声]
			我清了清嗓子。
			-> go_to

*/

=== function seen_more_recently_than(-> link, -> marker)
	{ TURNS_SINCE(link) >= 0:
        { TURNS_SINCE(marker) == -1:
            ~ return true
        }
        ~ return TURNS_SINCE(link) < TURNS_SINCE(marker)
    }
    ~ return false

