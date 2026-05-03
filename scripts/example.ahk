#SingleInstance force
#Hotstring *

today := A_YYYY "-" A_MM "-" A_DD
time := A_Hour ":" A_Min ":" A_Sec
datetime := A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec

::/date::%today%
::/time::%time%
::/datetime::%datetime%
::/now::%A_Now%

::/today::%A_YYYY%年%A_MM%月%A_DD%日
::/weekday::%A_Dow%
::/weeknum::第 %A_YWeek% 周

::/today-cn::
{
    FormatTime, output, %A_Now%, yyyy年MM月dd日
    Send %output%
}

::/datetime-cn::
{
    FormatTime, output, %A_Now%, yyyy年MM月dd日 HH:mm:ss
    Send %output%
}

::/weekday-cn::
{
    weekdays := ["周日","周一","周二","周三","周四","周五","周六"]
    Send % weekdays[A_YDay // 7 + 1]
}

::/timestamp::
{
    Send %A_TickCount%
}

::/calc::
{
    InputBox, expr, 计算器, 请输入表达式（如 2+3*4）
    if ErrorLevel != 1 {
        try {
            result := %expr%
            if (result != "") {
                Send %result%
                Clipboard := result
            }
        }
    }
}

^!c::
{
    InputBox, days, 日期计算, 请输入天数（如 7 或 -3）
    if ErrorLevel != 1 {
        EnvAdd, today, %days%, Days
        FormatTime, output, %today%, yyyy-MM-dd
        Send %output%
    }
}

^!d::
{
    today := A_Now
    InputBox, other, 日期差, 请输入另一个日期（格式 YYYYMMDDHH24MISS）`n或留空计算与今天的天数差
    if ErrorLevel != 1 {
        if (other = "") {
            other := A_Now
        }
        EnvSub, today, %other%, Days
        SendInput %today% 天
    }
}

::/mail::
{
    Send jliu@example.com
}

::/addr::
{
    Send 北京市朝阳区某某路100号
}

::/sig::
{
    Send --
    Send 金柳
    Send 2026-05-03
}

::/todo::
{
    Send [ ] 待办事项
}

::/done::
{
    Send [x] 已完成
}

::/link::
{
    Send [链接描述](https://)
}

::/code::
{
    Send ``code``
    SendInput {Left 6}
}

::/bold::
{
    Send **文字**
    SendInput {Left 5}
}

::/table::
{
    Send | 列1 | 列2 | 列3 |
    SendInput `n| --- | --- | --- |
    SendInput `n|    |    |    |
}

::/sql-sel::
{
    Send SELECT * FROM table_name WHERE condition;
    SendInput {Left 12}
}

::/sql-ins::
{
    Send INSERT INTO table_name (col1, col2) VALUES ('val1', 'val2');
}

::/py-fn::
{
    Send def function_name(args):
    SendInput `n    """docstring"""
    SendInput `n    pass
    SendInput `{Left 4}
}

::/js-fn::
{
    Send const functionName = (args) => {
    SendInput `n  // TODO
    SendInput `n};
    SendInput {Up}{End}{Left 2}
}

::/lua-fn::
{
    Send local function funcName(args)
    SendInput `n    -- TODO
    SendInput `nend
    SendInput {Up}{End}{Left 4}
}

#IfWinActive ahk_exe Code.exe
::/func::
{
    Send function %A_Space%%A_Space%()
    SendInput `{Left 2}
}
::/main::
{
    Send local function main()
    SendInput `n    -- TODO
    SendInput `nend`n`nmain()
}
#IfWinActive

#IfWinActive ahk_exe WINWORD.EXE
::/title::
{
    SendInput {End}{Enter}
}
#IfWinActive

^!s::
{
    MsgBox 文本扩展器已就绪`n`n日期/时间: /date /time /datetime`n计算: /calc`n常用: /mail /sig /todo
}
