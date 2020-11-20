;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Menus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	;Tray menu
if(A_IsCompiled=1)
	Menu, Tray, NoStandard
menu, tray, Click, 1
Menu, Tray, Tip, PEM - Context is installed
Menu, Tray, add, Show, mShowPEM
if(islabel("Dropper_Show"))
	Menu, Tray, add, Dropper, Dropper_Show
Menu, Tray, add, Install context, Install
Menu, Tray, add, Remove Context, Remove
Menu, Tray, add, About PEM, mShowAbout
Menu, Tray, add, Exit, Exittime
Menu, Tray, default,Show
	; ? button menu
Menu, main, add, Silent Mode,msilentmode
Menu, main, add, Start in tray,mstartintray
Menu, main, add, Check programs on start, mcheckprogramsonstart
Menu, main, add, Check registry on exit, mcheckregonexit
Menu, main, add, Show Balloon Tip, mShowBalloonTip
Menu, main, add, Start with Dropper, mDropperOnStart
Menu, main, add
Menu, main, add, About PEM, mshowabout
Menu, main, add, View Readme, mreadme
Menu, main, add, Show Dropper, Dropper_show
Menu, main, add, Exit, exittime

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Main GUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gui 1: +resize +minsize
Gui 1: +LastFound
PEM_ID:=WinExist()
gui 1: 	add,	listview, 		w325 	r10 					vListViewVar	ggListView -multi +sort, 	Ext|Program
gui 1: 	add,	button,			w1		h1		x0		y0						ggListViewEnter hidden default
gui 1: 	add,	button, 		w40		h20		x20		y170 	vnewbutton		ggButtonNew, 				New
gui 1: 	add,	button, 		w40 	h20		x70 	y170	vdelbutton 		ggButtonDel, 				Del
Gui 1:	add,	text,							x115 	y173 	vdrivetext, 								Drive:
iniread, 		drv, 		pem.ini,		config,		drive
drivelist=PEM|A:|B:|C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Y:|Z:|
stringreplace, drivelist,drivelist,%drv%,%drv%|
Gui 1:	add,	dropdownlist, 	w50 	r7 		x150	y170 	vdrivelist 		ggDriveList,				%Drivelist%

gui 1: font, underline w600 
gui 1: add, Button, x207 y170 w105 ggToggleContext vcontextbutton
gui 1: font
gui 1: add, button, y172 x317 w20 h20 ggmainmenu vMenuButton,?

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Add/Edit extension~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gui 2: +owner1
Gui 2:	Add,	groupbox,	x5	 	y1 		w330 	h70 	vgroupbox2					,Add
Gui 2:	Add,	text,		x13 	y20													,Extension
Gui 2:	Add,	Edit,		x13		y35 	w50 			vExtVar		ggifempty
Gui 2:	Add,	text,		x70		y20													,Path\Program
Gui 2:	Add,	combobox,	x70		y35		w240 			vPathVar	ggifempty
Gui 2:	Add,	Button, 	x315	y34		w15 						ggpathselect	,…
Gui 2:	Add,	Button, 	x200	y80 	w60 			vok2button 	default disabled,OK
Gui 2:	Add,	Button,		x270	y80 	w60											,Cancel
Gui 2:	Font, s10 underline cRed
Gui 2:	Add, 	text,		x7 		y80									gmreadme			,DO NOT include the drive letter!

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~About GUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gui 3: +owner1 +toolwindow
Gui 3:	add,	picture, 	x10 	y10		w50		h50			icon1	,%A_scriptname%
Gui 3:	font,	underline w600
Gui 3:	add,	text,		x70 	y3									,PEM v%THISVERSION%
gui 3:	font
gui 3:	add,	text,		x70 	y20 	w250						,PEM stands for `"Portable Extension Manager`". It is designed to simplify opening files without adding file associations to registry. It was written in Autohotkey by Jon (me). For more information`, view the readme.
gui 3:	font,	underline
gui 3:	add,	text,		x70		y75 			ggemail 	CBlue	,FreewareWire@gmail.com
Gui 3:	add,	text, 		x70 	y90				ggwebsite 	CBlue	,http://sites.google.com/site/freewarewiresoftware
gui 3:	font
FileGetTime, CreationDate, %A_Scriptfullpath%,C
Formattime,CreationDate,%creationdate%,MM-dd-yyyy
Gui 3:	Add, 	Statusbar,	vinfobar									,Compiled with AHK version %A_AhkVersion%
gui 3: default
SB_SetParts(220)
SB_SetText("Created: " . CreationDate,2)