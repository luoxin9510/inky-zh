// 原作：inkle Ltd.（出处：Sorcery! 中 Swindlestones 骗子骰对话游戏的简化版）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、变量名、knot 名、divert 目标、人名（含 Half-Orc）一律保留英文；
//       仅翻译叙事文本与作者注释。print_number 函数已改为输出中文数字
//       （一、两、十、二十、百、千、百万 等），去除英文里的复数 "s" 与连字符。
//       Swindlestones 是 Sorcery! 系列原创的骗子骰游戏，规则类似 perudo / liar's dice。
//       详见 docs/translation-glossary.md。

LIST Dice =
    MeA1 = 11, MeA2, MeA3, MeA4,
    MeB1 = 21, MeB2, MeB3, MeB4,
    MeC1 = 31, MeC2, MeC3, MeC4,
    MeD1 = 41, MeD2, MeD3, MeD4,
    MeE1 = 51, MeE2, MeE3, MeE4,
    ThemA1 = 61, ThemA2, ThemA3, ThemA4,
    ThemB1 = 71, ThemB2, ThemB3, ThemB4,
    ThemC1 = 81, ThemC2, ThemC3, ThemC4,
    ThemD1 = 91, ThemD2, ThemD3, ThemD4,
    ThemE1 = 101, ThemE2, ThemE3, ThemE4

LIST Players = Me = 10, Them  = 60

VAR DiceCountMe = 5
VAR DiceCountThem = 5


CONST DEBUG_FIXED_RANDOM = false // true

CONST DEBUG_AI_DECISIONS = false // true

{DEBUG_FIXED_RANDOM:
    ~ SEED_RANDOM(3)
}

-> begin_game -> END



/*
    辅助函数
*/

=== function pop(ref _list)
    ~ temp el = LIST_MIN(_list)
    ~ _list -= el
    ~ return el



=== function came_from(-> x)
    ~ return TURNS_SINCE(x) == 0



=== function print_number(x)
~ x = INT(x) // 转成整数——本函数只处理整型
{
    - x >= 1000000:
        ~ temp k = x mod 1000000
        {print_number((x - k) / 1000000)}百万{ k > 0:{print_number(k)}}
    - x >= 1000:
        ~ temp y = x mod 1000
        {print_number((x - y) / 1000)}千{ y > 0:{print_number(y)}}
    - x >= 100:
        ~ temp z = x mod 100
        {print_number((x - z) / 100)}百{z > 0:{print_number(z)}}
    - x == 0:
        零
    - x < 0:
        负{print_number(-1 * x)}
    - else:
        { x >= 20:
            { x / 10:
                - 2: 二十
                - 3: 三十
                - 4: 四十
                - 5: 五十
                - 6: 六十
                - 7: 七十
                - 8: 八十
                - 9: 九十
            }
        }
        { x < 10 || x > 20:
            { x mod 10:
                - 1: 一
                - 2: 两
                - 3: 三
                - 4: 四
                - 5: 五
                - 6: 六
                - 7: 七
                - 8: 八
                - 9: 九
            }
        - else:
            { x:
                - 10: 十
                - 11: 十一
                - 12: 十二
                - 13: 十三
                - 14: 十四
                - 15: 十五
                - 16: 十六
                - 17: 十七
                - 18: 十八
                - 19: 十九
            }
        }
}

/*
    骰子
*/

=== function faceValue(dice)
    ~ return LIST_VALUE(dice) mod 10


/*
    输出
*/

=== function stateDiceFor(who)
    ~ temp dice = diceForPlayer(who)
    <b>{listDice(dice)}</b>

=== function listDice(dice)
    {_listDice(dice, 1)}
=== function _listDice(dice, val)
    ~ temp values = valuesIn(val, dice)
    ~ temp count = LIST_COUNT(values)
    { count > 0:
        {print_number(count)} 个 {val}
        ~ dice -= values
    }
    {dice:
        { count > 0:
            { countValuesIn(faceValue(LIST_MIN(dice)), dice) == LIST_COUNT(dice):
                <> 以及
            - else:
                <>、
            }
        }
        <> { _listDice(dice, val+1) }
    }

/*
    查询
*/

=== function countValuesFor(value, who)
    ~ temp dice = diceForPlayer(who)
    ~ return LIST_COUNT(valuesIn(value, dice))

=== function countValuesIn(value, dice)
    ~ return LIST_COUNT(valuesIn(value, dice))

=== function valuesIn(value, dice)
    ~ temp lowestDice = pop(dice)
    { lowestDice:
        ~ temp retVal = ()
        {faceValue(lowestDice) == value:
            ~ retVal = lowestDice
        }
        ~ return retVal + valuesIn(value, dice)
    }
    ~ return ()




=== function diceCountForPlayer(who)
    { who :
    -   Me:     ~ return DiceCountMe
    -   Them:   ~ return DiceCountThem
    }

=== function diceForPlayer(who)
    ~ return LIST_RANGE(Dice, LIST_VALUE(who), LIST_VALUE(who) + 10 * diceCountForPlayer(who))

/*
    掷骰
*/

=== function rollDice()
    ~ Dice = ()
    ~ rollDiceFor(Me, DiceCountMe)
    ~ rollDiceFor(Them, DiceCountThem)
 //   [Me:     {diceForPlayer(Me) }  ]
 //   [Them:   {diceForPlayer(Them) }]

=== function rollDiceFor(who, diceNumber)
    { diceNumber > 0:
        ~ temp diceOffset = LIST_VALUE(who) + (diceNumber - 1) * 10 + RANDOM(1, 4)
        ~ Dice += Dice(diceOffset)
        ~ rollDiceFor(who, diceNumber - 1)
    }

/*
    当前的下注
*/

=== function stateBet(bet)
    {print_number(betCount(bet))} 个 {betNumber(bet)}

=== function betNumber(bet)
    ~ return LIST_VALUE(bet) mod 10

=== function betCount(bet)
    ~ return FLOOR(LIST_VALUE(bet) / 10)


=== function possibleBets()
    ~ return LIST_RANGE(LIST_ALL(Dice), LIST_VALUE(lastBet) + 1, (DiceCountMe + DiceCountThem) * 10 + 4)

=== function possibleBetCounts()
    ~ temp bets = possibleBets()
    ~ return getCountsFromBets(bets)

=== function getCountsFromBets(bets)
    ~ temp bet = pop(bets)
    { bet:
        ~ bet = Dice(betCount(bet) * 10 + 1)
        ~ return bet + getCountsFromBets(bets)
    }
    ~ return ()

=== function possibleBetsForCount(c)
    ~ return possibleBets() ^ LIST_RANGE(LIST_ALL(Dice), c * 10, c * 10 + 4)



=== function countDiceAtValue(diceToConsider, value)
    ~ temp die = pop(diceToConsider)
    { die:
        ~ temp retValue = (faceValue(die) == value)
        ~ return retValue + countDiceAtValue(diceToConsider, value)
    }
    ~ return 0


/*
    游戏主循环
*/

VAR firstTurn = Me

VAR lastBet = ()

== begin_game
    你在桌边落座。对面那个半兽人（Half-Orc）正用一柄匕首剔牙。
    "准备好了？"他低声咕哝着，把一堆骰子甩给你。
- (opts)
    * (whatis)   "这是什么游戏？"[]你问道。
        "Swindlestones（骗子骰），"半兽人回答。"靠的是运气，还有脑子。"他低声笑了起来。"还有<i>长相</i>。"
        -> opts
    *   { whatis } "规矩是怎么样的？"
        "你在手心后头摇骰子。我在我这边摇。你说，'桌上有 2 个 1，' 大概这意思。我喊'抓'，也就是不信你——或者我喊一个更大的注。要么数字更高，要么骰子更多。被抓的时候，咱们就摊牌，看谁说得对。输的，丢一颗骰子。骰子没了，人也就输了。"
        * *     "懂了。"

        * *     "也就是说，注会一路往上叠？"
                半兽人点了点头。
        - -     "简单得很。来吧，开局。"
                -> opts
    +   [ 摇骰 ]
        -> main

=== main

    ~ rollDice()
    你{DiceCountMe == 1:把仅剩的那颗骰子|把你的 {print_number(DiceCountMe)} 颗骰子拢到一起}在掌心后头一摇，结果是 { stateDiceFor(Me)  }。
    半兽人摇了他的{DiceCountThem > 1:那 {print_number(DiceCountThem)} 颗}骰子，{~低声一笑|哼了一声}。

    ~ resetAI()

    ~ lastBet = ()
    ~ Players = firstTurn



    ->turnstart

= turnchange
    ~ Players = LIST_INVERT(Players)
    -> turnstart

= turnstart
    { Players:
    -   Me:     -> my_turn
    -   Them:   -> their_turn
    }



= my_turn
    { not came_from(-> their_turn):
        "你先下注，"半兽人咕哝道。
    }

    { not came_from(-> stateDiceFor):
        [ 你手里是 {stateDiceFor(Me) } ]
    }

- (top)

    { lastBet:
        +   [ 抓他！ ]
            "我抓，"你出声。

            -> call_last_bet(Me)
    }

    ~ temp bets = possibleBetCounts()
    {bets:
        -> bet_opts(bets, true)
    }

= bet_opts(bets, countsOnly)
- (opts)
    ~ temp bet = pop(bets)
    {countsOnly:
        +   [ 下注 {print_number(betCount(bet))} 个 ……  ]
            ~ bets = possibleBetsForCount(betCount(bet))
            -> bet_opts(bets, false)
    - else:
        +   [ 下注 {stateBet(bet)} ]
            "我下注 <b>{stateBet(bet)}</b>，"你出声。
            -> makeBet(bet)
    }
    { bets:
        -> opts
    }
    { not countsOnly:
        +   [ 返回 ]
            -> top
    }
    -> DONE




= makeBet(bet)
    ~ lastBet = bet
    -> turnchange


= their_turn

    "我想想，"半兽人低声念叨，用一根勾起的指甲挠了挠下巴。


    ~ temp newBet = ()

    -> filter_and_obtain_bet(  newBet ) ->


    { not newBet:
        -> he_calls

    - else:
        -> he_bets(newBet)
    }

= he_bets(newBet)
    <> "我下注 <b>{stateBet(newBet)}</b>。<>

    { cycle:
    -   {shuffle:
        -   该——你了。
        -   嗯？
        -   该你了。
        -   下一个，你。
        -   到你了。
        -   你说说看。
        }
    -   {shuffle:
        -   你怎么说？
        -   认输吧，我看。
        -   我吃定你了。
        -   这个数，你跟不下去吧。
        -
        -
        -
        }
    }
    <>"

    -> makeBet(newBet)


 = he_calls
        <> "我抓。"

        -> call_last_bet(Them)



= call_last_bet(who)
    // who 抓的是 who 的注
    骰子摊开。除了我的 { stateDiceFor(Me)  }，他还有 { stateDiceFor(Them)  }。

    ~ temp valuesInSet = countValuesIn(betNumber(lastBet), Dice)

    ~ temp betWasOkay = ( valuesInSet >= betCount(lastBet) )

    <> 桌上一共 {not betWasOkay:只有} <b>{print_number(valuesInSet)} 个 {betNumber(lastBet)}</b>。



    ~ temp winner = ()

    {not betWasOkay:
        ~ winner = who
    - else:
        ~ winner = LIST_INVERT(who)
    }


    -> resolve_round(winner)


 = resolve_round(winner)
    { winner:
    - Me:   ~ DiceCountThem--
    - Them: ~ DiceCountMe--
    }

    {
    - DiceCountThem <= 0:
        -> end_game(Me)
    - DiceCountMe <= 0:
        -> end_game(Them)
    }



    { winner:
    - Me:
        半兽人不耐地嘟囔了一声，把自己的一颗骰子甩到一边。
    - Them:
        半兽人深为满意地点了点头，看着你把自己的一颗骰子推开。
    }

    +   [ 再来一轮 ]

        ~ firstTurn = winner
        -> main



/*
    AI
*/

=== end_game(winner)
    { winner:
    - Me:   -> you_win
    - Them:     -> he_wins
    }

= you_win
    你笑逐颜开，把半兽人的金币尽数收入囊中。理所当然地，他伸手去摸他的剑……

    ->->

= he_wins
    你把最后一颗骰子甩出去，那家伙伸过桌来，把那堆金币尽数搂进自己怀里。
    "你一坐到椅子上，我就看出你是个输家，"他得意地咕哝着。"输家相。"
    ->->


/*
    AI
*/



=== function findBetsUpTo(value, maxCount, bets)
    ~ temp bet = pop(bets)
    { bet:
        ~ temp retVal = ()
        { betNumber(bet) == value && betCount(bet) <= maxCount:
            ~ retVal = bet
        }
        ~ return retVal + findBetsUpTo(value, maxCount, bets)
    }
    ~ return ()

VAR whatDiceDoWeThinkYouHave = ()

=== function resetAI()
    ~ whatDiceDoWeThinkYouHave = ()

===  filter_and_obtain_bet(  ref newBet )

    {DEBUG_AI_DECISIONS:  [ 他实际有 {stateDiceFor(Them) } ] }

    ~ temp countOfLastBet = betCount(lastBet)
    ~ temp valueOfLastBet = betNumber(lastBet)

    { lastBet:
        ~ temp iThinkYouHave = FLOOR(countOfLastBet / 2) + 1
        ~ iThinkYouHave -= countValuesIn(valueOfLastBet, whatDiceDoWeThinkYouHave)
        { iThinkYouHave: // 我们觉得你手上的这个数比之前估计的还多，再加 1 颗
            ~ whatDiceDoWeThinkYouHave += LIST_RANDOM(valuesIn ( valueOfLastBet, LIST_ALL(Dice) - whatDiceDoWeThinkYouHave ) )
        }
    }




    ~ temp aRandomValue = RANDOM(1, 4)

    ~ temp bets = possibleBets()

    ~ temp cannotCall = countValuesFor(betNumber(lastBet), Them) >= betCount(lastBet)

    ~ temp valuesIHave = countValuesFor(valueOfLastBet, Them)

    ~ temp uncertaintyInYourDice = MAX(0, DiceCountMe - LIST_COUNT(whatDiceDoWeThinkYouHave) )

    {DEBUG_AI_DECISIONS: [ AI 推测你有 {listDice(whatDiceDoWeThinkYouHave)}，不确定度 {uncertaintyInYourDice} ]  }

    +   { valuesIHave + DiceCountMe < countOfLastBet } ->
        {DEBUG_AI_DECISIONS: [ 你下虚了，我们能确定 ]  }
        // 你下虚了，而且我们确信无疑


    +   {findBetsUpTo(4, countValuesFor(4, Them), bets) } {RANDOM(1, 5) >= 4 }  ->
        {DEBUG_AI_DECISIONS: [ 安全的高位 4 注 ] }
        ~ newBet = findBetsUpTo(4, countValuesFor(4, Them) , bets)

    +   { not lastBet }     ->
        { DEBUG_AI_DECISIONS:  [ 随便挑一个开局注 ] }
        ~ temp myCount = countValuesFor(aRandomValue, Them)
        ~ newBet = findBetsUpTo(aRandomValue, myCount + 1,  bets )



    +   { LIST_COUNT(whatDiceDoWeThinkYouHave) > DiceCountMe * 1.5 } {not cannotCall} ->
        {DEBUG_AI_DECISIONS: [ 我们怀疑你在虚张声势 ] }
        // 你的下注东一榔头西一棒子。抓。

    +   { RANDOM(1, 3) == 1 }
        { DiceCountThem + countValuesIn(valueOfLastBet, whatDiceDoWeThinkYouHave) <= countOfLastBet + 1 }
        ->
        {DEBUG_AI_DECISIONS: [ 加注压你 ]  }
        ~ newBet =  findBetsUpTo(valueOfLastBet, countOfLastBet + 1, bets )


    +   { valuesIHave + countValuesIn(valueOfLastBet, whatDiceDoWeThinkYouHave) + FLOOR(uncertaintyInYourDice / 4) + 1 <  countOfLastBet }  {not cannotCall} ->
       {DEBUG_AI_DECISIONS:  [ 我们怀疑你手上没有这么多牌兜底 ] }

    +   {findBetsUpTo(3, countValuesFor(3, Them), bets) }
        { countValuesIn(4 , whatDiceDoWeThinkYouHave )  == 0}
        ->
        {DEBUG_AI_DECISIONS:  [ 我们这边 3 多，又判断你没什么 4，逼你一下 ] }
        ~ newBet = findBetsUpTo(3, countValuesFor(3, Them) , bets)

    +   {findBetsUpTo(1, countValuesFor(1, Them) + countValuesIn(1, whatDiceDoWeThinkYouHave) + uncertaintyInYourDice  / 2, bets) }     ->
        {DEBUG_AI_DECISIONS: [ 默认下注：稳妥的 1 ] }
        ~ newBet = findBetsUpTo(1, countValuesFor(1, Them) + countValuesIn(1, whatDiceDoWeThinkYouHave)  + uncertaintyInYourDice  / 2, bets)

    +   {findBetsUpTo(3, countValuesFor(3, Them) + countValuesIn(3, whatDiceDoWeThinkYouHave)  + uncertaintyInYourDice  / 2, bets) }     ->
        {DEBUG_AI_DECISIONS: [ 默认下注：稳妥的 3 ] }
        ~ newBet = findBetsUpTo(3, countValuesFor(3, Them) + countValuesIn(3, whatDiceDoWeThinkYouHave) + uncertaintyInYourDice  / 2, bets)

    +   {findBetsUpTo(2, countValuesFor(2, Them) + countValuesIn(2, whatDiceDoWeThinkYouHave)  + uncertaintyInYourDice  / 2, bets) }     ->
        {DEBUG_AI_DECISIONS: [ 默认下注：稳妥的 2 ] }
        ~ newBet = findBetsUpTo(2, countValuesFor(2, Them) + countValuesIn(2, whatDiceDoWeThinkYouHave) + uncertaintyInYourDice  / 2, bets)

    +   {findBetsUpTo(4, countValuesFor(4, Them) + countValuesIn(4, whatDiceDoWeThinkYouHave)  + uncertaintyInYourDice  / 2, bets) }     ->
       {DEBUG_AI_DECISIONS:  [ 默认下注：稳妥的 4 ] }
        ~ newBet = findBetsUpTo(4, countValuesFor(4, Them) + countValuesIn(4, whatDiceDoWeThinkYouHave) + uncertaintyInYourDice  / 2, bets)


    +   ->
        {DEBUG_AI_DECISIONS: [ 找一个兜底注 ] }
        - - (makebet)
            ~ newBet = pop(bets)
            {DEBUG_AI_DECISIONS:  [ {newBet}:  { betCount(newBet)} <= {countValuesFor(betNumber(newBet), Them)} + {countValuesIn(betNumber(newBet), whatDiceDoWeThinkYouHave)} + {uncertaintyInYourDice} ] }

        + + { betCount(newBet) <= countValuesFor(betNumber(newBet), Them) + countValuesIn(betNumber(newBet), whatDiceDoWeThinkYouHave) + uncertaintyInYourDice  }
            {RANDOM(1, 5) >= 3 || cannotCall }  ->
            { DEBUG_AI_DECISIONS: [ 冒险试一手更高的注 ]  }
            ->->


        + + ->
            { not bets:
                { DEBUG_AI_DECISIONS: [ 走投无路了，抓。 ]  }
                ~ newBet = ()
                ->->
            }
            -> makebet



    -   // 确保最后只剩一个注
        ~ newBet = LIST_RANDOM(newBet)


        ->->
