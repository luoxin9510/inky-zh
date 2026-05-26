// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 a_or_an.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、VAR / function 名、参数名一律保留英文。本函数处理英文不定冠词 a/an 的选择，
//       中文无对应语法，故函数内的 "a {x}"、"an {x}" 仍保持英文输出，仅翻译说明性注释。

/*
    在名词前打印出正确形式的英文不定冠词。

    用法：

    VAR firstAnimal = "cat"
    VAR secondAnimal = "elephant"
    VAR thirdAnimal = "elongated badger"
    I put {a(firstAnimal)} and {a(secondAnimal)} into {a("{~old|nice} box")} with {a(thirdAnimal)}.



*/


=== function a(x)
    ~ temp stringWithStartMarker = "^" + x
    { stringWithStartMarker ? "^a" or stringWithStartMarker ? "^A" or stringWithStartMarker ? "^e" or  stringWithStartMarker ? "^E"  or stringWithStartMarker ? "^i" or stringWithStartMarker ? "^I"  or stringWithStartMarker ? "^o" or stringWithStartMarker ? "^O" or stringWithStartMarker ? "^u"  or stringWithStartMarker ? "^U"  :
            an {x}

    // 如果想得到 "an historic..." 这种效果，可以再扩展检查 "^hi"
    - else:
        a {x}
    }