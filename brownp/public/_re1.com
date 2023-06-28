! Written by Peter M Brown, University of Lowell, 1990 
!
! This program will purge and rename every file to *.*;1
!
$ on severe_error then goto error
$
$ @science$disk:[brownp.public]write.file "re1"
$
$ write sys$output "OWNER has been set to full access to avoid errors"
$
$ if p1 .EQS. "" then goto ALL_FILES
$
$ONE_FILE:
$   set prot = (o:rwed) 'p1'
$   purge 'p1'
$   p1 = p1 + ";*"
$   rename 'p1' ;1
$goto done
$
$ALL_FILES:
$   set prot = (o:rwed) *.*;*
$   purge
$   rename *.*;* ;1
$
$DONE:
$   write sys$output "--  RE1 Completed."
$   dir
$exit
$
$ERROR:
$   write sys$output "Error, program aborted."
$exit
