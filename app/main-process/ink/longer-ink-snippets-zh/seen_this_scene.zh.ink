// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 seen_this_scene.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、VAR / function 名、参数名、divert 目标一律保留英文；仅翻译说明性注释。

/*
	测试流程是否在"本场景内"到达过某个 gather。它是 "seen_more_recently_than" 的一种扩展，但因实在常用，单独提取出来更方便。

	用法：

	// 在此定义场景起点
	~ sceneStart = -> start_of_scene

	- (start_of_scene)
		"欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_this_scene(-> cough_politely.cough) }
			"你好！"

		+	{ not seen_this_scene(-> cough_politely.cough) }
			["你好！"]
			我想开口说话，却一个字也吐不出来！
			-> opts


	=== cough_politely(-> go_to)
		*	(cough) [礼貌地咳一声]
			我清了清嗓子。
			-> go_to

*/


VAR sceneStart = -> seen_this_scene

=== function seen_this_scene(-> link)
	{  sceneStart == -> seen_this_scene:
		[ERROR] - 使用 "seen_this_scene" 之前必须先初始化 sceneStart 变量！
		~ return false
	}
	~ return seen_more_recently_than(link, sceneStart)


=== function seen_more_recently_than(-> link, -> marker)
	{ TURNS_SINCE(link) >= 0:
        { TURNS_SINCE(marker) == -1:
            ~ return true
        }
        ~ return TURNS_SINCE(link) < TURNS_SINCE(marker)
    }
    ~ return false

