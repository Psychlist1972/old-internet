$ if f$mode() .nes. "INTERACTIVE" then exit
$ on severe_error then continue
$ on error then continue
$ w :== write sys$output
$
$ @[brownp.tools]protection.com
$
$ @[brownp.tools]newcmds.com
$ w "Command shell defined."
$
$ @[brownp.tools]keypad.com
$ w "Keypad defined."
$
$! set broadcast=nophone
$
$ show broadcast
$ show users/full brownp
$
$ set process/name = "Lllick me"
$ set process/name = "Balow Me luza"
$ set process/name = "The Psychlist"
$ set process/name = " - Nemesis -"
$
$
$ clear
$
$ quota
$
$ run [brownp.public]calendar
$
$ open/read infile .default
$	read infile current_dir
$ close infile
$
$ purge .default
$
$ set def 'current_dir'
$
$ directory
$exit
