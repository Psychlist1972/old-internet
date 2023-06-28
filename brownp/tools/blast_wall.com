$! $ @<what-ever-you-called-the-file> <username> "message"
$!
$ status = 1
$ cr[0,8] = 12
$ bell[0,8] = 7
$ of:="                                                                     "
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
$ status_0 = "Unknown problem"
$ status_1 = "The operation was completed successfully."
$ status_success = 1
$ status_2 = "Invalid user syntax"
$ status_3 = "Slave could not communicate with user"
$ status_4 = "node::user> missing user name"
$ status_5 = "The slave does not have necessary privileges."
$ status_6 = "The specified Target user does not exist."
$ status_7 = "The Target's terminal cannot be used by PHONE."
$ status_8 = "The Target logged off during the procedure."
$ status_9 = "Target phone off hook (e.g., /NOBROADCAST set)."
$ status_other = "Bad status code."
$ !
$ remote_user = p1
$ if remote_user .eqs. "" then read sys$command remote_user -
    /error=error/end=exit/prompt="User to send message to: "
$ remote_user = f$edit(remote_user,"trim,upcase,uncomment")
$ remote_node = f$parse(remote_user,,,"node") - "_"
$ remote_user = remote_user - remote_node
$ if remote_user .eqs. "" then goto exit
$ if remote_node .eqs. "" then remote_node = f$logi("sys$node") - "_"
$ message = "''p2'"
$ if message .eqs. "" then read sys$command message -
    /error=error/end=exit/prompt="Message to display:"
$ message = "''cr'''bell'''bell'''f$edit(message,"trim")'''of'''bell'''bell'" + null_byte
$ open/read/write link 'remote_node'"29="
$ write /error=error link id_rmt_user,message,remote_user
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .ne. status_success then goto bad_status
$!!!
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$!!
$ if f$cvui(0,8,ans) .eq. status_success then goto exit
$close link
$BAD_STATUS:
$ status_code = f$cvui(0,8,ans)
$ if status_code .gt. 9 then status_code = 10
$ status_message = status_'status_code'
$ write sys$output "''f$fao("Bad status received = !2ZB - ",status_code)'''status_message'"
$ERROR:
$ status = $status
$ write sys$output "An error has occured."
$EXIT:
$ if f$logi("link") .nes. "" then -
    write link slave_exit,message
$ if f$logi("link") .nes. "" then -
    close link
$ exit status

