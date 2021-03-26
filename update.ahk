;----------Globel Set----------
SendMode Event
SetWorkingDir, %A_ScriptDir%
global version := ""
FileRead, version, version.txt
if(A_Args.Length() = 0){
    CheckUpdate("exe")
}else if(A_Args.Length() = 1){
    if(A_Args[1] = "start"){
        CheckUpdate("start")
    }else if(A_Args[1] = "menu"){
        CheckUpdate("menu")
    }
}

CheckUpdate(CheckFrom)
{
    UrlDownloadToFile, https://github.com/gamegenius/PoE_AutoClick/releases/latest/download/version.txt, latest_version.txt
    FileRead, latest_version, latest_version.txt
    if(RegExMatch(latest_version,version)){
        if(CheckFrom = "menu" or CheckFrom = "exe"){
            MsgBox, % "已經是最新版！`n版本號碼：" . version
            ExitApp
        }else if(CheckFrom = "start"){
            ExitApp
        }
    }else{
        MsgBox, 4,,% "檢查到新版本！`n目前版本號碼：" . version . "`n最新版本號碼：" . latest_version . "`n是否更新?"
        IfMsgBox, Yes
        {
            Process, Exist, PoE_AutoClick.exe
            if (ErrorLevel != 0) {
                Process, Close, PoE_AutoClick.exe
            }
            UrlDownloadToFile,https://github.com/gamegenius/PoE_AutoClick/releases/download/%latest_version%/UpdateCommand.txt,UpdateCommand.txt
            loop, Read, UpdateCommand.txt
            {
                LINE := StrSplit(A_LoopReadLine, ",")
                OPCODE := LINE[1]
                if(OPCODE = "FileDelete"){
                    FileDelete,% LINE[2]
                }else if(OPCODE = "UrlDownloadToFile"){
                    UrlDownloadToFile,% LINE[2],% LINE[3]
                }else if(OPCODE = "Run"){
                    Run, % LINE[2]
                }else if(OPCODE = "RunWait"){
                    RunWait, % LINE[2]
                }

            }
            FileDelete, UpdateCommand.txt
            ExitApp
        }
    }
}

