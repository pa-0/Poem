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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Argument Mode~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hands any files passed as arguments~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Argmode:
alreadyshown=
loop, %0%
{
	file:=%A_Index%
	;-----------------------File doesn't exist-----------------------
	ifnotexist, %file%
	{ 	msgbox,48,%@File_not_found%, %file%`n`n%@File_Not_Exist%
		continue
	}
	;-----------------------Program not set-----------------------
	Splitpath, file,,,ext
	Iniread, program, Poem.ini, .%ext%, program
	if(program="ERROR")
	{	Msgbox,48,%@Program_not_set_for_extension%,%@No_Program_Set_Message% %ext%
		return
	}
	iniread, drv, Poem.ini, config, drive
	if(drv="Poem")
		Splitpath, A_scriptDir,,,,,drv
	;-----------------------Program doesn't exist-----------------------
	if(!FileExist(program:=Determine(program,drv)))
	{	ifinstring, AlreadyShown,%Program%
			return
		Msgbox,48,%@Program_not_found%,%program%`n`n%@Program_Not_Exist%
		AlreadyShown.="|" . Program
	}
	Iniread, workingdir, Poem.ini, .%ext%, workingdir,0
	if(workingdir)
		SplitPath, program,,dir
	else
		Splitpath, file,,dir
	Iniread, Arguments, Poem.ini, .%ext%, arguments, `%1
	stringreplace, arguments, arguments, `%1, %file%
	full=`"%program%`" `"%arguments%`"
	run, %full%,%dir%
}
return

ButtonWidth(Input1, Input2="")
{
	MARGIN=10
	if(StrLen(Input1)>StrLen(Input2))
		returnval:=StrLen(Input1)*7
	else
		returnval:=StrLen(Input2)*7
	returnval+=MARGIN
	if(returnval<30)
		returnval=30
	return returnval
}