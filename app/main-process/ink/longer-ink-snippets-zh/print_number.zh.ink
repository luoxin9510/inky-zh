// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 print_number.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、function 名、参数名一律保留英文。本函数原版输出英文数词（one、twenty、hundred 等），
//       本译本改为输出中文数词（一、两、十、百、千、百万），并删去英文里的连字符与 "and" 连接词。
//       同一函数在 swindlestones.zh.ink / pontoon_example.zh.ink 内嵌的版本与此一致。

/*
    将一个介于 -1,000,000,000 与 1,000,000,000 之间的数字转换为其打印（整数）形式。

    用法：

    There are {print_number(RANDOM(100000,10000000))} stars in the sky.

    Pi is roughly {print_number(3.1417)}.

*/

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
