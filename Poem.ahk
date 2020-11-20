/*
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~Poem version 2.0~~~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~Copyright Qweex 2009-2015~~~~~~~~~~~~~~~
	~~~Distributed under the GNU General Public License~~~
	~~~~~~~~~~~~~~~~~http://www.qweex.com~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~MrQweex@qweex.com~~~~~~~~~~~~~~~~~~
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    This file is part of Poem.

    Poem is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Poem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with StartupSaver.  If not, see <http://www.gnu.org/licenses/>.
*/

About_Name=Poem
About_Version=2.0
About_DateLaunch=2009
About_Date=2012
About_CompiledDate=02/06/2012

#SingleInstance off
#NoTrayIcon		;Leave this in here so the tray icon won't flicker if another Poem is started.
INIFILE=Poem.ini
SetWorkingDir, %A_ScriptDir%
LOCALES=English|Italiano
	;SLOW SPOT - 20ms
#Include res\Locale.ahk
#Include res\Update.ahk


if(Strlen("​")=1)
	SORTCHAR:="​"    ;Use Zero Width Space for the sort character if Unicode is supported
else
	SORTCHAR:=A_Space
HASH:=MD5(A_WorkingDir,StrLen(A_WorkingDir))
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Argument Mode~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hands any files passed as arguments~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(%0%>0) {
	gosub Argmode
	exitapp
}

NoArgs:
if A_IsCompiled
	Menu, tray, icon, % A_ScriptFullpath
Menu, tray, icon
;iniread, drv, Poem.ini,	config,	drive, Poem
ini_load(INI_VAR, INIFILE)
drv := ini_read(INI_VAR, "config","drive","Poem")
#include Poem_gui.ahk		;80ms
#include Poem_Dropper.ahk	;20ms
AfterDropper:


;``````````````````````````Config options in INI``````````````````````````
;Iniread, TempVar, %INIFILE%, config, checkRegistry,1
TempVar := ini_read(INI_VAR, "config","CheckRegistry","1")
if(TempVar = "" or not TempVar = 0)
	Menu, main, check,%@Check_Registry_On_Exit%

;Iniread, checkPrograms, %INIFILE%, config, checkPrograms,0
checkPrograms := ini_read(INI_VAR, "config","CheckPrograms","0")
if(checkPrograms = "" or not checkPrograms = 0)
	Menu, main, check,%@Check_programs_on_start%

;Iniread, startintray, %INIFILE%, config, startInTray,0
startintray := ini_read(INI_VAR, "config","startintray","0")
if(startintray = "" or not startintray = 0)
	Menu, main, check,%@Start_in_tray%

;Iniread, showBalloon, %INIFILE%, config, showBalloon,1
showBalloon := ini_read(INI_VAR, "config","showBalloon","1")
if(showBalloon!=0)
{	Menu, main, check, %@Show_balloon_tip%
	showBalloon=1
}


;iniread, silentMode, %INIFILE%, config, silentMode, 0
silentMode := ini_read(INI_VAR, "config","silentMode","0")
if(silentMode=1)
{	Menu, main, check, %@Silent_Mode%
	Menu, main, disable, %@Check_registry_on_exit%
	Menu, main, disable, %@Show_Balloon_tip%
	Menu, main, disable, %@Check_programs_on_start%
	Menu, main, disable, %@Start_in_tray%
	gosub install
}
else
	gosub contextState

;``````````````````````````"First Time" message``````````````````````````
;iniread, firstTime, %INIFILE%, config, firstTime
firstTime := ini_read(INI_VAR, "config","firstTime","0")
if(firstTime!=0)
{	gui 1: +owndialogs
	msgbox, 68, %@Read_the_manual%, %@First_Time_Message%`n`n-MrQweex		
	ifmsgbox, Yes
		gosub mReadme
	iniwrite, 0, %INIFILE%, config, firstTime
}

;``````````````````````````Add Entries``````````````````````````
gui 1: default
;iniread, 		drv, 		Poem.ini,		config,		drive,	Poem
drv := drv = "Poem" ? SubStr(A_ScriptDir,1,2) : drv
;iniread, TempVar, %INIFILE%, config, filetypes,:
TempVar := ini_read(INI_VAR, "config","filetypes",":")
if(TempVar!=":")
{
	Num=
	loop, parse, TempVar, |
	{
		Program := ini_read(INI_VAR, "." . A_LoopField,"Program","ERROR")
		WorkingDir := ini_read(INI_VAR, "." . A_LoopField,"WorkingDir","ERROR")
		Arguments := ini_read(INI_VAR, "." . A_LoopField,"Arguments","ERROR")
		
		if(checkPrograms=1 and silentmode!=1 and !FileExist(Determine(program,drv)) and warned!=1)
		{	traytip,,%@Missing_Program_Message%
			Settimer, removetraytip, -5000
			Warned=1
		}
		DoesExist=2
		IfExist, % Determine(Program,drv)
			DoesExist--
		Num.=SORTCHAR
		LV_Add("Icon" . DoesExist,Num,A_LoopField,Program)
		Gui, listview, ListviewVar2
		LV_Add("",WorkingDir,Arguments)
		Gui, listview, ListviewVar
	}
	LV_Modifycol(1,20)
	LV_ModifyCol(2,"autohdr")
	LV_ModifyCol(3,"autohdr")
}
if(silentMode!=1 and startintray!=1)
	gui 1: show, autosize, Poem - %@Portable_Extension_Manager%
else if(startintray==1 and silentmode!=1)
	gosub guiclose
	
;iniread, TempVar, %INIFILE%, config, startDropper
TempVar := ini_read(INI_VAR, "config","startDropper","0")
if(TempVar)
{	Menu, main, check, %@Start_with_Dropper%
	gosub Dropper_show
}


Hotkey, ifwinactive, ahk_id %POEM_ID%
Hotkey, ^n, gButtonNew
Hotkey, Enter,gListViewEnter
Hotkey, Delete, gButtonRemove
Hotkey, ^i, gToggleContext

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
	if(selectedRow!>0)
		return
	goto _showGUI2
gListViewEnter:
	selectedRow:=LV_GetNext(0, "Focused")
	if(selectedRow=0 or !LV_GetCount("Selected"))
		Return
_showGUI2:
	LV_GetText(ExtVar, selectedRow,2)
	LV_GetText(PathVar, selectedRow,3)
		Gui, listview, ListviewVar2
		LV_GetText(DirVar,selectedRow,1)
		LV_GetText(ArgVar,selectedRow,2)
	Gui, listview, ListviewVar
	Guicontrol 2:, groupbox2, %@Edit_Extension% - %ExtVar%
	GuiControl 2:, ExtVar, %ExtVar%
	GuiControl 2:, PathVar, % updatecombo(PathVar)
	gosub, gCheckStatus
	if(DirVar)
		GuiControl 2:, WorkingDir,1
	else
		GuiControl 2:, WorkingDir2,1

	GuiControl 2:, Arguments, %ArgVar%
	Gui 2: show, autosize,%@Edit_Extension%
	if !GUIW
	{
		gui 2: +LastFound
		Wingetpos,,,GUIW
	}
return

gButtonNew:
	gui 1: +disabled
	selectedRow=0
	Guicontrol 2:, PathVar,% updatecombo()
	guicontrol 2:, ExtVar,
	Guicontrol 2:, groupbox2, %@New_Extension%
	guicontrol 2:, WorkingDir,1
	guicontrol 2:, Arguments,`%1
	gosub, gCheckStatus
	gui 2: show, autosize,%@New_Extension%
	gui 2: default
	if !GUIW
	{
		gui 2: +LastFound
		Wingetpos,,,GUIW
	}
return

gButtonRemove:
	gui 1: default
	selectedRow:=LV_GetNext("Selected")
	if(selectedRow=0)
		return
	LV_GetText(ExtVar,selectedRow,2)
	LV_Delete(selectedRow)
	if(selectedRow=LV_GetCount() + 1)
		LV_Modify(selectedRow - 1, "Select")
	Else
		LV_Modify(selectedRow, "Select")
	Inidelete, %INIFILE%, .%ExtVar%
	gosub WriteFiletypes
return

gDriveList:
	gui 1:submit, nohide
	iniwrite, %driveList%, %INIFILE%, config, drive
	loop,% LV_GetCount()
	{
		LV_GetText(program, A_Index, 3)
		if(FileExist(Determine(program,drivelist)))
			LV_Modify(A_Index, "+Icon1")
		else
			LV_Modify(A_Index, "+Icon2")
	}
	;!!!
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
	menPos_x+=menPos_w+5
	Menu, main, show,%menPos_x%,%menPos_y%
return

;``````````````````````````GUI 2: Add/Edit``````````````````````````
	;For the "..." button
gPathSelect:
	gui 2: default
	guicontrolget, menpos_, pos, PathButton
	menPos_x+=menPos_w+5
	Menu, pathselect, show, %menPos_x%, %menPos_y%
return

gRelativeToDisk:
gRelativeToPoem:
	gui 2: +OwnDialogs
	FileselectFile, PathVar,,,%@Select_Program%
	if(PathVar="")
		Return
	if(A_ThisLabel="gRelativeToDisk")
	{
		Splitpath, PathVar,part2,part1,,,part0
		msgbox, %part2%`n%part1%`n%part0%
		if(strlen(part1)>2)
		{	Stringreplace, part1, part1, %part0%\,
			PathVar:=part1 . "\" . part2
		} else
			PathVar:=part2
	} else {
		PathVar:=RelativeAte(PathVar)
		if(!PathVar)
			msgbox,, WARNING, Paths relative to Poem must be on the same drive!		;DEBUG
	}
	Guicontrol 2:,PathVar,%PathVar%||

gCheckStatus:
	gui 2: submit, nohide
	TempPath:=Determine(PathVar,drv = "ERROR" ? SubStr(A_scriptdir,1,2) : drv)
	if(TempPath=0)
		guicontrol 2: +hidden,IconStatus
	else
	{	guicontrol 2: -hidden,IconStatus
		if(FileExist(TempPath) && !InStr(FileExist(TempPath),"D"))
			guicontrol 2:,IconStatus, icons\checkmark.ico
		else
			guicontrol 2:,IconStatus, icons\xmark.ico	
	}
	if(PathVar="")
		guicontrol 2:disabled,ok2button
	Else
		guicontrol 2:enabled,ok2button
return

gExpandHelp:
	gui 2: default
	guicontrol,,ExpandHelp, %@Advanced% vv
	guicontrol, -hidden, ArgumentText
	guicontrol, -hidden, Arguments
	guicontrol, -hidden, WorkingDirTxt
	guicontrol, -hidden, WorkingDirGB
	guicontrol, -hidden, WorkingDir
	guicontrol, -hidden, WorkingDir2
	guicontrol, -hidden, Help
	guicontrol,move,groupbox2,% "h" . GB_H+TXT_H
	guicontrol,move,ok2button,% "y" . OK_Y+TXT_H
	guicontrol,move,cancel2button,% "y" . OK_Y+TXT_H
	guicontrol,+ggHideHelp,ExpandHelp
	gui 2: show, autosize
	Gui 2: +Minsize +Minsize%GUIW%x
return

gHideHelp:
	gui 2: default
	guicontrol,,ExpandHelp, %@Advanced% >>
	guicontrol, +hidden, ArgumentText
	guicontrol, +hidden, Arguments
	guicontrol, +hidden, WorkingDirTxt
	guicontrol, +hidden, WorkingDirGB
	guicontrol, +hidden, WorkingDir
	guicontrol, +hidden, WorkingDir2
	guicontrol, +hidden, Help
	guicontrol,move,groupbox2,% "h" . GB_H
	guicontrol,move,ok2button,% "y" . OK_Y
	guicontrol,move,cancel2button,% "y" . OK_Y
	guicontrol,+ggExpandHelp,ExpandHelp
	Gui 2: -Minsize
	gui 2: show, autosize
	Gui 2: +Minsize +Minsize%GUIW%x
return


2ButtonOk:
	Gui 2:submit, nohide
	if(selectedRow=0 and CheckIfDupe(ExtVar)=1)
	{	gui 2: +owndialogs
		msgbox,,%@Extension_already_set%,%@Already_A_Program_Message% %ExtVar%.
		Return
	}
	gui 2: hide
	if(SubStr(ExtVar,1,1)=".")
		ExtVar:=SubStr(ExtVar,2)
	IniWrite, %PathVar%, 	%INIFILE%, .%ExtVar%,program
	iniwrite, %WorkingDir%, %INIFILE%, .%ExtVar%,workingdir
	iniwrite, %arguments%, %INIFILE%, .%ExtVar%,arguments
	DoesExist=2
	IfExist, % Determine(PathVar,drv)
		DoesExist--
	gui 1: default
	if(selectedRow=0)
	{
		LV_Add("Icon" . DoesExist,Num,ExtVar,PathVar)
		Gui, listview, ListviewVar2
		LV_Add("",WorkingDir,Arguments)
		Gui, listview, ListviewVar
	}
	Else
	{
		LV_Modify(selectedRow,"Icon" . DoesExist,"",ExtVar,PathVar)
		Gui, listview, ListviewVar2
		LV_modify(selectedrow,"",WorkingDir,Arguments)
		Gui, listview, ListviewVar
	}
gosub, WriteFiletypes

2ButtonCancel:
	gui 1: -Disabled
	gui 2: hide
	gui 1: show
return


;``````````````````````````GUI 3: About``````````````````````````
gEmail:
	run, mailto:%EMAIL%
return

gWebsite:
	run, %WEBSITE%
return

;``````````````````````````Menu glabels``````````````````````````
mShowPoem:
if(ismax=1)
	gui 1: show, Maximize, Poem - %@Portable_Extension_Manager%
else
	gui 1: show,, Poem - %@Portable_Extension_Manager%
Return

mShowAbout:
	gui 3: show, autosize, %@About_Poem%
Return

mReadme:
	ifnotexist, readme.txt
	{ 	gui 1: +owndialogs	
		msgbox,48,%@File_Not_Found%, %@The_Readme_does_not_seem_to_exist%
		Return
	}
	run, readme.txt
return

	;Handles the "Silent Mode" Menu option
mSilentMode:
	iniread, TempVar, %INIFILE%, config, silentMode,0
	ifequal, TempVar, 0
	{	Menu, main, check, %@Silent_Mode%
		Menu, main, disable, %@Check_registry_on_exit%
		Menu, main, disable, %@Show_Balloon_tip%
		Menu, main, disable, %@Check_programs_on_start%
		Menu, main, disable, %@Start_in_tray%
		iniwrite, 1, %INIFILE%, config, silentMode
	}
	else
	{	Menu, main, uncheck, %@Silent_Mode%
		Menu, main, enable, %@Check_registry_on_exit%
		Menu, main, enable, %@Show_Balloon_tip%
		Menu, main, enable, %@Check_programs_on_start%
		Menu, main, enable, %@Start_in_tray%
		iniwrite, 0, %INIFILE%, config, silentMode
	}
return

mCheckProgramsOnStart:
	Iniread, TempVar, %INIFILE%, config, checkPrograms,0
	ifequal, TempVar, 0
	{	Menu, main, check, %@Check_programs_on_start%
		iniwrite, 1, %INIFILE%, config, checkprograms
	}
	Else
	{	Menu, main, uncheck, %@Check_programs_on_start%
		iniwrite, 0, %INIFILE%, config, checkprograms
	}
return

mCheckRegOnExit:
	Iniread, TempVar, %INIFILE%, config, checkRegistry,1
	ifequal, TempVar, 0
	{	Menu, main, check, %@Check_registry_on_exit%
		iniwrite, 1, %INIFILE%, config, checkregistry
	}
	Else
	{	Menu, main, uncheck, %@Check_registry_on_exit%
		iniwrite, 0, %INIFILE%, config, checkregistry
	}
return

mStartInTray:
	Iniread, TempVar, %INIFILE%, config, startInTray,0
	ifequal, TempVar, 0
	{	Menu, main, check, %@Start_in_tray%
		iniwrite, 1, %INIFILE%, config, startInTray
	}
	Else
	{	Menu, main, uncheck, %@Start_in_tray%
		iniwrite, 0, %INIFILE%, config, startInTray
	}
return

	;Toggles Dropper to start with Poem
mDropperOnStart:
	Iniread, TempVar, %INIFILE%, config, startDropper,0
	ifequal, TempVar, 0
	{	Menu, main, check, %@Start_with_Dropper%
		iniwrite, 1, %INIFILE%, config, startDropper
	}
	Else
	{	Menu, main, uncheck, %@Start_with_Dropper%
		iniwrite, 0, %INIFILE%, config, startDropper
	}
return

	;Checks if the balloon tip is enabled
mShowBalloonTip:
	iniread, showBalloon, %INIFILE%, config, showBalloon,1
	if(showBalloon=0)
	{ 	menu, main, check, %@Show_balloon_tip%
		iniwrite, 1, %INIFILE%, config, showBalloon
	}
	else
	{	Menu, main, uncheck, %@Show_balloon_tip%
		iniwrite, 0, %INIFILE%, config, showBalloon
	}
return

;``````````````````````````GUI Events``````````````````````````
guiclose:
	iniread, showBalloon, %INIFILE%, config, showBalloon,1
	iniread, silentMode, %INIFILE%, config, silentMode,0
	if(showBalloon!=0 and silentMode!=1 and balloonShown!=1)
	{ 	traytip,,%@Tray_Love_Message%,,16
		Settimer, removetraytip, -3000
		balloonShown=1
	}
	WinGet, IsMax, MinMax, Poem - %@Portable_Extension_Manager%
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
	AdjustResize("ListViewVar","wh")
	AdjustResize("newbutton","y")
	AdjustResize("editbutton","y")
	AdjustResize("delbutton","y")
	AdjustResize("drivelist","xy")
	AdjustResize("contextbutton","xy")
	AdjustResize("menubutton","xy")
	Winset, redraw,,ahk_id %Poem_ID%
return

2GuiSize:
	AdjustResize("groupbox2","wh")
	AdjustResize("WorkingDirTxt","x")
	AdjustResize("WorkingDirGB","x")
	AdjustResize("WorkingDir","x")
	AdjustResize("WorkingDir2","x")
	AdjustResize("PathVar","w")
	AdjustResize("pathbutton","x")
	AdjustResize("Arguments","w")
	AdjustResize("ok2button","xy")
	AdjustResize("cancel2button","xy")
	gui 2: +lastfound
	Winset, redraw
return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;Checks if extension already has a program
CheckIfDupe(newextension)
{	
	gui 1: default
	loop, % LV_GetCount()
	{	LV_GetText(checkit,A_Index,2)
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
	global HASH
	RegRead, RegInstalled, HKEY_CLASSES_ROOT, *\shell\Poem %HASH%
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
return

install:
	if(!A_Iscompiled and !DontCare)
	{	Traytip,Script is not compiled,Poem is currently not compiled so the registry key will give an error.`nIt will still be created for debu​gging purposes but will not work.,10,2
		DontCare=1
	}
	;if not A_IsAdmin
	;{
	;   DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath
	;      , str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
	;   ExitApp
	;}
	StringSplit, Array, A_ScriptDir,\
	Dir:=Array%Array0%
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, *\shell\Poem %HASH%\,,Poem [%dir%]		;@Open_with_Poem
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, *\shell\Poem %HASH%\command,,`"%A_scriptfullpath%`" `"`%1`"
	_isInstalled:
	Guicontrol 1:, contextbutton, %@Uninstall%
	Guicontrol 1:+gremove, contextbutton
	Menu, tray, enable, %@Uninstall%
	Menu, Tray, disable, %@Install%
	Menu, Tray, Tip, Poem - %@Context_is_installed%
return

remove:
	Regdelete, HKEY_CLASSES_ROOT, *\shell\Poem %HASH%
	_notInstalled:
	Guicontrol 1:, contextbutton, %@Install%
	Menu, tray, disable, %@Uninstall%
	Menu, Tray, enable, %@Install%
	Menu, Tray, Tip, Poem - %@Context_is_not_installed%
	Guicontrol 1:+ginstall, contextbutton
return

;``````````````````````````Other``````````````````````````
	;Updates the drop down list of previously used paths
updateCombo(choose="")
{	global
	gui 1: default
	CB_String=
	Loop, % LV_GetCount()
	{	LV_GetText(TempVar,A_Index,3)
		CB_String:=CB_String . TempVar . "|"
	}
	Sort, CB_String,D| U Z
	if not choose
		return CB_String
	CB_String.="|"
	Ifinstring, CB_String,%choose%
		StringReplace, CB_String,CB_String,|%choose%|,|%choose%||
;~ 	if substr(CB_String,StrLen(CB_String),1)="|"
	return CB_String
}

WriteFiletypes:
	Str=
	Num=SORTCHAR
	loop, % LV_GetCount()
	{
		LV_GetText(TempVar,A_Index,2)
		Str.= "|" . TempVar
		Num.=SORTCHAR
	}
	iniwrite,% SubStr(Str,2), %INIFILE%, config, filetypes
return

GetFullPath(ShortPathName)
{
	Loop %ShortPathName%
		LongName = %A_LoopFileLongPath%
	if(LongName)
		return Longname
	return ShortPathName
}

removetraytip:
	traytip
return

ChangeLocale:
	iniwrite, %A_ThisMenuItem%,%INIFILE%,config,Language
reload

exittime:
	iniread, TempVar, %INIFILE%, config, silentMode, 0
	if(TempVar=1)
	{	Regdelete, HKEY_CLASSES_ROOT, *\shell\Poem %HASH%
		ExitApp
	}
	Iniread, TempVar, %INIFILE%, config, checkregistry
	if(TempVar!=0)
	{
		if(checkContext()=1)
		{ 	gui 1: +owndialogs
			;Yes = Remove context then quit`nNo = Quit without removing`nCancel = Do not remove or quit	
			msgbox,51,%@Context_still_installed%,%@Context_Installed_Message%
			ifmsgbox, Yes
				gosub remove
			else ifmsgbox, Cancel
				Return
		}
	}
exitapp

#include Poem_run.ahk
#include res\AdjustResize.ahk
#include res\Relativeate.ahk
#include res\OtherFunctions.ahk
#include res\Debug.ahk
#include AboutWindow.ahk