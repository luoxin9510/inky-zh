// 原作：inkle Ltd.（出处：Overboard! 中的简化版 pontoon 牌局示例）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、变量名、knot 名、divert 目标、人名一律保留英文；
//       仅翻译叙事文本与作者注释。pontoon 即英式 21 点（Twenty-One），
//       twist=要牌，stick=停牌，bust=爆牌,five card trick=五张牌，
//       burn=烧牌重发。print_number 已改为输出中文数字，与 swindlestones.zh.ink 风格一致。
/*

    本例是 Overboard! 中 pontoon（英式 21 点）牌局的简化版。

    程序中真实模拟了一副扑克牌的洗牌与发牌，玩家可以叫额外牌并下注，随后由 AI 角色 Carstairs（一位英国绅士兼牌坛老手）开打。

    在正式游戏（www.inklestudios.com/overboard）中，每手牌之间还会穿插对话选项，并提供更多狡黠的手段帮玩家扭转牌桌局势！

*/


-> play_game -> END

/* ---------------------------------------------

    函数与定义

--------------------------------------------- */

VAR myCards = ()
VAR hisCards = ()
VAR faceUpCards = ()

VAR money = 400


VAR CstrsBank = 1000

 LIST PackOfCards =
    A_Spades = 1, 2_Spades, 3_Spades, 4_Spades,
    5_Spades, 6_Spades, 7_Spades, 8_Spades,
    9_Spades, 10_Spades, J_Spades, Q_Spades, K_Spades,
    A_Diamonds = 101 , 2_Diamonds, 3_Diamonds, 4_Diamonds,
    5_Diamonds, 6_Diamonds, 7_Diamonds, 8_Diamonds,
    9_Diamonds, 10_Diamonds, J_Diamonds, Q_Diamonds, K_Diamonds,
    A_Hearts = 201, 2_Hearts, 3_Hearts, 4_Hearts,
    5_Hearts, 6_Hearts, 7_Hearts, 8_Hearts,
    9_Hearts, 10_Hearts, J_Hearts, Q_Hearts, K_Hearts,
    A_Clubs = 301, 2_Clubs, 3_Clubs, 4_Clubs,
    5_Clubs, 6_Clubs, 7_Clubs, 8_Clubs,
    9_Clubs, 10_Clubs, J_Clubs, Q_Clubs, K_Clubs

LIST Suits = Spades = 0, Diamonds, Hearts, Clubs

LIST Values = Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King




=== function suit(x)
    ~ return Suits(INT(FLOOR(LIST_VALUE(x) / 100)))

=== function number(x)
    ~ return Values(LIST_VALUE(x) mod 100)



=== function value(x)
    ~ return MIN(LIST_VALUE(x) mod 100, 10)

=== function shuffle()
    ~ PackOfCards = LIST_ALL(PackOfCards)

=== function addSpecificCardOfValue(ref toHand, val, faceUp)
    ~ temp x = pullCardOfValue(val)
    ~ return addSpecificCard( toHand, x, faceUp)

=== function addSpecificCard(ref toHand, x, faceUp)
    ~ toHand += x
    {faceUp:
        ~ faceUpCards += x
    }
    ~ return x

=== function addCard(ref toHand, faceUp)
    ~ temp x = pullCardOfValue(LIST_ALL(Values))
    ~ temp retVal = addSpecificCard( toHand, x, faceUp)
    ~ return retVal


=== function pullCardOfValue(valuesAllowed)
    ~ temp card = pop_random(PackOfCards)
    { card:
        { valuesAllowed !? number(card):
            ~ return pullCardOfValue(valuesAllowed)
        }
        ~ return card
    }
    [ 错误：找不到点数属于 {valuesAllowed} 的牌！ ]
    ~ shuffle()
    ~ return pullCardOfValue(valuesAllowed)

=== function nameCard(x)
    {_nameCard(x, true) }

=== function _nameCard(x, allowVariants)
    ~ temp num = number(x)
    {allowVariants:
        { RANDOM(1, 3) == 1:
            一张{suit(x):
                - Spades: 黑桃
                - Diamonds: 方块
                - Hearts: 红桃
                - Clubs: 梅花
            }<>{num:
                - Ace: A
                - Two: 2
                - Three: 3
                - Four: 4
                - Five: 5
                - Six: 6
                - Seven: 7
                - Eight: 8
                - Nine: 9
                - Ten: 10
                - Jack: J
                - Queen: Q
                - King: K
            }
        - else:
            那张{suit(x):
                - Spades: 黑桃
                - Diamonds: 方块
                - Hearts: 红桃
                - Clubs: 梅花
            }<>{num:
                - Ace: A
                - Two: 2
                - Three: 3
                - Four: 4
                - Five: 5
                - Six: 6
                - Seven: 7
                - Eight: 8
                - Nine: 9
                - Ten: 10
                - Jack: J
                - Queen: Q
                - King: K
            }
        }
    - else:
        {suit(x):
            - Spades: 黑桃
            - Diamonds: 方块
            - Hearts: 红桃
            - Clubs: 梅花
        }<>{num:
            - Ace: A
            - Two: 2
            - Three: 3
            - Four: 4
            - Five: 5
            - Six: 6
            - Seven: 7
            - Eight: 8
            - Nine: 9
            - Ten: 10
            - Jack: J
            - Queen: Q
            - King: K
        }
    }

=== function printHandDescriptively(x, mine)
    {printHand(faceUpCards ^ x)}<>明置在桌上
    ~ temp faceDownCards = x - faceUpCards
    {faceDownCards:
        <>，另有<>
        { mine:
            {printHand(faceDownCards)}
        - else:
            {print_number(LIST_COUNT(faceDownCards))} 张
        }
        <> {~{mine:暗扣在手|}|背面朝下|盲扣}
    }

=== function printHand(x)
    ~ _printHand(x)
=== function _printHand(x)
    ~ temp y = pop(x)
    {y:
        {nameCard(y)}
        {LIST_COUNT(x):
        - 0:
            ~ return
        - 1:
            <> 以及 {_printHand(x)}
        - else:
            <>、{_printHand(x)}
        }
    }

== function listMyCards()
    ~ _listOfCards(myCards)
== function _listOfCards(hand)
    ~ temp y = pop(hand)
    { y:
        <>{_nameCard(y, false)}
        {hand:
            <><br>
            ~ _listOfCards(hand)
        }
    }



=== function isPontoon(x)
    ~ return handContains(x, Ace) && ( handContains(x, King) || handContains(x, Queen) || handContains(x, Jack) ) && LIST_COUNT(x) == 2

=== function handContains(x, card)
    ~ temp y = pop(x)
    { y:
        { number(y) == card:
            ~ return true
        - else:
            ~ return handContains(x, card)
        }
    }
    ~ return false

=== function minTotalOfHand(x)
    ~ temp y = pop(x)
    {y:
        ~ return minTotalOfHand(x) + value(y)
    }
    ~ return 0

=== function maxTotalOfHand(x)
    ~ temp minTot = minTotalOfHand(x)
    {handContains(x, Ace) && minTot <= 11:
        ~ return minTot + 10
    - else:
        ~ return minTot
    }

=== function sayTotalOfHand(x)
    ~ temp minTot = minTotalOfHand(x)
    { shuffle:
    -   合计
    -   总计
    -   凑出
    -   正好
    }
    <> {print_number(minTot)} 点
    { handContains(x, Ace)  && minTot <= 11:
        ~ temp max = maxTotalOfHand(x)
        <>，或 {print_number(maxTotalOfHand(x))} 点
    }
=== function finalTotalOfHand(x)
    { isPontoon(x):
        pontoon 牌型
    - else:
        {print_number(maxTotalOfHand(x))} 点
    }


=== function describeMyCards()
    { shuffle:
    -   V:      ……{printHandDescriptively(myCards, true)}。 #thought
    - { shuffle:
        -   CARSTAIRS:  {~头一{~张|发|亮}{!给您}是|}

        -   CARSTAIRS:  这位女士{~拿到|得到}的是

        }
        <> {nameCard(faceUpCards ^ myCards)}
        V:  ……另一张盖着，是 {nameCard(myCards - faceUpCards)}…… #thought
    }
    V:      ……{sayTotalOfHand(myCards)}…… #thought




== function describePot(bet)
    { shuffle:
    -   CARSTAIRS:  目前{~注码|赌注|底池}是 {print_number(bet)} 英镑。
    -   CARSTAIRS:  {~一共下了|{~已经|总共}有} {print_number(bet)} 英镑{~在底池里|压在桌面上}。
    }


/*------------------------------------------

    游戏主循环

------------------------------------------*/

=== play_game

- (top_of_game)

    ~ temp startingMoney = money

    ~ myCards = ()

    ~ hisCards = ()
    ~ faceUpCards = ()

    ~ temp bet = 20

    { once:
    -   VO:     我把两张十英镑钞票丢到桌上。
    -   V:  二十英镑。
        CARSTAIRS:     底池现在是二十英镑。
    -   VO:     我扔下我那一份底注。



    }
    {

    - LIST_COUNT(PackOfCards) < 10:
        ~ shuffle()
        ~ temp plural = RANDOM(1,2)

        VO:         Carstairs {~把牌|把所有牌}{plural:{~全部|}收拢起来|拢成一叠}，然后{~熟练|快速|漫不经心|一丝不苟||}地{~一掀|洗}了{plural:它们|一遍}，才开始发头两张牌。

    - else:

        VO:     Carstairs {~推给我|抛给我|塞过来|发出}{~{~一张新|一张全新的}牌|我的第一张牌}{~，正面朝上|}{~，从{~牌堆顶端|}抽出|}。
    }
    ~ temp myNewCard = ()

    ~ myNewCard = addCard(myCards, true)


    { shuffle:
    -   CARSTAIRS:  {~第一张{~牌|发出来}的是|}{nameCard(myNewCard)}。

    -   CARSTAIRS:  这位女士{~拿到|得到|收下}{nameCard(myNewCard)}。
    }

    ~ temp hisNewCard =  addCard(hisCards, true)
    { stopping:
    -   CARSTAIRS:  至于庄家嘛……拿到{nameCard(hisNewCard)}。
        -
        { shuffle:
        -   CARSTAIRS: 而我自己是{nameCard(hisNewCard)}。

        -   CARSTAIRS:  {~庄家{~拿到……|手里是}|至于我，是}{nameCard(hisNewCard)}。
        }
    }

    {once:
    -   CARSTAIRS:      您可以弃牌，也可以下注继续。
    }

    ~ temp incr = 0
- (bet_opts)
    +   [ 弃牌 ]

        V:  {~不玩了|弃牌}。
        -> i_lost

    +   [ 下注 50 英镑 ]
        ~ incr =  50
    +   {money - bet < 200} [ 下注 100 英镑 ]
        ~ incr = 100
    +   {money - bet >= 200} [ 下更大的注…… ]
        + + {CHOICE_COUNT() < 2 }  {money - bet <= 300} [   下 100 英镑   ]
            ~ incr = 100
        + + {CHOICE_COUNT() < 2 } {money - bet <= 250} [   下 150 英镑    ]
            ~ incr =  150
        + + {CHOICE_COUNT() < 2 } [   下 200 英镑   ]
            ~ incr =  200
        + + {CHOICE_COUNT() < 2 } {money - bet >= 300} [   下 300 英镑   ]
            ~ incr = 300
        + + [ 下更小的注…… ]
            -> bet_opts


-
    { shuffle:
    -   V:  我再放进 {print_number(incr)} 英镑{incr > 50:。|，加注}。
    -   V:  我加注 {print_number(incr)} 英镑。
    }
    { incr >= 200:

        { shuffle once:
        -   VO:     Carstairs 挑了挑眉。
        -   CARSTAIRS:  我的老天。
        -   CARSTAIRS:  哎呀，这就有意思了。
        -   CARSTAIRS:  看来今儿有人手气正旺。
        }

    }
 -      ~ bet += incr

        { describePot(bet) }

        { shuffle:
        -   VO:     他{~递|发}了{~给我|出}第二张牌，背面朝下。
        -   CARSTAIRS:  这是您的下一张牌。
            { RANDOM(1, 2):
               VO:     他把牌滑过桌面送到我面前，背面朝下。
            }
        }

        {once:
        -   CARSTAIRS:  您自己看就行，别让我瞧见。
        }

        ~ myNewCard = addCard(myCards, false)


        V:  ……{nameCard(myNewCard)}：{sayTotalOfHand(myCards)}…… #thought

        ~ addCard(hisCards, false)

        { shuffle:
        -   VO:     他也给自己发了一张，背面朝下。
        -   CARSTAIRS:  我自己也再来一张盲牌。
        }

- (myplay)

    { minTotalOfHand(myCards) > 21:
        { shuffle:
        -   V:  我爆了。
        -   V:  该死。
        -   VO:     我把牌{~一摔|甩}在桌上。
        }
        { i_lost mod 3 == 2:
            { shuffle:
            -   V:  你在做手脚。
            -   V:  你到底怎么做到的？
            -   V:  这不可能公平。
            }
            { shuffle:
            -   CARSTAIRS:  我向您保证绝对没有！
            -   CARSTAIRS:  夫人，我只押概率，不针对人。
            -   CARSTAIRS:  我对天发誓，我清清白白！
            }


        }
        -> i_lost
    }
    { LIST_COUNT(myCards) == 5:
        CARSTAIRS:  五张牌（five card trick）！
        CARSTAIRS:  在 pontoon 里五张牌组合可以压同点数的少牌一头。
    }

 - (check_for_burn)
    { LIST_COUNT(myCards) == 2 && minTotalOfHand(myCards) == 13 && money - bet >= 20:
        +   {came_from(-> burny)}
            [ 再烧一次 ]
            -> burny
        +   (burny) {not came_from(-> burny)}
            [ 再加 20 英镑烧牌重发（burn） ]
            ~ bet += 20
            V:  烧牌。
            >>> AUDIO CardCollectAndDealTwoCards
            VO:     Carstairs 把牌收回去，又发了两张新的。
            ~ faceUpCards -= myCards
            ~ myCards = ()
            ~ addCard(myCards, true)
            ~ addCard(myCards, false)
            V:      ……{printHandDescriptively(myCards, true)}…… #thought
            V:      ……{sayTotalOfHand(myCards)}…… #thought

            -> check_for_burn

        *   [ 保留这手牌 ]
            -> bid_loop
    - else:
        -> bid_loop
    }
    -> DONE

- (bid_loop)

    { not seen_very_recently(->  describePot):
        { describePot(bet) }
    }
    ~ temp gotTwentyOne = (maxTotalOfHand(myCards) == 21)
    {gotTwentyOne:
        {isPontoon(myCards):
            V:  ……居然是 pontoon 牌型！  #thought
        - else:
            V:  ……二十一点！   #thought
        }

    }

    +   [ 停牌 stick{not gotTwentyOne:，定在 {finalTotalOfHand(myCards)}} ]
        CARSTAIRS:  最终注码是 {print_number(bet)} 英镑。
        -> hisplay_begins

    *   (gloat) {gotTwentyOne} [ 得意一下 ]
        >>> AUDIO: V Chuckle 1
        V:  Carstairs 先生，您这下可惨了……
        CARSTAIRS:  是吗？
        -> hisplay_begins

    *   {gotTwentyOne} [ 不动声色 ]
        >>> AUDIO: V Clear Throat 1
        V:          那么，轮到您了。
        CARSTAIRS:  这么说您是停牌了，对吧？
        -> hisplay_begins

    +   {not gotTwentyOne} [ 要牌 twist ]
        { shuffle:
        -   V:  要牌。
        -   V:  再来一张。
        -   V:  再给我一张。
        -   V:  再来一张，正面朝上。
        }
        ~ temp newUpCard = addCard(myCards, true)

        CARSTAIRS:  {nameCard(newUpCard)}。

        V:  ……{sayTotalOfHand(myCards)}。 #thought
        -> myplay

    +   { (money - bet) >= 50 }  {not gotTwentyOne}
        [ 花 50 英镑买一张暗牌（buy） ]
        ~ bet += 50
        ~ temp newDownCard = addCard(myCards, false)
        {shuffle:
        -   V:  买牌。
        -   V:  我买一张。
        -   V:  再来一张，背面朝下。
        }
        {shuffle:
        -   CARSTAIRS:  注码现在是 {print_number(bet)}。
        -   CARSTAIRS:   底池里有 {print_number(bet)}。
        }

        { shuffle:
        -   VO:     Carstairs 又递给我一张牌，背面朝下。
        -   CARSTAIRS:   这是您要的牌。
        }

        V:  ……{nameCard(newDownCard)}。 #thought
        V:  ……{sayTotalOfHand(myCards)}。 #thought
        -> myplay

- (hisplay_begins)

    ~ faceUpCards += hisCards
    { shuffle:
    -   CARSTAIRS:  让我看看自己手里这些……
        CARSTAIRS:  {printHandDescriptively(hisCards, false)}。
    -   CARSTAIRS:  庄家这边……{printHandDescriptively(hisCards, false)}。
    }

    CARSTAIRS:  {sayTotalOfHand(hisCards)}。

- (hisplay_main)
    // AI 出牌

    ~ temp hes_scared = seen_more_recently_than(-> gloat, -> top_of_game)

    ~ temp hisTotal = minTotalOfHand(hisCards)

    { hisTotal > 21:
        { shuffle:
        -   CARSTAIRS:  我爆了！
        -   CARSTAIRS:  数字太大了！
        -   CARSTAIRS:  这把我没运气！
        }
        -> i_won
    }

    ~ temp hisMaxTotal = maxTotalOfHand(hisCards)

    ~ temp yourVisibleTotal = maxTotalOfHand(myCards ^ faceUpCards)
    ~ temp yourBestTotal = 21

    // 边缘情况：玩家手里是 ? - 3 - 5，最优组合便是 19 点。
    { LIST_COUNT(myCards - faceUpCards) == 1 && yourVisibleTotal < 10:
        ~ yourBestTotal = 11 + yourVisibleTotal
    }

    +   {hisMaxTotal > yourBestTotal || (hisMaxTotal == yourBestTotal && LIST_COUNT(myCards) < 5)} ->
        - - (he_sticks)
            CARSTAIRS:  庄家停牌，定在 {finalTotalOfHand(hisCards)}。
            -> hisplayover
    +   { hisMaxTotal >= 18 && !handContains(hisCards, Ace)}   -> he_sticks

    +   { hisTotal == 10 || hisTotal == 11 } -> he_twists

    +   { hisMaxTotal <= 15 || (hisMaxTotal <= 17 && handContains(hisCards, Ace)) || (hisMaxTotal <= 18 && hes_scared) } ->
        - - (he_twists)
            { shuffle:
            -   CARSTAIRS: 我再要一张。
            -    CARSTAIRS: 庄家要牌。
            -    CARSTAIRS: 再来一张……
            }

            ~ temp newHisCard = addCard(hisCards, true)
            CARSTAIRS:  {nameCard(newHisCard)}，{sayTotalOfHand(hisCards)}。
            -> hisplay_main

    +   {RANDOM(1, 3) == 1} ->
        -> he_sticks

    +   -> he_twists

- (hisplayover)

    ~ temp facedownCards = myCards - faceUpCards

- (dealoutcards)
    { pop(facedownCards):
        -> dealoutcards
    }


    ~ temp scoreDiff = maxTotalOfHand(myCards) - maxTotalOfHand(hisCards)
    { cycle:
    -   VO:     我把手里的牌摊开。
    -  VO:     我把牌{~翻|掀}{~过来|了个面}。
      -
    }

    { cycle:
    -   V:  我手上是{scoreDiff < 0:只有} {finalTotalOfHand(myCards)}{scoreDiff==0:<>，跟您一样}。
    -  V:      {finalTotalOfHand(myCards)}。
    }

    {
    - scoreDiff > 0 && maxTotalOfHand(myCards) < 21:
        {stopping:
        -   V:  我赢了？
        -   {cycle:
                - V:  我赢了。
                -
            }
        }
        -> i_won
    - scoreDiff < 0:
        CARSTAIRS:  庄家胜！
        -> i_lost
    - scoreDiff == 0:
        { LIST_COUNT(myCards) >= 5 && LIST_COUNT(hisCards) < 5:
            CARSTAIRS:  五张牌（five card trick）胜！
            -> i_won
        }
        CARSTAIRS:  平手。按规矩还是庄家拿走，抱歉了。
        -> i_lost
    }


- (i_won)
    ~ money += bet
    ~ CstrsBank -= bet

    VO:     我把桌上的钱收了回来。
    {
    - isPontoon(myCards):
        CARSTAIRS:  pontoon 牌型可是双倍。
        ~ money += bet
        ~ CstrsBank -= bet

        VO:     他又数出 {print_number(bet)} 英镑。
    - maxTotalOfHand(myCards) == 21 && LIST_COUNT(myCards) == 2:
        { once:
        -   CARSTAIRS:  不过这不算 pontoon，可惜了。
            CARSTAIRS:  得有一张人头牌（J/Q/K）才行。

        }
    }

    { shuffle:
    -   VO:     我现在手头有 {print_number(money)} 英镑了。
    -   V:      ……我现在手头有 {print_number(money)} 英镑了。
    }

    -> done

- (i_lost)

    ~ money -= bet
    ~ CstrsBank += bet
    VO:     Carstairs {~把|{~把|一把搂走}{~走|}}{~底池|赌注|{~从桌上|桌上的}钱}收走，顺手把牌也聚拢起来。
    { money < 50:
        V:  您把我掏空了！
        CARSTAIRS:  听到这话我很遗憾，Mrs V。
        CARSTAIRS:  谢您赏脸陪我玩这一局。


        VO:     他把赢来的钱塞进马甲口袋，咧嘴笑得像个傻子。
        -> finished
    }
    { money >= startingMoney:
        { shuffle:
        -   VO:     我手头还剩 {print_number(money)} 英镑。
        }
    - else:
        { shuffle:
        -   V:      ……我只剩 {print_number(money)} 英镑了…… #thought
        -   V:     ……还剩 {print_number(money)} 英镑……  #thought
        }
    }
    -> done

- (done)

    ~ temp wasPontoon = isPontoon(myCards)
    ~ myCards = ()

    { CstrsBank <= 50:
        CARSTAIRS:  好吧，Mrs Villensey，您把我口袋里的零花钱全赢光了！
        CARSTAIRS:  不得不说——比您先生当年的表现可强多了。
        -> finished
    }

    {
    - came_from(-> i_lost):
        {shuffle:
        -   CARSTAIRS:       够了没？
        -   CARSTAIRS:       继续？
        -   CARSTAIRS:       再来？
        }
    - came_from(-> i_won):
        { shuffle:
        -    CARSTAIRS:      再来一局？
        -    CARSTAIRS:      再来？
        -    CARSTAIRS:      再玩一把？
        }
    - else:
        { cycle:
        -   VO:     Carstairs {~在把牌码整齐|正一边把玩着}手里的{~牌|那副牌}。
        -   VO:     Carstairs 漫不经心地洗着牌。
            ~ shuffle()
        }
        { shuffle:
         -    CARSTAIRS:      我们还玩吗？
         -    CARSTAIRS:      Mrs Villensey，再来一手？
        }
    }

 - (replay_opts)

    +   [ 再玩一局 ]
        {
        - money >= 250:
            { shuffle:
            -   V:  来吧，发牌。

            -   V:  发牌。

            -   V:  再试一把。

            -   V:  再来！

            }
        - money >= 100:
            { shuffle:
            -   V:  我再玩一局。

            -   V:  我再玩一会儿。

            -   V:  我还没玩够。
            }
        -  money >= 70:
            { shuffle:
            -   V:  我还玩得起一局。
            -   V:  这一把可得走运点！
            }
        }
        -> top_of_game



    +   [ 不玩了 ]
        {shuffle:
        -   V:  晚点再说吧。
        -   V:  改天再玩。
        }

    - (finished)
        ~ myCards = ()

        ->->


/*------------------------------------------

    通用工具函数

    以下函数在 inky 0.12.0 及以上版本的 ink 代码片段菜单里都能找到现成版本。

------------------------------------------*/

/*
	判断当前回合是否经过了某个 gather。

	用法示例：

	- (welcome)
		"欢迎！"
	- (opts)
		*	{came_from(->welcome)}
			"欢迎光临！"
		*	"呃，什么？"
			-> opts
		*	"我们能继续吗？"

*/

=== function came_from(-> x)
    ~ return TURNS_SINCE(x) == 0

/*
	判断当前回合是否"最近"经过了某个 gather——即最近 3 个回合以内。

	用法示例：

	- (welcome)
		"欢迎！"
	- (opts)
		*	{seen_very_recently(->welcome)}
			"抱歉，您好，是的。"
		+	"呃，什么？"
			-> opts
		*	"我们能继续吗？"

*/

=== function seen_very_recently(-> x)
    ~ return TURNS_SINCE(x) >= 0 && TURNS_SINCE(x) <= 3

/*
	判断某个 divert 是否比另一个 divert 更晚被触达。

	如果从未触达第一个 divert，返回 false。
	如果从未触达第二个 divert，返回 true。

	这特别适合用来判断"这场戏里我们已经做过 X 吗"。

	用法示例：

	- (start_of_scene)
		"欢迎！"

	- (opts)
		<- cough_politely(-> opts)

		*	{ seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			"您好！"

		+	{ not seen_more_recently_than(-> cough_politely.cough, -> start_of_scene) }
			["您好！"]
			我想开口说话，可怎么也吐不出字！
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





/*
	从列表中取出底部（最小）元素，返回它并修改列表。

	若源列表为空，返回空列表 ()。

	用法示例：

	LIST fruitBowl = (apple), (banana), (melon)

	我吃了 {pop(fruitBowl)}。果盘里现在还有 {fruitBowl}。

*/

=== function pop(ref _list)
    ~ temp el = LIST_MIN(_list)
    ~ _list -= el
    ~ return el


/*
	从列表中随机取出一个元素，返回它并修改列表。

	若源列表为空，返回空列表 ()。

	用法示例：

	LIST fruitBowl = (apple), (banana), (melon)

	我吃了 {pop_random(fruitBowl)}。果盘里现在还有 {fruitBowl}。

*/

=== function pop_random(ref _list)
    ~ temp el = LIST_RANDOM(_list)
    ~ _list -= el
    ~ return el




/*
    将一个 -1,000,000,000 到 1,000,000,000 之间的整数转成中文数字写法。

    用法示例：

    天上有 {print_number(RANDOM(100000,10000000))} 颗星。

*/

=== function print_number(x)
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
                - 2: 二
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
