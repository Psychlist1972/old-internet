!
breakout.exe : breakout.obj
	link breakout, -
		brk_module, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("breakout.exe") .NES. "" then purge breakout.exe
breakout.obj : breakout.pas
	pas/list/analyze breakout
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
