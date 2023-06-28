$ @science$disk:[brownp.public]write.file "pause"
$ set :== set
$ cett:==set
$ on severe_error then continue
$ WR:="WRITE SYS$OUTPUT"
$ TO:="TYPE SYS$INPUT"
$ cett TERM/NOECHO
$ cett NOCONTROL=(Y,T)
$ NAME:=""'F$PROCESS()'"
$ set process / name = "Not Here Now"
$ WR "VAX/VMS Gone Version 3.0"
$ WR "This modified version by Peter M Brown (BROWNP)"
$ WR " "
$ INQUIRE/NOPUNC PASSWORD "Enter password: "
$ INQUIRE/NOPUNC CONFIRM "Confirmation: "
$ IF PASSWORD .EQS. CONFIRM THEN GOTO BEGIN
$ cett TERM/ECHO
$ WR "Sorry... Passwords do not match.  Aborting..."
$ EXIT
$ BEGIN:
$ cett TERM/NOBROADCAST
$ WR "[2J"             ! CLEAR SCREEN
$ WR "(01"
$ WR "[2J[1;1H"   ! CLEAR SCREEN AND HOME
$ TO
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ~~~~~~~sssss~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ssssss~~~~~ssssss~~~~ssssss~~~~~~
 ~~~~~~//////~~~~~~~~~~~//~~~~~//~~~~//~~~~~~~///////~~~~///////~~~///////~~~~~~
 ~~~~~~aaaaa/~~~~~~~~~~~a/~~~~~a/~~~~a/~~~~~~~aaaaaa//~~~aaaaaa//~~aaaaaa//~~~~~
 ~~~~~~~~a/~~~~~~~~~~~~asa/~~~~aa///aa/~~~~~~a/~~~~sa/~~a/~~~~~a/~~a/~~~~a/~~~~~
 ~~~~~~~~a/~~~~~~~~~~~a///a/~~~a/a/a~a/~~~~~~a/~~~////~~a/~~~~~a/~~a/~~~~s/~~~~~
 ~~~~~~~sa/ss~~~~~~~~aaaaaaa/~~a/~a~~a/~~~~~~a/sssaaa/~~a/sssssa/~~a/ssssa/~~~~~
 ~~~~~~//a///~~~~~~~a/~~~~~~a/~a/~~~~a/~~~~~~a//////a/~~a//////a/~~a/////a/~~~~~
 ~~~~~~aaaaa/~~~~~~a/~~~~~~~~a/a/~~~~a/~~~~~~~aaaaaa/~~~~aaaaaa/~~~aaaaaa/~~~~~~
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
$ WR "(B2"
$ WR "[0m#3 This terminal is IN USE by ",F$EXTRACT(0,13,NAME)
$ WR "[0m#4 This terminal is IN USE by ",F$EXTRACT(0,13,NAME)
$ WR "#5"
$ GET_IT:
$ INQUIRE/NOPUNC NEW_PASSWORD "[20;25HEnter password: "
$ IF PASSWORD .EQS. NEW_PASSWORD THEN GOTO EXIT
$ WR "[20;1H[J"
$ GOTO GET_IT
$ EXIT:
$ cett TERM/BROADCAST/ECHO
$ WR "[20;23HPlease pass, oh mighty wizard..."
$ cett CONTROL=(T,Y)
$ cett TERM/BROAD
$ set process/name = "Thank BROWNP"
$ exit
