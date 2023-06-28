!
infix.exe : infix.obj
	link infix, -
		value_stack, -
		operator_stack, -
		mod$dir:nodecont, -
		mod$dir:linked1, -
		mod$dir:linEditM, -
		mod$dir:pas_utils, -		
		comp$dir:utilities, -
		comp$dir:vt100

infix.obj : infix.pas
	pas/list/optimize value_stack
	pas/list/optimize operator_stack
	pas/list/optimize infix
	if f$search("*.obj") .NES. "" then purge *.obj
!
