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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Menus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;Tray menu
if(A_IsCompiled=1)
	Menu, Tray, NoStandard
menu, tray, Click, 1
Menu, Tray, Tip, Poem - %@Context_is_installed%
Menu, Tray, add, Show, mShowPoem
if(islabel("Dropper_Show"))
	Menu, Tray, add, Dropper, Dropper_Show
Menu, Tray, add, %@Install%, Install
Menu, Tray, add, %@Uninstall%, Remove
Menu, Tray, add, %@About_Poem%, ShowAbout
Menu, Tray, add, %@Exit%, Exittime
Menu, Tray, default,Show
	; ? button menu
Menu, main, add, %@Silent_Mode%,msilentmode
Menu, main, add, %@Start_in_tray%,mstartintray
Menu, main, add, %@Check_programs_on_start%, mcheckprogramsonstart
Menu, main, add, %@Check_registry_on_exit%, mcheckregonexit
Menu, main, add, %@Show_Balloon_Tip%, mShowBalloonTip
Menu, main, add, %@Start_with_Dropper%, mDropperOnStart
Menu, main, add
Menu, main, add, %@About_Poem%, showabout
Menu, main, add, %@Check_for_update%, Update
Menu, main, add, %@View_Readme%, mreadme
	loop, Parse, LOCALES, |
		Menu, locale, add, % A_LoopField,ChangeLocale
	Menu, locale, check, %LANG%
Menu, main, add, %@Language%,:locale
Menu, main, add, %@Show_Dropper%, Dropper_show
Menu, main, add, %@Exit%, exittime
	;PathSelect button
Menu, pathselect, add, %@Relative_to_Disk%, gRelativeToDisk
Menu, pathselect, add, %@Relative_to_Poem%, gRelativeToPoem

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Main GUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gui 1: +resize +minsize
Gui 1: +LastFound
POEM_ID:=WinExist()
LVw:=ButtonWidth(@Add)+ButtonWidth(@Edit)+ButtonWidth(@Remove)+55+ButtonWidth(@Install, @Uninstall)+20+20+30
if(LVw<365)
	LVw:=365
gui 1: 	add,	listview, 		w%LVw% 	r10 					vListViewVar	ggListView -multi +sort, 	|%@Extension%|%@Program%
gui 1:	add,	listview, xp yp	wp		hp		hidden			vListViewVar2	, WorkingDir|Arguments	;BoooOOOooo! Hidden listview!
Gui, listview, ListviewVar
guicontrolget, V_, pos, ListViewVar
V_H+=10
gui 1: 	add,	button,% "-wrap	w" . ButtonWidth(@Add) . "	x15		y" . V_H . " vnewbutton		ggButtonNew",		%@Add%
gui 1:	add,	button,% "-wrap	w" . ButtonWidth(@Edit) . "	xp+" . ButtonWidth(@Add)+5 . "	yp			 vEditButton	ggListViewEnter",	%@Edit%
gui 1: 	add,	button,% "-wrap	w" . ButtonWidth(@Remove) . "	xp+" . ButtonWidth(@Edit)+5 . " 	yp			 vdelbutton 	ggButtonRemove",	%@Remove%
V_H+=3
gui 1: add, button,% "-wrap x" . LVw-15 . " yp+3 w23 h23 ggmainmenu vMenuButton",?
gui 1: font, underline w600 
gui 1: add, Button,% "-wrap xp-" ButtonWidth(@Install, @Uninstall)+7 . " yp w" . ButtonWidth(@Install, @Uninstall)+5 .  " ggToggleContext vcontextbutton",%@Install%
gui 1: font
	;SLOW SPOT - 20ms
;drivelist=Poem|A:|B:|C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Y:|Z:|
Driveget, drivelist, list
tempvar=
loop, parse, drivelist
	tempvar .= A_LoopField . ":|"
drivelist:=tempvar
stringreplace, drivelist,drivelist,%drv%,%drv%|
V_H-=3
Gui 1:	add,	dropdownlist,% "w50 	r7 		xp-" . 50+5 . " yp+1 	vdrivelist 		ggDriveList",				%Drivelist%
V_H+=2

	;SLOW SPOT - 40 MS
ImageListID := IL_Create(2)
Gui, listview, ListviewVar
LV_SetImageList(ImageListID)
if(A_IsCompiled)
{
	IL_Add(ImageListID,A_ScriptName,3)
	IL_Add(ImageListID,A_ScriptName,4)
} else {
	IL_Add(ImageListID,"res\checkmark.ico")
	IL_Add(ImageListID,"res\xmark.ico")
}
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Add/Edit extension~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gui 2: default
Gui 2: +owner1
Gui 2: +resize +minsize
GB_H=105
OK_Y:=GB_H+5
CB_W=575

Gui 2:	Add,	groupbox,	x5	 	y1 		w%CB_W% h%GB_H%	vgroupbox2					,%@Add%
Gui 2:	Add,	Picture,	xp+5	yp+25	w32 h32			vIconStatus	hidden			,
Gui 2:	Add,	text,		xp+40 	yp-5												,%@Extension%
Gui 2:	Add,	Edit,		xp		yp+15	w100 			vExtVar
Gui 2:	Add,	text,		xp+110	yp-15												,%@Program%
	;SLOW SPOT - 20ms
Gui 2:	Add,	combobox,%	"xp	yp+15	w" . CB_W-200 . "	vPathVar	ggCheckStatus"
Gui 2:	Add,	Button,% "-wrap xp+" . CB_W-200+5 . "	yp-1	w35 		vpathButton	ggpathselect",... ;…
Gui 2:	Add,	Button,% "-wrap x70		yp+30	w" . ButtonWidth(@Advanced . " >>") . " vExpandHelp	ggExpandHelp	",%@Advanced% >>

Gui 2:	Add,	Text,		xp+20	yp+30					vArgumentText	hidden		,%@Arguments%
Gui 2:	Add,	Edit,		xp		yp+20	w230			vArguments		hidden		,`%1
Gui 2:	Add,	Text,		xp+270	yp-20					vWorkingDirTxt	hidden		,%@Working_Directory%
Gui 2:	Add,	groupbox,	xp		yp+10	w200	r1		vWorkingDirGB	hidden
Gui 2:	Add,	Radio,	-wrap xp+7	yp+15					vWorkingDir		hidden		,%@Program%
Gui 2:	Add,	Radio,	-wrap xp+100	yp					vWorkingDir2	hidden		,%@File%


gui 2: 	Add,	Text,		x75		yp+30	w475			vHelp		hidden			,%@Help%`n`t%@Example1%`n`t`t%@Example1A%`n`t`t%@Example1B%`n`t%@Example2%`n`t`t%@Example2A%`n`t`t%@Example2B%`n%@Help2%
guicontrolget, TempVar_, pos, WorkingDirGB
guicontrolget, TXT_, pos, Help
TXT_H+=TempVar_H+20
Gui 2:	Add,	Button,% "-wrap x" . CB_W-ButtonWidth(@Cancel) . " y" . OK_Y . " w" . ButtonWidth(@Cancel) . " vcancel2button		g2ButtonCancel",%@Cancel%
Gui 2:	Add,	Button,% "-wrap xp-" . ButtonWidth(@OK)+5 . " yp w" . ButtonWidth(@OK) . " vok2button 	g2ButtonOk default",%@OK%
