$!Another in a fine line of useless little programs by:
$!
$!				Brian E. Keener
$!			      written May 8, 1991
$!                          keenerb@aspen.ulowell.edu 
$!
$!	This program is designed to make any terminal "beep" on the hour to use 
$!this program it must be spawned useing the following command:
$!			SPAWN/NOWAIT @BEEPER.COM
$!
$ set nocontrol = (y,t)
$ wso       :== write sys$output
$ bell[0,8] == 7
$ esc[0,8]  == 27
$ cursup    == esc+"[A"
$ bellesc   == bell+cursup
$ beep      :== 'wso bellesc
$ set process/name="'lil beeper"
$
$ time = f$time()
$ time = f$extract(12,2,time)
$ time = f$interger(time)
$ oldtime = time
$
$ goto TIMECHECK
$
$TIMECHECK:
$
$ wait 00:00:01.00
$ time = f$time()
$ time = f$extract(12,2,time)
$ time = F$interger(time)
$ if oldtime .EQS. time then goto TIMECHECK
$ oldtime = time
$ goto NOTIFY
$
$NOTIFY:
$
$ beep
$ beep 
$ goto TIMECHECK
