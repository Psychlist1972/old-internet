!
! Trash.com written By Peter M Brown Ulowell 1990
! This program will do the following:
!
! 1     set the protection of the program so you CAN delete
!          the file in question
!
! 2     delete the file that you wish to delete
!
! 3     enables you to NOT specify the ;* or wildcard character
!
! 
$ on error then goto ERROR
$ on severe_error then goto ERROR
$
$ @science$disk:[brownp.public]write.file "trash"
$
$  set		:== set
$  prot		:== prot
$  delete	:== delete
$  filename	= p1
$
$
$
$ write sys$output "All versions of the files with the specified name/wildcard will be deleted."
$ write sys$output "Please do not add the ;* , this is automatically done."
$   if p1 .eqs. "" then read sys$command filename -
/error=error/end=exit/prompt = "_Filename :"
$   read sys$command r_u_sure -
/error=error/end=exit/prompt = "Are you sure ? (y/n) [n] > "
$
$
$   if r_u_sure .nes. "y" then goto abort
$
$!   if f$search(filename) .NES. "" 
$!   THEN
$	filename = filename + ";*"
$	set protection = (o:d) 'filename'
$       delete / noconfirm 'filename'
$!   ELSE
$!       write sys$output "No such file."
$!       exit
$!   ENDIF
$
$LEAVE:
$
$   write sys$output "File(s) deleted."
$   trash :== @science$disk:[brownp.public]_trash.com
$   
$   exit
$
$ABORT:
$   writeln sys$output "ABORT: Program aborted by user."
$   trash  :== @science$disk:[brownp.public]_trash.com
$
$   exit
$
$ERROR:
$   write sys$output "ERROR: Program terminated. File(s) not removed."
$   trash :== @science$disk:[brownp.public]_trash.com
$
$   exit
$
$EXIT_ERROR:
$	write sys$output "No such file."
$exit
