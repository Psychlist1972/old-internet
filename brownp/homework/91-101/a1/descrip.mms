! ------------
! This DESCRIP.MMS file is for use with 91.101 Assignment No. 1
! Written by Jesse M. Heines 8/14/91
!
getakey.exe : getakey.obj
	link getakey, -
		group$disk:[compsci]utilities, -
		group$disk:[compsci]vt100
	if f$search("getakey.exe") .NES. "" then purge getakey.exe
getakey.obj : getakey.pas, -
		group$disk:[compsci]utilities.obj, -
		group$disk:[compsci]vt100.obj
	pas/list/analyze getakey
	if f$search("*.ana") .NES. "" then purge *.ana
	if f$search("*.obj") .NES. "" then purge *.obj
!
