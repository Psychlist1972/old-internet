!                      G  E  T  .  C  O  M 
!
!              Written By Peter M Brown ULowell 1991
!
!
$BEGIN:
$
$ on severe_error then goto error
$ on error then goto error 
$ filename = p1
$ if p2 .EQS. "" then newfile = filename
$ if p2 .NES. "" then newfile = p2
$ copy 'p1' science$disk:[brownp]'newfile'
$ set prot = (w,s,o:rwed,g) science$disk:[brownp]'p1'
$
$ write sys$output "Mission Accomplished"
$  
$
$exit
$
$ERROR:
$
$ write sys$output "Error:"
$ exit
$
