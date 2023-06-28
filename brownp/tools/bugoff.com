!
! Written By Peter M Brown ULowell December 1990
!
!  This program is called by the LOGOFF or LO command
!
$ 
$ current_dir = f$directory()
$
$ open/write outfile science$disk:[brownp].default
$ 
$  write outfile current_dir
$
$ close outfile
$
$ type science$disk:[brownp.tools]outro.txt
$
$ write sys$output "Current directory has been logged."
$
$ logout
$
$exit
