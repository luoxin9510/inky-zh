// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 string_to_list.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、LIST / EXTERNAL / function 名、参数名、C# 代码一律保留英文；仅翻译说明性注释。


/*
	将字符串转换为某个特定 list 内对应的 list 元素。注意：该元素此时不必处在 list 变量中！

	这在从游戏向 ink 传参时很有用：游戏可以保存并以字符串 ID 的形式传入 list 元素。

	若找不到该元素，则返回空 list ()。

	用法：

	LIST capitalCities = Paris, London, NewYork

	~ temp thisCity = string_to_list("Paris", capitalCities)
	~ capitalCities += thisCity
	I've now visited {thisCity}.

	优化：

	下面这段代码在 inky 中可以工作，但可以在游戏中以下列 C# 外部函数绑定的方式外置，以提升性能：

	story.BindExternalFunction("STRING_TO_LIST", (string itemKey) => {
        try
        {
            return InkList.FromString(itemKey, story);
        }
        catch
        {
            return new InkList();
        }
    }, true);

*/

=== function string_to_list(stringElement, listSource)
    ~ temp retVal = STRING_TO_LIST(stringElement)
    { USED_STRING_TO_LIST_FALLBACK:
    	~ retVal = stringAsPickedFromList(stringElement, LIST_ALL(listSource) )
    }
     ~ return retVal


EXTERNAL STRING_TO_LIST(stringElement)
=== function STRING_TO_LIST(stringElement)
    ~ return USED_STRING_TO_LIST_FALLBACK()

=== function USED_STRING_TO_LIST_FALLBACK()
	// 这个桩函数用于检测游戏是否没有提供外部函数实现
    ~ return

// 兜底机制：递归遍历 listToTry，对元素名做字符串匹配
=== function stringAsPickedFromList(stringElement, listToTry)
    ~ temp minElement = LIST_MIN(listToTry)
    {minElement:
        { stringElement == "{minElement}":
            ~ return minElement
        }
        ~ return stringAsPickedFromList(stringElement, listToTry - minElement)
    }
    ~ return ()