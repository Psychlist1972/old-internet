!
! Makes sure no goombas get my password and login into my account
! this program will send mail to my friends and tell them that someone
! is logging into my account, and to look around.
!
$ set nocontrol=(Y,T)
$ set term/nobroadcast
$ 
$ on severe_error then goto ABORT
$ on error then goto ABORT
$
$ set term/noecho
$ inquire/nopunc pass "The Psychlist >>> "
$ set term/echo
$ if pass .nes. "`" then goto BAD_USER
$ clear
$ 
$ write sys$output "Greetings Emperor ...
$ set term/broadcast
$ set control = (y,t)
$ exit
$
$BAD_USER:
$ set term/noecho
$ inquire/nopunc pass "Do you want SYSTEM$REDEF running? [n] :"
$ set term/echo
$ if pass .nes. "`" then goto DICKHEAD
$ write sys$output "You may pass oh hallowed one..."
$ set term/broadcast
$ set control = (y,t)
$ exit
$ 
$DICKHEAD:
$ w :== write sys$output
$
$ w "########################################################################"  
$ w " "
$ w "BBBBBBBBB    RRRRRRRRRR    OOOOOOOOOO  WWW    WWW    WWW    NNN      NNN"
$ w "BB      BB   RR       RR  OO        OO  WW   WW WW   WW     NNNN     NN"  
$ W "BB      BB   RR       RR  OO        OO  WW  WW   WW  WW     NN NN    NN" 
$ W "BBBBBBBBB    RRRRRRRRRR   OO        OO  WW  WW   WW  WW     NN  NN   NN" 
$ W "BB      BB   RR       RR  OO        OO  WW  WW   WW  WW     NN   NN  NN" 
$ W "BB      BB   RR       RR  OO        OO  WW  WW   WW  WW     NN    NN NN"
$ W "BBBBBBBBB    RR       RR   OOOOOOOOOO    WWWW     WWWW      NN     NNNN"
$ W " "
$ W "####################################################################### "
$ W " "
$ W " "
$ 
$  write sys$output "One second please, updating public directory..."
$  mail science$disk:[brownp.tools.stalkerinfo]intruder.txt woods::brownp /subj = "READ THIS NOW!!!!'
$  mail science$disk:[brownp.tools.stalkerinfo]intruder.txt woods::rotondoj/subj = "READ THIS NOW !!!!"
$  mail science$disk:[brownp.tools.stalkerinfo]intruder.txt woods::mackinj/subj = "READ THIS NOW !!!!"
$  mail science$disk:[brownp.tools.stalkerinfo]intruder.txt woods::correaa/subj = "READ THIS NOW !!!!"
$  write sys$output " "
$  write sys$output "%SYSTEM-W-SLOW Please wait..."
$  Write sys$output " "
$
$ASSHOLE:
$ 
$ABORT:
$  logout
$  logoff
$  lo
$  quit
$exit
