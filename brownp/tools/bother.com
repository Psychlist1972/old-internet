
 
$ vfy = f$verify(f$integer(f$logical("debug")) .or. 0+f$integer("''debug'")) 
$ if f$cvui(1,1,0+"''debug'") .or. f$cvui(1,1,0+f$logical("debug")) - 
    then write sys$error "File WORK1:[MORRIS.COM]BOTHER.COM, 8-Mar-1984" 
$ set noon 
$ on control_y then goto exit 
$ v4 = "true" 
$ if f$extr(0,2,f$getsyi("version")) .eqs. "V3" then v4 = "false" 
$ ! 
$ null_byte[0,8] = 0		!Set up phone protocol values 
$ true_byte[0,8] = 1 
$ false_byte[0,8] = 0 
$ id_rmt_user[0,8] = 7		!Text = id of remote user, status rtn 
$ ring_rmt_user[0,8] = 8	!Text = 1 byte, true if first ring, sts rtn 
$ hang_up[0,8] = 9		!Link broken, no status 
$ master_busy[0,8] = 10		!When requested to do other functions 
$ master_answer[0,8] = 11	!From another master 
$ master_reject[0,8] = 12	!From another master 
$ slave_exit[0,8] = 13		!Command to slave 
$ text[0,8] = 14		!Text >= 1 char frag 
$ request_dir[0,8] = 15		!Null returned when done 
$ force_third_party[0,8] = 17	!Text is id of 3rd party 
$ on_hold[0,8] = 18		!Put target on hold 
$ off_hold[0,8] = 19		!Take target off hold 
$ ! 
$ status_unknown = 0		!Unknown problem 
$ status_success = 1		!The operation was completed successfully. 
$ status_isyntax = 2		!Invalid user syntax 
$ status_nocomm = 3		!Slave could not communicate with user 
$ status_missunam = 4		!<node::user> missing user name 
$ status_nopriv = 5		!The slave does not have necessary privileges. 
$ status_noexist = 6		!The specified Target user does not exist. 
$ status_badterm = 7		!The Target's terminal cannot be used by PHONE. 
$ status_logoff = 8		!The Target logged off during the procedure. 
$ status_offhook = 9		!Target phone off hook (e.g., /NOBROADCAST set). 
$ ! 
$ remote_user = p1 
$ if remote_user .eqs. "" then read sys$command remote_user - 
    /error=error/end=exit/prompt="User to bother: " 
$ if .not. v4 then remote_user := 'remote_user' 
$ if v4 then remote_user = f$edit(remote_user,"trim,upcase,uncomment") 
$ remote_node = f$parse(remote_user,,,"node") - "_" 
$ remote_user = remote_user - remote_node 
$ if remote_user .eqs. "" then goto exit 
$ if remote_node .eqs. "" then remote_node = f$logi("sys$node") - "_" 
$ local_user = p2 
$ if local_user .eqs. "" then read sys$command local_user - 
    /error=error/end=exit/prompt="Person to blame: " 
$!$ local_user = f$edit(local_user,"trim,upcase,uncomment") 
$ wait_time = p3 
$ if (wait_time .eqs. "") .and. (p1 .eqs. "") then read sys$command - 
    wait_time /error=error/end=exit/prompt="Delay time in seconds <5>: " 
$ if wait_time .eqs. "" then wait_time = "5" 
$ wait_time = f$integer(wait_time) 
$ fudge_factor = 50 
$ if wait_time .eq. 0 then fudge_factor = 0 
$ if wait_time .gt. 0 then wait_time = wait_time - 1 
$ if wait_time .ge. 3600 then wait_time = 3599 
$ wait_minutes = wait_time / 60 
$ wait_time = wait_time - wait_minutes * 60 
$ local_user = local_user + null_byte 
$ open/read/write link 'remote_node'"29=" 
$ write /error=error link id_rmt_user,local_user,remote_user 
$ read link ans /end=error/error=error 
$ if f$cvui(0,8,ans) .ne. status_success then goto bad_status 
$ count = 1 
$ write sys$output "''f$fao("!ZW ringy-dingy!%S...",count)'" 
$ write /error=error link ring_rmt_user,local_user,true_byte 
$ read link ans /end=error/error=error 
$ if f$cvui(0,8,ans) .ne. status_success then goto bad_status 
$LOOP: 
$ wait 'f$fao("0 00:!2ZB:!2ZB.!2ZB",wait_minutes,wait_time,fudge_factor)' 
$ count = count + 1 
$ write sys$output "''f$fao("!ZW ringy-dingy!%S...",count)'" 
$ write /error=error link ring_rmt_user,local_user,false_byte 
$ read link ans /end=error/error=error 
$ if f$cvui(0,8,ans) .eq. status_success then goto loop 
$BAD_STATUS: 
$ write sys$output "''f$fao("Bad status received = !2ZB.",f$cvui(0,8,ans))'" 
$ERROR: 
$ write sys$output "An error has occured." 
$EXIT: 
$ if f$logi("link") .nes. "" then - 
    write link slave_exit,local_user 
$ close link /error=final_exit 
$FINAL_EXIT: 
$ if vfy then set verify ! 'f$verify(0)' 
$ exit 
