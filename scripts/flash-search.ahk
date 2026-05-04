#Requires AutoHotkey v2.0
#SingleInstance Force

global g_LinkPanel := 0

!y::
{
    static CLIPBOARD_TIMEOUT := 0.3

    local clipboardBackup := ClipboardAll()

    A_Clipboard := ""
    Send "^c"

    local hasSelection := ClipWait(CLIPBOARD_TIMEOUT)

    if (!hasSelection)
    {
        A_Clipboard := clipboardBackup
        local clipText := A_Clipboard
        if (clipText != "")
        {
            HandleSearch(clipText)
        }
    }
    else
    {
        local selectedText := A_Clipboard
        A_Clipboard := clipboardBackup
        if (selectedText != "")
        {
            HandleSearch(selectedText)
        }
    }
}

HandleSearch(text)
{
    text := Trim(text, "`r`n` t")

    if (text = "")
        return

    local result := ExtractLinks(text)
    local links := result[1]
    local remaining := result[2]

    if (links.Length = 0)
    {
        SearchInBrowser(text)
        return
    }

    if (links.Length = 1)
    {
        OpenUrl(links[1])
        if (remaining != "" && IsChineseText(remaining))
        {
            SearchInBrowser(remaining)
        }
        return
    }

    ShowLinkPanel(links, remaining)
}

IsChineseText(text)
{
    loop parse text
    {
        local code := Ord(A_LoopField)
        if (code >= 0x4E00 && code <= 0x9FFF)
            return true
    }
    return false
}

ExtractLinks(text)
{
    local links := []
    local pos := 1

    static URL_PATTERN := "https?://[a-zA-Z0-9\-._~%:\/?#\[\]@!&$'()*+,;=_]+"

    while (pos := RegExMatch(text, URL_PATTERN, &match, pos))
    {
        local url := match[0]

        url := TrimTrailingPunct(url)

        if (url != "" && IsValidUrl(url))
        {
            links.Push(url)
        }

        pos += match.Len[0]
    }

    local remaining := ""
    if (pos <= StrLen(text))
    {
        remaining := SubStr(text, pos)
    }

    return [links, Trim(remaining, "`r`n` t")]
}

TrimTrailingPunct(url)
{
    local quote := Chr(34)
    local punct := ".,;:!?" quote . "' "
    loop
    {
        local lastChar := SubStr(url, -1)
        if (!InStr(punct, lastChar))
            return url
        local newLen := StrLen(url) - 1
        if (newLen <= 0)
            return url
        url := SubStr(url, 1, newLen)
    }
}

IsValidUrl(url)
{
    if (!InStr(url, "://"))
        return false

    local domainPart := SubStr(url, InStr(url, "://") + 3)

    if (domainPart = "")
        return false

    local portPos := InStr(domainPart, ":")
    local pathPos := InStr(domainPart, "/")
    local queryPos := InStr(domainPart, "?")

    local endPos := StrLen(domainPart) + 1
    if (portPos > 0 && portPos < endPos)
        endPos := portPos
    if (pathPos > 0 && pathPos < endPos)
        endPos := pathPos
    if (queryPos > 0 && queryPos < endPos)
        endPos := queryPos

    domainPart := SubStr(domainPart, 1, endPos - 1)

    if (domainPart = "")
        return false

    if (RegExMatch(domainPart, "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"))
        return true

    if (!InStr(domainPart, "."))
        return false

    return true
}

ShowLinkPanel(links, remaining := "")
{
    global g_LinkPanel

    if (g_LinkPanel != 0 && WinExist(g_LinkPanel))
    {
        g_LinkPanel.Destroy()
        g_LinkPanel := 0
    }

    local panel := Gui("+AlwaysOnTop +ToolWindow +Resize +MinSize400x100")
    panel.SetFont("s10", "Segoe UI")
    panel.Title := "选择链接"

    local infoText := "发现 " . links.Length . " 个链接，点击打开："
    if (remaining != "" && IsChineseText(remaining))
    {
        infoText .= "`n剩余文本将搜索: " . SubStr(remaining, 1, 20)
    }
    panel.AddText("w400 cBlue", infoText)

    for index, url in links
    {
        local displayText := GetDisplayUrl(url, 70)
        local btn := panel.AddButton("w400 h28", displayText)
        btn.OnEvent("Click", OpenLinkHandler.Bind(url))
    }

    local closeBtn := panel.AddButton("w400 h28", "关闭")
    closeBtn.OnEvent("Click", ClosePanelHandler)

    panel.OnEvent("Close", ClosePanelHandler)

    g_LinkPanel := panel
    panel.Show("Center AutoSize")
}

GetDisplayUrl(url, maxLen)
{
    if (StrLen(url) <= maxLen)
        return url

    local headLen := Integer(maxLen * 0.6)
    local tailLen := maxLen - headLen - 3

    return SubStr(url, 1, headLen) . "..." . SubStr(url, -tailLen)
}

OpenLinkHandler(url, *)
{
    OpenUrl(url)
}

ClosePanelHandler(*)
{
    global g_LinkPanel
    if (g_LinkPanel != 0)
    {
        g_LinkPanel.Destroy()
        g_LinkPanel := 0
    }
}

OpenUrl(url)
{
    try
    {
        Run(url)
    }
    catch Error as e
    {
        MsgBox("无法打开链接：`n" . url . "`n`n错误：" . e.Message, "错误", "Icon!")
    }
}

SearchInBrowser(query)
{
    if (query = "")
        return

    local encodedQuery := UriEncode(query)
    local searchUrl := "https://www.bing.com/search?q=" . encodedQuery

    try
    {
        Run(searchUrl)
    }
    catch Error as e
    {
        MsgBox("无法执行搜索：`n" . e.Message, "错误", "Icon!")
    }
}

UriEncode(str)
{
    local out := ""
    local hex := "0123456789ABCDEF"

    loop parse str
    {
        local ch := A_LoopField
        local code := Ord(ch)

        if (IsUnreservedChar(code))
        {
            out .= ch
        }
        else
        {
            out .= EncodeCharToUtf8Hex(ch, hex)
        }
    }

    return out
}

EncodeCharToUtf8Hex(ch, hex)
{
    local result := ""

    local size := StrPut(ch, "UTF-8")
    local buf := Buffer(size)
    StrPut(ch, buf, "UTF-8")

    loop size - 1
    {
        local b := NumGet(buf, A_Index - 1, "UChar")
        result .= "%" . SubStr(hex, (b >> 4) + 1, 1) . SubStr(hex, (b & 15) + 1, 1)
    }

    return result
}

IsUnreservedChar(code)
{
    return (code >= 65 && code <= 90)
        || (code >= 97 && code <= 122)
        || (code >= 48 && code <= 57)
        || code = 45
        || code = 95
        || code = 46
        || code = 126
}
