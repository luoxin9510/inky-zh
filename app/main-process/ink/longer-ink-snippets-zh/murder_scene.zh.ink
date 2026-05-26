// 原作：inkle Ltd.（出处：Writing with Ink —— Lists 一章的犯罪现场示例）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、变量名、knot 名、divert 目标、人名一律保留英文；
//       仅翻译叙事文本与作者注释。详见 docs/translation-glossary.md。

/*

    这是一个较长的犯罪现场调查示例，出自《Writing with Ink》中关于 List 的一章。

*/

-> murder_scene

// 辅助函数：从列表中弹出（pop）首个元素
=== function pop(ref list)
   ~ temp x = LIST_MIN(list)
   ~ list -= x
   ~ return x

//
//  系统：物品可以处于不同状态
//  有些状态通用，有些只对应特定物品
//

LIST OffOn = off, on
LIST SeenUnseen = unseen, seen

LIST GlassState = (none), steamed, steam_gone
LIST BedState = (made_up), covers_shifted, covers_off, bloodstain_visible

//
// 系统：物品栏（inventory）
//

LIST Inventory = (none), cane, knife

=== function get(x)
    ~ Inventory += x

//
// 系统：物品的摆放位置
// 物品可以摆"在……上面"或"放在……里"
//

LIST Supporters = on_desk, on_floor, on_bed, under_bed, held, with_joe

=== function move_to_supporter(ref item_state, new_supporter) ===
    ~ item_state -= LIST_ALL(Supporters)
    ~ item_state += new_supporter


// 系统：渐进式的知识链。
// 每个列表是一条事实链，链上后一条事实会取代前一条。
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
      ~ reach (statesToSet)     // 把其他还没设的状态也设上
      ~ return true            // 这个状态确实被设上了，返回 true

    - else:
      ~ return false || reach(statesToSet)
    }

//
// 初始化游戏
//

VAR bedroomLightState = (off, on_desk)

VAR knifeState = (under_bed)


//
// 知识链定义
//


LIST BedKnowledge = neatly_made, crumpled_duvet, hastily_remade, body_on_bed, murdered_in_bed, murdered_while_asleep

LIST KnifeKnowledge = prints_on_knife, joe_seen_prints_on_knife,joe_wants_better_prints, joe_got_better_prints

LIST WindowKnowledge = steam_on_glass, fingerprints_on_glass, fingerprints_on_glass_match_knife


//
// 剧情内容
//

=== murder_scene ===
    卧室。事情就发生在这里。现在该找找线索了。
- (top)
    { bedroomLightState ? seen:     <- seen_light  }
    <- compare_prints(-> top)

    *   (dobed) [床……]
        床身离地不高，但也没有低到东西滚不进去底下。床还是整整齐齐铺好的。
        ~ reach (neatly_made)
        - - (bedhub)
        * *     [掀开床罩]
                我把床罩往后掀开。底下的羽绒被皱巴巴的。
                ~ reach (crumpled_duvet)
                ~ BedState = covers_shifted
        * *     (uncover) {reached(crumpled_duvet)}
                [把床罩完全揭掉]
                我小心翼翼，没动到底下任何东西，把床罩整张揭了下来。下面的羽绒被一团乱。
                绝不是那位讲究分寸的女佣留下的样子。这分明是有人匆匆忙忙重新铺过。
                ~ reach (hastily_remade)
                ~ BedState = covers_off
        * *     (duvet) {BedState == covers_off} [ 掀开羽绒被 ]
                我把羽绒被掀开。底下是一张床单，上面的血迹粘稠未干。
                ~ BedState = bloodstain_visible
                ~ reach (body_on_bed)
                要么尸体是先被搬到这里、再被拖到地上的——要么这里就是凶案发生的地方。
        * *     {BedState !? made_up} [ 把床重新铺好 ]
                我小心把床单铺回原样，努力让它看起来没被动过。
                ~ BedState = made_up
        * *     [试试这张床]
                我手指张开按了按床。它吱呀了一下，但还不至于难听刺耳。
        * *     (darkunder) [看看床底下]
                我趴下身，往床底下瞅，但什么也看不清。

        * *     {TURNS_SINCE(-> dobed) > 1} [换点别的看看？]
                我从床边退开一步，环顾四周。
                -> top
        - -     -> bedhub

    *   {darkunder && bedroomLightState ? on_floor && bedroomLightState ? on}
        [ 看床底下 ]
        我往床底下窥过去。有个东西反光闪了一下。
        - - (reaching)
        * *     [ 伸手去拿 ]
                我把一条胳膊伸进床底，但那东西不知被踢到了多深处，指尖怎么也够不到。
                -> reaching
        * *     {Inventory ? cane} [用手杖把它拨过来]
                -> knock_with_cane

        * *     {reaching > 1 } [ 站起身 ]
                我重新站起身，把外套上的灰拍了拍。
                -> top

    *   (knock_with_cane) {reaching && TURNS_SINCE(-> reaching) >= 4 &&  Inventory ? cane } [用手杖去够床底]
        我把手杖伸到地毯上方，对那个反光的东西啪地敲了一下。它从床尾下方滑了出来。
        ~ move_to_supporter( knifeState, on_floor )
        * *     (standup) [站起来]
                满意了，我站起身，发现自己居然敲出来一把带血的刀。
                -> top

        * *     [再往床底看一眼]
                我把手杖挪开，又往床底看了一眼，但里面什么也没有了。
                -> standup

    *   {knifeState ? on_floor} [捡起那把刀]
        我小心避开刀柄，把刀刃从地毯上拎了起来。
        ~ get(knife)

    *   {Inventory ? knife} [仔细看看这把刀]
        血干得差不多了。干到刚好能让刀柄上那几个不完整的指纹显出来！
        ~ reach (prints_on_knife)

    *   [   书桌……]
        我把注意力转向书桌。一盏台灯摆在一角，另一角是一只整齐空着的待办收件盒。桌上没有别的东西摊开。
        靠在桌边的，是一根木手杖。
        ~ bedroomLightState += seen

        - - (deskstate)
        * *     (pickup_cane) {Inventory !? cane}  [捡起手杖 ]
                ~ get(cane)
              我把那根木手杖拿起来。沉甸甸的，上面没有任何记号。

        * *    { bedroomLightState !? on } [打开台灯]
                -> operate_lamp ->

        * *     [看看收件盒 ]
                我打量着收件盒，里面空无一物。要么死者的文件被人拿走了，要么他这一行最近接不到什么活——又或者，这只收件盒本来就只是摆给人看的。

        + +     (open)  {open < 3} [试着拉开抽屉]
                我{随手拉了一格抽屉|又拉了一格|拉了第三格}。{锁着的|这格也是锁着的|不出所料，也锁着}。

        * *     {deskstate >= 2} [换点别的看看？]
                我又一次从桌边退开。
                -> top

        - -     -> deskstate

    *     {(Inventory ? cane) && TURNS_SINCE(-> deskstate) <= 2} [挥一挥手杖]
        我手里还握着那根手杖：我试着挥了一下。确实沉，但也没沉到能当钝器砸人的地步。
        但用来自卫倒挺称手。死者怎么没去拿它？怎么没把它碰倒？

    *   [窗户……]
        我走到窗边往外看。下面是房子侧旁那条阴郁小溪的乏味景致。

        - - (window_opts)
        <- compare_prints(-> window_opts)
        * *     (downy) [往下看那条小溪]
                { GlassState ? steamed:
                    隔着雾气蒙蒙的玻璃，我看不见小溪。-> see_prints_on_glass -> window_opts
                }
                我盯着那条小溪奔流了一阵。这房子大概有潮气，除此之外，看不出别的什么。
        * *     (greasy) [盯着玻璃]
                { GlassState ? steamed: -> downy }
                窗玻璃油腻腻的。里里外外都好一阵子没人擦过了。
        * *     { GlassState ? steamed && not see_prints_on_glass && downy && greasy }
                [ 看看玻璃上的雾气 ]
                外面是个冷天。哈出来的气会在玻璃上凝出雾，再正常不过。 -> see_prints_on_glass ->
        + +     {GlassState ? steam_gone} [ 朝玻璃哈一口气 ]
                我又轻轻地朝玻璃哈了一口气。{ reached (fingerprints_on_glass): 那几枚指纹重新浮了出来。}
                ~ GlassState = steamed

        + +     [换点别的看看？]
                { window_opts < 2 || reached (fingerprints_on_glass) || GlassState ? steamed:
                    我把目光从这块乏味的玻璃上移开。
                    {GlassState ? steamed:
                        ~ GlassState = steam_gone
                        <> 哈出的雾气渐渐散了。
                    }
                    -> top
                }
                我从玻璃边往后靠了靠。哈出的气把窗格薄薄地蒙了一层雾。
               ~ GlassState = steamed

        - -     -> window_opts

    *   {top >= 5} [离开这个房间]
        我看够了。我{bedroomLightState ? on:把台灯关掉，}转身走出了房间。
        -> joe_in_hall

    -   -> top


= operate_lamp
    我按了按灯的开关。
    { bedroomLightState ? on:
        <> 灯泡暗了下去。
        ~ bedroomLightState += off
        ~ bedroomLightState -= on
    - else:
        { bedroomLightState ? on_floor: <> 床底下漏进了一点光。} { bedroomLightState ? on_desk : <> 灯光在打磨光亮的桌面上闪了闪。 }
        ~ bedroomLightState -= off
        ~ bedroomLightState += on
    }
    ->->


= compare_prints (-> backto)
    *   { between ((fingerprints_on_glass, prints_on_knife),     fingerprints_on_glass_match_knife) }
[比对刀上和窗上的指纹 ]
        我把那把带血的刀凑到窗边，又朝玻璃哈了一口气，让指纹重新显现，然后尽我所能比对了一番。
        谈不上科学，但它们看起来很像——非常像。
        ~ reach (fingerprints_on_glass_match_knife)
        -> backto

= see_prints_on_glass
    ~ reach (fingerprints_on_glass)
    {但我能看见几枚指纹，像是有人把手掌按在过上面。|那几枚指纹清晰、轮廓完整。} 我盯着看的工夫，它们渐渐淡了下去。
    ~ GlassState = steam_gone
    ->->

= seen_light
    *   {bedroomLightState !? on} [ 打开台灯 ]
        -> operate_lamp ->

    *   { bedroomLightState !? on_bed  && BedState ? bloodstain_visible }
        [ 把灯挪到床边 ]
        ~ move_to_supporter(bedroomLightState, on_bed)

        我把灯挪到血迹上方，凑近细看。血已经深深渗进棉布床单的纤维里。
        这一点毫无疑问。这里就是下手的位置。
        ~ reach (murdered_in_bed)

    *   { bedroomLightState !? on_desk } {TURNS_SINCE(-> floorit) >= 2 }
        [ 把灯放回书桌上 ]
        ~ move_to_supporter(bedroomLightState, on_desk)
        我把灯端回桌上，放回它原来的位置。
    *   (floorit) { bedroomLightState !? on_floor && darkunder }
        [把灯放到地上 ]
        ~ move_to_supporter(bedroomLightState, on_floor)
        我把灯端起来，放在地上。
    -   -> top

=== joe_in_hall
    我那位警局里的熟人 Joe 正等在过道里。"怎么样？"他催问道。"找到什么有意思的东西没有？"
- (found)
    *   {found == 1} "没什么。"
        他耸了耸肩。"可惜。"
        -> done
    *   { Inventory ? knife } "我找到了凶器。"
        "干得漂亮！"Joe 咧嘴一笑。"我们还以为凶手已经把它处理掉了呢。我这就替你装袋。"
        ~ move_to_supporter(knifeState, with_joe)

    *   {reached(prints_on_knife)} { knifeState ? with_joe }
        "刀身上有指纹[。"],"我对他说。
        他仔细审视了一番。
        "嗯。不太完整。靠这些做指纹比对会很吃力。"
        ~ reach (joe_seen_prints_on_knife)
    *   { reached((fingerprints_on_glass_match_knife, joe_seen_prints_on_knife)) }
        "窗户上也有一组指纹，跟刀上这组对得上。"
        "谁都可能碰过窗户，"Joe 若有所思地回了一句。"不过如果窗上那组更完整，对我们做比对应该会有帮助！"
        ~ reach (joe_wants_better_prints)
    *   { between(body_on_bed, murdered_in_bed)}
        "尸体一度被搬到了床上[。"],"我告诉他。"之后又被搬回了地上。"
        "为什么？"
        * *     "我不知道。"
                Joe 点点头。"好吧。"
        * *     "也许是为了从地上拿什么东西？"
                "为这种事不会把整具尸体搬走的。"
        * *     "也许他是死在床上的。"
                "目前都还只是猜测，"Joe 说。
    *   { reached(murdered_in_bed) }
        "死者是在床上被杀的，之后尸体被搬到了地上。"
        "为什么？"
        * *     "我不知道。"
                Joe 点点头。"那好。"
        * *     "也许凶手想误导我们。"
                "怎么个误导法？"
            * * *   "他们想让我们以为死者当时是醒着的[。"]，"我若有所思地回答。"以为死者是在和凶手照面，而不是在睡梦中被刺死的。"
            * * *   "他们想让我们以为现场曾发生过某种搏斗[。"]，"我回答。"想让我们觉得死者不是单纯地在睡梦中被一刀刺死。"
            - - -   "可如果他确实是死在床上，那最大可能就是这个：睡着的时候被一刀刺死。"
                    ~ reach (murdered_while_asleep)
        * *     "也许凶手原想清理一下现场。"
                "但被人撞见了，没来得及？这有可能。"

    *   { found > 1} "就这些。"
        "行。这是个开头，"Joe 答道。
        -> done
    -   -> found
-   (done)
    {
    - between(joe_wants_better_prints, joe_got_better_prints):
        ~ reach (joe_got_better_prints)
        <> "我这就去把窗上那组指纹弄过来。"
    - reached(joe_seen_prints_on_knife):
        <> "这组指纹我尽力跑一下比对。"
    - else:
        <> "线索不够多。"
    }
    -> END

