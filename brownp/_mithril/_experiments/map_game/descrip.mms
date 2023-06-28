!
map_game2.exe : map_game2.obj
	link map_game2, -
		[brownp.homework.91-101.modules]pas_utils, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("map_game2.exe") .NES. "" then purge map_game2.exe
map_game2.obj : map_game2.pas
	pas/list/analyze map_game2
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
