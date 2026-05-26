# Writing with ink
*用 ink 写作*


<details>
  <summary>Table of Contents 目录</summary>

  * [Introduction 引言](#introduction)
  * [Part One: The Basics 第一部分：基础](#part-one-the-basics)
    * [1) Content 内容](#1-content)
    * [2) Choices 选项](#2-choices)
    * [3) Knots 节点（Knots）](#3-knots)
    * [4) Diverts 跳转（Diverts）](#4-diverts)
    * [5) Branching The Flow 分支流](#5-branching-the-flow)
    * [6) Includes and Stitches 包含文件与支线（Stitches）](#6-includes-and-stitches)
    * [7) Varying Choices 多变的选项](#7-varying-choices)
    * [8) Variable Text 可变文本](#8-variable-text)
    * [9) Game Queries and Functions 游戏查询与函数](#9-game-queries-and-functions)
  * [Part 2: Weave 第二部分：编织（Weave）](#part-2-weave)
    * [1) Gathers 汇合（Gathers）](#1-gathers)
    * [2) Nested Flow 嵌套流](#2-nested-flow)
    * [3) Tracking a Weave 追踪编织结构](#3-tracking-a-weave)
  * [Part 3: Variables and Logic 第三部分：变量与逻辑](#part-3-variables-and-logic)
    * [1) Global Variables 全局变量](#1-global-variables)
    * [2) Logic 逻辑](#2-logic)
    * [3) Conditional blocks (if/else) 条件块（if/else）](#3-conditional-blocks-ifelse)
    * [4) Temporary Variables 临时变量](#4-temporary-variables)
    * [5) Functions 函数](#5-functions)
    * [6) Constants 常量](#6-constants)
    * [7) Advanced: Game-side logic 进阶：游戏侧逻辑](#7-advanced-game-side-logic)
   * [Part 4: Advanced Flow Control 第四部分：高级流程控制](#part-4-advanced-flow-control)
     * [1) Tunnels 隧道（Tunnels）](#1-tunnels)
     * [2) Threads 线程（Threads）](#2-threads)
   * [Part 5: Advanced State Tracking 第五部分：高级状态追踪](#part-5-advanced-state-tracking)
     * [1) Basic Lists 基础列表](#1-basic-lists)
	 * [2) Reusing Lists 复用列表](#2-reusing-lists)
	 * [3) List Values 列表值](#3-list-values)
	 * [4) Multivalued Lists 多值列表](#4-multivalued-lists)
	 * [5) Advanced List Operations 高级列表运算](#5-advanced-list-operations)
	 * [6) Multi-list Lists 多列表的列表](#6-multi-list-lists)
	 * [7) Long example: crime scene 长示例：犯罪现场](#7-long-example-crime-scene)
	 * [8) Summary 小结](#8-summary)
   * [Part 6: International character support in identifiers 第六部分：标识符的国际化字符支持](#part-6-international-character-support-in-identifiers)
</details>

## Introduction
*引言*


**ink** 是一种围绕"为纯文本标注流程"这一理念构建的脚本语言，用于创作可交互的剧本。

最基本地说，它可以用来写一篇"自选历险（Choose Your Own）"风格的故事，或者一棵分支对话树。但它真正的强项，是写那些**选项众多、流程会大量重新汇合**的对话。

**ink** 提供了若干特性，让不懂技术的作者也能频繁地分支，并轻松呈现这些分支带来的大大小小的后果。

脚本本身追求干净、逻辑清晰，让分支对话能用肉眼直接测试。流程在尽可能多的地方采用**声明式**的写法来描述。

它也是按"反复修改"这一使用场景设计的——修改一段流程应当很快。

# Part One: The Basics
*第一部分：基础*


## 1) Content
*内容*


### The simplest ink script
*最简单的 ink 脚本*


最基础的 ink 脚本，就是一份 .ink 文件里的纯文本：

	Hello, world!

运行时，它会输出这段内容然后停下来。

不同的几行文本会产生不同的段落。脚本：

	Hello, world!
	Hello?
	Hello, are you there?

输出的样子也一样（依次三段）。


### Comments
*注释*


默认情况下，你文件里的所有文字都会出现在输出内容里，除非做了特殊标记。

最简单的标记就是注释。**ink** 支持两种注释。一种是写给读代码的人看的，编译器会忽略它：

	"What do you make of this?" she asked.

	// Something unprintable...

	"I couldn't possibly comment," I replied.

	/*
		... or an unlimited block of text
	*/

另一种是用来提醒作者自己"这里还要写"的，编译时编译器会把它打印出来：


	TODO: Write this section properly!

### Tags
*标签*


游戏运行时，文本内容会按"原样"显示。但有时给某一行内容附加额外信息、告诉游戏该如何处理这行内容，会很有用。

**ink** 提供了一套简单的"井号标签（hashtag）"系统来给内容行打标签：

	A line of normal game-text. # colour it blue

这些标签不会出现在主文本流里，但游戏可以读取它们并按需使用。详见 [Running Your Ink 运行你的 ink](RunningYourInk.md#marking-up-your-ink-content-with-tags)。

## 2) Choices
*选项*


游戏向玩家提供输入的方式是"文本选项"。一个文本选项用 `*` 字符标记。

如果没有给出别的流程指令，玩家做完选择后流程会接着进入下一行文本：

	Hello world!
	*	Hello back!
		Nice to hear from you!

会产生下面这样的游戏：

	Hello world
	1: Hello back!

	> 1
	Hello back!
	Nice to hear from you.

默认情况下，选项的文字会再次出现在输出里。

### Suppressing choice text
*抑制选项文字的输出*


有些游戏会把选项的"文字"和它的"结果"分开。在 **ink** 中，如果选项文字放在方括号里，那这段文字就不会被打印到响应文本里：

	Hello world!
	*	[Hello back!]
		Nice to hear from you!

产生：

	Hello world
	1: Hello back!

	> 1
	Nice to hear from you.

#### Advanced: mixing choice and output text
*进阶：混合选项文字与输出文字*


实际上方括号把选项的内容切成了三段。括号**前**的部分会同时出现在选项和输出里；括号**内**的部分只出现在选项里；括号**后**的部分只出现在输出里。等于给一行内容提供了两种"结尾方式"：

	Hello world!
	*	Hello [back!] right back to you!
		Nice to hear from you!

产生：

	Hello world
	1: Hello back!
	> 1
	Hello right back to you!
	Nice to hear from you.

这在写对话选项时特别有用：

	"What's that?" my master asked.
	*	"I am somewhat tired[."]," I repeated.
		"Really," he responded. "How deleterious."

产生：

	"What's that?" my master asked.
	1. "I am somewhat tired."
	> 1
	"I am somewhat tired," I repeated.
	"Really," he responded. "How deleterious."

### Multiple Choices
*多个选项*


要让选项真的成为"选项"，我们得提供多个可选项。直接列出即可：

	"What's that?" my master asked.
	*	"I am somewhat tired[."]," I repeated.
		"Really," he responded. "How deleterious."
	*	"Nothing, Monsieur!"[] I replied.
		"Very good, then."
	*  "I said, this journey is appalling[."] and I want no more of it."
		"Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."

会产生这样的游戏：

	"What's that?" my master asked.

	1: "I am somewhat tired."
	2: "Nothing, Monsieur!"
	3: "I said, this journey is appalling."

	> 3
	"I said, this journey is appalling and I want no more of it."
	"Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."

这套语法足以写出一组选项。但在真实游戏里，我们需要根据玩家的选择把流程从一个位置移到另一个位置。要做到这点，得引入更多一些的结构。

## 3) Knots
*节点（Knots）*


### Pieces of content are called knots
*内容片段被称为"节点（knot）"*


要让游戏能分支，我们得给一段段内容打上名字（就像老式纸质 gamebook 里的"第 18 段"那样）。

这些片段叫做 **knot**（节点），是 ink 内容的基本结构单元。

### Writing a knot
*编写一个 knot*


knot 的开头用两个或更多的等号标记：

	=== top_knot ===

（结尾的等号可加可不加；名字必须是不含空格的单个单词。）

knot 的开头是一行标题；其后的内容都属于这个 knot：

	=== back_in_london ===

	We arrived into London at 9.45pm exactly.

#### Advanced: a knottier "hello world"
*进阶：稍复杂一点的 "hello world"*


当你开始写 ink 文件时，**knot 外面**的内容会自动被运行。但 knot 里的内容不会自动运行，所以一旦你开始用 knot 装内容，就得告诉游戏该跳到哪里。这通过"跳转箭头" `->` 来完成，下一节会详细讲。

最简单的带 knot 的脚本是：

	-> top_knot

	=== top_knot ===
	Hello world!

不过 **ink** 不喜欢"散开的线头（loose ends）"，一旦它认为发生了这种情况，编译期或运行期就会发出警告。上面的脚本编译时会产生：

	WARNING: Apparent loose end exists where the flow runs out. Do you need a '-> END' statement, choice or divert? on line 3 of tests/test.ink

运行时会产生：

	Runtime error in tests/test.ink line 3: ran out of content. Do you need a '-> DONE' or '-> END'?

下面这段能正常运行也能正常编译：

	=== top_knot ===
	Hello world!
	-> END

`-> END` 是给作者和编译器的双重标记，意思是"故事流程到这里就该停了"。

## 4) Diverts
*跳转（Diverts）*


### Knots divert to knots knot
*跳转到另一个 knot*


你可以用 `->`（**跳转箭头**）告诉故事从一个 knot 移动到另一个 knot。跳转是即时发生的，不需要任何用户输入：

	=== back_in_london ===

	We arrived into London at 9.45pm exactly.
	-> hurry_home

	=== hurry_home ===
	We hurried home to Savile Row as fast as we could.

#### Diverts are invisible
*跳转是看不见的*


跳转是设计成"无缝"的，甚至可以发生在句子中间：

	=== hurry_home ===
	We hurried home to Savile Row -> as_fast_as_we_could

	=== as_fast_as_we_could ===
	as fast as we could.

输出和上面相同的一行：

	We hurried home to Savile Row as fast as we could.

#### Glue
*黏合（Glue）*


默认行为是在每一行新内容之前插入换行。但有些情况下，内容必须坚持不要换行——这时可以用 `<>`，也就是 **glue（黏合）**：

	=== hurry_home ===
	We hurried home <>
	-> to_savile_row

	=== to_savile_row ===
	to Savile Row
	-> as_fast_as_we_could

	=== as_fast_as_we_could ===
	<> as fast as we could.

也会产生：

	We hurried home to Savile Row as fast as we could.

你没法"用得太多" glue：多个 glue 挨在一起没有额外效果。（而且没办法"取消"一个 glue——一行一旦被黏住了就会一直黏着。）


## 5) Branching The Flow
*分支流*


### Basic branching
*基础分支*


把 knot、选项和跳转组合起来，就得到了"自选历险（choose-your-own）"类游戏的基本结构：

	=== paragraph_1 ===
	You stand by the wall of Analand, sword in hand.
	* [Open the gate] -> paragraph_2
	* [Smash down the gate] -> paragraph_3
	* [Turn back and go home] -> paragraph_4

	=== paragraph_2 ===
	You open the gate, and step out onto the path.

	...

### Branching and joining
*分支与合流*


借助跳转，作者可以分出多条流程再把它们汇回到一起，而玩家完全不会看出流程已经合流：

	=== back_in_london ===

	We arrived into London at 9.45pm exactly.

	*	"There is not a moment to lose!"[] I declared.
		-> hurry_outside

	*	"Monsieur, let us savour this moment!"[] I declared.
		My master clouted me firmly around the head and dragged me out of the door.
		-> dragged_outside

	*	[We hurried home] -> hurry_outside


	=== hurry_outside ===
	We hurried home to Savile Row -> as_fast_as_we_could


	=== dragged_outside ===
	He insisted that we hurried home to Savile Row
	-> as_fast_as_we_could


	=== as_fast_as_we_could ===
	<> as fast as we could.


### The story flow
*故事的流程*


knot 与跳转组合起来构成了游戏的基本"故事流"。这条流是"平的"——没有调用栈，跳转也不会"返回"。

在大多数 ink 脚本里，故事流从顶部开始，像一团意大利面那样到处乱蹿，最终（理想情况下）到达某个 `-> END`。

这种相当松散的结构让作者可以放手写——分支、再合流，根本不用担心结构本身。开新分支或新跳转不需要任何样板代码，也不需要追踪任何状态。

#### Advanced: Loops
*进阶：循环*


你完全可以用跳转来制造循环内容，而 **ink** 提供了好几个特性来配合循环用：可以让内容自我变化，也可以控制选项能被选中多少次。

详见 [Varying Text 可变文本](#8-variable-text) 和 [Conditional Choices 条件选项](#conditional-choices) 这两节。

哦对了，下面这段是合法的，但绝不是个好主意：

	=== round ===
	and
	-> round

## 6) Includes and Stitches
*包含文件与支线（Stitches）*


### Knots can be subdivided knot
*可以再细分*


随着故事变长，没有更多结构的话会越来越难管理。

knot 可以再分成叫 **stitch（支线）** 的子段，用**单个**等号标记：

	=== the_orient_express ===
	= in_first_class
		...
	= in_third_class
		...
	= in_the_guards_van
		...
	= missed_the_train
		...

比如说，可以拿一个 knot 当作一场戏，再用 stitch 表示这场戏里的各个事件。

### Stitches have unique names
*支线有唯一名字*


跳转到某个 stitch 时使用它的"地址"：

	*	[Travel in third class]
		-> the_orient_express.in_third_class

	*	[Travel in the guard's van]
		-> the_orient_express.in_the_guards_van

### The first stitch is the default
*第一个 stitch 是默认目标*


跳转到一个含有 stitch 的 knot 时，会跳到这个 knot 里**第一个** stitch。所以：

	*	[Travel in first class]
		"First class, Monsieur. Where else?"
		-> the_orient_express

等同于：

	*	[Travel in first class]
		"First class, Monsieur. Where else?"
		-> the_orient_express.in_first_class

（……除非我们调整了 knot 内部 stitch 的顺序！）

你也可以把内容放在 knot 顶部、所有 stitch 之外。但记得自己跳出去——引擎**不会**在走完头部内容后自动进入第一个 stitch：

	=== the_orient_express ===

	We boarded the train, but where?
	*	[First class] -> in_first_class
	*	[Second class] -> in_second_class

	= in_first_class
		...
	= in_second_class
		...


### Local diverts
*局部跳转*


在一个 knot 内部跳转到本 knot 的 stitch 时，不用写完整地址：

	-> the_orient_express

	=== the_orient_express ===
	= in_first_class
		I settled my master.
		*	[Move to third class]
			-> in_third_class

	= in_third_class
		I put myself in third.

这意味着 stitch 和 knot 不能重名，但**多个 knot 可以包含同名的 stitch**。（所以"东方快车"和"SS 蒙古号"都可以各自有一个 first class。）

如果出现歧义，编译器会警告你。

### Script files can be combined
*多个脚本文件可以合并*


你也可以用 include 语句把内容拆成多个文件：

	INCLUDE newspaper.ink
	INCLUDE cities/vienna.ink
	INCLUDE journeys/orient_express.ink

include 语句必须放在文件顶部，**不能**放在 knot 内部。

某个 knot 必须在哪个文件里才能被跳转到？没有这种限制——换句话说，拆分文件不会影响游戏的命名空间。

## 7) Varying Choices
*多变的选项*


### Choices can only be used once
*选项只能用一次*


默认情况下，游戏里的每个选项只能被选中一次。如果你的故事里没有循环，你永远不会注意到这一行为。但只要用了循环，你会很快发现选项一个个消失……

	=== find_help ===

		You search desperately for a friendly face in the crowd.
		*	The woman in the hat[?] pushes you roughly aside. -> find_help
		*	The man with the briefcase[?] looks disgusted as you stumble past him. -> find_help

产生：

	You search desperately for a friendly face in the crowd.

	1: The woman in the hat?
	2: The man with the briefcase?

	> 1
	The woman in the hat pushes you roughly aside.
	You search desperately for a friendly face in the crowd.

	1: The man with the briefcase?

	>

……再下一轮，就没有选项可选了。

#### Fallback choices
*兜底选项（Fallback choices）*


上面的例子之所以在那里停下来，是因为下一个 choice 步会触发"内容耗尽"运行时错误：

	> 1
	The man with the briefcase looks disgusted as you stumble past him.
	You search desperately for a friendly face in the crowd.

	Runtime error in tests/test.ink line 6: ran out of content. Do you need a '-> DONE' or '-> END'?

我们可以用"兜底选项（fallback choice）"解决。兜底选项不会显示给玩家，但当没有其他可选项时，游戏会自动"选"它。

兜底选项其实就是"没有选项文字的选项"：

	*	-> out_of_options

而且，稍微滥用一下语法，我们还能让兜底选项自带内容——用"选项+箭头"的写法：

	* 	->
		Mulder never could explain how he got out of that burning box car. -> season_2

#### Example of a fallback choice
*兜底选项的示例*


把这一招加进前面的例子，得到：

	=== find_help ===

		You search desperately for a friendly face in the crowd.
		*	The woman in the hat[?] pushes you roughly aside. -> find_help
		*	The man with the briefcase[?] looks disgusted as you stumble past him. -> find_help
		*	->
			But it is too late: you collapse onto the station platform. This is the end.
			-> END

产生：

	You search desperately for a friendly face in the crowd.

	1: The woman in the hat?
	2: The man with the briefcase?

	> 1
	The woman in the hat pushes you roughly aside.
	You search desperately for a friendly face in the crowd.

	1: The man with the briefcase?

	> 1
	The man with the briefcase looks disgusted as you stumble past him.
	You search desperately for a friendly face in the crowd.
	But it is too late: you collapse onto the station platform. This is the end.


### Sticky choices
*粘性选项（Sticky choices）*


"只能选一次"的行为并不总是我们想要的，所以 ink 还提供了第二种选项：**sticky（粘性）选项**。粘性选项不会被"用掉"，用 `+` 开头标记：

	=== homers_couch ===
		+	[Eat another donut]
			You eat another donut. -> homers_couch
		*	[Get off the couch]
			You struggle up off the couch to go and compose epic poetry.
			-> END

兜底选项也可以是粘性的：

	=== conversation_loop
		*	[Talk about the weather] -> chat_weather
		*	[Talk about the children] -> chat_children
		+	-> sit_in_silence_again

### Conditional Choices
*条件选项*


你也可以手动开关选项。**ink** 提供了相当多的逻辑可用，最简单的判断是"玩家有没有看过某段内容"。

游戏里每个 knot/stitch 都有唯一的地址（这样才能被跳转），我们就用同样的地址来检查它是否被看过：

	*	{ not visit_paris } 	[Go to Paris] -> visit_paris
	+ 	{ visit_paris 	 } 		[Return to Paris] -> visit_paris

	*	{ visit_paris.met_estelle } [ Telephone Mme Estelle ] -> phone_estelle

注意：测试 `knot_name` 时，**只要这个 knot 里任意一个 stitch 被看过**，结果就为真。

也要注意：条件并不会覆盖选项的"只能选一次"行为，所以如果你想让某个选项可以重复选，仍需使用粘性选项。

#### Advanced: multiple conditions
*进阶：多重条件*


你可以给一个选项加多个逻辑测试；这样的话，**所有测试都通过**才会显示该选项：

	*	{ not visit_paris } 	[Go to Paris] -> visit_paris
	+ 	{ visit_paris } { not bored_of_paris }
		[Return to Paris] -> visit_paris

#### Logical operators: AND and OR
*逻辑运算符：AND 与 OR*


上面的"多重条件"其实就是普通编程里的 AND 运算。ink 支持 `and`（也可以写成 `&&`）和 `or`（也可以写成 `||`），用法和常规一致，也支持括号：

	*	{ not (visit_paris or visit_rome) && (visit_london || visit_new_york) } [ Wait. Go where? I'm confused. ] -> visit_someplace

对非程序员说一句：`X and Y` 表示 X 和 Y 必须都为真；`X or Y` 表示至少有一个为真。我们没有 `xor`。

你也可以用标准的 `!` 表示 `not`，不过有时编译器会被搞糊涂——它会把 `{!text}` 当成"只显示一次"的列表。建议直接写 `not`，反正"否定的布尔测试"也没那么花哨。

#### Advanced: knot/stitch labels are actually read counts
*进阶：knot/stitch 名其实是阅读计数*


测试：

	*	{seen_clue} [Accuse Mr Jefferson]

实际上测试的是一个**整数**而不是 true/false 标记。一个被这样使用的 knot/stitch，本质上是一个整数变量，里面装的是"该地址的内容被玩家看过的次数"。

如果非 0，上面这种测试就会返回真，但你也可以更具体：

	* {seen_clue > 3} [Flat-out arrest Mr Jefferson]


#### Advanced: more logic
*进阶：更多逻辑*


**ink** 还支持比这里讲到的多得多的逻辑与条件 —— 见 [variables and logic 变量与逻辑](#part-3-variables-and-logic) 章节。


## 8) Variable Text
*可变文本*


### Text can vary
*文本可以变化*


到目前为止，我们看到的所有内容都是静态的、固定的文本。但内容也可以**在被打印的那一刻**发生变化。

### Sequences, cycles and other alternatives
*序列、循环及其他"备选块"*


最简单的文本变化由 **alternatives（备选块）**提供，它根据某种规则从几个候选里挑一个。**ink** 支持若干种。备选块写在 `{`…`}` 大括号里，元素之间用 `|`（竖线）分隔。

只有"某段内容被走过不止一次"时这些才有意义！

#### Types of alternatives
*备选块的种类*


**Sequences 序列**（默认）：

一个 sequence（又叫"stopping block"）会追踪自己被走过多少次，每次显示下一个元素。一旦走到最后一个，就一直显示最后那个。

	The radio hissed into life. {"Three!"|"Two!"|"One!"|There was the white noise racket of an explosion.|But it was just static.}

	{I bought a coffee with my five-pound note.|I bought a second coffee for my friend.|I didn't have enough money to buy any more coffee.}

**Cycles 循环**（用 `&` 标记）：

cycle 类似 sequence，但是会循环回到第一个：

	It was {&Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday} today.


**Once-only 只显示一次**（用 `!` 标记）：

once-only 类似 sequence，但走完所有内容后就什么也不显示。（可以想成"最后一个元素是空的 sequence"。）

	He told me a joke. {!I laughed politely.|I smiled.|I grimaced.|I promised myself to not react again.}

**Shuffles 洗牌**（用 `~` 标记）：

shuffle 会随机输出其中一个：

	I tossed the coin. {~Heads|Tails}.

#### Features of Alternatives
*备选块的特性*


备选块可以包含空元素：

	I took a step forward. {!||||Then the lights went out. -> eek}

备选块可以嵌套：

	The Ratbear {&{wastes no time and |}swipes|scratches} {&at you|into your {&leg|arm|cheek}}.

备选块里可以包含跳转语句：

	I {waited.|waited some more.|snoozed.|woke up and waited more.|gave up and left. -> leave_post_office}

也可以用在选项文字里：

	+ 	"Hello, {&Master|Monsieur Fogg|you|brown-eyes}!"[] I declared.

（……但有一个限制：选项的文字**不能**以 `{` 开头，因为它会被当成条件判断。）

（……不过这个限制还有一个小补丁：如果你在 `{` 之前转义一个空格 `\ `，ink 会把它当作文字。）

	+\	{&They headed towards the Sandlands|They set off for the desert|The party followed the old road South}

#### Examples
*示例*


把备选块放进循环里，可以毫不费力地造出"看起来很有智能、能追踪状态"的玩法。

下面是一版"打地鼠"（whack-a-mole），只有一个 knot。注意我们用了 once-only 选项加 fallback，以确保地鼠不会跑来跑去，并且游戏一定会结束：

	=== whack_a_mole ===
		{I heft the hammer.|{~Missed!|Nothing!|No good. Where is he?|Ah-ha! Got him! -> END}}
		The {&mole|{&nasty|blasted|foul} {&creature|rodent}} is {in here somewhere|hiding somewhere|still at large|laughing at me|still unwhacked|doomed}. <>
		{!I'll show him!|But this time he won't escape!}
		* 	[{&Hit|Smash|Try} top-left] 	-> whack_a_mole
		*  [{&Whallop|Splat|Whack} top-right] -> whack_a_mole
		*  [{&Blast|Hammer} middle] -> whack_a_mole
		*  [{&Clobber|Bosh} bottom-left] 	-> whack_a_mole
		*  [{&Nail|Thump} bottom-right] 	-> whack_a_mole
		*   ->
        	    Then you collapse from hunger. The mole has defeated you!
	            -> END


会产生下面这个"游戏"：

	I heft the hammer.
	The mole is in here somewhere. I'll show him!

	1: Hit top-left
	2: Whallop top-right
	3: Blast middle
	4: Clobber bottom-left
	5: Nail bottom-right

	> 1
	Missed!
	The nasty creature is hiding somewhere. But this time he won't escape!

	1: Splat top-right
	2: Hammer middle
	3: Bosh bottom-left
	4: Thump bottom-right

	> 4
	Nothing!
	The mole is still at large.
	1: Whack top-right
	2: Blast middle
	3: Clobber bottom-left

	> 2
	Where is he?
	The blasted rodent is laughing at me.
	1: Whallop top-right
	2: Bosh bottom-left

	> 1
	Ah-ha! Got him!


再来一段"生活忠告"。注意里面用了粘性选项——电视的诱惑永远不会褪色：

	=== turn_on_television ===
	I turned on the television {for the first time|for the second time|again|once more}, but there was {nothing good on, so I turned it off again|still nothing worth watching|even less to hold my interest than before|nothing but rubbish|a program about sharks and I don't like sharks|nothing on}.
	+	[Try it again]	 		-> turn_on_television
	*	[Go outside instead]	-> go_outside_instead

    === go_outside_instead ===
    -> END



#### Sneak Preview: Multiline alternatives
*预告：多行备选块*

**ink** 还有另一种格式，用于在"多行内容块"之间做备选。详见 [multiline blocks 多行块](#multiline-blocks) 一节。



### Conditional Text
*条件文本*


文本也可以根据逻辑测试来变化，跟选项一样：

	{met_blofeld: "I saw him. Only for a moment." }

或：

	"His real name was {met_blofeld.learned_his_name: Franz|a secret}."

它们可以单独出现一行，也可以嵌进一段内容里。甚至可以嵌套，所以：

	{met_blofeld: "I saw him. Only for a moment. His real name was {met_blofeld.learned_his_name: Franz|kept a secret}." | "I missed him. Was he particularly evil?" }

可以产生：

	"I saw him. Only for a moment. His real name was Franz."

或：

	"I saw him. Only for a moment. His real name was kept a secret."

或：

	"I missed him. Was he particularly evil?"

## 9) Game Queries and Functions
*游戏查询与函数*


**ink** 提供了几个有用的"游戏层级"查询函数，用来获取游戏状态，方便写条件逻辑。它们不算语言本身的一部分，但永远可用，作者也无法修改它们。某种意义上，它们就是这门语言的"标准库函数"。

约定上这些名字写成全大写。

### CHOICE_COUNT()

`CHOICE_COUNT` 返回**当前 chunk** 里到目前为止已经创建的选项数。例如：

	*	{false} Option A
	* 	{true} Option B
	*  {CHOICE_COUNT() == 1} Option C

会产生两个选项：B 和 C。这在控制"一轮里玩家能看到几个选项"时很有用。

### TURNS()

返回自游戏开始以来已经经过的回合数。

### TURNS_SINCE(-> knot)

`TURNS_SINCE` 返回从上次访问某个 knot/stitch 到现在经过的"步数"（严格地说，是玩家输入的次数）。

值为 0 表示"作为当前 chunk 的一部分被看到了"；值为 -1 表示"从未被看到过"；其他正值表示几个回合之前被看到的。

	*	{TURNS_SINCE(-> sleeping.intro) > 10} You are feeling tired... -> sleeping
	* 	{TURNS_SINCE(-> laugh) == 0}  You try to stop laughing.

注意传给 `TURNS_SINCE` 的参数是一个"divert target（跳转目标）"，不是 knot 地址本身（因为 knot 地址是一个数字——阅读计数——不是故事里的位置……）。

TODO: （需要给编译器加上 `-c` 选项）

#### Sneak preview: using TURNS_SINCE in a function
*预告：在函数里使用 TURNS_SINCE*


`TURNS_SINCE(->x) == 0` 这个测试太常用了，常常值得把它封成一个 ink 函数：

	=== function came_from(-> x)
		~ return TURNS_SINCE(x) == 0

[函数](#5-functions) 一节会更清楚地讲到这里的语法，不过上面这个写法让你能写出：

	* {came_from(->  nice_welcome)} 'I'm happy to be here!'
	* {came_from(->  nasty_welcome)} 'Let's keep this quick.'

……让游戏对玩家**刚刚**看过的内容做出反应。

### SEED_RANDOM()

测试时常常需要固定随机数生成器，让 ink 每次玩都产生同样的结果。方法是给随机数系统"种子"：

	~ SEED_RANDOM(235)

传给种子函数的数字可以任意，不同种子会产生不同的结果序列。

#### Advanced: more queries
*进阶：更多查询*


你可以自定义"外部函数"，但语法稍有不同——见下面的 [函数](#5-functions) 一节。


# Part 2: Weave
*第二部分：编织（Weave）*


到这里为止，我们一直在用最简单的方法构建"分支故事"：用"选项"链接到"页面"。

但这要求我们给故事里每个目的地都起一个唯一的名字，写作起来很慢，也会让人不愿意做小分支。

**ink** 还有一套强大得多的语法可用，专门为简化"始终向前"的故事流而设计（大多数故事都是向前的，但大多数计算机程序不是）。

这种格式叫 **weave（编织）**，它建立在基础的"内容/选项"语法之上，加了两个新特性：**gather 标记** `-`，以及**选项与汇合点的嵌套**。

## 1) Gathers
*汇合（Gathers）*


### Gather points gather the flow back together
*汇合点把流程重新汇合到一起*


回到本文档开头的那个"多选项"示例：

	"What's that?" my master asked.
		*	"I am somewhat tired[."]," I repeated.
			"Really," he responded. "How deleterious."
		*	"Nothing, Monsieur!"[] I replied.
		*  "I said, this journey is appalling[."] and I want no more of it."
			"Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."

在真实游戏里，这三个选项很可能都通向同一个结局——Monsieur Fogg 离开房间。我们可以用 **gather** 来实现这一点，**不需要**新建 knot 或加跳转：

	"What's that?" my master asked.
		*	"I am somewhat tired[."]," I repeated.
			"Really," he responded. "How deleterious."
		*	"Nothing, Monsieur!"[] I replied.
			"Very good, then."
		*  "I said, this journey is appalling[."] and I want no more of it."
		"Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."

	-	With that Monsieur Fogg left the room.

会产生下面这段试玩：

	"What's that?" my master asked.

	1: "I am somewhat tired."
	2: "Nothing, Monsieur!"
	3: "I said, this journey is appalling."

	> 1
	"I am somewhat tired," I repeated.
	"Really," he responded. "How deleterious."
	With that Monsieur Fogg left the room.

### Options and gathers form chains of content
*选项与汇合点串成内容链*


我们可以把"汇合-分支"这种结构串起来，组成一段始终向前的"分支序列"：

	=== escape ===
	I ran through the forest, the dogs snapping at my heels.

		* 	I checked the jewels[] were still in my pocket, and the feel of them brought a spring to my step. <>

		*  I did not pause for breath[] but kept on running. <>

		*	I cheered with joy. <>

	- 	The road could not be much further! Mackie would have the engine running, and then I'd be safe.

		*	I reached the road and looked about[]. And would you believe it?
		* 	I should interrupt to say Mackie is normally very reliable[]. He's never once let me down. Or rather, never once, previously to that night.

	-	The road was empty. Mackie was nowhere to be seen.

这就是最基本的 weave。本节剩下的内容会介绍更多特性：weave 可以嵌套、可以含支线和插队跳转、可以在自身内部跳转，最重要的是，可以**引用早先的选择来影响后面的结果**。

#### The weave philosophy weave
*的哲学*


weave 不只是"分支流的便捷封装"，它还是一种**写出更稳健内容**的方式。上面那个 `escape` 示例已经有 4 条可能路径了，更复杂的序列可能有非常非常多。如果用普通跳转，每次都得顺着跳转一个个追，错误很容易溜进来。

而 weave 保证流程"从顶部开始、向下落到底部"。基础的 weave 结构里，**流程错误是不可能发生的**，输出文本也能直接通读。也就是说你不用真在游戏里把所有分支都跑一遍来确认它们按预期工作。

weave 也方便修稿——尤其是把一句话拆开、插入更多选项以增添变化或调整节奏，**完全不需要重新搭建流程**。


## 2) Nested Flow
*嵌套流*


上面的 weave 都相当简单、"平"的结构。不管玩家怎么选，从顶到底走的回合数都一样。但有时候某些选择需要更多深度或复杂度。

为此，我们允许 weave 嵌套。

提醒一句：嵌套 weave 非常强大、非常紧凑，但需要一点时间适应！

### Options can be nested
*选项可以嵌套*


看下面这一场戏：

	- 	"Well, Poirot? Murder or suicide?"
	*	"Murder!"
	* 	"Suicide!"
	-	Ms. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.

第一个出现的选择是 "Murder!" 还是 "Suicide!"。Poirot 如果宣判自杀，那就没什么后续；但若是他认为是谋杀，就还需要追问——他怀疑谁？

我们可以通过一组**嵌套的子选项**来加新选项。告诉脚本"这些新选项是另一个选项的子选项"的方法是用**两个**星号而不是一个：


	- 	"Well, Poirot? Murder or suicide?"
		*	"Murder!"
		 	"And who did it?"
			* * 	"Detective-Inspector Japp!"
			* * 	"Captain Hastings!"
			* * 	"Myself!"
		* 	"Suicide!"
		-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.

（注意把行也跟着缩进以体现嵌套是好风格，不过编译器并不在乎缩进。）

如果我们也想给另一条路径加子选项，做法类似：

	- 	"Well, Poirot? Murder or suicide?"
		*	"Murder!"
		 	"And who did it?"
			* * 	"Detective-Inspector Japp!"
			* * 	"Captain Hastings!"
			* * 	"Myself!"
		* 	"Suicide!"
			"Really, Poirot? Are you quite sure?"
			* * 	"Quite sure."
			* *		"It is perfectly obvious."
		-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.

现在那个初始的指控选择会引出相应的追问——但无论哪条路，最终流程都会在那个 gather 点重新汇合，到 Mrs. Christie 客串的那段。

那如果我们想要更长的子场景呢？

### Gather points can be nested too
*汇合点也可以嵌套*


有时候不是要扩展选项的数量，而是要多加几拍剧情。我们可以**像嵌套选项一样嵌套汇合点**：

	- 	"Well, Poirot? Murder or suicide?"
			*	"Murder!"
			 	"And who did it?"
				* * 	"Detective-Inspector Japp!"
				* * 	"Captain Hastings!"
				* * 	"Myself!"
				- - 	"You must be joking!"
				* * 	"Mon ami, I am deadly serious."
				* *		"If only..."
			* 	"Suicide!"
				"Really, Poirot? Are you quite sure?"
				* * 	"Quite sure."
				* *		"It is perfectly obvious."
			-	Mrs. Christie lowered her manuscript a moment. The rest of the writing group sat, open-mouthed.

如果玩家选了 "murder"，他会在自己那条子分支上连选两次——一整段平铺的 weave，只属于他自己。

#### Advanced: What gathers do
*进阶：gather 到底做了什么*


gather 大体上是直觉的，但要把它的行为讲清楚有点难：一般规则是，玩家做完选择后，故事会找到**下一个不在更深层的 gather** 然后跳过去。

核心思路就一句话：**选项把故事的几条路径分开，gather 把它们合回来**。（所以叫 "weave"，编织！）


### You can nest as many levels are you like
*想嵌套多深都行*


上面我们只用了两层嵌套：主流程和子流程。但理论上深度没有上限：

	-	"Tell us a tale, Captain!"
		*	"Very well, you sea-dogs. Here's a tale..."
			* * 	"It was a dark and stormy night..."
					* * * 	"...and the crew were restless..."
							* * * *  "... and they said to their Captain..."
									* * * * *		"...Tell us a tale Captain!"
		*	"No, it's past your bed-time."
 	-	To a man, the crew began to yawn.

不过子层多了就难读也难改了，所以好风格是：一旦子选项变得不好处理，就跳出去到一个新的 stitch 里。

理论上你可以把整个故事写成一个 weave。

### Example: a conversation with nested nodes
*示例：带嵌套节点的对话*


来一段长例子：

	- I looked at Monsieur Fogg
	*	... and I could contain myself no longer.
		'What is the purpose of our journey, Monsieur?'
		'A wager,' he replied.
		* * 	'A wager!'[] I returned.
				He nodded.
				* * * 	'But surely that is foolishness!'
				* * *  'A most serious matter then!'
				- - - 	He nodded again.
				* * *	'But can we win?'
						'That is what we will endeavour to find out,' he answered.
				* * *	'A modest wager, I trust?'
						'Twenty thousand pounds,' he replied, quite flatly.
				* * * 	I asked nothing further of him then[.], and after a final, polite cough, he offered nothing more to me. <>
		* * 	'Ah[.'],' I replied, uncertain what I thought.
		- - 	After that, <>
	*	... but I said nothing[] and <>
	- we passed the day in silence.
	- -> END

下面是两种可能的试玩。短的一种：

	I looked at Monsieur Fogg

	1: ... and I could contain myself no longer.
	2: ... but I said nothing

	> 2
	... but I said nothing and we passed the day in silence.

长的一种：

	I looked at Monsieur Fogg

	1: ... and I could contain myself no longer.
	2: ... but I said nothing

	> 1
	... and I could contain myself no longer.
	'What is the purpose of our journey, Monsieur?'
	'A wager,' he replied.

	1: 'A wager!'
	2: 'Ah.'

	> 1
	'A wager!' I returned.
	He nodded.

	1: 'But surely that is foolishness!'
	2: 'A most serious matter then!'

	> 2
	'A most serious matter then!'
	He nodded again.

	1: 'But can we win?'
	2: 'A modest wager, I trust?'
	3: I asked nothing further of him then.

	> 2
	'A modest wager, I trust?'
	'Twenty thousand pounds,' he replied, quite flatly.
	After that, we passed the day in silence.

希望这能展示前面讲的哲学：weave 提供了一种紧凑的方式，能在保证"从开始走到结束"的前提下提供大量分支和选择！


## 3) Tracking a Weave
*追踪编织结构*


有时候 weave 本身就够用了。当不够用时，我们需要更多控制。

### Weaves are largely unaddressed weave
*基本上是无地址的*


默认情况下，weave 里的内容行没有地址或标签，意味着既不能跳转过去，也不能拿它来做条件测试。在最基本的 weave 结构里，选项决定玩家走过的路径和看到的内容，但一旦 weave 结束，这些选择和路径都被忘掉。

但若我们想"记住"玩家看过什么，可以——在需要的地方用 `(label_name)` 语法加标签。

### Gathers and options can be labelled
*汇合点与选项都可以打标签*


任意嵌套层级的 gather 点都可以用括号打标签：

	-  (top)

打了标签之后，gather 就和 knot/stitch 一样可以被跳转、也可以在条件里测试。这样你就能用以前的选择影响 weave 内部后面的结果，同时仍然享受"流程清晰、向前推进"的好处。

选项也可以像 gather 一样用括号打标签。标签括号要写在条件之前。

这些地址可以用在条件测试里，方便造出"靠其他选项解锁的选项"：

	=== meet_guard ===
	The guard frowns at you.

	* 	(greet) [Greet him]
		'Greetings.'
	*	(get_out) 'Get out of my way[.'],' you tell the guard.

	- 	'Hmm,' replies the guard.

	*	{greet} 	'Having a nice day?' // only if you greeted him

	* 	'Hmm?'[] you reply.

	*	{get_out} [Shove him aside] 	 // only if you threatened him
		You shove him sharply. He stares in reply, and draws his sword!
		-> fight_guard 			// this route diverts out of the weave

	-	'Mff,' the guard replies, and then offers you a paper bag. 'Toffee?'


### Scope
*作用域*


在同一个 weave 块里，你可以直接用标签名；从外面引用时需要写路径——要么是同一个 knot 里另一个 stitch：

	=== knot ===
	= stitch_one
		- (gatherpoint) Some content.
	= stitch_two
		*	{stitch_one.gatherpoint} Option

要么指向另一个 knot：

	=== knot_one ===
	-	(gather_one)
		* {knot_two.stitch_two.gather_two} Option

	=== knot_two ===
	= stitch_two
		- (gather_two)
			*	{knot_one.gather_one} Option


#### Advanced: all options can be labelled
*进阶：所有选项都可以打标签*


其实，ink 里的所有内容都是 weave，哪怕看不到 gather。这意味着你可以给游戏里**任何**选项打括号标签，然后用地址语法引用它。特别地，这让你能测试"玩家走到某个结局时具体选了哪个选项"。

	=== fight_guard ===
	...
	= throw_something
	*	(rock) [Throw rock at guard] -> throw
	* 	(sand) [Throw sand at guard] -> throw

	= throw
	You hurl {throw_something.rock:a rock|a handful of sand} at the guard.


#### Advanced: Loops in a weave
*进阶：weave 里的循环*


打标签让我们可以在 weave 内部造循环。下面是个标准模式——向 NPC 提问：

	- (opts)
		*	'Can I get a uniform from somewhere?'[] you ask the cheerful guard.
			'Sure. In the locker.' He grins. 'Don't think it'll fit you, though.'
		*	'Tell me about the security system.'
			'It's ancient,' the guard assures you. 'Old as coal.'
		*	'Are there dogs?'
			'Hundreds,' the guard answers, with a toothy grin. 'Hungry devils, too.'
		// We require the player to ask at least one question
		*	{loop} [Enough talking]
			-> done
	- (loop)
		// loop a few times before the guard gets bored
		{ -> opts | -> opts | }
		He scratches his head.
		'Well, can't stand around talking all day,' he declares.
	- (done)
		You thank the guard, and move away.




#### Advanced: diverting to options
*进阶：跳转到选项*


选项本身也可以被跳转到：但跳过去时会跳到"选中该选项之后产生的输出"，**就像该选项被选中了一样**。所以打印的内容会忽略方括号里的文字；如果这个选项是 once-only，它也会被标记为"用过了"：

	- (opts)
	*	[Pull a face]
		You pull a face, and the soldier comes at you! -> shove

	*	(shove) [Shove the guard aside] You shove the guard to one side, but he comes back swinging.

	*	{shove} [Grapple and fight] -> fight_the_guard

	- 	-> opts

产生：

	1: Pull a face
	2: Shove the guard aside

	> 1
	You pull a face, and the soldier comes at you! You shove the guard to one side, but he comes back swinging.

	1: Grapple and fight

	>

#### Advanced: Gathers directly after an option
*进阶：选项正下方的 gather*


下面这样的写法是合法的，而且常常很有用：

	*	"Are you quite well, Monsieur?"[] I asked.
		- - (quitewell) "Quite well," he replied.
	*	"How did you do at the crossword, Monsieur?"[] I asked.
		-> quitewell
	*	I said nothing[] and neither did my Master.
	-	We feel into companionable silence once more.

注意第一个选项正下方有一个第 2 级的 gather 点：这里其实没什么要"汇合"的，但它给了我们一个方便的位置，让第二个选项可以跳过去。




# Part 3: Variables and Logic
*第三部分：变量与逻辑*


到目前为止，我们已经用"玩家看过哪些内容"做条件，写了条件文本和条件选项。

**ink** 还支持**变量**——临时的和全局的、存数值/内容、甚至存"故事流程命令"的都行。它在逻辑这一块功能完整，并且提供了几个额外的结构来帮助管理分支故事中往往很复杂的逻辑。


## 1) Global Variables
*全局变量*


最强大的一类变量——可以说对故事最有用的一类——是用来保存"游戏状态某个独有属性"的变量：从主角口袋里有多少钱，到表示主角心情的某个值都行。

这类变量叫**全局（global）**变量，因为它在故事的任何位置都能访问——既能读也能写。（传统编程里通常会避免这类东西，因为它让程序的一部分能干扰另一无关部分。但故事就是故事，故事就讲一个"后果"：发生在 Vegas 的事很少能留在 Vegas。）

### Defining Global Variables
*定义全局变量*


全局变量可以在任何位置用 `VAR` 语句定义。必须给一个初始值，初始值决定变量的类型——整数、浮点（小数）、内容、或故事地址。

	VAR knowledge_of_the_cure = false
	VAR players_name = "Emilia"
	VAR number_of_infected_people = 521
	VAR current_epilogue = -> they_all_die_of_the_plague

### Using Global Variables
*使用全局变量*


我们可以用前面看过的方式测试全局变量来控制选项、提供条件文本：

	=== the_train ===
		The train jolted and rattled. { mood > 0:I was feeling positive enough, however, and did not mind the odd bump|It was more than I could bear}.
		*	{ not knows_about_wager } 'But, Monsieur, why are we travelling?'[] I asked.
		* 	{ knows_about_wager} I contemplated our strange adventure[]. Would it be possible?

#### Advanced: storing diverts as variables
*进阶：把跳转当变量来存*


"跳转（divert）"语句本身就是一种**值**，它能被存、被改、被跳转：

	VAR 	current_epilogue = -> everybody_dies

	=== continue_or_quit ===
	Give up now, or keep trying to save your Kingdom?
	*  [Keep trying!] 	-> more_hopeless_introspection
	*  [Give up] 		-> current_epilogue


#### Advanced: Global variables are externally visible
*进阶：全局变量对外部可见*


全局变量在 runtime 里也可以被读和改，所以是"游戏代码与故事"之间通信的好渠道。

**ink** 层常常是个适合存放"玩法变量"的地方——没有存档/读档问题要担心，故事本身也能对当前值做出反应。



### Printing variables
*打印变量*


变量的值可以作为内容打印出来，用一个类似 sequence 和条件文本的内联语法：

	VAR friendly_name_of_player = "Jackie"
	VAR age = 23

	My name is Jean Passepartout, but my friend's call me {friendly_name_of_player}. I'm {age} years old.

这对调试也有用。要做更复杂的"基于逻辑和变量的打印"，见后面"函数"那一节。

### Evaluating strings
*字符串求值*


你可能注意到上面我们说变量能存"内容（content）"而不是"字符串（string）"。这是有意的，因为 ink 定义的字符串里可以包含 ink——不过它最终一定会求值为一个字符串。（吓人吧！）

	VAR a_colour = ""

	~ a_colour = "{~red|blue|green|yellow}"

	{a_colour}

……会产生 red、blue、green、yellow 之一。

注意一旦这种内容被求值过了，它的值就"粘住了"。（量子态塌缩。）所以下面：

	The goon hits you, and sparks fly before you eyes, {a_colour} and {a_colour}.

……不会产生很有意思的效果。（要是你真希望它每次都变，请用一个文本函数来打印颜色！）

这也是为什么

	VAR a_colour = "{~red|blue|green|yellow}"

被明确禁止——它会在故事**构建**的时候求值，这多半不是你想要的。


## 2) Logic
*逻辑*


显然，我们的全局变量并不打算当作常量用，所以需要一套语法来修改它们。

由于默认情况下 **ink** 脚本里的任何文本都会直接打印到屏幕，我们需要一个标记符号表示"这一行是要做数值运算的"——这个标记就是 `~`。

下面这些语句都给变量赋值：


	=== set_some_variables ===
		~ knows_about_wager = true
		~ x = (x * x) - (y * y) + c
		~ y = 2 * x * y

下面这些用来测试条件：

	{ x == 1.2 }
	{ x / 2 > 4 }
	{ y - 1 <= x * x }

### Mathematics
*数学*


**ink** 支持四种基本数学运算（`+`、`-`、`*`、`/`），加上 `%`（或 `mod`，返回整除的余数）。还有 `POW` 表示"几次方"：

	{POW(3, 2)} is 9.
	{POW(16, 0.5)} is 4.


如果需要更复杂的运算，可以写函数（必要时用递归），或者调用外部游戏代码里的函数（处理更高级的事）。


#### RANDOM(min, max)

ink 可以用 `RANDOM` 函数生成随机整数。`RANDOM` 是设计成像骰子那样的（是的，杠精们，我们说的是 *a dice*），min 和 max **都是闭区间**：

	~ temp dice_roll = RANDOM(1, 6)

	~ temp lazy_grading_for_test_paper = RANDOM(30, 75)

	~ temp number_of_heads_the_serpent_has = RANDOM(3, 8)

可以为了测试给随机数生成器设种子，见前面"Game Queries and Functions 游戏查询与函数"一节。

#### Advanced: numerical types are implicit
*进阶：数值类型是隐式的*


运算结果——特别是除法的结果——基于输入的类型来决定。整数除法返回整数，浮点除法返回浮点：

	~ x = 2 / 3
	~ y = 7 / 3
	~ z = 1.2 / 0.5

会把 `x` 设为 0、`y` 设为 2、`z` 设为 2.4。

#### Advanced: INT(), FLOOR() and FLOAT()
*进阶：INT()、FLOOR() 和 FLOAT()*


如果你不想要隐式类型转换，或者想把一个变量向下取整，可以直接转换：

	{INT(3.2)} is 3.
	{FLOOR(4.8)} is 4.
	{INT(-4.8)} is -4.
	{FLOOR(-4.8)} is -5.

	{FLOAT(4)} is, um, still 4.



### String queries
*字符串查询*


对一个文本引擎来说挺奇怪：**ink** 在字符串处理上没多少功能——它假定任何字符串处理都由游戏代码（或者外部函数）来做。但我们支持三种基本查询：相等、不相等、子串（我们用 `?`，原因在后面的章节会清楚）。

下面这些都返回 true：

	{ "Yes, please." == "Yes, please." }
	{ "No, thank you." != "Yes, please." }
	{ "Yes, please" ? "ease" }


## 3) Conditional blocks (if/else)
*条件块（if/else）*


我们已经看到条件用来控制选项和故事内容；**ink** 也提供了与常见 if/else-if/else 结构等价的写法。

### A simple 'if'
*一个简单的 if*


if 的语法沿用了前面条件的写法，`{`…`}` 表示"在测试某个东西"：

	{ x > 0:
		~ y = x - 1
	}

也可以提供 else 分支：

	{ x > 0:
		~ y = x - 1
	- else:
		~ y = x + 1
	}

### Extended if/else if/else blocks
*扩展的 if/else if/else 块*


上面的语法实际上只是一种更通用结构的特例——有点像别的语言的 switch 语句：

	{
		- x > 0:
			~ y = x - 1
		- else:
			~ y = x + 1
	}

用这种形式我们可以包含 else-if 条件：

	{
		- x == 0:
			~ y = 0
		- x > 0:
			~ y = x - 1
		- else:
			~ y = x + 1
	}

（注意，和其他一切一样，空白完全是为了可读性，没有任何语法含义。）

### Switch blocks switch
*块*


ink 还真有一个 switch 语句：

	{ x:
	- 0: 	zero
	- 1: 	one
	- 2: 	two
	- else: lots
	}

#### Example: context-relevant content
*示例：上下文相关的内容*


注意这些测试不一定要基于变量——它们也可以用阅读计数，跟其他条件一样。下面这种构造相当常见，用法等同于"做一段当前游戏状态相关的内容"：

	=== dream ===
		{
			- visited_snakes && not dream_about_snakes:
				~ fear++
				-> dream_about_snakes

			- visited_poland && not dream_about_polish_beer:
				~ fear--
				-> dream_about_polish_beer

			- else:
				// breakfast-based dreams have no effect
				-> dream_about_marmalade
		}

这种语法的好处是**易扩展、易设优先级**。



### Conditional blocks are not limited to logic
*条件块并不局限于做逻辑*


条件块既可以控制逻辑，也可以控制故事内容：

	I stared at Monsieur Fogg.
	{ know_about_wager:
		<> "But surely you are not serious?" I demanded.
	- else:
		<> "But there must be a reason for this trip," I observed.
	}
	He said nothing in reply, merely considering his newspaper with as much thoroughness as entomologist considering his latest pinned addition.

你甚至可以把选项放进条件块里：

	{ door_open:
		* 	I strode out of the compartment[] and I fancied I heard my master quietly tutting to himself. 			-> go_outside
	- else:
		*	I asked permission to leave[] and Monsieur Fogg looked surprised. 	-> open_door
		* 	I stood and went to open the door[]. Monsieur Fogg seemed untroubled by this small rebellion. -> open_door
	}

……但注意上面例子里没有用 weave 语法和嵌套，这不是偶然：为了避免各种嵌套混在一起搞混，**条件块里不允许包含 gather 点**。

### Multiline blocks
*多行块*


还有另一类多行块，是对前面"备选块"系统的扩展。下面几种都合法，效果你大概也猜到了：

 	// Sequence: go through the alternatives, and stick on last
	{ stopping:
		-	I entered the casino.
		-  I entered the casino again.
		-  Once more, I went inside.
	}

	// Shuffle: show one at random
	At the table, I drew a card. <>
	{ shuffle:
		- 	Ace of Hearts.
		- 	King of Spades.
		- 	2 of Diamonds.
			'You lose this time!' crowed the croupier.
	}

	// Cycle: show each in turn, and then cycle
	{ cycle:
		- I held my breath.
		- I waited impatiently.
		- I paused.
	}

	// Once: show each, once, in turn, until all have been shown
	{ once:
		- Would my luck hold?
		- Could I win the hand?
	}

#### Advanced: modified shuffles
*进阶：变体的 shuffle*


上面那个 shuffle 块其实是"shuffled cycle"——它会洗牌、按顺序播完、再洗牌再循环。

还有两个 shuffle 变体：

`shuffle once`：洗牌、播完一遍、之后什么也不显示。

	{ shuffle once:
	-	The sun was hot.
	- 	It was a hot day.
	}

`shuffle stopping`：把内容（除最后一项外）洗牌、播完之后停在最后一项。

	{ shuffle stopping:
	- 	A silver BMW roars past.
	-	A bright yellow Mustang takes the turn.
	- 	There are like, cars, here.
	}


## 4) Temporary Variables
*临时变量*


### Temporary variables are for scratch calculations
*临时变量用于一次性计算*


有时候，全局变量太"重"。**ink** 提供了临时变量来做一些临时计算：

	=== near_north_pole ===
		~ temp number_of_warm_things = 0
		{ blanket:
			~ number_of_warm_things++
		}
		{ ear_muffs:
			~ number_of_warm_things++
		}
		{ gloves:
			~ number_of_warm_things++
		}
		{ number_of_warm_things > 2:
			Despite the snow, I felt incorrigibly snug.
		- else:
			That night I was colder than I have ever been.
		}

故事一旦离开定义该临时变量的 stitch，里面的值就会被丢弃。

### Knots and stitches can take parameters knot
*和 stitch 可以接受参数*


参数是一种特别有用的临时变量。任何 knot/stitch 都可以接受一个参数：

	*	[Accuse Hasting]
			-> accuse("Hastings")
	*	[Accuse Mrs Black]
			-> accuse("Claudia")
	*	[Accuse myself]
			-> accuse("myself")

	=== accuse(who) ===
		"I accuse {who}!" Poirot declared.
		"Really?" Japp replied. "{who == "myself":You did it?|{who}?}"
		"And why not?" Poirot shot back.


……如果你想把一个临时值从一个 stitch 传到另一个，参数是必需的！

#### Example: a recursive knot definition
*示例：递归 knot 定义*


临时变量在递归里是安全的（全局变量不行），所以下面这段能正常工作：

	-> add_one_to_one_hundred(0, 1)

	=== add_one_to_one_hundred(total, x) ===
		~ total = total + x
		{ x == 100:
			-> finished(total)
		- else:
			-> add_one_to_one_hundred(total, x + 1)
		}

	=== finished(total) ===
		"The result is {total}!" you announce.
		Gauss stares at you in horror.
		-> END


（事实上这种定义有用到 **ink** 专门为它提供了一种特殊 knot——名字也很有想象力地叫 `function`——它有特定限制，并且可以返回值。见下一节。）


#### Advanced: sending divert targets as parameters
*进阶：把跳转目标当参数传*


knot/stitch 地址是一种值（用 `->` 字符标记），可以被存、被传递。所以下面这样既合法又常用：

	=== sleeping_in_hut ===
		You lie down and close your eyes.
		-> generic_sleep (-> waking_in_the_hut)

	===	 generic_sleep (-> waking)
		You sleep perchance to dream etc. etc.
		-> waking

	=== waking_in_the_hut
		You get back to your feet, ready to continue your journey.

……但注意 `generic_sleep` 定义里那个 `->`：在 **ink** 里，参数需要显式标类型的情况只有这一处。因为不这么写很容易意外地变成下面这样：

	=== sleeping_in_hut ===
		You lie down and close your eyes.
		-> generic_sleep (waking_in_the_hut)

……这会把 `waking_in_the_hut` 的阅读计数传进 sleeping knot，然后尝试跳转到这个数字。





## 5) Functions
*函数*


knot 上能加参数，已经让它接近通常意义上的"函数"了，但它缺一个关键概念——调用栈和返回值。

**ink** 包含函数：它们就是 knot，带有以下限制和特性：

一个函数：
- 不能包含 stitch
- 不能使用跳转，不能提供选项
- 可以调用其他函数
- 可以包含被打印的内容
- 可以返回任意类型的值
- 可以安全地递归

（其中一些限制看起来挺死板，但若想要更面向故事的"调用栈风格"特性，见 [Tunnels 隧道](#1-tunnels) 一节。）

返回值通过 `~ return` 语句提供。

### Defining and calling functions
*定义和调用函数*


定义函数：直接把一个 knot 声明为 function：

	=== function say_yes_to_everything ===
		~ return true

	=== function lerp(a, b, k) ===
		~ return ((b - a) * k) + a

函数通过"名字+括号"调用，即使没有参数也要带括号：

	~ x = lerp(2, 8, 0.3)

	*	{say_yes_to_everything()} 'Yes.'

跟别的语言一样，函数执行完后会把流程交还给调用方。虽然函数不能跳转，但仍然可以调用其他函数：

	=== function say_no_to_nothing ===
		~ return say_yes_to_everything()

### Functions don't have to return anything
*函数不必返回值*


函数不必有返回值，可以只是把一些值得封装的操作打包起来：

	=== function harm(x) ===
		{ stamina < x:
			~ stamina = 0
		- else:
			~ stamina = stamina - x
		}

……但记住：函数不能跳转，所以上面这段虽然防住了 Stamina 变负，**它并不会**杀掉血量归零的玩家。

### Functions can be called inline
*函数可以内联调用*


函数可以在 `~` 内容行上调用，也可以在一段内容中间调用。在后一种情况下，返回值（如果有）会被打印（函数想打印的其他东西也会一起打印）；如果没有返回值，就不会打印任何东西。

内容默认是"被黏进去的"，所以：

	Monsieur Fogg was looking {describe_health(health)}.

	=== function describe_health(x) ===
	{
	- x == 100:
		~ return "spritely"
	- x > 75:
		~ return "chipper"
	- x > 45:
		~ return "somewhat flagging"
	- else:
		~ return "despondent"
	}

会产生：

	Monsieur Fogg was looking despondent.

#### Examples
*示例*


你可能会写：

	=== function max(a,b) ===
		{ a < b:
			~ return b
		- else:
			~ return a
		}

	=== function exp(x, e) ===
		// returns x to the power e where e is an integer
		{ e <= 0:
			~ return 1
		- else:
			~ return x * exp(x, e - 1)
		}

那么：

	The maximum of 2^5 and 3^3 is {max(exp(2,5), exp(3,3))}.

产生：

	The maximum of 2^5 and 3^3 is 32.


#### Example: turning numbers into words
*示例：把数字变成英文写法*


下面这个例子很长，但几乎出现在 inkle 至今每一款游戏里。（回忆一下：多行大括号里以连字符开头的行，要么表示"一个要测试的条件"，要么——如果大括号开头跟了一个变量——表示"要拿来比较的一个值"。）

    === function print_num(x) ===
    {
        - x >= 1000:
            {print_num(x / 1000)} thousand { x mod 1000 > 0:{print_num(x mod 1000)}}
        - x >= 100:
            {print_num(x / 100)} hundred { x mod 100 > 0:and {print_num(x mod 100)}}
        - x == 0:
            zero
        - else:
            { x >= 20:
                { x / 10:
                    - 2: twenty
                    - 3: thirty
                    - 4: forty
                    - 5: fifty
                    - 6: sixty
                    - 7: seventy
                    - 8: eighty
                    - 9: ninety
                }
                { x mod 10 > 0:<>-<>}
            }
            { x < 10 || x > 20:
                { x mod 10:
                    - 1: one
                    - 2: two
                    - 3: three
                    - 4: four
                    - 5: five
                    - 6: six
                    - 7: seven
                    - 8: eight
                    - 9: nine
                }
            - else:
                { x:
                    - 10: ten
                    - 11: eleven
                    - 12: twelve
                    - 13: thirteen
                    - 14: fourteen
                    - 15: fifteen
                    - 16: sixteen
                    - 17: seventeen
                    - 18: eighteen
                    - 19: nineteen
                }
            }
    }

这让我们可以写：

	~ price = 15

	I pulled out {print_num(price)} coins from my pocket and slowly counted them.
	"Oh, never mind," the trader replied. "I'll take half." And she took {print_num(price / 2)}, and pushed the rest back over to me.



### Parameters can be passed by reference
*参数可以按引用传*


函数参数也可以"按引用（by reference）"传，意味着函数可以**直接修改**传进来的变量本身，而不是创建一个带有该值的临时变量。

例如，大多数 **inkle** 故事都包含：

	=== function alter(ref x, k) ===
		~ x = x + k

像这样的行：

	~ gold = gold + 7
	~ health = health - 4

就可以变成：

	~ alter(gold, 7)
	~ alter(health, -4)

读起来略好懂一些，更有用的是它们可以**内联**写出来，达到最大紧凑度：

	*	I ate a biscuit[] and felt refreshed. {alter(health, 2)}
	* 	I gave a biscuit to Monsieur Fogg[] and he wolfed it down most undecorously. {alter(foggs_health, 1)}
	-	<> Then we continued on our way.

把简单操作包成函数也提供了一个统一放调试信息的地方，需要的话。




## 6) Constants
*常量*



### Global Constants
*全局常量*


交互式故事常常依赖状态机来追踪某个更高层流程走到了哪一阶段。实现方式有很多，但最方便的是用**常量**。

有时候把常量定义为字符串很方便，便于打印出来（用于玩法或调试）：

	CONST HASTINGS = "Hastings"
	CONST POIROT = "Poirot"
	CONST JAPP = "Japp"

	VAR current_chief_suspect = HASTINGS

	=== review_evidence ===
		{ found_japps_bloodied_glove:
			~ current_chief_suspect = POIROT
		}
		Current Suspect: {current_chief_suspect}

有时候给它们赋个数值有用：

	CONST PI = 3.14
	CONST VALUE_OF_TEN_POUND_NOTE = 10

有时候数字本身就有别的用途：

	CONST LOBBY = 1
	CONST STAIRCASE = 2
	CONST HALLWAY = 3

	CONST HELD_BY_AGENT = -1

	VAR secret_agent_location = LOBBY
	VAR suitcase_location = HALLWAY

	=== report_progress ===
	{  secret_agent_location == suitcase_location:
		The secret agent grabs the suitcase!
		~ suitcase_location = HELD_BY_AGENT

	-  secret_agent_location < suitcase_location:
		The secret agent moves forward.
		~ secret_agent_location++
	}

常量只不过是让你能给"故事状态"取一些易懂的名字。

## 7) Advanced: Game-side logic
*进阶：游戏侧逻辑*


**ink** 引擎里有两种核心方式给游戏代码挂钩子：在 ink 中声明的**外部函数**让你能直接调用游戏里的 C# 函数；**变量观察者（variable observer）**是在 ink 变量被修改时游戏端触发的回调。两者都在 [Running your ink 运行你的 ink](RunningYourInk.md) 一文里讲。

# Part 4: Advanced Flow Control
*第四部分：高级流程控制*



## 1) Tunnels
*隧道（Tunnels）*


**ink** 故事默认的结构是一棵"平的"选项树：分支、合流、可能循环，但故事永远位于"某个确定的地方"。

但这种平铺结构让某些事变得困难：想象一个游戏里可以发生下面这种交互：

	=== crossing_the_date_line ===
	*	"Monsieur!"[] I declared with sudden horror. "I have just realised. We have crossed the international date line!"
	-	Monsieur Fogg barely lifted an eyebrow. "I have adjusted for it."
	*	I mopped the sweat from my brow[]. A relief!
	* 	I nodded, becalmed[]. Of course he had!
	*  I cursed, under my breath[]. Once again, I had been belittled!

……但它可能发生在故事的好几个不同位置。我们不想给每个位置都复制一份内容，但这段内容结束后又需要知道"该往哪儿返回"。可以用参数：

	=== crossing_the_date_line(-> return_to) ===
	...
	-	-> return_to

	...

	=== outside_honolulu ===
	We arrived at the large island of Honolulu.
	- (postscript)
		-> crossing_the_date_line(-> done)
	- (done)
		-> END

	...

	=== outside_pitcairn_island ===
	The boat sailed along the water towards the tiny island.
	- (postscript)
		-> crossing_the_date_line(-> done)
	- (done)
		-> END

这两个位置现在都调用并执行同一段故事流，但完成后会返回到各自需要去的下一步。

可如果被调用的这一段故事更复杂呢？——如果它跨越好几个 knot？用上面的写法，我们就得在 knot 之间不停地传 "return-to" 参数，才能始终记得返回点。

为此 **ink** 把这件事内建到语言里，新增了一种类似"子程序（subroutine）"的跳转，叫做 **tunnel（隧道）**。

### Tunnels run sub-stories
*隧道运行子故事*


tunnel 的语法看上去就是一个跳转，**末尾再加一个跳转箭头**：

	-> crossing_the_date_line ->

意思是"先做 crossing_the_date_line 的故事，然后从这里继续"。

在 tunnel 本体里语法比参数化的版本更简洁：用 `->->` 语句结束 tunnel，意思大致就是"继续"：

	=== crossing_the_date_line ===
	// this is a tunnel!
	...
	- 	->->

注意 tunnel knot 不需要专门声明为 tunnel，所以编译器只能在运行时检查 tunnel 是否真的以 `->->` 结束。你写的时候要小心，确保所有进入 tunnel 的流程都能真的从里面出来。

tunnel 可以串联，也可以以普通跳转结束：

	...
	// this runs the tunnel, then diverts to 'done'
	-> crossing_the_date_line -> done
	...

	...
	//this runs one tunnel, then another, then diverts to 'done'
	-> crossing_the_date_line -> check_foggs_health -> done
	...

tunnel 也可以嵌套，所以下面这段是合法的：

	=== plains ===
	= night_time
		The dark grass is soft under your feet.
		+	[Sleep]
			-> sleep_here -> wake_here -> day_time
	= day_time
		It is time to move on.

	=== wake_here ===
		You wake as the sun rises.
		+	[Eat something]
			-> eat_something ->
		+	[Make a move]
		-	->->

	=== sleep_here ===
		You lie down and try to close your eyes.
		-> monster_attacks ->
		Then it is time to sleep.
		-> dream ->
		->->

……以此类推。


#### Advanced: Tunnels can return elsewhere
*进阶：隧道可以"返回到别处"*


故事里有时会发生意外。所以有时候 tunnel 没办法保证一定要回到出发点。**ink** 提供了一种语法让你能"从一个 tunnel 返回，但实际上跳到别处"。但要谨慎使用——把自己绕晕的概率非常高。

但仍然有不可或缺的场景：

	=== fall_down_cliff 
	-> hurt(5) -> 
	You're still alive! You pick yourself up and walk on.
	
	=== hurt(x)
		~ stamina -= x 
		{ stamina <= 0:
			->-> youre_dead
		}
	
	=== youre_dead
	Suddenly, there is a white light all around you. Fingers lift an eyepiece from your forehead. 'You lost, buddy. Out of the chair.'
	 
即使在不那么戏剧化的场景，我们也可能想打破结构：
 
	-> talk_to_jim ->
 
	 === talk_to_jim
	 - (opts) 	
		*	[ Ask about the warp lacelles ] 
			-> warp_lacells ->
		*	[ Ask about the shield generators ] 
			-> shield_generators ->	
		* 	[ Stop talking ]
			->->
	 - -> opts 

	 = warp_lacells
		{ shield_generators : ->-> argue }
		"Don't worry about the warp lacelles. They're fine."
		->->

	 = shield_generators
		{ warp_lacells : ->-> argue }
		"Forget about the shield generators. They're good."
		->->
	 
	 = argue 
	 	"What's with all these questions?" Jim demands, suddenly. 
	 	...
	 	->->

#### Advanced: Tunnels use a call-stack
*进阶：隧道使用调用栈*


tunnel 是放在调用栈上的，所以可以安全地递归。


## 2) Threads
*线程（Threads）*


到目前为止，尽管有各种分支和跳转，ink 里的一切都是**完全线性**的。但实际上作者可以把故事"分叉（fork）"成不同的子段，以应对更多可能的玩家行为。

我们把这叫做 **threading（穿线）**，不过这里的 thread 不是计算机科学里那个意思——更像是把多块来源不同的内容"缝（stitch）"在一起。

注意：这绝对是个高级特性。一旦涉及 thread，故事的"工程化"会变得复杂不少！

### Threads join multiple sections together
*线程把多个段落连到一起*


thread 让你能一次性把多个来源的内容组合到一起。例如：

    == thread_example ==
    I had a headache; threading is hard to get your head around.
    <- conversation
    <- walking


    == conversation ==
    It was a tense moment for Monty and me.
     * "What did you have for lunch today?"[] I asked.
        "Spam and eggs," he replied.
     * "Nice weather, we're having,"[] I said.
        "I've seen better," he replied.
     - -> house

    == walking ==
    We continued to walk down the dusty road.
     * [Continue walking]
        -> house

    == house ==
    Before long, we arrived at his house.
    -> END

它把多段故事合并成单独一段：

    I had a headache; threading is hard to get your head around.
    It was a tense moment for Monty and me.
    We continued to walk down the dusty road.
    1: "What did you have for lunch today?"
    2: "Nice weather, we're having,"
    3: Continue walking

遇到 `<- conversation` 这样的 thread 语句时，编译器会**分叉**故事流。它会先处理一个分叉，运行 `conversation` 里的内容，把它产生的选项都收集起来；这条分叉走完后再去跑另一条。

所有内容都被收集起来一起展示给玩家。但玩家一旦选择了一项，引擎就会跳进那条分叉，**把其他分叉折叠、丢弃**。

注意全局变量**不会**被分叉，包括 knot 和 stitch 的阅读计数也不会。

### Uses of threads
*线程的用途*


在普通故事里你可能永远用不到 thread。

但对于有大量独立运动部件的游戏，thread 很快就变得必不可少。想象一个角色在地图上独立移动的游戏：某个房间的主故事中枢可能长这样：

	CONST HALLWAY = 1
	CONST OFFICE = 2

	VAR player_location = HALLWAY
	VAR generals_location = HALLWAY
	VAR doctors_location = OFFICE

	== run_player_location
		{
			- player_location == HALLWAY: -> hallway
		}

	== hallway ==
		<- characters_present(HALLWAY)
		*	[Drawers]	-> examine_drawers
		* 	[Wardrobe] -> examine_wardrobe
		*  [Go to Office] 	-> go_office
		-	-> run_player_location
	= examine_drawers
		// etc...

	// Here's the thread, which mixes in dialogue for characters you share the room with at the moment.

	== characters_present(room)
		{ generals_location == room:
			<- general_conversation
		}
		{ doctors_location == room:
			<- doctor_conversation
		}
		-> DONE

	== general_conversation
		*	[Ask the General about the bloodied knife]
			"It's a bad business, I can tell you."
		-	-> run_player_location

	== doctor_conversation
		*	[Ask the Doctor about the bloodied knife]
			"There's nothing strange about blood, is there?"
		-	-> run_player_location



特别注意：我们需要一个明确的方式让"走进侧线 thread 的玩家"返回主流程。大多数情况下，thread 要么需要一个参数告诉它返回到哪里，要么需要由它自己结束当前故事段。


### When does a side-thread end?
*侧线 thread 何时结束？*


侧线 thread 在"没流程可处理"时结束。注意，它**收集**选项以待之后展示（这跟 tunnel 不同：tunnel 收集选项、展示、并顺着选项往下走，直到显式 return，可能要好几步之后才返回）。

有时一个 thread 没有内容可提供——也许这个角色其实没什么可对话的，又或者我们还没写。这种情况下，我们必须显式标记 thread 的结束。

否则，"内容用尽"可能是个故事 bug 或者一根挂着的故事线头，我们希望编译器告诉我们这些。

### Using `-> DONE`
*使用 `-> DONE`*


需要标记 thread 结束时用 `-> DONE`：意思是"流程在这里**有意**结束"。如果不写，可能会得到一条警告——游戏照样能跑，但这是提醒你"还有未完成的事"。

本节开头的例子会产生警告；修法如下：

    == thread_example ==
    I had a headache; threading is hard to get your head around.
    <- conversation
    <- walking
    -> DONE

那个额外的 DONE 告诉 ink "这里流程到此为止，下一段故事要靠 thread 来推进"。

注意：如果流程是以"所有条件都不满足的选项"收尾的，**不需要** `-> DONE`。引擎会把这种情况当作合法、刻意的"流程结束"。

**选项被选中之后不需要 `-> DONE`**。一旦选项被选中，那根 thread 就不再是 thread 了——它又变回了普通的故事流。

这种情况下用 `-> END` **不会**结束 thread，而是结束整个故事流。（这才是为什么需要两种结束流程方式的真正原因。）


#### Example: adding the same choice to several places
*示例：把同一个选项加到多处*


thread 可以用来把同一个选项加进很多不同的位置。这样用时，惯例是把一个跳转当参数传进去，告诉故事选项执行完后去哪里：

	=== outside_the_house
	The front step. The house smells. Of murder. And lavender.
	- (top)
		<- review_case_notes(-> top)
		*	[Go through the front door]
			I stepped inside the house.
			-> the_hallway
		* 	[Sniff the air]
			I hate lavender. It makes me think of soap, and soap makes me think about my marriage.
			-> top

	=== the_hallway
	The hallway. Front door open to the street. Little bureau.
	- (top)
		<- review_case_notes(-> top)
		*	[Go through the front door]
			I stepped out into the cool sunshine.
			-> outside_the_house
		* 	[Open the bureau]
			Keys. More keys. Even more keys. How many locks do these people need?
			-> top

	=== review_case_notes(-> go_back_to)
	+	{not done || TURNS_SINCE(-> done) > 10}
		[Review my case notes]
		// the conditional ensures you don't get the option to check repeatedly
	 	{I|Once again, I} flicked through the notes I'd made so far. Still not obvious suspects.
	- 	(done) -> go_back_to

注意这跟 tunnel 不一样——tunnel 跑同一块内容但不给玩家选择。所以这样：

	<- childhood_memories(-> next)
	*	[Look out of the window]
	 	I daydreamed as we rolled along...
	 - (next) Then the whistle blew...

可能效果完全等同于：

	*	[Remember my childhood]
		-> think_back ->
	*	[Look out of the window]
		I daydreamed as we rolled along...
	- 	(next) Then the whistle blew...

但一旦被穿插进去的那个选项里有多个 choice、或者 choice 上还带条件逻辑（当然还可能有文本内容），thread 版本就更实用了。


#### Example: organisation of wide choice points
*示例：组织"宽选项点"*


把 ink 当作"脚本"而非字面输出的游戏，往往会产生**大量并行的选项**，由玩家通过别的游戏内交互（比如在场景里走来走去）来过滤。这种情况下 thread 也能简单地把选项划分开：

```
=== the_kitchen
- (top)
	<- drawers(-> top)
	<- cupboards(-> top)
	<- room_exits
= drawers (-> goback)
	// choices about the drawers...
	...
= cupboards(-> goback)
	// choices about cupboards
	...
= room_exits
	// exits; doesn't need a "return point" as if you leave, you go elsewhere
	...
```

# Part 5: Advanced State Tracking
*第五部分：高级状态追踪*


互动量大的游戏会迅速变得非常复杂，作者的工作有相当一部分是**维持连贯性**而不是堆内容。

如果游戏文本想要模拟点什么——不管是纸牌游戏、玩家对游戏世界的认知、还是房子里各种灯的开关状态——这一点尤其重要。

**ink** 并不提供经典 parser IF（指令解析式互动小说）那种完整的"世界模型"系统——这里没有"物体"概念，没有"包含"、"打开"或"上锁"的概念。但它确实提供了一套**简单却强大、非常灵活**的状态追踪系统，让作者能在需要时近似地模拟世界模型。

#### Note: New feature alert!
*注意：新特性！*


这个特性对该语言来说还很新。我们都还没把它可能的用法全发掘完——但很确定它会有用！如果你想到了什么聪明用法，欢迎告诉我们！


## 1) Basic Lists
*基础列表*


状态追踪的基本单元是一个"状态列表（list of states）"，用 `LIST` 关键字定义。注意 ink 里的 list **完全不**像 C# 的 list（C# 的 list 是数组）。

例如：

	LIST kettleState = cold, boiling, recently_boiled

这一行做了两件事：第一，定义了三个新值——`cold`、`boiling`、`recently_boiled`；第二，定义了一个名为 `kettleState` 的变量来装这些状态。

我们可以告诉这个 list 取某个值：

	~ kettleState = cold

可以改变它的值：

	*	[Turn on kettle]
		The kettle begins to bubble and boil.
		~ kettleState = boiling

可以查询它的值：

	*	[Touch the kettle]
		{ kettleState == cold:
			The kettle is cool to the touch.
		- else:
		 	The outside of the kettle is very warm!
		}

方便起见，定义 list 的时候可以用括号给它一个初始值：

	LIST kettleState = cold, (boiling), recently_boiled
	// at the start of the game, this kettle is switched on. Edgy, huh?

……如果这套写法看上去有点冗余，是有原因的——再过几节就会看到。



## 2) Reusing Lists
*复用列表*


上面的例子用在 kettle 上还行，但要是我们炉子上同时还烧着一锅呢？这时可以**定义一个状态列表，再把它装进多个变量里**——想装多少个就装多少个：

	LIST daysOfTheWeek = Monday, Tuesday, Wednesday, Thursday, Friday
	VAR today = Monday
	VAR tomorrow = Tuesday

### States can be used repeatedly
*状态可以反复复用*


这让我们能在多个位置使用同一个状态机：

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold

	*	{kettleState == cold} [Turn on kettle]
		The kettle begins to boil and bubble.
		~ kettleState = boiling
	*	{potState == cold} [Light stove]
	 	The water in the pot begins to boil and bubble.
	 	~ potState = boiling

那如果再加个微波炉呢？我们可能想把功能再泛化一点：

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold
	VAR microwaveState = cold

	=== function boilSomething(ref thingToBoil, nameOfThing)
		The {nameOfThing} begins to heat up.
		~ thingToBoil = boiling

	=== do_cooking
	*	{kettleState == cold} [Turn on kettle]
		{boilSomething(kettleState, "kettle")}
	*	{potState == cold} [Light stove]
		{boilSomething(potState, "pot")}
	*	{microwaveState == cold} [Turn on microwave]
		{boilSomething(microwaveState, "microwave")}

或者甚至……

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold
	VAR microwaveState = cold

	=== cook_with(nameOfThing, ref thingToBoil)
	+ 	{thingToBoil == cold} [Turn on {nameOfThing}]
	  	The {nameOfThing} begins to heat up.
		~ thingToBoil = boiling
		-> do_cooking.done

	=== do_cooking
	<- cook_with("kettle", kettleState)
	<- cook_with("pot", potState)
	<- cook_with("microwave", microwaveState)
	- (done)

注意 "heatedWaterStates" 这个 list 仍然可用——也可以拿它来测试或赋值。

#### List values can share names list
*的值可以重名*


复用 list 会带来歧义。如果我们有：

	LIST colours = red, green, blue, purple
	LIST moods = mad, happy, blue

	VAR status = blue

……编译器怎么知道你指的是哪个 blue？

我们用类似 knot/stitch 那样的 `.` 语法消除歧义：

	VAR status = colours.blue

……不消除歧义之前，编译器会一直报错。

注意，**状态的"姓"**和**装状态的变量**完全是两回事。所以：

	{ statesOfGrace == statesOfGrace.fallen:
		// is the current state "fallen"
	}

……是对的。


#### Advanced: a LIST is actually a variable
*进阶：LIST 本身就是一个变量*


一个让人意外的特性是：

	LIST statesOfGrace = ambiguous, saintly, fallen

实际上**同时**做了两件事：它创建了三个值 `ambiguous`、`saintly` 和 `fallen`，必要时给它们冠以姓 `statesOfGrace`；它**还**创建了一个叫 `statesOfGrace` 的变量。

这个变量可以像普通变量一样使用。所以下面这段虽然合法但**非常容易把人搞晕**，且是个坏主意：

	LIST statesOfGrace = ambiguous, saintly, fallen

	~ statesOfGrace = 3.1415 // set the variable to a number not a list value

……同时也不影响下面这段照常工作：

	~ temp anotherStateOfGrace = statesOfGrace.saintly




## 3) List Values
*列表值*


定义一个 list 时，值是有顺序的，且顺序**有意义**。实际上我们可以把这些值当作数字看待。（也就是说它们是枚举。）

	LIST volumeLevel = off, quiet, medium, loud, deafening
	VAR lecturersVolume = quiet
	VAR murmurersVolume = quiet

	{ lecturersVolume < deafening:
		~ lecturersVolume++

		{ lecturersVolume > murmurersVolume:
			~ murmurersVolume++
			The murmuring gets louder.
		}
	}

值本身也可以用通常的 `{...}` 语法打印——会打印出它的"名字"：

	The lecturer's voice becomes {lecturersVolume}.

### Converting values to numbers
*把值转成数字*


如果需要，可以用 `LIST_VALUE` 函数显式取得数值。注意 list 里的**第一个**值数值是 1，不是 0：

	The lecturer has {LIST_VALUE(deafening) - LIST_VALUE(lecturersVolume)} notches still available to him.

### Converting numbers to values
*把数字转成值*


反过来则把 list 的名字当函数用：

	LIST Numbers = one, two, three
	VAR score = one
	~ score = Numbers(2) // score will be "two"

### Advanced: defining your own numerical values
*进阶：自定义数值*


默认情况下，list 的值从 1 开始、每次加 1，但你也可以指定自己的数值：

	LIST primeNumbers = two = 2, three = 3, five = 5

如果你指定了某个值的数值但没指定下一个，ink 会默认下一个加 1。所以下面这两种写法等价：

	LIST primeNumbers = two = 2, three, five = 5


## 4) Multivalued Lists
*多值列表*


前面所有例子里都包含一个有意的"假话"，现在我们要拆掉它：**list（以及装 list 值的变量）不必只包含一个值**。

### Lists are boolean sets list
*本质上是布尔集合*


一个 list 变量不是"装着一个数字的变量"。打个比方，list 就像宿舍楼前的"在/不在"姓名牌——上面列着一串名字，每个名字对应一个房间号，旁边还有个写着 "in" 或 "out" 的小开关。

可能谁都不在：

	LIST DoctorsInSurgery = Adams, Bernard, Cartwright, Denver, Eamonn

也可能人人都在：

	LIST DoctorsInSurgery = (Adams), (Bernard), (Cartwright), (Denver), (Eamonn)

也可能有些在、有些不在：

	LIST DoctorsInSurgery = (Adams), Bernard, (Cartwright), Denver, Eamonn

**括号里的名字会在初始状态下被包含进列表**。

注意，如果你给值指定了数值，括号可以套在整个项上、也可以只套住名字：

	LIST primeNumbers = (two = 2), (three) = 3, (five = 5)

#### Assiging multiple values
*一次赋多个值*


可以一次性给整个 list 赋值：

	~ DoctorsInSurgery = (Adams, Bernard)
	~ DoctorsInSurgery = (Adams, Bernard, Eamonn)

可以赋空列表来清空：

	~ DoctorsInSurgery = ()


#### Adding and removing entries
*添加和删除项*


list 项可以单个或成组地添加、删除：

	~ DoctorsInSurgery = DoctorsInSurgery + Adams
 	~ DoctorsInSurgery += Adams  // this is the same as the above
	~ DoctorsInSurgery -= Eamonn
	~ DoctorsInSurgery += (Eamonn, Denver)
	~ DoctorsInSurgery -= (Adams, Eamonn, Denver)

加入一个**已经在 list 里**的项不会有任何效果；删除一个**不在 list 里**的项也不会有任何效果。两者都不会报错，且 list **永远不会包含重复项**。


### Basic Queries
*基础查询*


我们有几个基本方式获取 list 内容信息：

	LIST DoctorsInSurgery = (Adams), Bernard, (Cartwright), Denver, Eamonn

	{LIST_COUNT(DoctorsInSurgery)} 	//  "2"
	{LIST_MIN(DoctorsInSurgery)} 		//  "Adams"
	{LIST_MAX(DoctorsInSurgery)} 		//  "Cartwright"
	{LIST_RANDOM(DoctorsInSurgery)} 	//  "Adams" or "Cartwright"

#### Testing for emptiness
*判空测试*


跟 ink 里大多数值一样，list 可以"原样"测试：除非为空，否则返回 true。

	{ DoctorsInSurgery: The surgery is open today. | Everyone has gone home. }

#### Testing for exact equality
*精确相等测试*


多值 list 的测试比单值的要复杂一点。相等（`==`）现在表示**集合相等**——也就是说**所有项都完全一致**。

例如：

	{ DoctorsInSurgery == (Adams, Bernard):
		Dr Adams and Dr Bernard are having a loud argument in one corner.
	}

如果 Eamonn 医生也在场，两人就不会争吵——因为比较的两个 list 不相等：DoctorsInSurgery 多了一个 `(Adams, Bernard)` 里没有的 Eamonn。

不等号 `!=` 按预期工作：

	{ DoctorsInSurgery != (Adams, Bernard):
		At least Adams and Bernard aren't arguing.
	}

#### Testing for containment
*包含测试*


要是我们只想问"Adams 和 Bernard 是否在场"呢？为此引入新运算符 `has`，也写作 `?`：

	{ DoctorsInSurgery ? (Adams, Bernard):
		Dr Adams and Dr Bernard are having a hushed argument in one corner.
	}

`?` 也可以用在单个值上：

	{ DoctorsInSurgery has Eamonn:
		Dr Eamonn is polishing his glasses.
	}

也可以否定，用 `hasnt` 或者 `!?`（**不是** `?`）。注意这会开始变得有点复杂：

	DoctorsInSurgery !? (Adams, Bernard)

**并不**表示"Adams 和 Bernard 都不在"，只表示"他俩并不**同时**在（争吵）"。

#### Warning: no lists contain the empty list
*警告：没有 list 会"包含空列表"*


注意：

	SomeList ? ()

这个测试**永远返回 false**，不论 `SomeList` 自身是不是空的。实践中这是个最实用的默认行为，因为你常常想做这种测试：

	SilverWeapons ? best_weapon_to_use 

如果玩家空手，希望这个测试 fail。

#### Example: basic knowledge tracking
*示例：基础知识追踪*


多值 list 最简单的用法之一是干净地追踪"游戏 flag"：

	LIST Facts = (Fogg_is_fairly_odd), 	first_name_phileas, (Fogg_is_English)

	{Facts ? Fogg_is_fairly_odd:I smiled politely.|I frowned. Was he a lunatic?}
	'{Facts ? first_name_phileas:Phileas|Monsieur}, really!' I cried.

特别是它让我们能用单行测试多个游戏 flag：

	{ Facts ? (Fogg_is_English, Fogg_is_fairly_odd):
		<> 'I know Englishmen are strange, but this is *incredible*!'
	}


#### Example: a doctor's surgery
*示例：诊所*


来一个完整一点的例子：

	LIST DoctorsInSurgery = (Adams), Bernard, Cartwright, (Denver), Eamonn

	-> waiting_room

	=== function whos_in_today()
		In the surgery today are {DoctorsInSurgery}.

	=== function doctorEnters(who)
		{ DoctorsInSurgery !? who:
			~ DoctorsInSurgery += who
			Dr {who} arrives in a fluster.
		}

	=== function doctorLeaves(who)
		{ DoctorsInSurgery ? who:
			~ DoctorsInSurgery -= who
			Dr {who} leaves for lunch.
		}

	=== waiting_room
		{whos_in_today()}
		*	[Time passes...]
			{doctorLeaves(Adams)} {doctorEnters(Cartwright)} {doctorEnters(Eamonn)}
			{whos_in_today()}

产生：

	In the surgery today are Adams, Denver.

	> Time passes...

	Dr Adams leaves for lunch. Dr Cartwright arrives in a fluster. Dr Eamonn arrives in a fluster.

	In the surgery today are Cartwright, Denver, Eamonn.

#### Advanced: nicer list printing
*进阶：更漂亮的 list 打印*


基础的 list 打印效果在游戏里并不好看。下面这种更佳：

	=== function listWithCommas(list, if_empty)
	    {LIST_COUNT(list):
	    - 2:
	        	{LIST_MIN(list)} and {listWithCommas(list - LIST_MIN(list), if_empty)}
	    - 1:
	        	{list}
	    - 0:
				{if_empty}
	    - else:
	      		{LIST_MIN(list)}, {listWithCommas(list - LIST_MIN(list), if_empty)}
	    }

	LIST favouriteDinosaurs = (stegosaurs), brachiosaur, (anklyosaurus), (pleiosaur)

	My favourite dinosaurs are {listWithCommas(favouriteDinosaurs, "all extinct")}.

手头也常常需要一个 is/are 函数：

	=== function isAre(list)
		{LIST_COUNT(list) == 1:is|are}

	My favourite dinosaurs {isAre(favouriteDinosaurs)} {listWithCommas(favouriteDinosaurs, "all extinct")}.

再较真一点：

	My favourite dinosaur{LIST_COUNT(favouriteDinosaurs) != 1:s} {isAre(favouriteDinosaurs)} {listWithCommas(favouriteDinosaurs, "all extinct")}.


#### Lists don't need to have multiple entries list
*不必含有多项*


list **不必**包含多个值。如果你想拿 list 当作状态机用，前面的所有示例都适用——用 `=`、`++`、`--` 设值，用 `==`、`<`、`<=`、`>`、`>=` 测试。这些都会按预期工作。

### The "full" list "
*完整"列表*


注意 `LIST_COUNT`、`LIST_MIN`、`LIST_MAX` 关心的是"谁在/不在 list 里"，**不是**"所有可能的医生"。要拿到所有可能的医生，用：

	LIST_ALL(element of list)

或：

	LIST_ALL(list containing elements of a list)

	{LIST_ALL(DoctorsInSurgery)} // Adams, Bernard, Cartwright, Denver, Eamonn
	{LIST_COUNT(LIST_ALL(DoctorsInSurgery))} // "5"
	{LIST_MIN(LIST_ALL(Eamonn))} 				// "Adams"

注意用 `{...}` 打印 list 时输出的是它最朴素的表示：值的名字，用逗号分隔。

#### Advanced: "refreshing" a list's type
*进阶："刷新"一个 list 的类型*


如果实在需要，可以造一个"知道自己是哪种 list 类型"的空 list：

	LIST ValueList = first_value, second_value, third_value
	VAR myList = ()

	~ myList = ValueList()

之后你就能：

	{ LIST_ALL(myList) }

#### Advanced: a portion of the "full" list
*进阶：取"完整列表"的一段*


也可以用 `LIST_RANGE` 函数取完整 list 的一段切片。有两种写法，都合法：

	LIST_RANGE(list_name, min_integer_value, max_integer_value)

或：

	LIST_RANGE(list_name, min_value, max_value)
	
这里 min 和 max 都是**闭区间**。如果游戏找不到精确的值，会尽量贴近，但绝不会超出范围。例如：

	{LIST_RANGE(LIST_ALL(primeNumbers), 10, 20)} 

会产生：
	
	11, 13, 17, 19



### Example: Tower of Hanoi
*示例：汉诺塔*


为了展示上面这些想法，下面是一个可玩的汉诺塔示例——写出来这样别人就不用再写一遍了：


	LIST Discs = one, two, three, four, five, six, seven
	VAR post1 = ()
	VAR post2 = ()
	VAR post3 = ()

	~ post1 = LIST_ALL(Discs)

	-> gameloop

	=== function can_move(from_list, to_list) ===
	    {
	    -   LIST_COUNT(from_list) == 0:
	        // no discs to move
	        ~ return false
	    -   LIST_COUNT(to_list) > 0 && LIST_MIN(from_list) > LIST_MIN(to_list):
	        // the moving disc is bigger than the smallest of the discs on the new tower
	        ~ return false
	    -   else:
	    	 // nothing stands in your way!
	        ~ return true

	    }

	=== function move_ring( ref from, ref to ) ===
	    ~ temp whichRingToMove = LIST_MIN(from)
	    ~ from -= whichRingToMove
	    ~ to += whichRingToMove

	== function getListForTower(towerNum)
	    { towerNum:
	        - 1:    ~ return post1
	        - 2:    ~ return post2
	        - 3:    ~ return post3
	    }

	=== function name(postNum)
	    the {postToPlace(postNum)} temple

	=== function Name(postNum)
	    The {postToPlace(postNum)} temple

	=== function postToPlace(postNum)
	    { postNum:
	        - 1: first
	        - 2: second
	        - 3: third
	    }

	=== function describe_pillar(listNum) ==
	    ~ temp list = getListForTower(listNum)
	    {
	    - LIST_COUNT(list) == 0:
	        {Name(listNum)} is empty.
	    - LIST_COUNT(list) == 1:
	        The {list} ring lies on {name(listNum)}.
	    - else:
	        On {name(listNum)}, are the discs numbered {list}.
	    }


	=== gameloop
	    Staring down from the heavens you see your followers finishing construction of the last of the great temples, ready to begin the work.
	- (top)
	    +  [ Regard the temples]
	        You regard each of the temples in turn. On each is stacked the rings of stone. {describe_pillar(1)} {describe_pillar(2)} {describe_pillar(3)}
	    <- move_post(1, 2, post1, post2)
	    <- move_post(2, 1, post2, post1)
	    <- move_post(1, 3, post1, post3)
	    <- move_post(3, 1, post3, post1)
	    <- move_post(3, 2, post3, post2)
	    <- move_post(2, 3, post2, post3)
	    -> DONE

	= move_post(from_post_num, to_post_num, ref from_post_list, ref to_post_list)
	    +   { can_move(from_post_list, to_post_list) }
	        [ Move a ring from {name(from_post_num)} to {name(to_post_num)} ]
	        { move_ring(from_post_list, to_post_list) }
	        { stopping:
	        -   The priests far below construct a great harness, and after many years of work, the great stone ring is lifted up into the air, and swung over to the next of the temples.
	            The ropes are slashed, and in the blink of an eye it falls once more.
	        -   Your next decree is met with a great feast and many sacrifices. After the funeary smoke has cleared, work to shift the great stone ring begins in earnest. A generation grows and falls, and the ring falls into its ordained place.
	        -   {cycle:
	            - Years pass as the ring is slowly moved.
	            - The priests below fight a war over what colour robes to wear, but while they fall and die, the work is still completed.
	            }
	        }
	    -> top



## 5) Advanced List Operations
*高级列表运算*


前一节涵盖了基本比较。还有一些更强大的特性，但——任何熟悉"数学集合"的人都知道——事情开始变得有点棘手。所以这一节带"进阶"警告。

本节大部分特性大多数游戏都用不到。

### Comparing lists
*比较 list*


我们可以用 `>`、`<`、`>=`、`<=` 做"不是精确相等"的比较。**警告！我们用的定义并不是"标准"定义**——它们基于"测试中两 list 各元素的数值"。

#### "Distinctly bigger than" "
*明显大于"*


`LIST_A > LIST_B` 意思是"A 中最小的值大于 B 中最大的值"：换句话说，若画在数轴上，**整个 A 都在整个 B 的右边**。`<` 反过来同理。

#### "Definitely never smaller than" "
*肯定不会更小"*


`LIST_A >= LIST_B` 意思是——深吸一口气——"A 的最小值至少是 B 的最小值，A 的最大值至少是 B 的最大值"。也就是说，若画在数轴上，整个 A 要么在 B 之上，要么和 B 重叠，但 B 不会比 A 伸得更高。

注意 `LIST_A > LIST_B` 蕴含 `LIST_A != LIST_B`；`LIST_A >= LIST_B` 允许 `LIST_A == LIST_B` 但排除 `LIST_A < LIST_B`，跟你大概期望的一样。

#### Health warning!
*健康警告！*


`LIST_A >= LIST_B` **不等于** `LIST_A > LIST_B or LIST_A == LIST_B`。

教训是：除非你脑子里有一幅清晰的图，否则**别用这些**。

### Inverting lists
*反转 list*


list 可以被"反转（invert）"——相当于把那块宿舍姓名牌上每个开关都拨到相反的位置：

	LIST GuardsOnDuty = (Smith), (Jones), Carter, Braithwaite

	=== function changingOfTheGuard
		~ GuardsOnDuty = LIST_INVERT(GuardsOnDuty)


注意对一个空 list 做 `LIST_INVERT`，如果游戏没有足够上下文知道"反转成什么"，会返回 null 值。如果你需要处理这种情况，最稳妥的是手动判断：

	=== function changingOfTheGuard
		{!GuardsOnDuty: // "is GuardsOnDuty empty right now?"
			~ GuardsOnDuty = LIST_ALL(Smith)
		- else:
			~ GuardsOnDuty = LIST_INVERT(GuardsOnDuty)
		}

#### Footnote
*脚注*


反转的语法原本是 `~ list`，后来我们改了——否则这一行：

	~ list = ~ list

不只是合法、还真的会让 list 反转自身，"自指自反"得太离谱了。

### Intersecting lists
*取交集*


`has` 或 `?` 运算符，更正式地说是"我是不是你的超集"运算符 ⊇——它包含"两个集合相等"，但不包含"大集合并不完全包含小集合"的情形。

如果要测试"两 list 是否有重叠"，用重叠运算符 `^` 取**交集**：

	LIST CoreValues = strength, courage, compassion, greed, nepotism, self_belief, delusions_of_godhood
	VAR desiredValues = (strength, courage, compassion, self_belief )
	VAR actualValues =  ( greed, nepotism, self_belief, delusions_of_godhood )

	{desiredValues ^ actualValues} // prints "self_belief"

结果是一个新的 list，所以可以测试它：

	{desiredValues ^ actualValues: The new president has at least one desirable quality.}

	{LIST_COUNT(desiredValues ^ actualValues) == 1: Correction, the new president has only one desirable quality. {desiredValues ^ actualValues == self_belief: It's the scary one.}}




## 6) Multi-list Lists
*多列表的列表*



到目前为止，我们所有例子都包含一个大幅简化——一个 list 变量里的所有值必须都来自**同一个 list 家族**。但实际上**不需要**。

这让我们能让 list ——目前为止扮演的角色是"状态机和 flag 追踪器"——同时充当**通用属性**，这对世界建模很有用。

这是我们的"盗梦空间时刻"。结果非常强大，但也比之前任何东西都更像"真正的代码"。

### Lists to track objects
*用 list 追踪物体*


例如可以定义：

	LIST Characters = Alfred, Batman, Robin
	LIST Props = champagne_glass, newspaper

	VAR BallroomContents = (Alfred, Batman, newspaper)
	VAR HallwayContents = (Robin, champagne_glass)

然后通过测试某个房间的状态来描述其中的物品：

	=== function describe_room(roomState)
		{ roomState ? Alfred: Alfred is here, standing quietly in a corner. } { roomState ? Batman: Batman's presence dominates all. } { roomState ? Robin: Robin is all but forgotten. }
		<> { roomState ? champagne_glass: A champagne glass lies discarded on the floor. } { roomState ? newspaper: On one table, a headline blares out WHO IS THE BATMAN? AND *WHO* IS HIS BARELY-REMEMBERED ASSISTANT? }

那么：

	{ describe_room(BallroomContents) }

产生：

	Alfred is here, standing quietly in a corner. Batman's presence dominates all.

	On one table, a headline blares out WHO IS THE BATMAN? AND *WHO* IS HIS BARELY-REMEMBERED ASSISTANT?

而：

	{ describe_room(HallwayContents) }

产生：

	Robin is all but forgotten.

	A champagne glass lies discarded on the floor.

我们也可以基于"组合条件"提供选项：

	*	{ currentRoomState ? (Batman, Alfred) } [Talk to Alfred and Batman]
		'Say, do you two know each other?'

### Lists to track multiple states
*用 list 追踪多重状态*


我们可以建模"具有多个状态的设备"。再回到 kettle……

	LIST OnOff = on, off
	LIST HotCold = cold, warm, hot

	VAR kettleState = (off, cold) // we need brackets because it's a proper, multi-valued list now

	=== function turnOnKettle() ===
	{ kettleState ? hot:
		You turn on the kettle, but it immediately flips off again.
	- else:
		The water in the kettle begins to heat up.
		~ kettleState -= off
		~ kettleState += on
		// note we avoid "=" as it'll remove all existing states
	}

	=== function can_make_tea() ===
		~ return kettleState ? (hot, off)

这种混合状态让"改变状态"更难一点，正如上面 off/on 的例子所示。所以下面这个辅助函数会很有用：

 	=== function changeStateTo(ref stateVariable, stateToReach)
 		// remove all states of this type
 		~ stateVariable -= LIST_ALL(stateToReach)
 		// put back the state we want
 		~ stateVariable += stateToReach

让你能写出：

 	~ changeState(kettleState, on)
 	~ changeState(kettleState, warm)


#### How does this affect queries?
*这对查询有何影响？*


上面给出的大多数查询都能很好地推广到多值 list：

    LIST Letters = a,b,c
    LIST Numbers = one, two, three

    VAR mixedList = (a, three, c)

	{LIST_ALL(mixedList)}   // a, one, b, two, c, three
    {LIST_COUNT(mixedList)} // 3
    {LIST_MIN(mixedList)}   // a
    {LIST_MAX(mixedList)}   // three or c, albeit unpredictably

    {mixedList ? (a,b) }        // false
    {mixedList ^ LIST_ALL(a)}   // a, c

    { mixedList >= (one, a) }   // true
    { mixedList < (three) }     // false

	{ LIST_INVERT(mixedList) }            // one, b, two

## 7) Long example: crime scene
*长示例：犯罪现场*


最后是一个很长的示例，演示了本节大量想法的实际运用。在通读代码前，你也许想先把它跑起来玩一遍，更好地理解各个"运动部件"。

	-> murder_scene

	// Helper function: popping elements from lists
	=== function pop(ref list)
	   ~ temp x = LIST_MIN(list) 
	   ~ list -= x 
	   ~ return x
	
	//
	//  System: items can have various states
	//  Some are general, some specific to particular items
	//
	

	LIST OffOn = off, on
	LIST SeenUnseen = unseen, seen
	
	LIST GlassState = (none), steamed, steam_gone
	LIST BedState = (made_up), covers_shifted, covers_off, bloodstain_visible
	
	//
	// System: inventory
	//
	
	LIST Inventory = (none), cane, knife
	
	=== function get(x)
	    ~ Inventory += x
	
	//
	// System: positioning things
	// Items can be put in and on places
	//
	
	LIST Supporters = on_desk, on_floor, on_bed, under_bed, held, with_joe
	
	=== function move_to_supporter(ref item_state, new_supporter) ===
	    ~ item_state -= LIST_ALL(Supporters)
	    ~ item_state += new_supporter
	
	
	// System: Incremental knowledge.
	// Each list is a chain of facts. Each fact supersedes the fact before 
	//
	
	VAR knowledgeState = ()
	
	=== function reached (x) 
	   ~ return knowledgeState ? x 
	
	=== function between(x, y) 
	   ~ return knowledgeState? x && not (knowledgeState ^ y)
	
	=== function reach(statesToSet) 
	   ~ temp x = pop(statesToSet)
	   {
	   - not x: 
	      ~ return false 

	   - not reached(x):
	      ~ temp chain = LIST_ALL(x)
	      ~ temp statesGained = LIST_RANGE(chain, LIST_MIN(chain), x)
	      ~ knowledgeState += statesGained
	      ~ reach (statesToSet) 	// set any other states left to set
	      ~ return true  	       // and we set this state, so true
	 
	    - else:
	      ~ return false || reach(statesToSet) 
	    }	
	
	//
	// Set up the game
	//
	
	VAR bedroomLightState = (off, on_desk)
	
	VAR knifeState = (under_bed)
	
	
	//
	// Knowledge chains
	//
	
	
	LIST BedKnowledge = neatly_made, crumpled_duvet, hastily_remade, body_on_bed, murdered_in_bed, murdered_while_asleep
	
	LIST KnifeKnowledge = prints_on_knife, joe_seen_prints_on_knife,joe_wants_better_prints, joe_got_better_prints
	
	LIST WindowKnowledge = steam_on_glass, fingerprints_on_glass, fingerprints_on_glass_match_knife
	
	
	//
	// Content
	//
	
	=== murder_scene ===
	    The bedroom. This is where it happened. Now to look for clues.
	- (top)
	    { bedroomLightState ? seen:     <- seen_light  }
	    <- compare_prints(-> top)

    *   (dobed) [The bed...]
        The bed was low to the ground, but not so low something might not roll underneath. It was still neatly made.
        ~ reach (neatly_made)
        - - (bedhub)
        * *     [Lift the bedcover]
                I lifted back the bedcover. The duvet underneath was crumpled.
                ~ reach (crumpled_duvet)
                ~ BedState = covers_shifted
        * *     (uncover) {reached(crumpled_duvet)}
                [Remove the cover]
                Careful not to disturb anything beneath, I removed the cover entirely. The duvet below was rumpled.
                Not the work of the maid, who was conscientious to a point. Clearly this had been thrown on in a hurry.
                ~ reach (hastily_remade)
                ~ BedState = covers_off
        * *     (duvet) {BedState == covers_off} [ Pull back the duvet ]
                I pulled back the duvet. Beneath it was a sheet, sticky with blood.
                ~ BedState = bloodstain_visible
                ~ reach (body_on_bed)
                Either the body had been moved here before being dragged to the floor - or this is was where the murder had taken place.
        * *     {BedState !? made_up} [ Remake the bed ]
                Carefully, I pulled the bedsheets back into place, trying to make it seem undisturbed.
                ~ BedState = made_up
        * *     [Test the bed]
                I pushed the bed with spread fingers. It creaked a little, but not so much as to be obnoxious.
        * *     (darkunder) [Look under the bed]
                Lying down, I peered under the bed, but could make nothing out.

        * *     {TURNS_SINCE(-> dobed) > 1} [Something else?]
                I took a step back from the bed and looked around.
                -> top
        - -     -> bedhub

    *   {darkunder && bedroomLightState ? on_floor && bedroomLightState ? on}
        [ Look under the bed ]
        I peered under the bed. Something glinted back at me.
        - - (reaching)
        * *     [ Reach for it ]
                I fished with one arm under the bed, but whatever it was, it had been kicked far enough back that I couldn't get my fingers on it.
                -> reaching
        * *     {Inventory ? cane} [Knock it with the cane]
                -> knock_with_cane

        * *     {reaching > 1 } [ Stand up ]
                I stood up once more, and brushed my coat down.
                -> top

    *   (knock_with_cane) {reaching && TURNS_SINCE(-> reaching) >= 4 &&  Inventory ? cane } [Use the cane to reach under the bed ]
        Positioning the cane above the carpet, I gave the glinting thing a sharp tap. It slid out from the under the foot of the bed.
        ~ move_to_supporter( knifeState, on_floor )
        * *     (standup) [Stand up]
                Satisfied, I stood up, and saw I had knocked free a bloodied knife.
                -> top

        * *     [Look under the bed once more]
                Moving the cane aside, I looked under the bed once more, but there was nothing more there.
                -> standup

    *   {knifeState ? on_floor} [Pick up the knife]
        Careful not to touch the handle, I lifted the blade from the carpet.
        ~ get(knife)

    *   {Inventory ? knife} [Look at the knife]
        The blood was dry enough. Dry enough to show up partial prints on the hilt!
        ~ reach (prints_on_knife)

    *   [   The desk... ]
        I turned my attention to the desk. A lamp sat in one corner, a neat, empty in-tray in the other. There was nothing else out.
        Leaning against the desk was a wooden cane.
        ~ bedroomLightState += seen

        - - (deskstate)
        * *     (pickup_cane) {Inventory !? cane}  [Pick up the cane ]
                ~ get(cane)
              I picked up the wooden cane. It was heavy, and unmarked.

        * *    { bedroomLightState !? on } [Turn on the lamp]
                -> operate_lamp ->

        * *     [Look at the in-tray ]
                I regarded the in-tray, but there was nothing to be seen. Either the victim's papers were taken, or his line of work had seriously dried up. Or the in-tray was all for show.

        + +     (open)  {open < 3} [Open a drawer]
                I tried {a drawer at random|another drawer|a third drawer}. {Locked|Also locked|Unsurprisingly, locked as well}.

        * *     {deskstate >= 2} [Something else?]
                I took a step away from the desk once more.
                -> top

        - -     -> deskstate

    *     {(Inventory ? cane) && TURNS_SINCE(-> deskstate) <= 2} [Swoosh the cane]
        I was still holding the cane: I gave it an experimental swoosh. It was heavy indeed, though not heavy enough to be used as a bludgeon.
        But it might have been useful in self-defence. Why hadn't the victim reached for it? Knocked it over?

    *   [The window...]
        I went over to the window and peered out. A dismal view of the little brook that ran down beside the house.

        - - (window_opts)
        <- compare_prints(-> window_opts)
        * *     (downy) [Look down at the brook]
                { GlassState ? steamed:
                    Through the steamed glass I couldn't see the brook. -> see_prints_on_glass -> window_opts
                }
                I watched the little stream rush past for a while. The house probably had damp but otherwise, it told me nothing.
        * *     (greasy) [Look at the glass]
                { GlassState ? steamed: -> downy }
                The glass in the window was greasy. No one had cleaned it in a while, inside or out.
        * *     { GlassState ? steamed && not see_prints_on_glass && downy && greasy }
                [ Look at the steam ]
                A cold day outside. Natural my breath should steam. -> see_prints_on_glass ->
        + +     {GlassState ? steam_gone} [ Breathe on the glass ]
                I breathed gently on the glass once more. { reached (fingerprints_on_glass): The fingerprints reappeared. }
                ~ GlassState = steamed

        + +     [Something else?]
                { window_opts < 2 || reached (fingerprints_on_glass) || GlassState ? steamed:
                    I looked away from the dreary glass.
                    {GlassState ? steamed:
                        ~ GlassState = steam_gone
                        <> The steam from my breath faded.
                    }
                    -> top
                }
                I leant back from the glass. My breath had steamed up the pane a little.
               ~ GlassState = steamed

        - -     -> window_opts

    *   {top >= 5} [Leave the room]
        I'd seen enough. I {bedroomLightState ? on:switched off the lamp, then} turned and left the room.
        -> joe_in_hall

    -   -> top
	
	
	= operate_lamp
	    I flicked the light switch.
	    { bedroomLightState ? on:
	        <> The bulb fell dark.
	        ~ bedroomLightState += off
	        ~ bedroomLightState -= on
	    - else:
	        { bedroomLightState ? on_floor: <> A little light spilled under the bed.} { bedroomLightState ? on_desk : <> The light gleamed on the polished tabletop. }
	        ~ bedroomLightState -= off
	        ~ bedroomLightState += on
	    }
	    ->->
	
	
	= compare_prints (-> backto)
	    *   { between ((fingerprints_on_glass, prints_on_knife),     fingerprints_on_glass_match_knife) } 
	[Compare the prints on the knife and the window ]
	        Holding the bloodied knife near the window, I breathed to bring out the prints once more, and compared them as best I could.
	        Hardly scientific, but they seemed very similar - very similiar indeed.
	        ~ reach (fingerprints_on_glass_match_knife)
	        -> backto
	
	= see_prints_on_glass
	    ~ reach (fingerprints_on_glass)
	    {But I could see a few fingerprints, as though someone hadpressed their palm against it.|The fingerprints were quite clear and well-formed.} They faded as I watched.
	    ~ GlassState = steam_gone
	    ->->
	
	= seen_light
	    *   {bedroomLightState !? on} [ Turn on lamp ]
	        -> operate_lamp ->

	    *   { bedroomLightState !? on_bed  && BedState ? bloodstain_visible }
	        [ Move the light to the bed ]
	        ~ move_to_supporter(bedroomLightState, on_bed)

	        I moved the light over to the bloodstain and peered closely at it. It had soaked deeply into the fibres of the cotton sheet.
	        There was no doubt about it. This was where the blow had been struck.
	        ~ reach (murdered_in_bed)

	    *   { bedroomLightState !? on_desk } {TURNS_SINCE(-> floorit) >= 2 }
	        [ Move the light back to the desk ]
	        ~ move_to_supporter(bedroomLightState, on_desk)
	        I moved the light back to the desk, setting it down where it had originally been.
	    *   (floorit) { bedroomLightState !? on_floor && darkunder }
	        [Move the light to the floor ]
	        ~ move_to_supporter(bedroomLightState, on_floor)
	        I picked the light up and set it down on the floor.
	    -   -> top
	
	=== joe_in_hall
	    My police contact, Joe, was waiting in the hall. 'So?' he demanded. 'Did you find anything interesting?'
	- (found)
	    *   {found == 1} 'Nothing.'
	        He shrugged. 'Shame.'
	        -> done
	    *   { Inventory ? knife } 'I found the murder weapon.'
	        'Good going!' Joe replied with a grin. 'We thought the murderer had gotten rid of it. I'll bag that for you now.'
	        ~ move_to_supporter(knifeState, with_joe)

	    *   {reached(prints_on_knife)} { knifeState ? with_joe }
	        'There are prints on the blade[.'],' I told him.
	        He regarded them carefully.
	        'Hrm. Not very complete. It'll be hard to get a match from these.'
	        ~ reach (joe_seen_prints_on_knife)
	    *   { reached((fingerprints_on_glass_match_knife, joe_seen_prints_on_knife)) }
	        'They match a set of prints on the window, too.'
	        'Anyone could have touched the window,' Joe replied thoughtfully. 'But if they're more complete, they should help us get a decent match!'
	        ~ reach (joe_wants_better_prints)
	    *   { between(body_on_bed, murdered_in_bed)}
	        'The body was moved to the bed at some point[.'],' I told him. 'And then moved back to the floor.'
	        'Why?'
	        * *     'I don't know.'
	                Joe nods. 'All right.'
	        * *     'Perhaps to get something from the floor?'
	                'You wouldn't move a whole body for that.'
	        * *     'Perhaps he was killed in bed.'
	                'It's just speculation at this point,' Joe remarks.
	    *   { reached(murdered_in_bed) }
	        'The victim was murdered in bed, and then the body was moved to the floor.'
	        'Why?'
	        * *     'I don't know.'
	                Joe nods. 'All right, then.'
	        * *     'Perhaps the murderer wanted to mislead us.'
	                'How so?'
	            * * *   'They wanted us to think the victim was awake[.'], I replied thoughtfully. 'That they were meeting their attacker, rather than being stabbed in their sleep.'
	            * * *   'They wanted us to think there was some kind of struggle[.'],' I replied. 'That the victim wasn't simply stabbed in their sleep.'
	            - - -   'But if they were killed in bed, that's most likely what happened. Stabbed, while sleeping.'
	                    ~ reach (murdered_while_asleep)
	        * *     'Perhaps the murderer hoped to clean up the scene.'
	                'But they were disturbed? It's possible.'

	    *   { found > 1} 'That's it.'
	        'All right. It's a start,' Joe replied.
	        -> done
	    -   -> found
	-   (done)
	    {
	    - between(joe_wants_better_prints, joe_got_better_prints):
	        ~ reach (joe_got_better_prints)
	        <> 'I'll get those prints from the window now.'
	    - reached(joe_seen_prints_on_knife):
	        <> 'I'll run those prints as best I can.'
	    - else:
	        <> 'Not much to go on.'
	    }
	    -> END



## 8) Summary
*小结*


总结一下这一节很难，但 **ink** 的 list 构造提供了：

### Flags Flag
*标记*

* 	每个 list 项是一次事件
* 	用 `+=` 标记事件"已发生"
*  	用 `?` 和 `!?` 测试

示例：

	LIST GameEvents = foundSword, openedCasket, metGorgon
	{ GameEvents ? openedCasket }
	{ GameEvents ? (foundSword, metGorgon) }
	~ GameEvents += metGorgon

### State machines
*状态机*

* 	每个 list 项是一个状态
*  用 `=` 设状态；用 `++` 和 `--` 前进/后退
*  用 `==`、`>` 等测试

示例：

	LIST PancakeState = ingredients_gathered, batter_mix, pan_hot, pancakes_tossed, ready_to_eat
	{ PancakeState == batter_mix }
	{ PancakeState < ready_to_eat }
	~ PancakeState++

### Properties
*属性*

*	每个 list 是一个不同的"属性"，其值是该属性可能取的状态（on/off、亮/灭等）
* 	改状态的做法是：先移除旧状态，再加上新状态
*  用 `?` 和 `!?` 测试

示例：

	LIST OnOffState = on, off
	LIST ChargeState = uncharged, charging, charged

	VAR PhoneState = (off, uncharged)

	*	{PhoneState !? uncharged } [Plug in phone]
		~ PhoneState -= LIST_ALL(ChargeState)
		~ PhoneState += charging
		You plug the phone into charge.
	*	{ PhoneState ? (on, charged) } [ Call my mother ]




# Part 6: International character support in identifiers
*第六部分：标识符的国际化字符支持*


默认情况下，ink 对故事**内容**里使用非 ASCII 字符没有任何限制。但目前对常量、变量、stitch、divert 等"具名流程元素"（统称**标识符**）的名字**还存在**字符限制。

对于使用非 ASCII 语言的作者，写故事时常常需要频繁切换输入法——给标识符取名时切到 ASCII、写故事内容时再切回——很不方便。此外，用作者自己的语言给标识符命名，能改善原始故事格式的整体可读性。

为缓解上述问题，ink **自动**支持一组预定义的非 ASCII 字符范围用作标识符。一般来说，这些范围被选成"该语言官方 Unicode 范围里的字母-数字子集"，已经足够用来命名标识符。下面这一节给出 ink 自动支持的非 ASCII 字符的更多细节。

### Supported Identifier Characters
*支持的标识符字符*


ink 当前对额外字符范围的支持局限于一组预定义的字符范围。

下面列出当前支持的标识符范围。

 - **Arabic 阿拉伯语**

   启用阿拉伯语系语言的字符，是官方 *Arabic* Unicode 范围 `؀`-`ۿ` 的子集。


 - **Armenian 亚美尼亚语**

   启用亚美尼亚语字符，是官方 *Armenian* Unicode 范围 `԰`-`֏` 的子集。


 - **Cyrillic 西里尔字母**

   启用使用西里尔字母的语言的字符，是官方 *Cyrillic* Unicode 范围 `Ѐ`-`ӿ` 的子集。


 - **Greek 希腊字母**

   启用使用希腊字母的语言的字符，是官方 *Greek and Coptic* Unicode 范围 `Ͱ`-`Ͽ` 的子集。


 - **Hebrew 希伯来语**

   启用希伯来语希伯来字母字符，是官方 *Hebrew* Unicode 范围 `֐`-`׿` 的子集。


 - **Latin Extended A 拉丁字母扩展 A**

   启用拉丁字母的扩展字符子集——完整对应官方 *Latin Extended-A* Unicode 范围 `Ā`-`ſ`。


 - **Latin Extended B 拉丁字母扩展 B**

   启用拉丁字母的扩展字符子集——完整对应官方 *Latin Extended-B* Unicode 范围 `ƀ`-`ɏ`。

- **Latin 1 Supplement 拉丁字母补充 1**

   启用拉丁字母的扩展字符子集——完整对应官方 *Latin 1 Supplement* Unicode 范围 `` - `ÿ`。


**注意！** ink 文件应当以 **UTF-8** 格式保存，这样才能确保上述字符范围被支持。

如果你想用的某个字符范围还未被支持，欢迎在 ink 主仓提一个 [issue](/inkle/ink/issues/new) 或 [pull request](/inkle/ink/pulls)。
