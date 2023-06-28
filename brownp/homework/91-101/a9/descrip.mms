!
line_edit.exe : line_edit.obj
	link line_edit, -
		mod$dir:pas_utils, -
		comp$dir:utilities, -
		comp$dir:vt100, -
		science$disk:[brownp.homework.91-101.a9]link_defs, -
		science$disk:[brownp.homework.91-101.a9]link1_module
	if f$search("line_edit.exe") .NES. "" then purge line_edit.exe
	if f$search("line_edit.obj") .NES. "" then delete/nocon line_edit.obj;*
	if f$search("*.dia") .NES. "" then delete/nocon *.dia;*

line_edit.obj : line_edit.pas
	pas/list/analyze/optimize link_defs 
	pas/list/analyze/optimize link1_module
	pas/list/analyze/optimize line_edit
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj

!
