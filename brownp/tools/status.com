!
!                    S  t  a  t  u  s  .  c  o  m
! 
!                          By Peter M Brown
!
!                           ULowell 1991
!
$ on error then continue
$ on severe_eror then continue
$
$ @science$disk:[brownp.public]write.file
$
$ uic = f$user()
$ CLEAR
$
$ write sys$output "Status for : " + uic
$ write sys$output "--------------------------------------------------------------"
$ show broadcast
$ write sys$output "--------------------------------------------------------------"
$ show status
$ write sys$output "--------------------------------------------------------------"
$ quo
$
$exit
