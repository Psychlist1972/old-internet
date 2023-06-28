! Many_mail written by Peter M Brown
! ULowell 
! December 1990
!
$ on error then goto error
$
$ wso := write sys$output
$ counter = 0
$
$ wso " "
$ wso "This annoying program written By Peter M Brown, ULowell, Dec 1990"
$ wso " "
$
$ uic = p1
$ if uic .eqs. "" then read sys$command uic -
 /prompt = "Username of the loser to receive MUCH mail :  "
$
$ wso " "
$ number = p2
$ if number .eqs. "" then read sys$command number -
 /prompt = "Number of copies to send :  "
$
$ wso " "
$ filename = p3
$ if filename .eqs. "" then read sys$command filename -
 /prompt = "Name of file to send out :  "
$
$ counter = f$integer(counter)
$ uic = f$string(uic)
$ !uic = f$edit(uic,"trim,upcase,uncomment")
$ 
$ 
$!
$ SEND:
$ 
$ counter = counter + 1
$ mail 'filename' 'uic'/ subj = "An annoying mail message"
$ IF counter .eqs. number then goto done
$ goto send
$
$! 
$ ERROR:
$
$ wso " "
$ wso " **    An Error has occured, program aborted.    ** "
$ wso " "
$ exit
$
$!
$ DONE:
$
$ wso "Thank you for annoying someone, everyone should do it sometime."
$ exit
