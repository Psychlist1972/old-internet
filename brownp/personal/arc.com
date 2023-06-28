$BEGIN:
$ write sys$output "Archived files available : "
$
$ directory/size electrical$disk:[cerconeg.bbs]*.old
$
$ inquire/nopunct filename "View which one (leave off the .OLD!) or QUIT > "
$
$ IF filename .EQS. "QUIT" THEN GOTO EXIT
$ IF filename .EQS. "" THEN GOTO BEGIN
$
$ type/page electrical$disk:[cerconeg.bbs]'filename'.old
$
$
$EXIT:
$
$exit
