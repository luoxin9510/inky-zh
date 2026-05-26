// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 storylets.ink，参考 smwhr/ink-storylets）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、VAR / LIST / function 名、knot 名、divert 目标、参数名、人物专名（Avocado Witch / Banana Boy / Crumpet King）一律保留英文；仅翻译叙事文本与作者注释。

/* "Storylet" 实现。

    基于 smwhr 的 https://github.com/smwhr/ink-storylets/tree/main。

    它让你把内容写成一个个 "storylet" —— 由前置条件守门的小片段 / 场景。游戏会从当前可用的 storylet 里挑出前 N 个供玩家选择。

    机制相当轻量，数据与故事内容贴在一起，便于作为可扩展模板使用。

*/



The beginning!

- (opts)
    // 从可用列表里挑出排名前 2 的 storylet
    <- listAvailableStorylets(2, -> opts)

    // 若无可用 storylet，提供一个兜底分支
    * ->

-   There was nothing else to do.
    -> END

// 下列函数遍历 storylet 数据库
// 按优先级顺序找出可用的 storylet

VAR AvailableStorylets = ()

== listAvailableStorylets(max, -> backTo)
    ~ AvailableStorylets = ()
    ~ computeStorylets(LIST_ALL(Storylets), max)
    -> offerStorylets(AvailableStorylets, backTo)

== function computeStorylets(list, max)
    ~ temp current = LIST_MIN(list)
    { current && max > 0:
        ~ list -= current
        ~ temp storyletFunction = StoryletDatabase(current)

        { storyletFunction(Condition):
            ~ AvailableStorylets += current
            ~ max--
        }
        ~ computeStorylets(list, max)
    }

=== offerStorylets(list, -> backTo)===
    ~ temp current = LIST_MIN(list)  // 按 storylet 升序排列
    {current:
        ~ list -= current
        ~ temp storyletFunction = StoryletDatabase(current)

        +   [{storyletFunction(ChoiceText)}]
            ~ temp whereTo = storyletFunction(Content)
            -> whereTo -> backTo
    }
    { list:
        -> offerStorylets(list, backTo)
    }
    -> DONE


// 数据库：把 storylet 的 LIST 值映射到对应的索引函数

LIST Props = Content, Condition, ChoiceText

LIST Storylets = StoryA, StoryB, StoryC         // 按优先级排序

=== function StoryletDatabase(storylet)
   { storylet:
   -  StoryA:   ~ return -> StoryletData_Avocado
   -  StoryB:   ~ return -> StoryletData_Bananas
   -  StoryC:   ~ return -> StoryletData_Crumpets
   }

// 故事内容：每个 storylet 都是一对「数据库函数 / 内容」。

=== function StoryletData_Avocado(prop)
    { prop:
    -   ChoiceText: 拜访 Avocado Witch
    -   Condition:  ~ return not witch_content  // 仅一次
    -   Content:    ~ return -> witch_content
    }

=== witch_content
    你拜访了女巫。
    ->->



=== function StoryletData_Bananas(prop)
    { prop:
    -   ChoiceText:  既然已经见过国王，那就去看望 Banana Boy 吧！
    -   Condition:  ~ return not boy_content && king_content // 仅一次
    -   Content:    ~ return -> boy_content
    }

=== boy_content
    你拜访了那个男孩。
    ->->


=== function StoryletData_Crumpets(prop)
    { prop:
    -   ChoiceText: 拜访 Crumpet King
    -   Condition:  ~ return not king_content  // 仅一次
    -   Content:    ~ return -> king_content
    }

=== king_content
    你拜访了国王。
    ->->
