!
scroller.exe : scroller.obj
	link scroller, -
		mod$dir:pas_utils, -
		comp$dir:utilities, -
		comp$dir:vt100, -
		science$disk:[brownp.homework.91-101.a8]windows, -
		science$disk:[brownp.homework.91-101.a8]menus
	if f$search("scroller.exe") .NES. "" then purge scroller.exe
	if f$search("scroller.obj") .NES. "" then delete/nocon scroller.obj;*
	if f$search("*.dia") .NES. "" then delete/nocon *.dia;*

scroller.obj : scroller.pas
	pas/list/analyze/optimize windows 
	pas/list/analyze/optimize menus
	pas/list/analyze/optimize scroller
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj

!
