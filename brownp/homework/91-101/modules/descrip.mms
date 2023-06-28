!
test.exe : test.obj
	link test, -
		[brownp.homework.91-101.modules]pas_utils, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("test.exe") .NES. "" then purge test.exe
test.obj : test.pas
	pas/check=all test
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
