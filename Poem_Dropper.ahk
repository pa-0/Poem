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

MINDROPPERSIZE=32

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INIRead~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Dropper_alpha := ini_read(INI_VAR, "Dropper","alpha","4")
Dropper_width := ini_read(INI_VAR, "Dropper","width","100")
Dropper_height := ini_read(INI_VAR, "Dropper","height","100")
Dropper_color := ini_read(INI_VAR, "Dropper","color","1")
Dropper_icon := ini_read(INI_VAR, "Dropper","icon","dropper")
Dropper_status := ini_read(INI_VAR, "Dropper","status","1")
Dropper_OnTop := ini_read(INI_VAR, "Dropper","OnTop","1")
Dropper_noMove := ini_read(INI_VAR, "Dropper","noMove","0")
Dropper_show := ini_read(INI_VAR, "Dropper","showonstart","0")
Dropper_same := ini_read(INI_VAR, "Dropper","same","0")

if(Dropper_width<MINDROPPERSIZE)
	Dropper_width:=MINDROPPERSIZE
if(Dropper_height<MINDROPPERSIZE)
	Dropper_height:=MINDROPPERSIZE
ifnotexist, %Dropper_icon%.ico
	Dropper_icon=Dropper
Dropper_resize=0
DropperColors1=%@Default%
DropperColors2=%@White%
DropperColors3=%@Black%
;DropperColors4=%@Transparent%

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Menus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;``````````````````````SubMenus``````````````````````
Menu, iconsMenu, add, Poem, mDropper_icon
Menu, iconsMenu, add, Dropper, mDropper_icon
Menu, iconsMenu, add, Simple, mDropper_icon
Menu, iconsMenu, check,%Dropper_icon%
Menu, alphaMenu, add, 1,mDropper_alpha
Menu, alphaMenu, add, 2,mDropper_alpha
Menu, alphaMenu, add, 3,mDropper_alpha
Menu, alphaMenu, add, 4,mDropper_alpha
Menu, alphaMenu, add, 5,mDropper_alpha
Menu, alphaMenu, add, 6,mDropper_alpha
Menu, alphaMenu, add, 7,mDropper_alpha
	Menu, alphaMenu, check, % Dropper_alpha
Menu, colorMenu, add, %@Default%, mDropper_Color
menu, colorMenu, add, %@White%, mDropper_color
menu, colorMenu, add, %@Black%, mDropper_Color
;menu, colorMenu, add, %@Transparent%, mDropper_Color
	Menu, colorMenu, check,% DropperColors%Dropper_Color%

;``````````````````````MainMenus``````````````````````
Menu, DropperMenu, add, %@Enabled%,mDropper_Toggle
if(Dropper_status=1)
	Menu, DropperMenu, check, %@Enabled%
Menu, DropperMenu, add, %@Always_On_Top%, mDropper_OnTop
if(Dropper_ontop=1)
	Menu, DropperMenu, check, %@Always_On_Top%
Menu, DropperMenu, add, %@Lock_Position%, mDropper_NoMove
;~ if(Dropper_nomove=1)
;~ 	Menu, DropperMenu, check, Lock Position
Menu, DropperMenu, add
Menu, DropperMenu, add, %@Icon%, :iconsMenu
Menu, DropperMenu, add, %@Resize%,mDropper_resize
Menu, DropperMenu, add, %@Transparency%, :alphaMenu
Menu, DropperMenu, add, %@Background%, :colorMenu
Menu, DropperMenu, add
Menu, DropperMenu, add, %@Show%, mShowPoem
if(A_Scriptname!="Poem_Dropper.ahk")
	Menu, DropperMenu, add, Poem, :main
Menu, DropperMenu, add, %@Close%,mDropper_close
Holy=EEEEEE

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(Dropper_OnTop=1)
	Gui 10: +alwaysontop
Gui 10: -Caption +ToolWindow -0x800000 -resize +Lastfound
WinSet, TransColor, %HOLY%
Gui 10: add, picture, ggDropper_Move x0 y0 w%Dropper_width% h%Dropper_height% vvDropper_pic ;,%Dropper_icon%.ico
Gui 10: font, s7 w700 CRed,Courier
Gui 10: add, text,% "vvDropper_hiddentext x2 y" . (Dropper_height-14) backgroundtrans,[%@disabled%]
if(Dropper_status!=0)
	guicontrol 10: +hidden, vDropper_Hiddentext
else
	gui 10: -E0x10
if(Dropper_color=4)
	Gui 10: Color, %HOLY%
else
	Gui 10: Color,% DropperColors%A_ThisMenuItempos%
Gui 10: +LastFound
Dropper_ID:=WinExist()
	
Gui 20: +toolwindow +owner10 +alwaysontop
Gui 20: add, text, x5 y5, w
Gui 20: add, edit, xp+12 yp-3 w40 vvDropper_editwidth ggDropper_editwidth, %Dropper_Width%
Gui 20: add, text, xp-12 yp+30, h
Gui 20: add, edit, xp+12 yp-3 w40 vvDropper_editheight, %Dropper_Height%
Gui 20: add, checkbox, x65 y3 w40 h20 +0x1000 vvDropper_same ggDropper_same Checked%vDropper_same%,Same
if(vDropper_same=1) {
;~ 	guicontrol 20:,vDropper_same,1
	guicontrol 20: disable, vDropper_editheight
	guicontrol 20:, vDropper_editheight, %Dropper_Width%
}
Gui 20: add, button, x0 y0 w0 h0 default vvDropper_hiddenbutton ggDropper_hiddenbutton

goto AfterDropper



Dropper_Show:
	ifwinexist, ahk_id %Dropper_ID%
		goto mDropper_close
	guicontrol 10:,vDropper_pic,%Dropper_icon%.ico
	Menu, main, check, %@Show_Dropper%
	Menu, tray, check, Dropper
	Gui 10: show, w%Dropper_width% h%Dropper_height%
	Winset, Trans,% Round((Dropper_Alpha * 35) + 10),ahk_id %Dropper_ID%
return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GLabels~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;`````````````````````````````Menu Labels`````````````````````````````
mDropper_alpha:
	Loop, 7
	{	if(A_thismenuitem=A_Index)
			Menu,alphaMenu, check, %A_Index%
		Else
			Menu,alphaMenu, uncheck, %A_Index%
	}
	Winset, Trans,% (A_ThisMenuItem * 35) + 10, ahk_id %Dropper_ID%
	iniwrite,%A_ThisMenuItem%, %INIFILE%, Dropper, alpha
return

mDropper_Close:
	Menu, main, uncheck, %@Show_Dropper%
	Menu, tray, uncheck, Dropper
	gui 20: hide
	gui 10: hide
return

mDropper_Color:
	Menu, colorMenu, uncheck, %@Default%
	Menu, colorMenu, uncheck, %@White%
	Menu, colorMenu, uncheck, %@Black%
	;Menu, colorMenu, uncheck, %@Transparent%
	Menu, colorMenu, check, %A_ThisMenuItem%
	Dropper_color:=A_ThisMenuItempos
	if(Dropper_color=4)
	{
		Gui 10: Color, %HOLY%
		WinSet, TransColor, %HOLY%
	}
	else
		Gui 10: Color,% DropperColors%A_ThisMenuItempos%
	iniwrite, %Dropper_Color%, %INIFILE%, Dropper,Color
return

mDropper_icon:
	Menu, iconsMenu, uncheck,%Dropper_icon%
	Menu, iconsMenu, check, %A_ThisMenuItem%
	Dropper_icon := A_ThisMenuItem
	iniwrite, %Dropper_icon%, %INIFILE%, Dropper,Icon
	gui 10: default
	guicontrol 10:,vDropper_pic,%Dropper_icon%.ico
return

mDropper_OnTop:
	Winset, Alwaysontop, toggle, ahk_id %Dropper_ID%
	Menu, DropperMenu, togglecheck, %@Always_On_Top%
	iniwrite,% Dropper_OnTop := Dropper_OnTop = 1 ? 0 : 1,%INIFILE%, Dropper, OnTop
return

mDropper_NoMove:
	Menu, DropperMenu, togglecheck, %@Lock_Position%
	iniwrite,% Dropper_NoMove:= Dropper_NoMove = 1 ? 0 : 1,%INIFILE%, Dropper, OnTop
return

mDropper_resize:
	if(Dropper_resize=0)
	{
		Gui 10: +Resize
		Dropper_resize=1
		Menu, DropperMenu, check, Resize
		Wingetpos, posx, posy,,,ahk_id %Dropper_ID%
		posx:= posx < 123 ? posx+123 : posx-123
		gui 20: show, w113 x%posx% y%posy%, %@Set_size%
	}
	else
	{
		Gui 10: -Resize
		Dropper_resize=0
		Menu, DropperMenu, uncheck, Resize
		gui 20: hide
		Guicontrol 10:,vDropper_pic,%Dropper_icon%.ico
		iniwrite, %Dropper_height%, %INIFILE%, Dropper, height
		iniwrite, %Dropper_width%, %INIFILE%, Dropper, width
	}
return

mDropper_Toggle:
	Menu, DropperMenu, togglecheck, Enabled
	if(Dropper_status=0) {
		Gui 10: +E0x10
		Guicontrol 10:+hidden,vDropper_hiddentext
		Dropper_status=1
	} else {
		Gui 10: -E0x10
		Guicontrol 10:-hidden,vDropper_hiddentext
		Dropper_status=0
	}
	iniwrite, %Dropper_status%, %INIFILE%,Dropper,Status
Return

;`````````````````````````````Gui Glabels`````````````````````````````
gDropper_move:
	if(Dropper_NoMove!=1)
		PostMessage, 0xA1, 2,,, A
Return

gDropper_editwidth:
gui 2: submit, nohide
	if(Dropper_same=1)
	{
		guicontrol 20:, vDropper_editheight, %vDropper_editwidth%
		vDropper_editheight:=vDropper_editwidth
	}
return

gDropper_hiddenbutton:
	gui 20: submit, nohide
	if(vDropper_same=1)
		vDropper_editheight:=vDropper_editwidth
	Gui 10: show, w%vDropper_editwidth% h%vDropper_editheight%
return

gDropper_same:
	gui 20: submit, nohide
	if(vDropper_same=1)
	{
		guicontrol 20: disable, vDropper_editheight
		guicontrol 20:, vDropper_editheight, %vDropper_editwidth%
		Gui 10: show, w%vDropper_editwidth% h%vDropper_editwidth%
	}
	Else
		guicontrol 20: enable, vDropper_editheight
	iniwrite, %vDropper_same%, %INIFILE%,Dropper,Same
return

;`````````````````````````````Gui Events`````````````````````````````
10GuiContextMenu:
	Menu, DropperMenu, show
Return

10GuiDropFiles:
	Loop, Parse, A_GuiEvent, `n
		%A_Index%:=GetFullPath(A_LoopField)
	goto ArgMode	
return

10Guisize:
	if(Dropper_Resize=0)
		return
	Dropper_width:=A_Guiwidth
	if(vDropper_same=1)
		Dropper_height:=A_Guiwidth
	Else
		Dropper_height:=A_Guiheight
	if(Dropper_width<MINDROPPERSIZE)
		Dropper_width:=MINDROPPERSIZE
	if(Dropper_height<MINDROPPERSIZE)
		Dropper_height:=MINDROPPERSIZE
	gui 10: show, w%Dropper_Width% h%Dropper_Height%
	guicontrol 10: Move, vDropper_Pic,w%Dropper_Width% h%Dropper_Height%
	guicontrol 10: Move, vDropper_hiddentext,% "y" . (Dropper_Height-14)
	guicontrol 20:, vDropper_editwidth, %Dropper_Width%
	guicontrol 20:, vDropper_editheight, %Dropper_Height%
	if(Dropper_width<95) {
		if(Dropper_width<50) {
			if(Dropper_width<30)
				Guicontrol 10:, vDropper_hiddentext,*
			else
				Guicontrol 10:, vDropper_hiddentext,[-]
			}
		Else
			Guicontrol 10:, vDropper_hiddentext,[%@disabled_abbreviation%]
	} else
		Guicontrol 10:, vDropper_hiddentext,[%@disabled%]
	Guicontrol 10:+backgroundtrans, vDropper_hiddentext
return