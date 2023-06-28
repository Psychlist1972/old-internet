$
$ show users/full/output = who.dat
$
$ IF p1 .EQS. "brownp" THEN GOTO THANK_BROWNP
$ IF p1 .EQS. "grep"  THEN GOTO GREP 
$
$
$PLAYERS:
$
$	run science$disk:[brownp.tools]who
$	delete/noconfirm who.dat;*
$exit
$
$
$THANK_BROWNP:
$
$	run science$disk:[brownp.tools]thank_brownp
$	delete/noconfirm who.dat;*
$exit 
$
$
$GREP:
$
$	open/write grepid grep.dat 
$	write grepid p2
$	close grepid
$
$	run science$disk:[brownp.tools]grep
$	delete/noconfirm who.dat;*
$	delete/noconfirm grep.dat;*
$exit
