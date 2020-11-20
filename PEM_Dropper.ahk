MINDROPPERSIZE=32

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INIRead~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
iniread, Dropper_alpha, %INIFILE%, Dropper, alpha, 4
iniread, Dropper_Width, %INIFILE%, Dropper, Width, 100
iniread, Dropper_height, %INIFILE%, Dropper, Height, 100
if(Dropper_width<MINDROPPERSIZE)
	Dropper_width:=MINDROPPERSIZE
if(Dropper_height<MINDROPPERSIZE)
	Dropper_height:=MINDROPPERSIZE
iniread, Dropper_color, %INIFILE%, Dropper, Color, Default
iniread, Dropper_icon, %INIFILE%, Dropper, Icon, Dropper
ifnotexist, %Dropper_icon%.ico
	Dropper_icon=Dropper
iniread, Dropper_status,%INIFILE%, Dropper, Status, 1
iniread, Dropper_OnTop,%INIFILE%, Dropper, OnTop, 1
;~ iniread, Dropper_noMove,%INIFILE%, Dropper, noMove, 0
iniread, Dropper_show, %INIFILE%, Dropper,showonstart,0
iniread, vDropper_same, %INIFILE%,Dropper,Same,0
Dropper_resize=0

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Menus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;``````````````````````SubMenus``````````````````````
Menu, iconsMenu, add, Dropper, mDropper_icon
Menu, iconsMenu, add, PEM, mDropper_icon
Menu, iconsMenu, check,%Dropper_icon%
Menu, alphaMenu, add, 1,mDropper_alpha
Menu, alphaMenu, add, 2,mDropper_alpha
Menu, alphaMenu, add, 3,mDropper_alpha
Menu, alphaMenu, add, 4,mDropper_alpha
Menu, alphaMenu, add, 5,mDropper_alpha
Menu, alphaMenu, add, 6,mDropper_alpha
Menu, alphaMenu, add, 7,mDropper_alpha
	Menu, alphaMenu, check, % Dropper_alpha
Menu, colorMenu, add, Default, mDropper_Color
menu, colorMenu, add, White, mDropper_color
menu, colorMenu, add, Black, mDropper_Color
	Menu, colorMenu, check, %Dropper_Color%

;``````````````````````MainMenus``````````````````````
Menu, DropperMenu, add, Enabled,mDropper_Toggle
if(Dropper_status=1)
	Menu, DropperMenu, check, Enabled
Menu, DropperMenu, add, Always On Top, mDropper_OnTop
if(Dropper_ontop=1)
	Menu, DropperMenu, check, Always On Top
Menu, DropperMenu, add, Lock Position, mDropper_NoMove
;~ if(Dropper_nomove=1)
;~ 	Menu, DropperMenu, check, Lock Position
Menu, DropperMenu, add
Menu, DropperMenu, add, Icon, :iconsMenu
Menu, DropperMenu, add, Resize,mDropper_resize
Menu, DropperMenu, add, Transparency, :alphaMenu
Menu, DropperMenu, add, Background, :colorMenu
Menu, DropperMenu, add
Menu, DropperMenu, add, Show, mShowPem
if(A_Scriptname!="PEM_Dropper.ahk")
	Menu, DropperMenu, add, PEM, :main
Menu, DropperMenu, add, Close,mDropper_close

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(Dropper_OnTop=1)
	Gui 10: +alwaysontop
Gui 10: -Caption +ToolWindow -0x800000 -resize
Gui 10: +Lastfound
Dropper_ID:=WinExist()
Gui 10: add, picture, ggDropper_Move x0 y0 w%Dropper_width% h%Dropper_height% vvDropper_pic,%Dropper_icon%.ico
Gui 10: font, s7 w700 CRed,Courier
Gui 10: add, text,% "vvDropper_hiddentext x2 y" . (Dropper_height-14) backgroundtrans,[disabled]
if(Dropper_status!=0)
	guicontrol 10: +hidden, vDropper_Hiddentext
else
	gui 10: -E0x10

Gui 20: +toolwindow -syswindow +owner10 +alwaysontop
Gui 20: add, text, x5 y5, w
Gui 20: add, edit, xp+12 yp-3 w40 vvDropper_editwidth ggDropper_editwidth, %Dropper_Width%
Gui 20: add, text, xp-12 yp+30, h
Gui 20: add, edit, xp+12 yp-3 w40 vvDropper_editheight, %Dropper_Height%
Gui 20: add, checkbox, x65 y3 w40 h20 +0x1000 vvDropper_same ggDropper_same Checked%vDropper_same%,Same
gui 20: add, button, 
if(vDropper_same=1) {
;~ 	guicontrol 20:,vDropper_same,1
	guicontrol 20: disable, vDropper_editheight
	guicontrol 20:, vDropper_editheight, %Dropper_Width%
}
Gui 20: add, button, x0 y0 w0 h0 default vvDropper_hiddenbutton ggDropper_hiddenbutton
	
goto AfterDropper

Dropper_Show:
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
gui 20: hide
gui 10: hide
return

mDropper_Color:
Menu, colorMenu, uncheck, Default
Menu, colorMenu, uncheck, White
Menu, colorMenu, uncheck, Black
Menu, colorMenu, check, %A_ThisMenuItem%
Gui 10: Color, %A_ThisMenuItem%
Dropper_color:=A_ThisMenuItem
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
Menu, DropperMenu, togglecheck, Always On Top
iniwrite,% Dropper_OnTop := Dropper_OnTop = 1 ? 0 : 1,%INIFILE%, Dropper, OnTop
return

mDropper_NoMove:
Menu, DropperMenu, togglecheck, Lock Position
iniwrite,% Dropper_NoMove:= Dropper_NoMove = 1 ? 0 : 1,%INIFILE%, Dropper, OnTop
return

mDropper_resize:
if(Dropper_resize=0) {
	Gui 10: +Resize
	Dropper_resize=1
	Menu, DropperMenu, check, Resize
	Wingetpos, posx, posy,,,ahk_id %Dropper_ID%
	posx:= posx < 123 ? posx+123 : posx-123
	gui 20: show, w113 x%posx% y%posy%, Set size
}
else {
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
if(Dropper_same=1) {
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
if(vDropper_same=1) {
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
Stringsplit, file, A_GuiEvent,`n
0:=file0
loop, %0%
	%A_index%:=File%A_Index%
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
			Guicontrol 10:, vDropper_hiddentext,[d]
		}
	Else
		Guicontrol 10:, vDropper_hiddentext,[dis]
} else
	Guicontrol 10:, vDropper_hiddentext,[disabled]
Guicontrol 10:+backgroundtrans, vDropper_hiddentext
return