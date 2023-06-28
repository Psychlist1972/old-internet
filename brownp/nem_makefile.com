!
! Written By Peter M Brown UMass-Lowell 1991
!
!
$ CHECK_ACCOUNT:
$	set def sys$login
$	if f$search ("database_nem.dir") .NES. "" THEN GOTO ABORT
$	if f$search ("database_code.dir") .NES. "" THEN GOTO ABORT
$	if f$search ("image.dir") .NES. "" THEN GOTO ABORT
$	if f$search ("source.dir") .NES. "" THEN GOTO ABORT
$
$ CREATE_DIRECTORIES:
$	cre/dir [.database_nem]
$	write sys$output "Directory [.DATABASE_NEM] created."
$
$	cre/dir [.database_code]
$	write sys$output "Directory [.DATABASE_CODE] created."
$
$	cre/dir [.image]
$	write sys$output "Directory [.IMAGE] created."
$
$	cre/dir [.source]
$	write sys$output "Directory [.SOURCE] created."
$
$
$ SET_COMMAND:
$
$ CREATE_HELP_LIB:
$
$ COMPILE:
$
$ LINK_MODULES:
$
$ CLEANUP:
$	rename *.exe [.IMAGE]
$		write sys$output "Executables moved."
$	rename *.pas [.SOURCE]
$		write sys$output "Source files moved."
$	rename *.pen [.SOURCE]
$		write sys$output "Pascal ENvironment files moved."
$	rename *.obj [.SOURCE]
$		write sys$output "Object files moved."
$	rename nemesis.help [.DATABASE_NEM]
$	rename commands.paper [.IMAGE]
$		write sys$output "Nemesis.Help and Commands.Paper moved."
$
$ SET_PROTECTIONS:
$	set prot = (w:re,s:re,g:re,o:rwed) [.IMAGE]*.*
$	set prot = (w:rw,s:rw,g:rw,o:rwed) [.DATABASE_NEM]*.*
$	set prot = (w,s,g,o:rwed) [.SOURCE]*.*
$		write sys$output "Protections set."
$
$		write sys$output " "
$		write sys$output "Use NEMESIS/REBUILD to create universe."
$		write sys$output " "
$ exit
$
$ ABORT:
$	write sys$output "Nemesis makefile has already been executed, "
$	write sys$output "or IMAGE, SOURCE, DATABASE_NEM, DATABASE_CODE"
$	write sys$output "directories already exist."
$exit
