!
! RESET.COM written by Peter M Brown ULowell 1991
!
! Use this program if your screen is messed up (graphics/window etc)
!
$ w :== write sys$output
$
$ @science$disk:[brownp.public]write.file "reset"
$
$ set term/echo
$
$ clear
$
$ type science$disk:[brownp.public]_gra_off.txt
$ 
$
$ w "[0m "
$ w "[24;1r"
$ w "[24;1h"
$ w "Terminal screen is cleaned up"
$
$ exit


