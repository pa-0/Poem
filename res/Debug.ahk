Debug(Param1="", param2 ="", param3 ="", param4 ="", param5 ="",param6="")
{
	loop, 6
	{	if (Param%A_Index%!="")
			ErrorMsg .= Param%A_Index%
		ErrorMsg .= "`n"
	}
	msgbox, %errormsg%
}

BEFORE()
{
  global TICK_BEFORE
  TICK_BEFORE := A_TickCount
}

AFTER()
{
  global TICK_BEFORE
  msgbox,% A_TickCount-TICK_BEFORE
}