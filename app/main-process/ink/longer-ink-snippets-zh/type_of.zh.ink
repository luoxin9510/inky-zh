// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 type_of.ink，作者 @IFcoltransG）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / function 名、参数名、LIST 条目名一律保留英文；仅翻译说明性注释。

/*
	判断一个通用 ink 变量的类型。作者：inkle Discord 上的 @IFcoltransG。


	用法：

	VAR x = "Hello!"
	VAR y = 14
	LIST z = (Hat), (Coat)

	{type_of(x) == Number:
		这是一个数字，所以可以放心地除以 2。
		{x / 2}
	}


*/


LIST Type = List, String, Number, Bool
=== function type_of(val)
    {"{val + val}":
        - "{val}{val}":
            {val ? val:
                ~ return String
            - else:
                ~ return List // empty
            }

        - "{val}":
            { "{val}" == "0":
                ~ return Number // zero
            - else:
                ~ return List
            }

        - else:
            {"{not not val}" == "{val}":
                ~ return Bool
            }
            ~ return Number
    }