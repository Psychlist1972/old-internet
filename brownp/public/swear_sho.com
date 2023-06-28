$ ! FUCK YOU! A fun little ESCAPE show by:
$ !           Ed Sutherland
$ !
$ ! Frustrated? Angry? Well, this little program should help you take out some
$ ! of those pent-up feelings! Just EXTR/NOHE FUCK.YOU and use @FUCK.YOU to run
$ ! the program. So MANY ways to say it, aren't there?
$ !
$ ! To use, EXTR/NOHE STAR.WARS and @STAR.WARS to run.
$ !
$Write :== type sys$input
$ ENOUGH=0
$ Write
 [2J
$ FUCKYOU:
$wait 00:00:00.20
$Write
 [1;7m[12;16H#3FUCK YOU![0m
 [0;1m[13;16H#4FUCK YOU!
 [0m
$ wait 00:00:00.20
$Write
 [0;1m[12;16H#3FUCK YOU![0m
 [0;1;7m[13;16H#4FUCK YOU!
 [0m
$ ENOUGH=ENOUGH+1
$ IF ENOUGH .EQS. 5 THEN GOTO FLASH 
$ GOTO FUCKYOU
$ FLASH:
$ ENOUGH=0
$ FUCKTWO:
$ WAIT 00:00:00.20
$Write
 [1;7m[12;16H#3FUCK YOU![m
 [1;7m[13;16H#4FUCK YOU![m
 [m
$wait 00:00:00.20
$Write
 [0;1m[12;16H#3FUCK YOU![m
 [0;1m[13;16H#4FUCK YOU![m
 [m
$ ENOUGH=ENOUGH+1
$ IF ENOUGH .EQS. 5 THEN GOTO ALT
$ GOTO FUCKTWO
$ ALT:
$ ENOUGH=0
$ FUCKTHREE:
$ WAIT 00:00:00.20
$Write
 [1;7m[12;16H#3FUCK[0;1m YOU![m
 [1;7m[13;16H#4FUCK[0;1m YOU![m
 [m
$ WAIT 00:00:00.20
$ Write
 [0;1m[12;16H#3FUCK [0;1;7mYOU[0;1m!
 [0;1m[13;16H#4FUCK [0;1;7mYOU[0;1m!
 [m
$ ENOUGH=ENOUGH+1
$ IF ENOUGH .EQS. 5 THEN GOTO BOLD
$ GOTO FUCKTHREE
$ BOLD:
$ ENOUGH=0
$ FUCKFOUR:
$ WAIT 00:00:00.20
$Write
 [0m[12;16H#3FUCK YOU![m
 [0m[13;16H#4FUCK YOU![m
 [m
$ WAIT 00:00:00.20
$Write
 [0;1m[12;16H#3FUCK YOU![m
 [0;1m[13;16H#4FUCK YOU![m
 [m
$ ENOUGH=ENOUGH+1
$ IF ENOUGH .EQS. 5 THEN GOTO DONE
$ GOTO FUCKFOUR
$ DONE:
$Write
 [0;1m[12;16H#3FUCK YOU![m
 [0;1m[13;16H#4FUCK YOU![m
 [m
$EXIT
