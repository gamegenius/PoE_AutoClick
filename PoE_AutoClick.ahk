;----------Globel Set----------
SendMode Event
SetWorkingDir, %A_ScriptDir%
global Stats := []
global select_point := ""
loop, Read, stats.txt
{
    Stats.Push(A_LoopReadLine)
}
StartProgram() 
;----------Main Window----------
;----------Main Window GUI Create----------
Gui, Main:New, , PoE_AutoClick
Gui, Main:add, Tab3, w320 h480, General|Position Settings

;----------Main Window Tab 1 Variables----------
Currency_List = 混沌石|富豪石|崇高石|工匠石|幻色石|後悔石|改造石|機會石|無效石|祝福石|神聖石|重鑄石|鏈結石|點金石|瓦爾寶珠|自定義
;Currency_List = Chaos|Regal|Exalted|Jewellers|Chrome|Regret|Alt|Chance|Annul|Blessed|Divine|Scour|Fusing|Alch|Vaal|Custom
;----------Main Window Tab 1 GUI----------
Gui, Main:Tab, 1
;Column 1
Gui, Main:add, CheckBox, x30 y40 gEnable_Currency_1 vEnable_Currency_1, 第一種通貨:
Gui, Main:add, CheckBox, x30 y70 gEnable_Currency_2 vEnable_Currency_2, 第二種通貨:
Gui, Main:add, CheckBox, x30 y100 gEnable_Currency_3 vEnable_Currency_3, 第三種通貨:
Gui, Main:add, CheckBox, x30 y130 gEnable_Currency_4 vEnable_Currency_4, 第四種通貨:
Gui, Main:add, CheckBox, x30 y160 gEnable_Check_Modifier vEnable_Check_Modifier, 檢查詞綴:
Gui, Main:add, text, x30 y190 h12, 自動點擊次數:
Gui, Main:add, text, x30 y220, (0為無限)
;Column 2
Gui, Main:Add, DropDownList, x120 y37 w160 Disabled vCurrency_Select_1, %Currency_List%
Gui, Main:Add, DropDownList, x120 y67 w160 Disabled vCurrency_Select_2, %Currency_List%
Gui, Main:Add, DropDownList, x120 y97 w160 Disabled vCurrency_Select_3, %Currency_List%
Gui, Main:Add, DropDownList, x120 y127 w160 Disabled vCurrency_Select_4, %Currency_List%
Gui, Main:add, Button, x120 y155 w160 Disabled vModifier_Select gModifier_Select wp, 選取詞綴
;Gui, Main:add, Edit, Disabled vCheck_Modifier_Text wp, 
Gui, Main:Add, Edit, x120 y187 w160 Number Limit4 vRun_Times_Edit
Gui, Main:Add, UpDown, x120 y187 Range0-5000 0x80 vRun_Times_UpDown, 0
Gui, Main:add, Button, x120 y215 w160 Default gRun_Macro wp, 開始

Gui, Main:Add, ListView, x30 y280 r10 w280 vModifier_Selected_List gModifier_Selected_List, 詞綴|Min|Max
;----------Main Window Tab 1 Program Prepare----------
;----------Main Window Tab 1 GUI Control Function----------
Enable_Currency_1()
{
    Gui, Main:Default
    GuiControlGet, Enable_Currency_1
    if (Enable_Currency_1 = 1) {
        GuiControl, Enable, Currency_Select_1
    } else {
        GuiControl, Disable, Currency_Select_1
    }
}
Enable_Currency_2()
{
    Gui, Main:Default
    GuiControlGet, Enable_Currency_2
    if (Enable_Currency_2 = 1) {
        GuiControl, Enable, Currency_Select_2
    } else {
        GuiControl, Disable, Currency_Select_2
    }
}
Enable_Currency_3()
{
    Gui, Main:Default
    GuiControlGet, Enable_Currency_3
    if (Enable_Currency_3 = 1) {
        GuiControl, Enable, Currency_Select_3
    } else {
        GuiControl, Disable, Currency_Select_3
    }
}
Enable_Currency_4()
{
    Gui, Main:Default
    GuiControlGet, Enable_Currency_4
    if (Enable_Currency_4 = 1) {
        GuiControl, Enable, Currency_Select_4
    } else {
        GuiControl, Disable, Currency_Select_4
    }
}
Enable_Check_Modifier() 
{
    Gui, Main:Default
    GuiControlGet, Enable_Check_Modifier

    if (Enable_Check_Modifier = 1) {
        GuiControl, Enable, Modifier_Select
    } else {
        GuiControl, Disable, Modifier_Select
    }
}

Modifier_Select() 
{
    Gui, Main:Default
    Gui, ModifierSelector:Show
}
Run_Macro()
{
    Gui, Main:Default
    ;MsgBox, % "Run_Macro"
    BlockInput, MouseMove
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        GuiControl, Disable, Enable_Currency_1
        GuiControl, Disable, Enable_Currency_2
        GuiControl, Disable, Enable_Currency_3
        GuiControl, Disable, Enable_Currency_4
        GuiControl, Disable, Enable_Check_Modifier
        GuiControl, Disable, Currency_Select_1
        GuiControl, Disable, Currency_Select_2
        GuiControl, Disable, Currency_Select_3
        GuiControl, Disable, Currency_Select_4
        GuiControl, Disable, Check_Modifier_Text
        GuiControl, Disable, Run_Speed
        GuiControl, Disable, Run_Times_Edit
        GuiControl, Disable, Run_Times_UpDown
        GuiControlGet, Enable_Check_Modifier
        GuiControlGet, Run_Times_Edit
        if(Run_Times_Edit = 0) {
            if(Enable_Check_Modifier) {
                Gui, ModifierSelector:Default
                Gui, ListView, ConfirmModifierLists
                ConfirmModifierListCount := LV_GetCount()
                Gui, Main:Default
                if(ConfirmModifierListCount > 0) {
                    MsgBox, % "次數：無限`n詞綴篩選：是`n可長按ESC停止或詞綴洗出後自動停止"
                    Loop 
                    {
                        processOfMacroStop := processOfMacro(0)
                        Check_Modifier := checkModifier()
                        if(ErrorLevel or Check_Modifier or processOfMacroStop or GetKeyState("Escape")) {
                            endOfMacro()
                            break
                        }
                    }
                } else {
                    MsgBox, % "詞綴篩選列表為空"
                    endOfMacro()
                }
            } else {
                MsgBox, % "次數：無限`n詞綴篩選：否`n可長按ESC停止"
                Loop 
                {
                    processOfMacroStop := processOfMacro(1)
                    if(ErrorLevel or processOfMacroStop or GetKeyState("Escape")) {
                        endOfMacro()
                        break
                    }
                }
            }
        } else {
            if(Enable_Check_Modifier) {
                Gui, ModifierSelector:Default
                Gui, ListView, ConfirmModifierLists
                ConfirmModifierListCount := LV_GetCount()
                Gui, Main:Default
                if(ConfirmModifierListCount > 0) {
                    MsgBox, % "次數：" . Run_Times_Edit . "`n詞綴篩選：是`n可長按ESC停止或詞綴洗出後自動停止"
                    loop, %Run_Times_Edit% 
                    {
                        processOfMacroStop := processOfMacro(0)
                        Check_Modifier := checkModifier()
                        if(ErrorLevel or A_Index >= Run_Times_Edit or Check_Modifier or processOfMacroStop or GetKeyState("Escape")) {
                            endOfMacro()
                            break
                        }
                    }
                } else {
                    MsgBox, % "詞綴篩選列表為空"
                    endOfMacro()
                }

            } else {
                MsgBox, % "次數：" . Run_Times_Edit . "`n詞綴篩選：否`n可長按ESC停止"
                loop, %Run_Times_Edit% 
                {
                    processOfMacroStop := processOfMacro(1)
                    if(ErrorLevel or A_Index >= Run_Times_Edit or processOfMacroStop or GetKeyState("Escape")) {
                        endOfMacro()
                        break
                    }
                }
            }
        }
    } else {
        endOfMacro()
        MsgBox, 未找到Path Of Exile視窗
    }
}
;----------Main Window Tab 1 Function----------

checkModifier() 
{
    ;MsgBox, % "checkModifier"
    Gui, Main:Default
    ClipboardOld := Clipboard
    Clipboard := ""
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Item")
        Send ^c
        ClipWait 1
        ;MsgBox, % Clipboard
        Gui, ModifierSelector:Default
        Gui, ListView, ConfirmModifierLists
        ConfirmModifierListCount := LV_GetCount()
        GuiControlGet,ModifierCheckMode
        Gui, Main:Default

        Modifier_Value_Compare := 1
        ;MsgBox,% "ModifierCheckMode:" . ModifierCheckMode
        if(ModifierCheckMode = "全部符合"){
            Modifier_Compare_Result := 1
        }else if(ModifierCheckMode = "部分符合"){
            Modifier_Compare_Result := 0
        }
        ;MsgBox, % "ConfirmModifierListCount:" . ConfirmModifierListCount
        loop, %ConfirmModifierListCount%
        {
            Gui, ModifierSelector:Default
            Gui, ListView, ConfirmModifierLists
            LV_GetText(Modifier, A_Index, 1)
            LV_GetText(Modifier_Min, A_Index, 2)
            LV_GetText(Modifier_Max, A_Index, 3)
            Gui, Main:Default
            Modifier_Prepare := StrReplace(Modifier, "#", "(.[0-9\.]+|[0-9\.]+)", ReplaceCount)
            Modifier_Prepare := "O)" . Modifier_Prepare
            ;MsgBox, % Modifier . ":" . Modifier_Min . "-" . Modifier_Max
            ;MsgBox, % "ReplaceCount:" . ReplaceCount
            if(RegExMatch(Clipboard, Modifier_Prepare, Modifier_Compare)) {
                if(ReplaceCount) {
                    Modifier_Value_Position := 1
                    loop, %ReplaceCount% 
                    {
                        ;MsgBox, % "A_Index:" . A_Index
                        if(ErrorLevel or A_Index >= ReplaceCount) {
                            ;MsgBox, % "Modifier_Value_Position:" . Modifier_Value_Position
                            ;MsgBox, % "Modifier_Value_Position_Before:" . Modifier_Value_Position
                            Modifier_Value_Position := RegExMatch(Modifier, "#", , StartingPosition := Modifier_Value_Position)
                            ;MsgBox, % "Modifier_Value_Position_After:" . Modifier_Value_Position
                            ;MsgBox, % "Modifier_Compare:" . Modifier_Compare.Value
                            RegExMatch(Modifier_Compare.Value, "O)[0-9]+", Modifier_Value, StartingPosition := Modifier_Value_Position)
                            ;MsgBox, % "Modifier_Value:" . Modifier_Value.Value
                            if(Modifier_Min != "") {
                                if(Modifier_Value.Value >= Modifier_Min) {
                                    ;MsgBox, % "Modifier_Min:" . Modifier_Min . ", 1"
                                    Modifier_Value_Compare := Modifier_Value_Compare and 1
                                } else {
                                    ;MsgBox, % "Modifier_Min:" . Modifier_Min . ", 0"
                                    Modifier_Value_Compare := Modifier_Value_Compare and 0
                                }
                            }
                            if(Modifier_Max != "") {
                                if(Modifier_Value.Value <= Modifier_Max) {
                                    ;MsgBox, % "Modifier_Max:" . Modifier_Max . ", 1"
                                    Modifier_Value_Compare := Modifier_Value_Compare and 1
                                } else {
                                    ;MsgBox, % "Modifier_Max:" . Modifier_Max . ", 0"
                                    Modifier_Value_Compare := Modifier_Value_Compare and 0
                                }
                            }
                            if(Modifier_Value_Compare) {
                                if(ModifierCheckMode = "全部符合"){
                                    Modifier_Compare_Result := Modifier_Compare_Result and 1
                                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                                    break
                                }else if(ModifierCheckMode = "部分符合"){
                                    Modifier_Compare_Result := Modifier_Compare_Result or 1
                                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                                    break
                                }

                            } else {
                                if(ModifierCheckMode = "全部符合"){
                                    Modifier_Compare_Result := Modifier_Compare_Result and 0
                                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                                    break
                                }else if(ModifierCheckMode = "部分符合"){
                                    Modifier_Compare_Result := Modifier_Compare_Result or 0
                                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                                    break
                                }

                            }
                        } else {
                            ;MsgBox, % "Modifier_Value_Position_Before:" . Modifier_Value_Position
                            Modifier_Value_Position := RegExMatch(Modifier, "#", , StartingPosition := Modifier_Value_Position) + 1
                            ;MsgBox, % "Modifier_Value_Position_After:" . Modifier_Value_Position
                        }
                    }
                } else {
                    if(ModifierCheckMode = "全部符合"){
                        Modifier_Compare_Result := Modifier_Compare_Result and 1
                        ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                    }else if(ModifierCheckMode = "部分符合"){
                        Modifier_Compare_Result := Modifier_Compare_Result or 1
                        ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                    }

                }
            } else {
                if(ModifierCheckMode = "全部符合"){
                    Modifier_Compare_Result := Modifier_Compare_Result and 0
                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                }else if(ModifierCheckMode = "部分符合"){
                    Modifier_Compare_Result := Modifier_Compare_Result or 0
                    ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                }
            }
            if(ErrorLevel or A_Index >= ConfirmModifierListCount) {
                ;MsgBox, % "Modifier_Compare_Result:" . Modifier_Compare_Result
                return Modifier_Compare_Result
                break
            }
        }
    }
}
Modifier_Selected_List()
{

}
processOfMacro(MacroMode)
{
    ;MsgBox, % "processOfMacro"
    Gui, Main:Default
    GuiControlGet, Enable_Currency_1
    GuiControlGet, Enable_Currency_2
    GuiControlGet, Enable_Currency_3
    GuiControlGet, Enable_Currency_4
    GuiControlGet, Currency_Select_1
    GuiControlGet, Currency_Select_2
    GuiControlGet, Currency_Select_3
    GuiControlGet, Currency_Select_4
    if(MacroMode = 0){
        if (Enable_Currency_1 = 1) {
            if(GetKeyState("Escape")){
                Return 1
            }else{
                point_name := CurrencyChangeToEN(Currency_Select_1)
                moveMouseToPoint(point_name)
                Send {Click Right}
                moveMouseToPoint("Item")
                Send {Click Left}
            }
        }
        if (Enable_Currency_2 = 1) {
            if(GetKeyState("Escape")){
                Return 1
            }else{
                point_name := CurrencyChangeToEN(Currency_Select_2)
                moveMouseToPoint(point_name)
                Send {Click Right}
                moveMouseToPoint("Item")
                Send {Click Left}
            }
        }
        if (Enable_Currency_3 = 1) {
            if(GetKeyState("Escape")){
                Return 1
            }else{
                point_name := CurrencyChangeToEN(Currency_Select_3)
                moveMouseToPoint(point_name)
                Send {Click Right}
                moveMouseToPoint("Item")
                Send {Click Left}
            }
        }
        if (Enable_Currency_4 = 1) {
            if(GetKeyState("Escape")){
                Return 1
            }else{
                point_name := CurrencyChangeToEN(Currency_Select_4)
                moveMouseToPoint(point_name)
                Send {Click Right}
                moveMouseToPoint("Item")
                Send {Click Left}
            }
        }
    }else if(MacroMode = 1){
        if((Enable_Currency_1 + Enable_Currency_2 + Enable_Currency_3 + Enable_Currency_4) = 1){
            if (Enable_Currency_1 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    if(GetKeyState("Shift")){
                        Sleep, 32
                        Send {Click Left}
                    }else{
                        point_name := CurrencyChangeToEN(Currency_Select_1)
                        moveMouseToPoint(point_name)
                        Send {Click Right}
                        moveMouseToPoint("Item")
                        Send {Shift Down}
                        Send {Click Left}
                    }
                }
            }
            if (Enable_Currency_2 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    if(GetKeyState("Shift")){
                        Sleep, 32
                        Send {Click Left}
                    }else{
                        point_name := CurrencyChangeToEN(Currency_Select_2)
                        moveMouseToPoint(point_name)
                        Send {Click Right}
                        moveMouseToPoint("Item")
                        Send {Shift Down}
                        Send {Click Left}
                    }
                }
            }
            if (Enable_Currency_3 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    if(GetKeyState("Shift")){
                        Sleep, 32
                        Send {Click Left}
                    }else{
                        point_name := CurrencyChangeToEN(Currency_Select_3)
                        moveMouseToPoint(point_name)
                        Send {Click Right}
                        moveMouseToPoint("Item")
                        Send {Shift Down}
                        Send {Click Left}
                    }
                }
            }
            if (Enable_Currency_4 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    if(GetKeyState("Shift")){
                        Sleep, 32
                        Send {Click Left}
                    }else{
                        point_name := CurrencyChangeToEN(Currency_Select_4)
                        moveMouseToPoint(point_name)
                        Send {Click Right}
                        moveMouseToPoint("Item")
                        Send {Shift Down}
                        Send {Click Left}
                    }
                }
            }
        }else{
            if (Enable_Currency_1 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    point_name := CurrencyChangeToEN(Currency_Select_1)
                    moveMouseToPoint(point_name)
                    Send {Click Right}
                    moveMouseToPoint("Item")
                    Send {Click Left}
                }
            }
            if (Enable_Currency_2 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    point_name := CurrencyChangeToEN(Currency_Select_2)
                    moveMouseToPoint(point_name)
                    Send {Click Right}
                    moveMouseToPoint("Item")
                    Send {Click Left}
                }
            }
            if (Enable_Currency_3 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    point_name := CurrencyChangeToEN(Currency_Select_3)
                    moveMouseToPoint(point_name)
                    Send {Click Right}
                    moveMouseToPoint("Item")
                    Send {Click Left}
                }
            }
            if (Enable_Currency_4 = 1) {
                if(GetKeyState("Escape")){
                    Return 1
                }else{
                    point_name := CurrencyChangeToEN(Currency_Select_4)
                    moveMouseToPoint(point_name)
                    Send {Click Right}
                    moveMouseToPoint("Item")
                    Send {Click Left}
                }
            }
        }

    }

}
endOfMacro()
{
    ;MsgBox, % "endOfMacro"
    Gui, Main:Default
    GuiControlGet, Enable_Currency_1
    GuiControlGet, Enable_Currency_2
    GuiControlGet, Enable_Currency_3
    GuiControlGet, Enable_Currency_4
    GuiControlGet, Enable_Check_Modifier
    GuiControlGet, Run_Times_Edit
    if (Enable_Currency_1 = 1) {
        GuiControl, Enable, Currency_Select_1
    }
    if (Enable_Currency_2 = 1) {
        GuiControl, Enable, Currency_Select_2
    }
    if (Enable_Currency_3 = 1) {
        GuiControl, Enable, Currency_Select_3
    }
    if (Enable_Currency_4 = 1) {
        GuiControl, Enable, Currency_Select_4
    }
    if (Enable_Check_Modifier = 1) {
        GuiControl, Enable, Modifier_Select
    }
    GuiControl, Enable, Enable_Currency_1
    GuiControl, Enable, Enable_Currency_2
    GuiControl, Enable, Enable_Currency_3
    GuiControl, Enable, Enable_Currency_4
    GuiControl, Enable, Enable_Check_Modifier
    GuiControl, Enable, Run_Times_Edit
    GuiControl, Enable, Run_Times_UpDown
    Send {Shift Up}
    BlockInput, MouseMoveOff
    TrayTip, PoE_AutoClick, 腳本結束, 3, 1
}

;----------Main Window Tab 2 GUI----------
Gui, Main:Tab, 2
;Column 1
Gui, Main:add, text, x30 y40 h12 section, 物品位置:
Gui, Main:add, text, x30 y65 h12, 混沌石位置:
Gui, Main:add, text, x30 y90 h12, 富豪石位置:
Gui, Main:add, text, x30 y115 h12, 崇高石位置:
Gui, Main:add, text, x30 y140 h12, 工匠石位置:
Gui, Main:add, text, x30 y165 h12, 幻色石位置:
Gui, Main:add, text, x30 y190 h12, 後悔石位置:
Gui, Main:add, text, x30 y215 h12, 改造石位置:
Gui, Main:add, text, x30 y240 h12, 機會石位置:
Gui, Main:add, text, x30 y265 h12, 無效石位置:
Gui, Main:add, text, x30 y290 h12, 祝福石位置:
Gui, Main:add, text, x30 y315 h12, 神聖石位置:
Gui, Main:add, text, x30 y340 h12, 重鑄石位置:
Gui, Main:add, text, x30 y365 h12, 鏈結石位置:
Gui, Main:add, text, x30 y390 h12, 點金石位置:
Gui, Main:add, text, x30 y415 h12, 瓦爾寶珠位置:
Gui, Main:add, text, x30 y440 h12, 自定義位置:
;Column 2
Gui, Main:add, Button, x120 y35 w80 h20 gItem_Position_Set, 設定位置
Gui, Main:add, Button, x120 y60 w80 h20 gChaos_Position_Set, 設定位置
Gui, Main:add, Button, x120 y85 w80 h20 gRegal_Position_Set, 設定位置
Gui, Main:add, Button, x120 y110 w80 h20 gExalted_Position_Set, 設定位置
Gui, Main:add, Button, x120 y135 w80 h20 gJewellers_Position_Set, 設定位置
Gui, Main:add, Button, x120 y160 w80 h20 gChrome_Position_Set, 設定位置
Gui, Main:add, Button, x120 y185 w80 h20 gRegret_Position_Set, 設定位置
Gui, Main:add, Button, x120 y210 w80 h20 gAlt_Position_Set, 設定位置
Gui, Main:add, Button, x120 y235 w80 h20 gChance_Position_Set, 設定位置
Gui, Main:add, Button, x120 y260 w80 h20 gAnnul_Position_Set, 設定位置
Gui, Main:add, Button, x120 y285 w80 h20 gBlessed_Position_Set, 設定位置
Gui, Main:add, Button, x120 y310 w80 h20 gDivine_Position_Set, 設定位置
Gui, Main:add, Button, x120 y335 w80 h20 gScour_Position_Set, 設定位置
Gui, Main:add, Button, x120 y360 w80 h20 gFusing_Position_Set, 設定位置
Gui, Main:add, Button, x120 y385 w80 h20 gAlch_Position_Set, 設定位置
Gui, Main:add, Button, x120 y410 w80 h20 gVaal_Position_Set, 設定位置
Gui, Main:add, Button, x120 y435 w80 h20 gCustom_Position_Set, 設定位置
;Column 3
Gui, Main:add, Button, x210 y35 w80 h20 gItem_Position_Test, 位置測試
Gui, Main:add, Button, x210 y60 w80 h20 gChaos_Position_Test, 位置測試
Gui, Main:add, Button, x210 y85 w80 h20 gRegal_Position_Test, 位置測試
Gui, Main:add, Button, x210 y110 w80 h20 gExalted_Position_Test, 位置測試
Gui, Main:add, Button, x210 y135 w80 h20 gJewellers_Position_Test, 位置測試
Gui, Main:add, Button, x210 y160 w80 h20 gChrome_Position_Test, 位置測試
Gui, Main:add, Button, x210 y185 w80 h20 gRegret_Position_Test, 位置測試
Gui, Main:add, Button, x210 y210 w80 h20 gAlt_Position_Test, 位置測試
Gui, Main:add, Button, x210 y235 w80 h20 gChance_Position_Test, 位置測試
Gui, Main:add, Button, x210 y260 w80 h20 gAnnul_Position_Test, 位置測試
Gui, Main:add, Button, x210 y285 w80 h20 gBlessed_Position_Test, 位置測試
Gui, Main:add, Button, x210 y310 w80 h20 gDivine_Position_Test, 位置測試
Gui, Main:add, Button, x210 y335 w80 h20 gScour_Position_Test, 位置測試
Gui, Main:add, Button, x210 y360 w80 h20 gFusing_Position_Test, 位置測試
Gui, Main:add, Button, x210 y385 w80 h20 gAlch_Position_Test, 位置測試
Gui, Main:add, Button, x210 y410 w80 h20 gVaal_Position_Test, 位置測試
Gui, Main:add, Button, x210 y435 w80 h20 gCustom_Position_Test, 位置測試
;----------Main Window Tab 2 Program Prepare----------
Hotkey, LButton, getMousePos, off
;----------Main Window Tab 2 GUI Control Function----------
Item_Position_Set()
{
    Gui, Main:Default
    select_point := "Item"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Chaos_Position_Set()
{
    Gui, Main:Default
    select_point := "Chaos"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Regal_Position_Set()
{
    Gui, Main:Default
    select_point := "Regal"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Exalted_Position_Set()
{
    Gui, Main:Default
    select_point := "Exalted"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Jewellers_Position_Set()
{
    Gui, Main:Default
    select_point := "Jewellers"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Chrome_Position_Set()
{
    Gui, Main:Default
    select_point := "Chrome"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Regret_Position_Set()
{
    Gui, Main:Default
    select_point := "Regret"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Alt_Position_Set()
{
    Gui, Main:Default
    select_point := "Alt"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Chance_Position_Set()
{
    Gui, Main:Default
    select_point := "Chance"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Annul_Position_Set()
{
    Gui, Main:Default
    select_point := "Annul"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Blessed_Position_Set()
{
    Gui, Main:Default
    select_point := "Blessed"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Divine_Position_Set()
{
    Gui, Main:Default
    select_point := "Divine"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Scour_Position_Set()
{
    Gui, Main:Default
    select_point := "Scour"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Fusing_Position_Set()
{
    Gui, Main:Default
    select_point := "Fusing"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Alch_Position_Set()
{
    Gui, Main:Default
    select_point := "Alch"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Vaal_Position_Set()
{
    Gui, Main:Default
    select_point := "Vaal"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Custom_Position_Set()
{
    Gui, Main:Default
    select_point := "Custom"
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        MsgBox, 左鍵點選通貨兩下
        Hotkey, LButton, getMousePos, on
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }

}
Item_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Item")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Chaos_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Chaos")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Regal_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Regal")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Exalted_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Exalted")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Jewellers_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Jewellers")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Chrome_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Chrome")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Regret_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Regret")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Alt_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Alt")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Chance_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Chance")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Annul_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Annul")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Blessed_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Blessed")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Divine_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Divine")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Scour_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Scour")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Fusing_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Fusing")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Alch_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Alch")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Vaal_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Vaal")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
Custom_Position_Test()
{
    Gui, Main:Default
    if (WinExist("Path of Exile") and (WinExist("ahk_exe PathOfExile_x64.exe") or WinExist("ahk_exe PathOfExile.exe"))) {
        WinActivate
        moveMouseToPoint("Custom")
    } else {
        MsgBox, 未找到Path Of Exile視窗
    }
}
;----------Main Window Tab 2 Function----------
CurrencyChangeToEN(Currency)
{
    if(Currency = "混沌石") {
        return "Chaos"
    } else if (Currency = "富豪石") {
        return "Regal"
    } else if (Currency = "崇高石") {
        return "Exalted"
    } else if (Currency = "工匠石") {
        return "Jewellers"
    } else if (Currency = "幻色石") {
        return "Chrome"
    } else if (Currency = "後悔石") {
        return "Regret"
    } else if (Currency = "改造石") {
        return "Alt"
    } else if (Currency = "機會石") {
        return "Chance"
    } else if (Currency = "無效石") {
        return "Annul"
    } else if (Currency = "祝福石") {
        return "Blessed"
    } else if (Currency = "神聖石") {
        return "Divine"
    } else if (Currency = "重鑄石") {
        return "Scour"
    } else if (Currency = "鏈結石") {
        return "Fusing"
    } else if (Currency = "點金石") {
        return "Alch"
    } else if (Currency = "瓦爾寶珠") {
        return "Vaal"
    } else if (Currency = "自定義") {
        return "Custom"
    }
}
moveMouseToPoint(point)
{
    ;MsgBox, % "moveMouseToPoint-point:" . point
    Move_X := readPosXFromIni(point)
    Move_Y := readPosYFromIni(point)
    MouseMove, Move_X, Move_Y
}
getMousePos()
{
    Hotkey, LButton, getMousePos, off
    MouseGetPos, mouse_Position_x, mouse_Position_y
    ;MsgBox, % "getMousePos`nmouse_Position_x:" . mouse_Position_x . "`nmouse_Position_y:" . mouse_Position_y
    writePosToIni(mouse_Position_x, mouse_Position_y)
}
writePosToIni(mouse_Position_x, mouse_Position_y)
{
    ;MsgBox, % "writePosToIni`nmouse_Position_x:" . mouse_Position_x . "`nmouse_Position_y:" . mouse_Position_y
    IniWrite, %mouse_Position_x%, position.ini, %select_point%, x
    IniWrite, %mouse_Position_y%, position.ini, %select_point%, y
    TrayTip, PoE_AutoClick, 座標抓取成功, 3, 1
    if (WinExist("PoE_AutoClick")) {
        WinActivate
    }
}
readPosXFromIni(point)
{
    ;MsgBox, % "readPosXFromIni-point:" . point
    IniRead, point_x, position.ini, %point%, x
    Return point_x
}
readPosYFromIni(point)
{
    ;MsgBox, % "readPosYFromIni-point:" . point
    IniRead, point_y, position.ini, %point%, y
    Return point_y
}
;----------End Main Window Tab----------
Gui, Main:Show
;----------End Main Window GUI----------
;----------End Main Window----------

;----------ModifierSelector Window----------
;----------GUI Create----------
Gui, ModifierSelector:New, , ModifierSelector
Gui, ModifierSelector:add, edit, Hidden vModifierSearchStopCode
Gui, ModifierSelector:add, edit, x10 y6 vModifierInput w520
Gui, ModifierSelector:add, button, x540 y4 w80 Default vModifierSearch gModifierSearch, 搜尋
Gui, ModifierSelector:add, button, Disabled x630 y4 w80 vModifierSearchStop gModifierSearchStop, 停止
Gui, ModifierSelector:add, button, x720 y4 w80 vAddModifierByManual gAddModifierByManual, 手動新增
Gui, ModifierSelector:Add, DropDownList, x810 y5 w80 vModifierCheckMode, 部分符合||全部符合
Gui, ModifierSelector:add, button, x900 y4 w80 gModifierConfirm, 確認
Gui, ModifierSelector:Add, ListView, x10 y32 r25 w480 vModifierList gModifierList, 詞綴
Gui, ModifierSelector:Add, ListView, x500 y32 r25 w480 vConfirmModifierList gConfirmModifierList, 詞綴|Min|Max
Gui, ModifierSelector:Add, Progress, x10 w970 h20 cBlue vSearchProgress, 0

;----------ModifierSelector Window GUI Control Function----------
ModifierList() 
{
    Gui, ModifierSelector:Default
    if (A_GuiEvent = "DoubleClick") {
        Gui, ListView, ModifierList
        LV_GetText(RowText, A_EventInfo)
        GuiControl, AddModifier:, AddModifier_Now, %RowText%
        Gui, AddModifier:Show

    }
}
ConfirmModifierList()
{
    Gui, ModifierSelector:Default
    if (A_GuiEvent = "DoubleClick") {
        Gui, ListView, ConfirmModifierList
        LV_GetText(RowText, A_EventInfo, 1)
        GuiControl, EditModifier:, EditModifier_Now, %RowText%
        LV_GetText(RowText, A_EventInfo, 2)
        GuiControl, EditModifier:, EditModifier_Min, %RowText%
        LV_GetText(RowText, A_EventInfo, 3)
        GuiControl, EditModifier:, EditModifier_Max, %RowText%
        GuiControl, EditModifier:, EditModifier_Row, %A_EventInfo%
        Gui, EditModifier:Show

    }
}
ModifierSearch()
{
    Gui, ModifierSelector:Default
    GuiControl, Disable, ModifierInput
    GuiControl, Disable, ModifierSearch
    GuiControl, Enable, ModifierSearchStop
    Search_Count = 0
    Gui, ListView, ModifierList
    LV_Delete()
    for Line in Stats
    {
        GuiControlGet, ModifierInput
        GuiControlGet, ModifierSearchStopCode
        Now_Progress := Floor(A_Index / Stats.Length() * 100)
        GuiControl, , SearchProgress, %Now_Progress%
        if (InStr(Stats[A_Index], ModifierInput)) {
            Gui, ModifierSelector:ListView, ModifierList
            LV_Add("", Stats[A_Index])
            LV_ModifyCol()
        }
        if (ErrorLevel or ModifierSearchStopCode) {
            GuiControl, ModifierSelector:, ModifierSearchStopCode, 0
            break
        }
    }
    GuiControl, Enable, ModifierInput
    GuiControl, Enable, ModifierSearch
    MsgBox, 搜尋結束
    GuiControl, Disable, ModifierSearchStop
}
ModifierSearchStop() 
{
    Gui, ModifierSelector:Default
    GuiControl, ModifierSelector:, ModifierSearchStopCode, 1
    GuiControl, Disable, ModifierSearchStop
}
AddModifierByManual() 
{
    Gui, ModifierSelector:Default
    Gui, ManualAddModifier:Show
}
ModifierConfirm()
{
    Gui, Main:Default
    Gui, ListView, Modifier_Selected_List
    LV_Delete()

    Gui, ModifierSelector:Default
    Gui, ListView, ConfirmModifierList
    Loop ,% LV_GetCount()
    {
        Gui, ModifierSelector:Default
        Gui, ListView, ConfirmModifierList
        LV_GetText(Column1, A_Index ,1)
        LV_GetText(Column2, A_Index ,2)
        LV_GetText(Column3, A_Index ,3)
        Gui, Main:Default
        Gui, ListView, Modifier_Selected_List
        LV_Add("", Column1, Column2, Column3)
        LV_ModifyCol()
        Gui, ModifierSelector:Default
    }
    Gui, ModifierSelector:Cancel
    Gui, Main:Default
    Gui, Main:Show
}

;----------End ModifierSelector Window----------

;----------AddModifier Window----------
;----------AddModifier Window GUI Create----------
Gui, AddModifier:New, , AddModifier
Gui, AddModifier:Add, Text, x15 y20, 詞綴：
Gui, AddModifier:Add, Text, x15 y60, Min:
Gui, AddModifier:Add, Text, x15 y85, Max:
Gui, AddModifier:add, edit, x50 y10 r2 w240 ReadOnly vAddModifier_Now
Gui, AddModifier:add, edit, x50 y55 w240 vAddModifier_Min
Gui, AddModifier:add, edit, x50 y80 w240 vAddModifier_Max
Gui, AddModifier:add, button, x50 y105 w240 Default gAddModifier, 新增
;----------AddModifier WindowGUI Control Function----------
AddModifier() 
{
    Gui, AddModifier:Default
    GuiControlGet, AddModifier_Now
    GuiControlGet, AddModifier_Min
    GuiControlGet, AddModifier_Max
    Gui, ModifierSelector:Default
    Gui, ListView, ConfirmModifierList
    LV_Add("", AddModifier_Now, AddModifier_Min, AddModifier_Max)
    LV_ModifyCol()
    Gui, AddModifier:Default
    GuiControl, AddModifier:, AddModifier_Now, 
    GuiControl, AddModifier:, AddModifier_Min, 
    GuiControl, AddModifier:, AddModifier_Max, 
    Gui, AddModifier:Cancel
    Gui, ModifierSelector:Show
}
;----------End AddModifier Window----------

;----------ManualAddModifier Window----------
;----------ManualAddModifier Window GUI Create----------
Gui, ManualAddModifier:New, , ManualAddModifier
Gui, ManualAddModifier:Add, DropDownList, x15 y5 w130 vManualAddModifierMode gManualAddModifierMode, 手動輸入||插槽數量|連線數量
Gui, ManualAddModifier:Add, DropDownList, x160 y5 w130 Disabled vLinkAndSocketQuantity gLinkAndSocketQuantity, 6||5|4|3|2|1
Gui, ManualAddModifier:Add, Text, x15 y45, 詞綴：
Gui, ManualAddModifier:Add, Text, x15 y85, Min:
Gui, ManualAddModifier:Add, Text, x15 y110, Max:
Gui, ManualAddModifier:add, edit, x50 y35 r2 w240 vManualAddModifier_Now
Gui, ManualAddModifier:add, edit, x50 y80 w240 vManualAddModifier_Min
Gui, ManualAddModifier:add, edit, x50 y105 w240 vManualAddModifier_Max
Gui, ManualAddModifier:add, button, x50 y130 w240 Default gManualAddModifier, 新增
;----------ManualAddModifier WindowGUI Control Function----------
ManualAddModifierMode()
{
    Gui, ManualAddModifier:Default
    GuiControlGet,ManualAddModifierMode
    if(ManualAddModifierMode = "手動輸入"){
        GuiControl,ManualAddModifier:,ManualAddModifier_Now,
        GuiControl,ManualAddModifier:,ManualAddModifier_Min,
        GuiControl,ManualAddModifier:,vManualAddModifier_Max,
        GuiControl,Disable,LinkAndSocketQuantity
        GuiControl,Enable,ManualAddModifier_Now
        GuiControl,Enable,ManualAddModifier_Min
        GuiControl,Enable,ManualAddModifier_Max
    }else{
        GuiControl,ManualAddModifier:,ManualAddModifier_Now,
        GuiControl,ManualAddModifier:,ManualAddModifier_Min,
        GuiControl,ManualAddModifier:,vManualAddModifier_Max,
        GuiControl,Enable,LinkAndSocketQuantity
        GuiControl,Disable,ManualAddModifier_Now
        GuiControl,Disable,ManualAddModifier_Min
        GuiControl,Disable,ManualAddModifier_Max
        GuiControlGet,ManualAddModifierMode
        GuiControlGet,LinkAndSocketQuantity
        if(ManualAddModifierMode = "插槽數量"){
            SocketQuantity := "[R|G|B|W]"
            loop, % LinkAndSocketQuantity - 1
            {
                SocketQuantity := SocketQuantity . ".[R|G|B|W]"
            }
            GuiControl,ManualAddModifier:,ManualAddModifier_Now,%SocketQuantity%

        }else if(ManualAddModifierMode = "連線數量"){
            LinkQuantity := "[R|G|B|W]"
            loop, % LinkAndSocketQuantity - 1
            {
                LinkQuantity := LinkQuantity . "-[R|G|B|W]"
            }
            GuiControl,ManualAddModifier:,ManualAddModifier_Now,%LinkQuantity%
        }
    }
}
LinkAndSocketQuantity()
{
    Gui, ManualAddModifier:Default
    GuiControlGet,ManualAddModifierMode
    GuiControlGet,LinkAndSocketQuantity
    if(ManualAddModifierMode = "插槽數量"){
        SocketQuantity := "[R|G|B|W]"
        loop, % LinkAndSocketQuantity - 1
        {
            SocketQuantity := SocketQuantity . ".[R|G|B|W]"
        }
        GuiControl,ManualAddModifier:,ManualAddModifier_Now,%SocketQuantity%

    }else if(ManualAddModifierMode = "連線數量"){
        LinkQuantity := "[R|G|B|W]"
        loop, % LinkAndSocketQuantity - 1
        {
            LinkQuantity := LinkQuantity . "-[R|G|B|W]"
        }
        GuiControl,ManualAddModifier:,ManualAddModifier_Now,%LinkQuantity%
    }
}
ManualAddModifier()
{
    Gui, ManualAddModifier:Default
    GuiControlGet, ManualAddModifier_Now
    GuiControlGet, ManualAddModifier_Min
    GuiControlGet, ManualAddModifier_Max
    Gui, ModifierSelector:Default
    Gui, ListView, ConfirmModifierList
    LV_Add("", ManualAddModifier_Now, ManualAddModifier_Min, ManualAddModifier_Max)
    LV_ModifyCol()
    Gui, ManualAddModifier:Default
    GuiControl, ManualAddModifier:, ManualAddModifier_Now, 
    GuiControl, ManualAddModifier:, ManualAddModifier_Min, 
    GuiControl, ManualAddModifier:, ManualAddModifier_Max, 
    Gui, ManualAddModifier:Cancel
    Gui, ModifierSelector:Show
}
;----------End ManualAddModifier Window----------

;----------EditModifier Window----------
;----------EditModifier Window GUI Create----------
Gui, EditModifier:New, , EditModifier
Gui, EditModifier:add, edit, Hidden vEditModifier_Row
Gui, EditModifier:Add, Text, x15 y20, 詞綴：
Gui, EditModifier:Add, Text, x15 y60, Min:
Gui, EditModifier:Add, Text, x15 y85, Max:
Gui, EditModifier:add, edit, x50 y10 r2 w240 ReadOnly ys vEditModifier_Now
Gui, EditModifier:add, edit, x50 y55 w240 vEditModifier_Min
Gui, EditModifier:add, edit, x50 y80 w240 vEditModifier_Max
Gui, EditModifier:add, button, x50 y105 w115 Default gEditModifier, 編輯
Gui, EditModifier:add, button, x175 y105 w115 gRemoveModifier, 移除
;----------EditModifier WindowGUI Control Function----------
EditModifier() 
{
    Gui, EditModifier:Default
    GuiControlGet, EditModifier_Row
    GuiControlGet, EditModifier_Now
    GuiControlGet, EditModifier_Min
    GuiControlGet, EditModifier_Max
    Gui, ModifierSelector:Default
    Gui, ListView, ConfirmModifierList
    LV_Modify(EditModifier_Row, , EditModifier_Now, EditModifier_Min, EditModifier_Max)
    LV_ModifyCol()
    Gui, EditModifier:Default
    GuiControl, EditModifier:, EditModifier_Row, 
    GuiControl, EditModifier:, EditModifier_Now, 
    GuiControl, EditModifier:, EditModifier_Min, 
    GuiControl, EditModifier:, EditModifier_Max, 
    Gui, EditModifier:Cancel
    Gui, ModifierSelector:Show
}
RemoveModifier() 
{
    Gui, EditModifier:Default
    GuiControlGet, EditModifier_Row
    Gui, ModifierSelector:Default
    Gui, ListView, ConfirmModifierList
    LV_Delete(EditModifier_Row)
    Gui, EditModifier:Default
    GuiControl, EditModifier:, EditModifier_Row, 
    GuiControl, EditModifier:, EditModifier_Now, 
    GuiControl, EditModifier:, EditModifier_Min, 
    GuiControl, EditModifier:, EditModifier_Max, 
    Gui, EditModifier:Cancel
    Gui, ModifierSelector:Show
}
;----------End EditModifier Window----------

;----------Menu----------
Menu, Tray, NoStandard
Menu, Tray, Icon, icon.ico
Menu, Tray, Insert, , 開啟GUI, showGUI
Menu, Tray, Insert, , 檢查更新, CheckUpdateFromMenu
Menu, Tray, Insert, , 結束程式, Exit_App
;----------Menu Function----------
showGUI()
{
    Gui, Main:Show
}
Exit_App()
{
    ExitApp
}
;----------End Menu----------
;----------Check Update----------
CheckUpdateFromMenu()
{
    CheckUpdate("menu")
}
CheckUpdate(CheckFrom)
{
    if(FileExist("update.exe") != ""){
        RunWait,update.exe %CheckFrom%
    }else{
        UrlDownloadToFile,https://github.com/gamegenius/PoE_AutoClick/releases/latest/download/update.exe,update.exe
    }

}
;----------Start Program----------
StartProgram()
{
    CheckUpdate("start")
}
;----------Globel Function----------

