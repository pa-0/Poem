#SingleInstance off
#NoTrayIcon		;Leave this in here so the tray icon won't flicker if another PEM is started.
THISVERSION=1.0
INIFILE=PEM.ini
SetWorkingDir, %A_ScriptDir%

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Argument Mode~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hands any files passed as arguments~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(%0%>0) {
	gosub Argmode
	exitapp
}


NoArgs:
Menu, tray, icon
#include PEM_gui.ahk
#include PEM_Dropper.ahk
AfterDropper:

;``````````````````````````Config options in INI``````````````````````````
Iniread, TempVar, %INIFILE%, config, checkRegistry,1
if(TempVar = "" or not TempVar = 0)
	Menu, main, check,Check registry on exit

Iniread, checkPrograms, %INIFILE%, config, checkPrograms,0
if(checkPrograms = "" or not checkPrograms = 0)
	Menu, main, check,Check programs on start

Iniread, startintray, %INIFILE%, config, startInTray,0
if(startintray = "" or not startintray = 0)
	Menu, main, check,Start in tray

Iniread, showBalloon, %INIFILE%, config, showBalloon,1
if(showBalloon!=0)
{	Menu, main, check, Show balloon tip
	showBalloon=1
}

iniread, silentMode, %INIFILE%, config, silentMode, 0
if(silentMode=1)
{	Menu, main, check, Silent Mode
	Menu, main, disable, Check registry on exit
	Menu, main, disable, Show Balloon tip
	Menu, main, disable, Start in tray
	gosub install
}
else
	gosub contextState

;``````````````````````````Add Entries``````````````````````````
gui 1: default
iniread, drv, pem.ini, config, drive
drv := drv = "PEM" ? SubStr(A_ScriptDir,1,2) : drv
loop, read, %INIFILE%
{
	if(A_LoopReadLine="[key]")
	{	ReadNow=1
		Continue
	}
	if(ReadNow=1)
	{
		if(A_LoopReadLine="[config]" or A_LoopReadLine="[Dropper]")
			break
		ifinstring, A_Loopreadline,=
		{ 
			Stringsplit,part, A_LoopReadLine,=
			Iniread, part2,%INIFILE%, key, %part1%
			if(part2="ERROR")
				Continue
			if(checkPrograms=1 and drv!="ERROR" and silentmode!=1 and !FileExist(drv . "\" . part2) and warned!=1)
			{	traytip,,One or more of your programs is missing so PEM may not work.
				Settimer, removetraytip, -5000
				Warned=1
			}
			LV_Add("",part1,part2)
		}
	}
}
LV_ModifyCol(1,40)
LV_ModifyCol(2,"autohdr")

if(silentMode!=1 and startintray!=1)
	gui 1: show, w345, PEM - Portable Extension Manager

iniread, TempVar, %INIFILE%, config, startDropper
if(TempVar=1)
{	Menu, main, check, Start with Dropper
	gosub Dropper_show
}

;``````````````````````````"First Time" message``````````````````````````
iniread, firstTime, %INIFILE%, config, firstTime
ifnotequal, firstTime, 0
{	gui 1: +owndialogs
	msgbox, 68, Read the manual!, Greetings!`n`n`tIt looks like this is your first time using PEM.`nIf it is, I highly suggest skimming the readme so you know`nwhat does what, the dos and donts, and such. It'll only take`nlike 2 minutes, I swear. It would make me ever so happy.`n(Plus, it will help you use PEM!)`n`n-Jon		
	ifmsgbox, Yes
		gosub mReadme
	iniwrite, 0, %INIFILE%, config, firstTime
}

settimer,EmptyMem, 10000
EmptyMem:
EmptyMem()
return

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!END OF AUTOEXECUTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Glabels~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;``````````````````````````GUI 1: Main``````````````````````````
gListView:
if(A_GuiEvent!="DoubleClick")
	return
selectedRow:=A_EventInfo
goto _showGUI2
gListViewEnter:
selectedRow:=LV_GetNext(0, "Focused")
if selectedRow=0
	Return
_showGUI2:
LV_GetText(ExtVar, selectedRow,1)
LV_GetText(PathVar, selectedRow,2)
Guicontrol 2:, groupbox2, Edit extension - %ExtVar%
GuiControl 2:, ExtVar, %ExtVar%
GuiControl 2:, PathVar, % updatecombo(PathVar)
Gui 2: show, autosize,Edit entry
return

gButtonNew:
gui 1: +disabled
selectedRow=0
Guicontrol 2:, PathVar,% updatecombo()
guicontrol 2:, ExtVar,
Guicontrol 2:, groupbox2, New Extension
gui 2: show, autosize,Add entry
return

gButtonDel:
gui 1: default
selectedRow:=LV_GetNext()
if(selectedRow=0)
	return
LV_GetText(ExtVar,selectedRow,1)
LV_Delete(selectedRow)
if(selectedRow=LV_GetCount() + 1)
 LV_Modify(selectedRow - 1, "Select")
Else
 LV_Modify(selectedRow, "Select")
Inidelete, %INIFILE%, key, %ExtVar%
return

gDriveList:
gui 1:submit, nohide
iniwrite, %driveList%, %INIFILE%, config, drive
Return

gToggleContext:
if(checkcontext()=0)
  	goto install
else
	goto remove
return

	;For "?" button
gmainmenu:
gui 1: default
Coordmode, menu, relative
Guicontrolget, menPos_, pos, MenuButton
menPos_x+=menPos_w+3
;~ menPos_y+=menPos_y+3
Menu, main, show,%menPos_x%,%menPos_y%
return

;``````````````````````````GUI 2: Add/Edit``````````````````````````
	;For the "..." button
gPathselect:
gui 2: +OwnDialogs
FileselectFile, PathVar,,,Select Program
if(PathVar="")
	Return
Splitpath, PathVar,part2,part1,,,part0
Stringreplace, part1, part1, %part0%\,
PathVar:=part1 . "\" . part2
Guicontrol 2:,PathVar,%PathVar%||

	;Makes sure there is something in both fields in the add/edit window
gIfEmpty:
gui 2: submit, nohide
if(PathVar="" or ExtVar="")
	guicontrol 2:disabled,ok2button
Else
	guicontrol 2:enabled,ok2button
return

2ButtonOk:
Gui 2:submit, nohide
if(selectedRow=0 and CheckIfDupe(ExtVar)=1)
{	gui 2: +owndialogs
	msgbox,,Extension already set,There is already a program set for the extension %ExtVar%!
	Return
}
gui 2: hide
IniWrite, %PathVar%, %INIFILE%, key, %ExtVar%
gui 1: default
if(selectedRow=0)
	LV_Add("",ExtVar,PathVar)
Else
	LV_Modify(selectedRow,"",ExtVar,PathVar)

2ButtonCancel:
gui 1: -Disabled
gui 2: hide
gui 1: show
return


;``````````````````````````GUI 3: About``````````````````````````
gEmail:
run, mailto:FreewareWire@gmail.com
return

gWebsite:
run, http://sites.google.com/site/freewarewiresoftware
return

;``````````````````````````Menu glabels``````````````````````````
mShowPEM:
if(ismax=1)
	gui 1: show, Maximize, PEM - Portable Extension Manager
else
	gui 1: show,, PEM - Portable Extension Manager
Return

mShowAbout:
gui 3: show, autosize, About PEM
Return

mReadme:
ifnotexist, readme.txt
{ 	gui 1: +owndialogs	
	msgbox,48,File Not Found, The Readme does not seem to exist.
	Return
}
run, readme.txt
return

	;Handles the "Silent Mode" Menu option
mSilentMode:
iniread, TempVar, %INIFILE%, config, silentMode,0
ifequal, TempVar, 0
{	Menu, main, check, Silent Mode
	Menu, main, disable, Check registry on exit
	Menu, main, disable, Show Balloon tip
	Menu, main, disable, Start in tray
	iniwrite, 1, %INIFILE%, config, silentMode
}
else
{	Menu, main, uncheck, Silent Mode
	Menu, main, enable, Check registry on exit
	Menu, main, enable, Show Balloon tip
	Menu, main, enable, Start in tray
	iniwrite, 0, %INIFILE%, config, silentMode
}
return

mCheckProgramsOnStart:
Iniread, TempVar, %INIFILE%, config, checkPrograms,0
ifequal, TempVar, 0
{	Menu, main, check, Check programs on start
	iniwrite, 1, %INIFILE%, config, checkprograms
}
Else
{	Menu, main, uncheck, Check programs on start
	iniwrite, 0, %INIFILE%, config, checkprograms
}
return

mCheckRegOnExit:
Iniread, TempVar, %INIFILE%, config, checkRegistry,1
ifequal, TempVar, 0
{	Menu, main, check, Check registry on exit
	iniwrite, 1, %INIFILE%, config, checkregistry
}
Else
{	Menu, main, uncheck, Check registry on exit
	iniwrite, 0, %INIFILE%, config, checkregistry
}
return

mStartInTray:
Iniread, TempVar, %INIFILE%, config, startInTray,0
ifequal, TempVar, 0
{	Menu, main, check, Start in tray
	iniwrite, 1, %INIFILE%, config, startInTray
}
Else
{	Menu, main, uncheck, Start in tray
	iniwrite, 0, %INIFILE%, config, startInTray
}
return

	;Toggles Dropper to start with PEM
mDropperOnStart:
Iniread, TempVar, %INIFILE%, config, startDropper,0
ifequal, TempVar, 0
{	Menu, main, check, Start with Dropper
	iniwrite, 1, %INIFILE%, config, startDropper
}
Else
{	Menu, main, uncheck, Start with Dropper
	iniwrite, 0, %INIFILE%, config, startDropper
}
return

	;Checks if the balloon tip is enabled
mShowBalloonTip:
iniread, showBalloon, %INIFILE%, config, showBalloon,1
if(showBalloon=0)
{ 	menu, main, check, Show balloon tip	
	iniwrite, 1, %INIFILE%, config, showBalloon
}
else
{	Menu, main, uncheck, Show balloon tip
	iniwrite, 0, %INIFILE%, config, showBalloon
}
return

;``````````````````````````GUI Events``````````````````````````
guiclose:
iniread, showBalloon, %INIFILE%, config, showBalloon,0
iniread, silentMode, %INIFILE%, config, silentMode,0
if(showBalloon!=0 and silentMode!=1)
{ 	traytip,,PEM will stay in your tray because it loves you.
	Settimer, removetraytip, -3000
	iniwrite, 0, %INIFILE%, config, showBalloon
}
WinGet, IsMax, MinMax, PEM - Portable Extension Manager
gui 1: hide
gui 2: hide
gui 3: hide
Return

2guiclose:
gui 1: -Disabled
gui 2: hide
gui 1: show
return

GuiSize:
Anchor("ListViewVar","wh")
Anchor("newbutton","y")
Anchor("delbutton","y")
Anchor("drivetext","y")
Anchor("drivelist","y")
Anchor("contextbutton","xy")
Anchor("menubutton","xy")
LV_ModifyCol(2,"autohdr")
return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;Checks if extension already has a program
CheckIfDupe(newextension)
{	
	gui 1: default
	loop, % LV_GetCount()
	{	LV_GetText(checkit,A_Index)
		if(newextension=checkit)
			return 1
	}
	return 0
}

EmptyMem(PID="AHK Rocks"){
    pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Etc~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;``````````````````````````Registry stuff``````````````````````````
checkcontext()
{
	RegRead, RegInstalled, HKEY_CLASSES_ROOT, *\shell\PEM
	if(errorlevel=1)
		return 0
	Else
		return 1
}

ContextState:
if(checkContext()=1)
	goto _isInstalled
Else
	goto _notInstalled

install:
if(!A_Iscompiled and !DontCare)
{	Traytip,Script is not compiled,PEM is currently not compiled so the registry key will give an error.`nIt will still be created for debugging purposes but will not work.,10,2
	DontCare=1
}
RegWrite, REG_SZ, HKEY_CLASSES_ROOT, *\shell\PEM\,,Open with PEM
RegWrite, REG_SZ, HKEY_CLASSES_ROOT, *\shell\PEM\command,,`"%A_scriptfullpath%`" `"`%1`"
_isInstalled:
Guicontrol 1:, contextbutton, Remove Context
Menu, tray, enable, Remove context
Menu, Tray, disable, Install context
Menu, Tray, Tip, PEM - Context is installed
return

remove:
Regdelete, HKEY_CLASSES_ROOT, *\shell\PEM
_notInstalled:
Guicontrol 1:, contextbutton, Install Context
Menu, tray, disable, Remove context
Menu, Tray, enable, Install context
Menu, Tray, Tip, PEM - Context is not installed
return

;``````````````````````````Other``````````````````````````
	;Updates the drop down list of previously used paths
updateCombo(choose="")
{	global
	gui 1: default
	CB_String=
	Loop, % LV_GetCount()
	{	LV_GetText(TempVar,A_Index,2)
		CB_String:=CB_String . TempVar . "|"
	}
	Sort, CB_String,D| U Z
	if not choose
		return CB_String
	CB_String.="|"
	Ifinstring, CB_String,%choose%
		StringReplace, CB_String,CB_String,%choose%|,%choose%||
;~ 	if substr(CB_String,StrLen(CB_String),1)="|"
	return CB_String
}

removetraytip:
traytip
return

exittime:
iniread, TempVar, %INIFILE%, config, silentMode, 0
if(TempVar=1)
{	Regdelete, HKEY_CLASSES_ROOT, *\shell\PEM
	ExitApp
}
Iniread, TempVar, %INIFILE%, config, checkregistry
if(TempVar!=0)
{
	if(checkContext()=1)
	{ 	gui 1: +owndialogs
		;Yes = Remove context then quit`nNo = Quit without removing`nCancel = Do not remove or quit	
		msgbox,51,Context still installed,The context is still installed. Do you want to remove it before quitting?
		ifmsgbox, Yes
			gosub remove
		else ifmsgbox, Cancel
			Return
	}
}
exitapp

#include PEM_run.ahk
#include AdjustResize.ahk