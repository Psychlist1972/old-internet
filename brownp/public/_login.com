
!			L  O  G  I  N  .  C  O  M 
!                       
!                             Peter M Brown 
!                              ULowell 1991
!
!
! To use this, put this line in your LOGIN.COM
!
!		$ @science$disk:[brownp.public]_login.com
!
!
$ on severe_error then continue
$ on error then continue
$
$
$ if p1 .EQS. "not" then goto START_IT
$
$ write sys$output " "
$ write sys$output "Please wait one moment, defining new command set."
$
$START_IT:
$
$ @ science$disk:[brownp.public]write.file "login"
$ @ science$disk:[brownp.public]esc_codes.com
$
$ set command app_disk:[nemesis]nemesis.cld
$
$ pub*lic  :== @science$disk:[brownp.public]run__this__always.com
$
$ cd	   :== @science$disk:[brownp.public]_set_def.com
$ move     :== @science$disk:[brownp.public]_move_file.com
$ ala*rm   :== spawn/nolog/nowait @science$disk:[brownp.public]_alarm_clock.com
$ clo*ck   :== spawn/nolog/nowait run science$disk:[brownp.public]_jclock
$
$ more     :== type/page
$ page     :== type/page
$
$ gron	   :== type science$disk:[brownp.public]_gra_on.txt
$ groff    :== type science$disk:[brownp.public]_gra_off.txt
$ pau*se   :== @ science$disk:[brownp.public]_pause.com
$ who      :== @ science$disk:[brownp.public]_who2.com
$ pdir     :== @ science$disk:[brownp.public]_dir2.com
$ ls	   :== dir/prot/siz/owner
$ re1	   :== @ science$disk:[brownp.public]_re1.com
$ tra*sh   :== @ science$disk:[brownp.public]_trash.com
$ jit*ter  :== @science$disk:[brownp.public]_jitter.com
$ bon*er   :== run science$disk:[brownp.public]sex2
$ se*nd    :== spawn/process = "Annoy_mail_PMB"/nolog/nowait @science$disk:[brownp.public]_much_mail.com
$ con*vert :== @science$disk:[brownp.public]_convert
$
$! pers*onals :== @electrical$disk:[cerconeg.bbs]bbs
$! pers*onals :== run science$disk:[brownp.personal]personal
$ pers*onal :== run electrical$disk:[cerconeg.bbs]beta
$
$ joke*s :== @electrical$disk:[keenerb.jokes]jokes
$
$ res*et   :== @group$disk:[compsci]reset
$ setp*age :== @group$disk:[compsci]setpage
$ stat*us  :== @science$disk:[brownp.public]_status.com
$
$! newcmds  :== type/page science$disk:[brownp.public]login_help.txt
$ newcmds  :== help/library = science$disk:[brownp.help_library]newcmds
$
$  wha*t     :== show term
$  where     :== show def
$
$ mail     :== mail/edit=(send, reply=(extract), forward)
$ time     :== show time 
$
$  ki*ll     :== stop process / id = 
$
$  all        :== set prot=(w:re,g:re,o:rwed,s:re) *.*;*
$  own*er     :== set prot=(o:rwed) *.*;*
$  gro*up     :== set prot=(g:re  ) *.*;*
$  sysprot    :== set prot=(s:re  ) *.*;*
$
$ fin      :== finger/full
$
$ su       :== show users/full
$ elog     :== edit sys$login:login.com
$ alog     :== @sys$login:login.com
$ bro      :== set term/broadcast
$ nbr      :== set term/nobroadcast
$ echon    :== set term/echo
$ echoff   :== set term/noecho
$ draw     :== run science$disk:[brownp.public]_draw
$ oleary   :== print/queue= oleary
$ os101    :== print/queue = os101
$ os101b   :== print/queue = os101b
$ os101a   :== print/queue = os101a
$ quo*ta   :== @science$disk:[brownp.public]_quota.com
$ tree	   :== @science$disk:[brownp.public]tree.com
$  cs	     :== telnet CS
$
$  Ha*wk     :== telnet hawk        ! unix account (main)
$  As*pen    :== set host aspen     ! vms  account..woods cluster
$  Wi*llow   :== set host willow    ! vms  account..woods cluster
$  Gu*ll     :== set host gull      ! unix account HAWK cluster...mail server
$  par*rot   :== telnet parrot      ! unix workstation HAWK cluster
$  phe*asant :== telnet pheasant    ! unix workstation HAWK cluster
$  pip*et    :== telnet pipet       ! unix workstation HAWK cluster
$  pet*rel   :== telnet petrel      ! unix workstation HAWK cluster
$
$  diku :== telnet 139.102.14.10 4000
$  chaos :== telnet 128.112.120.28 4000
$
$ set term/dev = vt100
$ set term/insert
$ set term/wrap
$ set term/lowercase
$ set term/broadcast
$
$ if p1 .EQS. "not" then goto SET_PNAME
$
$ write sys$output " "
$ write sys$output "The command NEWCMDS will give you a help list for _LOGIN.COM"
$ write sys$output "and PAS_UTILS.  Please look at it."
$ write sys$output " "
$ write sys$output "Please look at the E_personals (type PERSONAL at the $), developed "
$ write sys$output "by Peter M Brown and George Cercone"
$ write sys$output "                                                     --- The Psychlist"
$ write sys$output " "
$ write sys$output "NOTE: You will probably get a process name error, please ignore it."
$ write sys$output " "
$
$
$SET_PNAME:
$
$ set process/name = "Thank BROWNP 5"
$ set process/name = "Thank BROWNP 4"
$ set process/name = "Thank BROWNP 3"
$ set process/name = "Thank BROWNP 2"
$ set process/name = "Thank BROWNP 1"
$
$ if p1 .EQS. "CLOCK" then CLOCK
$ if p1 .EQS. "clock" then CLOCK
$ if p2 .EQS. "CLOCK" then CLOCK
$ if p2 .EQS. "clock" then CLOCK
$
$exit
