!
shifter.exe : shifter.obj
	link shifter, -
		mod$dir:pas_utils, -
		comp$dir:utilities, -
		comp$dir:vt100, -
		comp$dir:convert
	if f$search("shifter.exe") .NES. "" then purge shifter.exe
shifter.obj : shifter.pas
	pas/list/analyze shifter
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
