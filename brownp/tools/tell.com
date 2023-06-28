$ ! IT'S BLAST.COM AND IT'S AS NASTY AS EVER!!!!!
$
$ status = 1
$ cr[0,8] = 13
$ bell[0,8] = 7
$ of:="                                                                       "
$ null_byte[0,8] = 0
$ true_byte[0,8] = 1
$ false_byte[0,8] = 0
$ id_rmt_user[0,8] = 7
$ ring_rmt_user[0,8] = 8
$ hang_up[0,8] = 9
$ master_busy[0,8] = 10
$ master_answer[0,8] = 11
$ master_reject[0,8] = 12
$ slave_exit[0,8] = 13
$ text[0,8] = 14
$ request_dir[0,8] = 15
$ force_third_party[0,8] = 17
$ on_hold[0,8] = 18
$ off_hold[0,8] = 19
$ 
$ status_0 = "Unknown problem"
$ status_1 = "The operation was completely successful"
$ status_success = 1
$ status_2 = "Invalid user syntax"
$ status_3 = "Slave could not communicate with user"
$ status_4 = "node::user. missing user name"
$ status_5 = "The slave does not have the neccasry privileges"
$ status_6 = "The specified Target user does not exist."
$ status_7 = "The Target's terminal cannot be used by PHONE"
$ status_8 = "The loser logged off during the procedure"
$ status_9 = "Target phone of hook (e.g., /nobroadcast set or he is being a prick)."
$ status_other = "bad status code" 
$
$ remote_user = p1
$ if remote_user .eqs. "" then read sys$command remote_user -
    /error=error/end=exit/prompt="Player to tell : "
$ remote_user = f$edit(remote_user,"trim,upcase,uncomment")
$ remote_node = f$parse(remote_user,,,"node") - "_"
$ remote_user = remote_user - remote_node
$ if remote_user .eqs. "" then goto exit
$ if remote_node .eqs. "" then remote_node = f$logi("sys$node") - "_"
$ message = "''p2'"
$ if message .eqs. "" then read sys$command message -
    /error=error/end=exit/prompt="Message : "
$
$ ! ----------------------------------------------------------------------
$   time = f$time()
$   write sys$output time
$   minute = f$extract(16,1,time)
$
$   if minute .EQS. "0" then message = "Psychlist screams : '"+message
$   if minute .EQS. "1" then message = "Pete Brown : '"+message
$   if minute .EQS. "2" then message = "Pete Brown says, '"+message
$   if minute .EQS. "3" then message = "Pete Brown tells you: '"+message
$   if minute .EQS. "4" then message = "Psychlist says, '"+message
$   if minute .EQS. "5" then message = "BROWNP says, '"+message
$   if minute .EQS. "6" then message = "Pete B. shouts : '"+message
$   if minute .EQS. "7" then message = "Psychlist shouts : '"+message
$   if minute .EQS. "8" then message = "Pete Brown yells: '"+message
$   if minute .EQS. "9" then message = "Pete B. wheezes : '"+message
$
$   show symbol message
$ ! ----------------------------------------------------------------------
$
$ on error then  goto BAD_STATUS
$ annoiance = "b"
$ if annoiance .eqs. "b" then message = "''cr'''bell'''bell'''f$edit(message,"trim")'''of'''bell'''bell'" + null_byte
$
$ open/read/write link 'remote_node'"29=" 
$ write /error=error link id_rmt_user,message,remote_user
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .ne. status_success then goto bad_status
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .eq. status_success then goto exit
$BAD_STATUS:
$ status_code = f$cvui(0,8,ans)
$ if status_code .gt. 9 then status_code= 10
$ status_message = status_'status_code'
$ close link
$ write sys$output "''f$fao("Bad status recieved = !2ZB - ",status_code)'''status_message'"
$ERROR:
$ status = $status
$ write sys$output "An error has occured."
$ exit
$EXIT:
$ if f$logi("link") .nes. "" then -
    write link slave_exit,message
$ if f$logi("link") .nes. "" then -
    close link
$ write sys$output "Message sent."
$ exit status
