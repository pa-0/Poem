/*
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

;``````````````````````````Locale reading```````````````````````
; It's annoying to include this in the main script.
Locale:
iniread, LANG,%INIFILE%,config,Language,English
if(LANG!="English")
	FileInstall, res\locale.ini, res\locale.ini

#include res\ini.ahk
ini_load(INI_VAR, "res\locale.ini")		;50

@Check_Registry_On_Exit := ini_read(INI_VAR, LANG,"Check registry on exit","Check registry on exit")
@Context_is_installed := ini_read(INI_VAR, LANG,"Context is installed","Context is installed")
@Context_is_not_installed := ini_read(INI_VAR, LANG,"Context is not installed","Context is not installed")
@Install := ini_read(INI_VAR, LANG,"Install","Install")
@Uninstall := ini_read(INI_VAR, LANG,"Uninstall","Uninstall")
@Remove := ini_read(INI_VAR, LANG,"Remove","Remove")
@About_Poem := ini_read(INI_VAR, LANG,"About Poem","About Poem")
@Silent_Mode := ini_read(INI_VAR, LANG,"Silent Mode","Silent Modes")
@Start_in_tray := ini_read(INI_VAR, LANG,"Start in tray","Start in tray")
@Check_programs_on_start := ini_read(INI_VAR, LANG,"Check programs on start","Check programs on start")
@Check_registry_on_exit := ini_read(INI_VAR, LANG,"Check registry on exit","Check registry on exit")
@Show_Balloon_Tip := ini_read(INI_VAR, LANG,"Show Balloon Tip","Show Balloon Tip")
@Start_with_Dropper := ini_read(INI_VAR, LANG,"Start with Dropper","Start with Dropper")
@View_Readme := ini_read(INI_VAR, LANG,"View Readme","View Readme")
@Show_Dropper := ini_read(INI_VAR, LANG,"Show Dropper","Show Dropper")
@Show := ini_read(INI_VAR, LANG,"Show","Show")
@Language := ini_read(INI_VAR, LANG,"Language","Language")
@Exit := ini_read(INI_VAR, LANG,"Exit","Exit")
@Relative_to_Disk := ini_read(INI_VAR, LANG,"Relative to Disk","Relative to Disk")
@Relative_to_Poem := ini_read(INI_VAR, LANG,"Relative to Poem","Relative to Poem")
@Extension := ini_read(INI_VAR, LANG,"Extension","Extension")
@Program := ini_read(INI_VAR, LANG,"Program","Program")
@Advanced := ini_read(INI_VAR, LANG,"Advanced","Advanced")
@Add := ini_read(INI_VAR, LANG,"Add","Add")
@Edit := ini_read(INI_VAR, LANG,"Edit","Edit")
@Portable_Extension_Manager := ini_read(INI_VAR, LANG,"Portable Extension Manager","Portable Extension Manager")
@Arguments := ini_read(INI_VAR, LANG,"Arguments","Arguments")
@Working_directory := ini_read(INI_VAR, LANG,"Working Directory","Working Directory")
@File := ini_read(INI_VAR, LANG,"File","File")
@Help := ini_read(INI_VAR, LANG," Help"," The path can either be relative on the disk or relative to Poem. A path relative to Poem must start with '.\' (Poem's folder) or '..\' (the parent folder).")
@Example1 := ini_read(INI_VAR, LANG," Example1","Examples of relative to disk:")
@Example1A := ini_read(INI_VAR, LANG," Example1A"," Program Files\Programmer's Notepad\pn.exe")
@Example1B := ini_read(INI_VAR, LANG," Example1B"," WINDOWS\system32\calc.exe")
@Example2 := ini_read(INI_VAR, LANG," Example2"," Examples of relative to Poem:")
@Example2A := ini_read(INI_VAR, LANG," Example2A"," ..\Portable Apps\Pidgin\Pidgin.exe")
@Example2B := ini_read(INI_VAR, LANG," Example2B"," .\Skeys\Skeys.exe")
@Help2 := ini_read(INI_VAR, LANG," Help2","In the arguments, `%1 is replaced with the path of the file.")
@OK := ini_read(INI_VAR, LANG,"OK","OK")
@Cancel := ini_read(INI_VAR, LANG,"Cancel","Cancel")
@About_Message := ini_read(INI_VAR, LANG,"_About Message","Poem stands for 'Portable Extension Manager'. It is designed to simplify opening files without adding file associations to registry. It was written in Autohotkey by Jon (me). For more information, view the readme.")
@Compiled_with_AHK_version := ini_read(INI_VAR, LANG,"Compiled with AHK version","Compiled with AHK version")
@Default := ini_read(INI_VAR, LANG,"Default","Default")
@White := ini_read(INI_VAR, LANG,"White","White")
@Black := ini_read(INI_VAR, LANG,"White","White")
@Transparent := ini_read(INI_VAR, LANG,"Transparent","Transparent")
@Enabled := ini_read(INI_VAR, LANG,"Enabled","Enabled")
@Always_on_top := ini_read(INI_VAR, LANG,"Always on top","Always on top")
@Lock_Position := ini_read(INI_VAR, LANG,"Lock Position","Lock Position")
@Icon := ini_read(INI_VAR, LANG,"Icon","Icon")
@Resize := ini_read(INI_VAR, LANG,"Resize","Resize")
@Transparency := ini_read(INI_VAR, LANG,"Transparency","Transparency")
@Background := ini_read(INI_VAR, LANG,"Background","Background")
@Close := ini_read(INI_VAR, LANG,"Close","Close")
@disabled := ini_read(INI_VAR, LANG,"Close","Close")
@disabled_abbreivation := ini_read(INI_VAR, LANG,"Close","Close")
@Set_Size := ini_read(INI_VAR, LANG,"Set size","Set size")
@Missing_Program_Message := ini_read(INI_VAR, LANG,"_Missing Program Message","One or more of your programs is missing so Poem may not work")
@Read_the_manual := ini_read(INI_VAR, LANG,"Read the manual","Read the manual")
@First_Time_Message := ini_read(INI_VAR, LANG," _First Time Message","It looks like this is your first time using Poem.`nIf it is, I highly suggest skimming the readme so you know`nwhat does what, the dos and donts, and such. It'll only take`nlike 2 minutes, I swear. It would make me ever so happy.`n(Plus, it will help you use Poem!)")
	Stringreplace, _First_Time_Message,_First_Time_Message,``n,`n,All
@Edit_Extension := ini_read(INI_VAR, LANG,"Edit Extension","Edit Extension")
@New_Extension := ini_read(INI_VAR, LANG,"New Extension","New Extension")
@Select_Program := ini_read(INI_VAR, LANG,"Select Program","Select Program")
@Extension_already_set := ini_read(INI_VAR, LANG,"Extension already set","Extension already set")
@Already_A_Program_Message := ini_read(INI_VAR, LANG,"Extension already set","Extension already set")
@File_Not_Found := ini_read(INI_VAR, LANG," File Not Found"," File Not Found")
@The_Readme_does_not_seem_to_exist := ini_read(INI_VAR, LANG,"The Readme does not seem to exist","The Readme does not seem to exist.")
@Tray_Love_Message := ini_read(INI_VAR, LANG,"_Tray Love Message","Poem will stay in your tray because it loves you.")
;@Open_with_Poem := ini_read(INI_VAR, LANG,"Open with Poem","Open with Poem")
@Context_still_installed := ini_read(INI_VAR, LANG,"Context still installed","Context still installed")
@Context_Installed_Message := ini_read(INI_VAR, LANG,"_Context Installed Message","he context is still installed. Do you want to remove it before quitting?")
@File_Not_Exist := ini_read(INI_VAR, LANG,"Context still installed","Context still installed")
@Program_not_set_for_extension := ini_read(INI_VAR, LANG,"_Program not set for extension","Program not set for extension:")
@No_Program_Set_Message := ini_read(INI_VAR, LANG," _No Program Set Message","There is currently no program set for")
@Program_not_found := ini_read(INI_VAR, LANG,"Program not found","Program not found")
@Program_Not_Exist := ini_read(INI_VAR, LANG," _Program Not Exist","does not seem to exist.")
@Translator := ini_read(INI_VAR, LANG," Translator")

if(@Translator="ERROR" or !@Translator)
	@Translator=Send us an e-mail if you would like to help translate.