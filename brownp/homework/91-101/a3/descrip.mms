!
pong.exe : pong.obj
	link pong, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("pong.exe") .NES. "" then purge pong.exe
pong.obj : pong.pas
	pas/list/analyze pong
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
