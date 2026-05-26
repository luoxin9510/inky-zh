// 原作：inkle Ltd.（出处：The Intercept —— inkle 公开的二战间谍短篇示范作）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、变量名、knot 名、divert 目标、人名一律保留英文；
//       仅翻译叙事文本与作者注释。详见 docs/translation-glossary.md。
//
// 背景小注：故事发生在二战时期英国 Bletchley Park（布莱切利园，盟军破译德军
// 密码的中枢）。"Bombe" 是图灵团队为破解 Enigma 而造的电机—机械式解密机；
// "intercept" 指截获的德军电报；主角是密码学分析员，被指控偷走了 Bombe 上
// 的一个关键部件 "component"。

// 角色变量。只追踪两项，使用 +/- 的天平刻度
VAR forceful = 0
VAR evasive = 0


// 道具
VAR teacup = false
VAR gotcomponent = false


// 故事状态：这些既可以用 knot 的读取次数实现，也可以写函数收集更复杂的逻辑，或者直接用变量
VAR drugged = false
VAR hooper_mentioned = false

VAR losttemper = false
VAR admitblackmail = false

// 我们递给 Hooper 的是哪种线索？
CONST NONE = 0
CONST STRAIGHT = 1
CONST CHESS = 2
CONST CROSSWORD = 3
VAR hooperClueType = NONE

VAR hooperConfessed = false

CONST SHOE = 1
CONST BUCKET = 2
VAR smashingWindowItem = NONE

VAR notraitor = false
VAR revealedhooperasculprit = false
VAR smashedglass = false
VAR muddyshoes = false

VAR framedhooper = false

// 你拿那个部件做了什么？
VAR putcomponentintent = false
VAR throwncomponentaway = false
VAR piecereturned = false
VAR longgrasshooperframe = false


// DEBUG 模式提供几个调试快捷入口——发布前记得置为 false！
VAR DEBUG = false
{DEBUG:
	进入 DEBUG 模式！
	*	[从头开始……]	-> start
	*	[嫁祸 Hooper……] -> claim_hooper_took_component
	*	[进 Hooper 的小屋……] -> inside_hoopers_hut
- else:
	// 首次跳转：从哪里开始？
 -> start
}

 /*--------------------------------------------------------------------------------
	用函数封装角色立场的移动，方便日后扩展这套逻辑
--------------------------------------------------------------------------------*/


 === function lower(ref x)
 	~ x = x - 1

 === function raise(ref x)
 	~ x = x + 1

/*--------------------------------------------------------------------------------

	故事开场！

--------------------------------------------------------------------------------*/

=== start ===

//  开场
	- 	他们让我一直等着。
		*	14 号棚屋（Hut 14）[]。我坐下后门就被锁上了。
		我连支笔都没有，没法干活。口袋里揣着今早那份截获的电报，但盯着那堆乱码字母只会把我逼疯。
		我不是机器，不管他们怎么说我。

	- (opts)
		{|我用手指敲着行军桌。|}
 		* 	(think) [思考]
 			他们怀疑我是叛徒。他们认为是我偷了那台计算机上的部件。他们会去搜我的床铺和箱子。
			等他们找不到东西，{plan:接着}就会回来逼我开口。
			-> opts
 		*	(plan) [盘算]
 			{not think:要说我是什么，那就是|我是}解谜的人。算数快，填字游戏拿手，下棋一流。
 			可眼下这副局面——这个陷阱——制胜的一手棋是什么？
 			* * 	(cooperate) [配合]
	 				我必须配合。我的可信度是最大的筹码。一旦自相矛盾，或者跟别人的说法对不上，就完了。
	 				我只能祈祷他们别问到我不想答的问题。
		 			~ lower(forceful)
	 		* * 	[搪塞]
		 			那就放假情报吧。正如这场欧洲战争打的是谋略与截听，不是飞机与炸弹。
		 			我唯一的指望是端出一个比真相更入他们耳的故事。
		 			~ raise(forceful)
	 		* * 	(delay) [迂回]
		 			避而不答，能拖就拖。军队这种机器从不在单一战线上死磕。只要我走得够慢，事情自己会从别的方向解决，我的名声也能保住。
		 			~ raise(evasive)
		*	[等]
	- 	-> waited

= waited
	-	半小时后，Harris 指挥官回来了。他迅速把门带上，仿佛怕一个字脱口而出会随风溜进来。
		"那么，"他笨拙地开口。这场面实在不体面。
		*	"指挥官。"
			他点点头。<>
		*	(tellme) {not start.delay} "告诉我这究竟是怎么回事。"
			他摇摇头。
			"行了，咱们就别装了。"
		*	[等]
			我什么都没说。
	-	他端来两杯茶，装在金属马克杯里：他把杯子放在我俩之间的桌面上。
		*	{tellme} [否认] "我没装什么。"
			{cooperate:尽管我打定主意要配合，但我还是开始撒谎了。}
			Harris 一脸不悦。-> pushes_cup
		*	(took) [拿一杯]
			~ teacup = true
			我端起一杯，暖着手。这茶<>
		*	(what2) {not tellme} "出什么事了？"
			"你心里有数。"
			-> pushes_cup
		*	[等]
			我等他开口。
			- - (pushes_cup) 他把一杯往我这边推了一半：<>
	-	算个善意的示好。
		够让我抱点希望吗？
 		* 	(lift_up_cup) {not teacup} [接过来]
 				我{took:举起马克杯|端起马克杯，}吹了吹热气。烫得喝不下。
 				Harris 端起自己那杯，只是握着。
 				~ teacup = true
 				~ lower(forceful)
 		* 	{not teacup} [不接]
 				不过是一杯食堂的淡茶。我没动它。
 				~ raise(forceful)

		*	{teacup} 	[喝]
				我把杯子凑到嘴边，可烫得喝不下。

		*	{teacup} 	[等]
			我没说话，只是 -> lift_up_cup

- 	"挺难办的局面，"{lift_up_cup:他|Harris}开口{forceful <= 0:，语气严肃}。我见过他用这种生硬的腔调说话，但只有面对高层将领时才会这样。"想必你也明白。"
 		* 	[同意]
 				"是挺别扭，"我回答
 		* 	(disagree) [不同意]
 				"我没看出哪里别扭，"我回答
				 ~ raise(forceful)
				 ~ raise(evasive)
 		* 	[撒谎] -> disagree
 		* 	[支吾]
 				"想必你应付过比这更糟的，"我漫不经心地答
 				~ raise(evasive)
	- 	{ teacup:
 			~ drugged  = true
			<>，啜着我的茶，仿佛我俩是老朋友
 	  	}
		<>。

 	-
 		*	[观察他]
			他脸上什么都看不出来。我见过 Harris 豪爽大笑的样子。今天他绷得紧紧的，活像 5 号棚屋（Hut 5）里那台机器一样，是军队这部机器的一部分。

 		*	[等]
 			我等着看他怎么应。

 		*	{not disagree} [微笑]
 			我勉强挤出一抹笑。对方没有回应。
 			~ lower(forceful)

// 你为什么会在这里
	-
		"我们需要那个部件，"他说。

	-	//"当然，别无选择，"他继续说。
		{not missing_reel:
			-> missing_reel -> harris_demands_component
		}
	-
 		* 	[是的]
 			"我当然知道，"我答。
 		* (no) [不]
 			"不，我不知道。而且我还有工作要做……"
			"你这工作要做下去恐怕也挺难，你不觉得吗？"Harris 打断我。

 		* 	[支吾]
 				-> here_at_bletchley_diversion
 		* 	[撒谎]
 				-> no
 	-	-> missing_reel -> harris_demands_component

=== missing_reel ===
	*	[那个被偷走的部件……]
	*	[耸耸肩]
		我耸耸肩。
		->->
	- 	那个磁鼓今天下午从 Bombe（"邦巴"，图灵团队为破译 Enigma 而造的解密机）上不翼而飞。我们四个当时都在棚屋里，处理刚到的德军电文。结果一塌糊涂。是 Russell 发现接线板上少了一截。
	-	我们四个谁都可能拿走它；而除我们之外的人，也没人知道它值什么。

 		*	{forceful <= 0 }[惊慌] 他们会把这事按到我头上。他们需要一只替罪羊，好让工作继续推进。我是最容易下手的目标。比其他人都弱。
 			~ lower(forceful)
 		*	[盘算] 那么我的概率是四分之一。还行；只是这把赌注本身比我能承受的高了一截。
 			~ raise(evasive)
 		*	{evasive >= 0} [否认] 不过这一切仍只是走个过场。工作不会停。会再造一个替换部件，我们都会被重新派回岗位。我们太有价值了，不会被枪毙。
 			~ raise(forceful)
 	-	->->


=== here_at_bletchley_diversion
	"在 Bletchley 这里？当然。"
 	~ raise(evasive)
 	~ lower(forceful)
	"是这里，是此刻，"Harris 纠正。"我们没在跟所有人谈话。我想象得到你心里多半相当不爽。我想象得到你觉得自己被针对了。{ forceful < 0:你是个敏感的人。}"

 	* (fine) "我没事[。]，"我答。"这一切只是个误会，越早澄清越好。"
 		~ lower(forceful)
		"我完全同意。"接着他直截了当地说出来，一句指控。

	*	{forceful < 0}	"你这话是什么意思？"

 	* (sore) { forceful >= 0 } "你他妈说对了[。]我是不爽。是不是别人怂恿你来的？是 Hooper 吗？他向来嫉妒我。他……"
 		~ raise(forceful)
 		~ hooper_mentioned = true
		指挥官的胡子随着抿紧的嘴唇翘了起来。"哦是吗？嫉妒你的成就？"
 		很难不觉得他是在{ evasive > 1 :嘲弄|敷衍}我。
		"还是你的脑子？还是别的什么？"
 		* * 	"嫉妒我的天才[。]Hooper 就是受不了我比他聪明。我们整天关在那间棚屋里贴身共事。这让他抓狂。让他做出更糟的事。"
				"你是在暗示，Hooper 会因为嫉妒你而出卖这个国家的未来？"Harris 字斟句酌，活像个职业军人，每个字都摆在一处，构成围住我的合围。
 					* * * 	[是]
	 							"{ forceful > 0:他确实就那么小肚鸡肠|这种事我不会觉得他干不出来}。他是个阴险小人。"{ teacup : 我把茶杯放下。|我用手抹了把额头。}
	 							~ raise(forceful)
	 							~ teacup = false
 					* * * 	[不]
	 							"不，{ forceful >0:当然不是|我想不会吧}。"{ teacup :我把茶杯放回桌上|我托着杯底转动着杯子}。
							 	~ lower(forceful)
								~ teacup = false
 					* * * 	[支吾]
	 							"我也不知道我在暗示什么。我不明白现在到底是怎么回事。"
	 							~ raise(evasive)
								"可你心里其实清楚得很。"Harris 眯起眼睛。
								-> done

					- - - 	(suggest_its_a_lie) "我能说的就是，自从我到这里以来，他一直在想方设法把我压一头。如果他故意把这整桩事捅出来，就为了让我被送上军事法庭，我也不会奇怪。"
							"我们不审判平民，"Harris 答。"叛徒是直接绞死的，奉女王陛下的旨意。"
 					* * * 	"那敢情好[。]，"我利落地回答。
 					* * * 	(iamnotraitor) "我不是叛徒[。]，"我{forceful > 0 :利落地回答|颤抖着回答。"老天爷在上！"}
 					* * * 	[撒谎] -> iamnotraitor
					- - - 他回望我。

 		* * 	"嫉妒我的地位[。]我的名声。"{ forceful > 0:我清楚自己听起来有多狂妄，但还是硬着头皮说下去。|我不喜欢这样自吹自擂，但还是说了下去。} "Hooper 就是受不了一想到，等这一切结束，受封爵位的会是我，而他……"
				"要是德军登陆，谁也别想拿到爵位，"Harris 厉声道。他扫了一眼棚屋的门，确认门闩仍然落着，然后压低声音继续："你拿不到，Hooper 也拿不到。现在回答我。"
				自门关上以来，我第一次琢磨：万一我<i>不</i>回答，威胁会是什么。

 		* * 	[支吾]
 				~ teacup = false
 				~ raise(forceful)
 				"我哪知道？"我有些防御地答。{ teacup :我把茶杯放回桌上。}  -> suggest_its_a_lie


 	* [老实说] 	-> sore
 	* [撒谎] 		-> fine

-	(done) -> harris_demands_component


=== harris_demands_component ===
	"{here_at_bletchley_diversion:那么请回答|那么}。东西在你这儿吗？"Harris {forceful > 3:微微出汗|不再绕弯子}：Bletchley 在他眼皮底下出事。"你知道东西在哪儿吗？"
	 	* 	[是]
	 		"知道。"
	 		-> admitted_to_something
	 	* (nope) [不知道] "我完全不知道。"
	 					-> silence
	 	* [撒谎] 		-> nope
	 	* [支吾]
	 		"什么部件？"
			 ~ raise(evasive)
			 ~ lower(forceful)
			"别装糊涂，"他回。"{ not missing_reel:今天下午失踪的那个部件。}它在哪儿？"

	- 	{ not missing_reel:
			-> missing_reel ->
		}
 		* 	[配合] "我知道它在哪儿。"
 			-> admitted_to_something
 		* (nothing) [拖延] "这事我一概不知。"我嗓音发颤{ forceful > 0:，是气出来的|；我不习惯跟挎着枪的人正面对峙}。

 		* [撒谎] -> nothing
 		* [支吾]

			"我不知道你凭什么挑我开刀。{ forceful > 0:我要求请律师。|我想要个律师。}"

			"现在是战时，"Harris 答。"老天作证，要是为了找回那个部件得把你毙了，我就毙了你。听明白没？"他指着马克杯，-> drinkit

		-	(silence) 一阵冰冷的沉默。{ forceful > 2:我多少撬动了他一点。|{ evasive > 2:他对我的支吾开始不耐烦。}}

		// 喝茶并交代
		- (drinkit) "现在把茶喝了，老实交代。"
		 * { teacup  }   	[喝] 			-> drinkfromcup
