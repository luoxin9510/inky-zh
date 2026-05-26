// 原作：inkle Ltd.（出处：Writing with Ink 配套示例片段 uppercase.ink）
// 原文 SPDX：MIT
// 非官方简体中文翻译，归属同 MIT；译者：luoxin9510 (inky-zh fork)
// 译注：ink 关键字、EXTERNAL / function 名、参数名、C# 代码一律保留英文。本函数针对英文大小写转换，
//       中文无大小写区分；仅翻译说明性注释。

/*
	将文本转换为大写。没有 inky 内的回退实现。

	用法：

	"Give me wine. {UPPERCASE("Give me wine!")}

	所需 C# 代码：

	外部绑定如下：

		story.BindExternalFunction("UPPERCASE", (string txt) =>
	    {
	        return txt.ToUpper();
	    });

*/

EXTERNAL UPPERCASE(txt)
=== function UPPERCASE(txt)
    {txt}
