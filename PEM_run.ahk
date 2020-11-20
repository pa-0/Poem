;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Argument Mode~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Hands any files passed as arguments~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Argmode:
alreadyshown=
loop, %0%
{
	file:=%A_Index%
	;-----------------------File doesn't exist-----------------------
	ifnotexist, %file%
	{ 	msgbox,48,File not found, The file:`n`n%file%`n`n could not be opened because it does not exist.
		return
	}
	;-----------------------Program not set-----------------------
	Splitpath, file,,,ext
	Iniread, program, pem.ini, key, %ext%
	if(program="ERROR")
	{	Msgbox,48,Program not set for extension,There is currently no program set for`n`n%ext%
		return
	}
	iniread, drv, pem.ini, config, drive
	if(drv="PEM")
		Splitpath, A_scriptDir,,,,,drv
	;-----------------------Program doesn't exist-----------------------
	if(!FileExist(drv . "\" . program))
	{	ifinstring, AlreadyShown,%Program%
			exitapp
		Msgbox,48,Program not found,The program:`n`n" program "`n`n does not seem to exist.	
		AlreadyShown.="|" . Program
	}
	program=%drv%\%program%
	full=`"%program%`" `"%file%`"
	Splitpath, program,,dir
	run, %full%,%dir%
}
return

