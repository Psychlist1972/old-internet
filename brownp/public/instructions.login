!
!			L o g i n . c o m
!
!		written by Peter M Brown ULowell 1991
!
!		      South Suite 407c x6183
!
!	To use this file (when mailed to you) Simply type the 
!	follwoing at the MAIL> prompt :
!
!	MAIL> READ 
!		then, after reading this message, type
!
!	MAIL> EXTRACT/NOHEADER LOGIN.COM
!		this file will then become your new login.com
!
!
!	Please feel free to distribute this to your friends.  Simply
!	type this at the $ prompt :
!
!		MAIL LOGIN.COM /SUBJ = "Login.com file for you"
!		TO: your friends username
!
$ on error then continue 
$ on severe_error then continue
$
! define W to stand for write sys$output, this way, ony a W must
! precede the string instead of "write sys$output"
!
! type HELP ==   for help on this concept.
! 
$ w :== write sys$output
$
!
! This gives you an abundance of new commands to use 
!
$ @science$disk:[brownp.public]_Login
$
!
! You can change whats in the quotes here to say whatever you want
!
$
$ set prompt = "ULowell VMS> "
$
$exit
