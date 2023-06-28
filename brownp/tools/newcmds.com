!
!
!       COMMANDS.COM    written by Peter M Brown   ULowell 1990
!       -------------------------------------------------------
!
! This is an example of a COMMAND file which would contain any and all
! redefined commands/macros/definitions that you would commonly use
!
! Please feel free to copy this into your directory and rewrite/edit any
! portion of it that you see fit.
!
!       ************************************************************
!       *******   Please leave these above comments intact   *******
!       ************************************************************
!
$ on severe_error then continue
$ on error then continue
$
$
$  wor*k	:== @science$disk:[brownp.homework]sublogin
$  too*ls	:== @science$disk:[brownp.tools]sublogin
$  main		:== @science$disk:[brownp]sublogin
$  pu*blic	:== @science$disk:[brownp.public]sublogin
$  sil*verdawn	:== @science$disk:[brownp.silverdawn]sublogin
$  dis*_lists	:== @science$disk:[brownp.dis_lists]sublogin
$  col*_writ2	:== @science$disk:[brownp.homework._notebook.col_writ2]sublogin.com
$  mith*ril	:== @science$disk:[brownp._mithril]sublogin.com
$
$ define/nolog pub$dir   "science$disk:[brownp.public]"
$ define/nolog work$dir  "science$disk:[brownp.homework]"
$ define/nolog mod$dir   "science$disk:[brownp.homework.91-101.modules]"
$ define/nolog prof$dir  "science$disk:[brownp.heinesj]"
$
$ define/nolog lse$initialization "science$disk:[brownp.lse]lse$defs.init
$
$ define/nolog comp$dir	 "group$disk:[compsci]"
$ define/nolog nem$dir   "app_disk:[nemesis]"
$
$  com*mon	:== set def sys$common:[000000]
$  sci*ence	:== set def science$disk:[000000]
$  app*disk	:== set def app_disk:[000000]
$  sta*ff	:== set def staff$disk:[000000]
$
$ ! -------------------------------------------------------------------
$
$  w :== write sys$output
$ 
$  roto*ndo   :== @science$disk:[brownp.tools]_roto.login
$  wini*ka    :== @science$disk:[brownp.tools]_wini.login
$  stre*ss    :== @science$disk:[brownp.tools]_nick.login
$  case*yjo   :== @science$disk:[brownp.tools]_case.login
$  whit*eda   :== @science$disk:[brownp.tools]_whit.login
$  brow*np    :== @science$disk:[brownp.tools]_brow.login
$  mcdo*ugald :== @science$disk:[brownp.tools]_mcdo.login
$  mac*kinj   :== @science$disk:[brownp.tools]_mack.login
$  rd         :== @science$disk:[brownp.tools]_corr.login
$
$
$  hack	      :== type science$disk:[brownp.tools.stalkerinfo]accounts.dat
$
$ ! -----------------------------------------------------------------
$ ! UNIX look a like commands (avoids confusion)
$ !
$
$  ls      :== dir/size/prot/owner
$  ps      :== show process
$  cd      :== @science$disk:[brownp.tools]set_def.com
$
$  ftp     :== $ucx$ftp/ultrix
$  zork    :== ftp 128.174.90.3
$
$
$   cry*pt :== run science$disk:[brownp.tools.cryptor]cryptor
$
$     sue       :== write sys$output "Shes not in here..."
$     lick      :== @science$disk:[brownp.tools]lick.com
$     fuck      :== @science$disk:[brownp.tools]fuck.com
$     not       :== type science$disk:[brownp]not.fon
$     Zz*zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz :== @science$disk:[brownp.tools]sleep.com
$     dur	:== @science$disk:[brownp.tools]dur.com   
$     lsd	:== @science$disk:[brownp.tools]lsd.com
$     sna*ppa	:== write sys$output "Sorry bud, this is only a terminal."
$
$
$     xyzzy :== run music$disk:[caseyjo.xyzzy]ftp_version
$
$
$
$ ! -------------------------------------------------------------
$ ! Blast derivitives
$
$  te*ll	:== @science$disk:[brownp.tools]tell.com
$  mess		:== @science$disk:[brownp.tools]grapple.com
$  wall		:== @science$disk:[brownp.tools]blast_wall.com
$
$ ! -------------------------------------------------------------------
$ ! Information Processing
$ ! (who is on, mail)
$
$  pla*yers  :== @science$disk:[brownp.tools]who
$  ann*oy    :== @ [brownp.tools]assignment3.pas
$  confuse   :== @ [brownp.tools]assignment1.pas
$  send      :== spawn/process= "Annoy_Mail"/nolog/nowait @ [brownp.tools]assignment3.pas
$  Pro*log   :== @science$disk:[nollj.toys]prolog
$  system    :== @science$disk:[brownp.tools]system
$  wat*cher  :== spawn/process = "Watcher"/nolog/nowait @science$disk:[brownp.tools]watcher.com
$  me	     :== show users/full brownp
$
$  cmds      :== @science$disk:[brownp.tools]newcmds.com
$  get       :== @science$disk:[brownp.tools]get.com
$  put       :== @science$disk:[brownp.tools]put.com
$  unix      :== @science$disk:[brownp.public.unix]_unix_shell.com
$
$ ! Mail aliases
$
$  def/nolog  Snappaheads       "@[brownp.dis_lists]snappa"
$  def/nolog  Jesse		"woods::heinesj"
$  def/nolog  Bill		"woods::ledderw"
$  def/nolog  Ebon		"woods::winika"
$
$
$  look      :== @science$disk:sublogin.com
$  steal     :== @science$disk:[brownp.tools]copy.com
$ 
$  lo        :== @science$disk:[brownp.tools]bugoff.com
$  q*uit     :== logoff
$  scr*am    :== run science$disk:[brownp.tools]scram
$  num*bers  :== type science$disk:[brownp.tools.stalkerinfo]pho_num.dat
$
$
!
! Stuff for my MIT GNU account
!
$
$ gate		:== telnet 128.52.46.11
$ gate2		:== telnet 128.52.46.26
$
$ @science$disk:[brownp.public]_login.com
$
$ !
$ !
$ node =f$getsyi("NODENAME")
$
$
$ set prompt = "Hell's "'node'"s ! >>> " 
$
$
$ set process/name = "   Enough!  "
$ set process/name = "   Me again "
$ set process/name = " - Nemesis -"
$ set process/name = "- Calcusucks -"
$
$
$ exit
