!
binary.exe : binary.obj
	link binary, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100, -
		group$disk:[compsci]convert
	if f$search("binary.exe") .NES. "" then purge binary.exe
binary.obj : binary.pas
	pas/list/analyze binary
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
