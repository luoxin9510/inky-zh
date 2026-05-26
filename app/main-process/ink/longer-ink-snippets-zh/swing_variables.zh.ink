// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 swing_variables.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、VAR / CONST / function 名、参数名一律保留英文；仅翻译叙事文本与作者注释。


/*

	概述：

	这是一套追踪"好行为与坏行为"并返回玩家在游戏过程中所累计比例的系统。

	例如：玩家说过 15 句好话、5 句恶语，那么他就有 75% 是"好人"。

	这让游戏可以根据玩家选择的整体倾向做出判断，而不必关心他到底遇到了多少次抉择时刻。

	它也意味着玩家的行为会随时间趋于稳定 —— 每多做一个决定，对整体数值的影响会越来越小。简而言之：木已成舟。


	系统：

	每个概念都对应一个"swing variable"。在被赋予初始值之后，可以被"raise（抬高）"或"lower（压低）"。

	对于更重要的行为，可以使用"elevate（拔高）"或"ditch（弃之）"。对于几乎无法挽回的行为，可以用"escalate（升级）"或"demolish（摧毁）"。

	可通过下列查询函数测试该变量："high"、"up"、"mid"、"down"、"low"。

	注意：在玩家积累若干抉择以"播种"系统之前，系统不会返回"up"或"down"的结果。


	用法：

	// 初始化变量
	VAR niceness = INITIAL_SWING

	// 修改变量
	~ raise(niceness) 		// 记录一次友善的选择
	~ lower(niceness)		// 记录一次刻薄的选择

	// 测试变量
	I'm <>
	{
	- up(niceness):
		nice
	- down(niceness):
		nasty
	- else:
		undecided
	}
	<>.


*/


CONST INITIAL_SWING = 1001

=== function swing_count(x)
    ~ return (upness(x) + downness(x)) - 2

=== function swing_ready(x)
    ~ return swing_count(x) >= 2

=== function raise(ref x)
	~ x = x + 1000



=== function elevate(ref x)
    ~ raise(x)
    ~ raise(x)
    ~ raise(x)

=== function lower(ref x)
	~ x = x + 1

== function ditch (ref x)
    ~ lower(x)
    ~ lower(x)
    ~ lower(x)

=== function demolish(ref x)
    ~ x = x + 20

=== function escalate(ref x)
    ~ x = x + (20 * 1000)



=== function upness(x)
	~ return x / 1000

=== function downness(x)
	~ return x % 1000


=== function high(x)
    ~ return (1 * upness(x) >= downness(x) * 9)

=== function up(x)
	~ return swing_ready(x) && (4 * upness(x) >= downness(x) * 6)

=== function down(x)
	~ return swing_ready(x) && (6 * upness(x) <= downness(x) * 4)

=== function low(x)
	~ return swing_ready(x) && (9 * upness(x) <= downness(x) * 1)

=== function mid(x)
    // 如果 swing 还未就绪，此函数返回 true
    // 因为"up 为 false 且 down 为 false"
    ~ return (not up(x) && not down(x))

