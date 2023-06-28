!
infix.exe : infix.obj
	link infix, -
		stacks, -
		mod$dir:nodecont, -
		mod$dir:linked1, -
		mod$dir:linEditM, -
		mod$dir:pas_utils, -		
		comp$dir:utilities, -
		comp$dir:vt100

infix.obj : infix.pas
	pas/analyze/optimize infix
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
