!
!
!  L o g . c o m
!  Written By Peter M Brown ULowell 1991
!
!
! Revision History :
! ----------------
! 05-DEC-1991   v1.0  PMB   Original coding for use with PERSONAL.PAS
!
!
!
$ on error then exit
$ on severe_error then exit
$ on control_y then continue
$ on control_c then continue
$
$ datfile = electrical$disk:[cerconeg.bbs]users.dat
$
$
$ time   = f$time()
$ userid = f$user()
$ userid = userid + "                                   "
$ userid = f$extract(0,20,userid)
$
$ open/append userfile 'dat_file'
$ write userfile user, " ! Personal Number : ",p1," ! Date: ",time
$ close usefile
$
$exit
