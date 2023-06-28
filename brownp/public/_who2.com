!                          W H O 2 . C O M
!
!                Written By Peter M Brown ULowell 1991
!
!
! Purpose : Simply allows a show users/full with the PAGE option.
!
$ @science$disk:[brownp.public]write.file "who2"
$ 
$
$on severe_error then continue
$on error then continue
$
$if p1 .NES. "" then goto ONE_PERSON
$
$BEGIN:
$     current = f$environment("DEFAULT")
$ !   show symbol current
$     set def sys$login  
$
$     show users/full/output = 666766who_file_data.pmb 'p1'
$
$     set prot = (w:rwed,o:rwed,g:rwed,s:rwed) 666766who_file_data.pmb;*
$     type/page 666766who_file_data.pmb
$     delete/noconfirm 666766who_file_data.pmb;*
$    
$     set def 'current'
$
$exit
$
$ONE_PERSON:
$	show users/full 'p1'
$exit
