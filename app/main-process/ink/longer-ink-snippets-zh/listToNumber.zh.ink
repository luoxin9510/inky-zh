// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 listToNumber.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、VAR / LIST / CONST / function 名、knot 名、divert 目标一律保留英文；仅翻译叙事文本与作者注释。

/*

    一套为 list 条目分配、读取与修改整数值的系统。

    这意味着你可以为运行时的事物分配可变的数值，例如给某件库存物品赋予数量，或给玩家的某项属性赋予数值。

*/


LIST Wallet = Coins, Notes, Cards

~ _setValueOfState(Coins, 3) // 玩家持有 3 枚硬币
~ _setValueOfState(Cards, 2) // 玩家持有 2 张卡片

我现在有 {_getValueOfState(Coins)} 枚硬币和 {_getValueOfState(Cards)} 张卡片。

~ _alterValueForState(Coins, 10)

现在我有 {_getValueOfState(Coins)} 枚。

~ _alterValueForState(Cards, 30)
~ _alterValueForState(Cards, -60)

现在我有 {_getValueOfState(Cards)} 张。哎呀！

-> END



// 1) 存储空间
VAR StatesNegative = () // 记录哪些 state 当前持有负值
VAR StatesBinary1 = ()
VAR StatesBinary2 = ()
VAR StatesBinary4 = ()
VAR StatesBinary8 = ()
VAR StatesBinary16 = ()
VAR StatesBinary32 = ()
VAR StatesBinary64 = ()
VAR StatesBinary128 = ()
VAR StatesBinary256 = ()
VAR StatesBinary512 = ()
VAR StatesBinary1024 = ()
VAR StatesBinary2048 = ()   // 可存储到 4095；如需更大范围，继续追加 state 即可
// --> 在此追加更多存储位

CONST MAX_BINARY_BIT = 2048

VAR StatesInStorage = ()


// 2) 读取被查询 state 的值


=== function _getValueOfState(id) // 始终对单个条目操作
    // 采用笨拙的逐位写法，而非花哨的循环
    ~ temp value = 0
    ~ value += (StatesBinary1 ? id) * 1
    ~ value += (StatesBinary2 ? id) * 2
    ~ value += (StatesBinary4 ? id) * 4
    ~ value += (StatesBinary8 ? id) * 8
    ~ value += (StatesBinary16 ? id) * 16
    ~ value += (StatesBinary32 ? id) * 32
    ~ value += (StatesBinary64 ? id) * 64
    ~ value += (StatesBinary128 ? id) * 128
    ~ value += (StatesBinary256 ? id) * 256
    ~ value += (StatesBinary512 ? id) * 512
    ~ value += (StatesBinary1024 ? id) * 1024
    ~ value += (StatesBinary2048 ? id) * 2048
// --> 在此追加更多存储位
    { StatesNegative ? id:
            ~ value = value * -1
    }
    ~ return value


// 3) 设置被赋值 state 的数值

=== function _setValueOfState(state, value) // 始终对单个条目操作
    { value >= 2 * MAX_BINARY_BIT || value <= -2 * MAX_BINARY_BIT:
        [ ERROR - 试图为 {state} 存入 {value}，但该值超出了预留的存储空间。请调高 {MAX_BINARY_BIT} 并增加额外的存储位。 ]
    }
    ~ temp currentValue = _getValueOfState(state)
    { currentValue != 0 && currentValue != value:
         ~ _removeValuesForState(state)
    }
    { value != 0:
        ~ StatesInStorage += state
        { value < 0:
            ~ StatesNegative += state
            ~ value = -1 * value         // 以正数形式存储该值
        - else:
            ~ StatesNegative -= state
        }
        ~ _setBinaryValuesForState(state, value, MAX_BINARY_BIT )
    }
    // 如需测试日志，请取消下行注释
    // [ {value} - 已将 {state} 的值设为 {getValueOfState(state) } ]


=== function _setBinaryValuesForState(id, value, binaryValue)
    { value >= binaryValue:
        ~ value -= binaryValue
        {binaryValue:
        -  1:   ~ StatesBinary1 += id
        -  2:   ~ StatesBinary2 += id
        -  4:   ~ StatesBinary4 += id
        -  8:   ~ StatesBinary8 += id
        -  16:   ~ StatesBinary16 += id
        -  32:   ~ StatesBinary32 += id
        -  64:   ~ StatesBinary64 += id
        -  128:   ~ StatesBinary128 += id
        -  256:   ~ StatesBinary256 += id
        -  512:   ~ StatesBinary512 += id
        -  1024:   ~ StatesBinary1024 += id
        -  2048:   ~ StatesBinary2048 += id
        }
// --> 在此追加更多存储行
    }
    { binaryValue > 1:
        ~ _setBinaryValuesForState(id, value, binaryValue / 2)
    }


// 3) 清除

=== function _removeValuesForState(state)
    ~ StatesInStorage -= state
    ~ StatesNegative -= state
    ~ StatesBinary1 -= state
    ~ StatesBinary2 -= state
    ~ StatesBinary4 -= state
    ~ StatesBinary8 -= state
    ~ StatesBinary16 -= state
    ~ StatesBinary32 -= state
    ~ StatesBinary64 -= state
    ~ StatesBinary128 -= state
    ~ StatesBinary256 -= state
    ~ StatesBinary512 -= state
    ~ StatesBinary1024 -= state
    ~ StatesBinary2048 -= state

// 4) 修改某个 state 的数值

=== function _alterValueForState(state, delta)
    ~ _setValueOfState(state, _getValueOfState(state) + delta)
