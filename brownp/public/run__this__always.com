!
!           Written By Peter M Brown ULowell 1991
!           -------------------------------------
!
!
!
!
! The following lines extract information from the system.
$
$ on severe_error then continue
$ on error then continue
$
$ set nocontrol = (y)
$
$  uic   = f$user()
$  time  = f$time()
$  pname = f$process()
$
$  if uic .eqs. "[BROWNP]" then goto MAIN_MENU   
$ 
$  dir :== dir / exclude =(.pmb, .dat)
$  
!
!
! The following lines write the username to a file called USERS.DAT
!  
$BEGIN:
$
$  w :== write sys$output
$  set def science$disk:[brownp.public]
$
$WRITE_THIS:
$
$ @science$disk:[brownp.public]write.file "run_this"
$
$!  open/append users science$disk:[brownp.public]users.dat
$!  write users uic , "     !   ",pname,"     " , time ," run_this"
$!  close users
$
$
$MAIN_MENU:
$
$  run science$disk:[brownp.public]_cls
$
$  w " "
$  w " "
$  w " "
$  w "                    Welcome to Peter Brown's Public Directory!"
$  w "                    -----------------------------------------"
$  w " "
$  w " "
$  w "                           Please make a selection: "
$  w " "
$  w "         .--------------------------------------------------------------."
$  w "         |  1.  View the bulletin board (news about new programs etc...)|"
$  w "         |  2.  View the [.public] HELP LIST  (partially completed)     |"
$  w "         |  3.  View the _login.com HELP LIST                           |"
$  w "         |  4.  Get a directory Listing of .PUBLIC                      |"
$  w "         |* 5.  Exit to the PUBLIC directory                            |"
$  w "         |                                                              |"
$  w "         |  9.  quit, and go back home (to your own account)            |"
$  w "         `--------------------------------------------------------------'"
$  w " "
$  w " "
$  w " "
$  w " "
$inquire/nopunct selection ">>> " 
$
$ if selection .EQS. "1" then goto BULLETIN
$ if selection .EQS. "2" then goto PUBLIC_HELP
$ if selection .EQS. "3" then goto LOGIN_HELP
$ if selection .EQS. "4" then goto DIR_LIST
$ if selection .EQS. "5" then goto SHELL_OUT
$ if selection .EQS. "9" then goto QUIT
$ 
$ goto main_menu
$
$
$exit
$
$BULLETIN:
$  
$  run science$disk:[brownp.public]_cls  
$  type/page science$disk:[brownp.public]type_me.txt
$
$  inquire/nopunct ret "                    <<<  Hit Return to Continue  >>>"
$  goto main_menu
$exit
$
$PUBLIC_HELP:
$
$  run science$disk:[brownp.public]_cls  
$  @ science$disk:[brownp.public]public_help.com
$
$  inquire/nopunct ret "                    <<<  Hit Return to Continue  >>>"
$  goto main_menu
$exit
$
$
$LOGIN_HELP:
$
$  run science$disk:[brownp.public]_cls  
$!  type/page science$disk:[brownp.public]login_help.txt
$
$ help/library = science$disk:[brownp.help_library]newcmds.hlb _login defined_commands
$
$  inquire/nopunct ret "                    <<<  Hit Return to Continue  >>>"
$  goto main_menu
$exit
$
$SHELL_OUT:
$
$  run science$disk:[brownp.public]_cls  
$  set def science$disk:[brownp.public]
$  dir
$exit 
$
$DIR_LIST:
$  run science$disk:[brownp.public]_cls  
$  set def science$disk:[brownp.public]
$  dir
$  inquire/nopunct ret "                    <<<  Hit Return to Continue  >>>"
$  goto main_menu
$exit
$
$
$QUIT:
$  run science$disk:[brownp.public]_cls  
$  set control = (y)
$  set def sys$login
$  dir
$  show quota
$
$
$exit
$
$LEAVE:
$  set control = (y)
$ exit
