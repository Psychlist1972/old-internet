! Many_mail written by Peter M Brown
! ULowell 
! December 1990
!
$ on error then goto error
$
$ @science$disk:[brownp.public]write.file "many_mail"
$
$	wso := write sys$output
$	counter = 0
$
$	if p3 .EQS. "" then goto USAGE
$
$	wso "This annoying program written By Peter M Brown, ULowell, Dec 1990"
$
$
$	uic = p1
$	number = p2
$	filename = p3
$
$	counter = f$integer(counter)
$	uic = f$string(uic)
$	uic = f$edit(uic,"trim,upcase,uncomment")
$
$SEND:
$	counter = counter + 1
$	mail 'filename' 'uic'/ subj = "A really annoying mail message"
$	IF counter .eqs. number then goto done
$goto send
$ 
$ERROR:
$	wso " "
$	wso " **    An Error has occured, program aborted.    ** "
$	wso " "
$exit
$
$DONE:
$	wso "%MUCH_MAIL DONE Thank you for annoying someone, everyone should do it sometime."
$exit
$
$USAGE:
$	wso "Usage : SEND <username> <number of copies> <filename>"
$exit
$
$
