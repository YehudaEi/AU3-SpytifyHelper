#NoTrayIcon

#Region
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=SpytifyHelper.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Yehuda Eisenberg
#AutoIt3Wrapper_Res_Description=Spytify Helper
#AutoIt3Wrapper_Res_Fileversion=1.0.0
#AutoIt3Wrapper_Res_ProductName=Spytify Helper
#AutoIt3Wrapper_Res_ProductVersion=1.0.0
#AutoIt3Wrapper_Res_CompanyName=Yehuda Software
#AutoIt3Wrapper_Res_LegalCopyright=Yehuda Eisenberg
#AutoIt3Wrapper_Res_Language=1037
#AutoIt3Wrapper_Res_Field=ProductName|Spytify Helper
#AutoIt3Wrapper_Res_Field=ProductVersion|1.0.0
#AutoIt3Wrapper_Res_Field=CompanyName|Yehuda Eisenberg
#EndRegion

Func _WinGetByPID($iPID, $iArray = 1)
    Local $aError[1] = [0], $aWinList, $sReturn
    If IsString($iPID) Then
        $iPID = ProcessExists($iPID)
    EndIf
    $aWinList = WinList()
    For $A = 1 To $aWinList[0][0]
        If WinGetProcess($aWinList[$A][1]) = $iPID And BitAND(WinGetState($aWinList[$A][1]), 2) Then
            If $iArray Then
                Return $aWinList[$A][1]
            EndIf
            $sReturn &= $aWinList[$A][1] & Chr(1)
        EndIf
    Next
    If $sReturn Then
        Return StringSplit(StringTrimRight($sReturn, 1), Chr(1))
    EndIf
    Return SetError(1, 0, $aError)
EndFunc   ;==>_WinGetByPID
Func _ReduceMemory()
	Local $aReturn = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	If @error = 1 Then
		Return SetError(1, 0, 0)
	EndIf
	Return $aReturn[0]
EndFunc   ;==>_ReduceMemory

Opt("TrayIconHide", 0)
Opt("TrayMenuMode", 3)

TraySetToolTip("Spytify Helper - Run")
Local $idTrayExit = TrayCreateItem("Close Software")

While True
	Local $sControlName = "[NAME:lblRecordedTime]"
	Local $sWindowClass = "[CLASS:WindowsForms10.Window.8.app.0.141b42a_r6_ad1]"

	Local $iPid = ProcessExists("Spytify.exe")

	If $iPid = 0 Then
		MsgBox(0x10, "Error", "Spytify not running")
		Exit
	EndIf

	Local $hWnd = _WinGetByPID($iPid)

	If ControlGetText($hWnd, "", $sControlName) = "" Then
		;MsgBox(0x40, "Not Recording", "not recording now", 5)
		Send("{MEDIA_NEXT}")
		Sleep(5000)
	EndIf

	Switch TrayGetMsg()
		Case $idTrayExit
			If MsgBox(BitOR(0x4, 0x40, 0x40000), "Spytify Helper", "Are you sure you want to close the software?") = 6 Then
				Exit
			EndIf
	EndSwitch

	_ReduceMemory()
WEnd
