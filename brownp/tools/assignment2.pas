$
$ status = 1
$ cr[0,8] = 13
$ bell[0,8] = 7
$ of:="                                                                       "
$ null_byte[0,8] = 0             !Set up phone protocol values               
$ true_byte[0,8] = 1
$ false_byte[0,8] = 0
$ id_rmt_user[0,8] = 7           !Text = id of remote user, status rtn
$ ring_rmt_user[0,8] = 8         !Text = 1 byte, true if first ring, sts rtn
$ hang_up[0,8] = 9               !Link broken, no status
$ master_busy[0,8] = 10          !When requested to do other functions
$ master_answer[0,8] = 11        !From another master
$ master_reject[0,8] = 12        !From another master
$ slave_exit[0,8] = 13           !Command to slave
$ text[0,8] = 14                 !Text >=1 char frag
$ request_dir[0,8] = 15          !Null returned when done
$ force_third_party[0,8] = 17    !Text is id of 3rd party
$ on_hold[0,8] = 18              !Put target on hold
$ off_hold[0,8] = 19             !Take target off hold
$ 
$ status_0 = "Unknown problem"
$ status_1 = "The operation was completely successful."
$ status_success = 1
$ status_2 = "Invalid user syntax"
$ status_3 = "Slave could not communicate with user"
$ status_4 = "node::user. missing user name"
$ status_5 = "The slave does not have the neccasry privileges."
$ status_6 = "The specified Target user does not exist."
$ status_7 = "The Target's terminal cannot be used by PHONE."
$ status_8 = "The Target logged off during the procedure."
$ status_9 = "Target phone of hook (e.g., /NOBROADCAST set)."
$ status_other = "Bad status code." 
$
$ write sys$output " "
$ write sys$output "       You MUST type in lowercase letters except when entering message"
$ write sys$output " "
$ amount = p1
$ if amount .eqs. "" then read sys$command amount -
    /error=error/end=exit/prompt="Number users to blast(ONE,SPECific,FILE): "
$ if amount .eqs. "one" then goto ONE
$ if amount .eqs. "spec" then goto SPECIFIC
$ if amount .eqs. "file" then goto FILE
$ if amount .eqs. "" then goto ONE
$ SCREW = "Error--You were supposed to enter one, spec, or file and not ''amount'"
$ goto EXIT
$
$
$ONE: 
$
$ remote_user = p2
$ if remote_user .eqs. "" then read sys$command remote_user -
    /error=error/end=exit/prompt="User to blast: "
$ goto SIZE
$
$
$SPECIFIC: 
$
$  write sys$output "             Hit return at prompt when done" 
$  create specific_users.txt
$  num = 1
$
$
$ GET_USERS: 
$
$  spec_user = p2  
$  inquire/nopunc spec_user "Specific user #''num': "
$  if spec_user .eqs. "" then amount = "file"
$  if spec_user .eqs. "" then u_file = "specific_users.txt"
$  if spec_user .eqs. "" then spec_user = "end_of_file"
$  open/append spus specific_users.txt
$  write spus "''spec_user'"
$  close spus
$  if spec_user .eqs. "end_of_file" then goto SIZE
$  num = num + 1
$  goto GET_USERS
$
$
$FILE:
$ 
$  u_file = p2
$  if u_file .eqs. "" then read sys$command u_file -
    /error=error/end=exit/prompt="Users.txt filename: "
$  !if f$search("''u_file';*") .eqs. "" then SCREW:== "Error--Users.txt file ''u_file' not found"
$   if f$search("''u_file';*") .eqs. "" then goto EXIT
$
$
$SIZE:
$ 
$ how = p3
$ if how .eqs. "" then read sys$command how -
    /error=error/end=exit/prompt="Blast LINE or FILE: "
$ w = 1
$ v = 1
$ if how .eqs. "line" then goto LINE
$ if how .eqs. "file" then goto TEXT
$ SCREW = "Error--You were supposed to enter line or file and not ''how'"
$ goto EXIT
$
$
$ANNOY:
$  
$ bell = p6
$ if bell .eqs. "" then read sys$command bell -
    /error=error/end=exit/prompt="Bell (y,n,f for fake): "
$ if bell .eqs. "" then goto BELL
$ if bell .eqs. "y" then goto BELL
$ if bell .eqs. "n" then goto BELL
$ if bell .eqs. "f" then goto BELL
$ SCREW =  "Error--You were supposed to enter y, n, of f and not ''bell'"
$ goto EXIT
$
$BELL:
$
$ if bell .eqs. "" then message = "''cr'''f$edit(message,"trim")'''of'" + null_byte
$ if bell .eqs. "n" then message = "''cr'''f$edit(message,"trim")'''of'" + null_byte
$ if bell .eqs. "y" then message = "''cr'''bell'''bell'''f$edit(message,"trim")'''of'''bell'''bell'" + null_byte
$ !if bell .eqs. "y" then message = "''cr'''bell'''bell'''f$edit(message,"trim")'''of'''bell'''bell'" + null_byte
$ if bell .eqs. "f" then message = "''f$edit(message,"trim")'" + null_byte
$ if how .eqs. "line" then goto LINE_CONT
$ w = 2
$ if kind .eqs. "one" then goto SINGLE_CONT
$ if how .eqs. "file" then goto FILE_CONT
$ exit
$
$
$LINE:
$ 
$ message = p5
$ if message .eqs. "" then read sys$command message -
    /error=error/end=exit/prompt="Message: "
$ goto ANNOY
$
$
$LINE_CONT: 
$
$ SCREW = 0
$ if amount .eqs. "one" then goto SEND
$ open/read who 'u_file
$
$
$USER:
$ 
$ read who remote_user
$ if remote_user .eqs. "end_of_file" then goto END
$ goto SEND
$
$
$TEXT:
$ 
$ kind = p4
$ if kind .eqs. "" then read sys$command kind -
    /error=error/end=exit/prompt="Send by ALL or ONE: "
$ file = p5
$ if file .eqs. "" then read sys$command file -
    /error=error/end=exit/prompt="File to blast: "
$ if f$search("''file';*") .eqs. "" then goto SCREWUP
$ if kind .eqs. "all" then goto ALL
$ if kind .eqs. "one" then goto SINGLE
$ SCREW = "Error--The file ''file' was not found"
$ goto EXIT
$
$
$ALL: 
$
$ SCREW = 0
$ if amount .eqs. "one" then goto BEGIN
$ open/read who 'u_file
$
$
$USER_2:
$ 
$ read who remote_user
$ if remote_user .eqs. "end_of_file" then goto END
$
$
$BEGIN:
$ 
$ open/read test 'file
$
$
$ LOOP:
$
$ read test message
$ if message .eqs. "end_of_file" then goto DONE
$ if w .eqs. 1 then goto annoy
$ goto bell
$
$
$FILE_CONT: 
$ goto SEND
$
$
$SINGLE:
$ 
$ SCREW = 0
$ goto START
$
$
$FINISHED_LINE: 
$
$ close who
$ goto NEXT_MESSAGE
$ 
$
$START:
$ 
$ open/read test 'file
$
$
$NEXT_MESSAGE:
$
$ read test message
$ if message .eqs. "end_of_file" then v = 2
$ if message .eqs. "end_of_file" then goto DONE
$ if w  .eqs. 1 then goto ANNOY
$ goto BELL
$
$
$SINGLE_CONT: 
$
$  open/read who 'u_file
$
$
$USER_3:
$ 
$  read who remote_user
$  if remote_user .eqs. "end_of_file" then goto FINISHED_LINE
$
$SEND:  
$ remote_user = f$edit(remote_user,"trim,upcase,uncomment")
$ remote_node = f$parse(remote_user,,,"node") - "_"
$ remote_user = remote_user - remote_node
$ if remote_user .eqs. "" then goto exit
$ if remote_node .eqs. "" then remote_node = f$logi("sys$node") - "_"
$ 
$ open/read/write link 'remote_node'"29=" 
$ write /error=error link id_rmt_user,message,remote_user
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .nes. status_success then goto BAD_STATUS
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$
$ if how .eqs. "file" then goto CLOSE
$ if amount .eqs. "one" then goto LAST_IF
$
$
$CLOSE:
$ 
$ close link
$ if how .eqs. "line" then goto RET_USER
$ if kind .eqs. "one" then goto RET_USER
$ goto LOOP
$
$
$DONE: 
$
$close test
$ if kind .eqs. "one" then goto LAST_IF
$
$
$RET_USER: 
$
$ write sys$output "          ''remote_user' blasting completed"
$ if kind .eqs. "one" then goto USER_3
$ if amount .eqs. "one" then goto LAST_IF
$ if how .eqs. "line" then goto USER
$ goto USER_2
$
$
$END:
$
$ close who
$ if remote_user .eqs. "end_of_file" then goto EXIT
$
$LAST_IF: 
$
$ if f$cvui(0,8,ans) .eqs. status_success then goto exit
$
$
$BAD_STATUS:
$
$ status_code = f$cvui(0,8,ans)
$ if status_code .gt. 9 then status_code = 10
$ status_message = status_'status_code'
$ write sys$output "''f$fao("Bad status received = !2ZB - ",status_code)'''status_message'"
$ if f$logi("link") .nes. "" then close link
$ if amount .eqs. "one" then goto ERROR
$ if v .eqs. 2 then goto EXIT
$ if kind .eqs. "one" then goto USER_3
$ if how .eqs. "file" then goto DONE 
$ if amount .eqs. "file" then goto RET_USER
$
$
$ERROR:
$
$ status = $status
$ write sys$output "An error has occured."
$
$
$EXIT:
$
$ !exit
$ if f$logi("link") .nes. "" then -
    write link slave_exit,message
$ if f$logi("link") .nes. "" then -
    close link
$ if f$logi("test") .nes. "" then -
    close test
$ if f$logi("who") .nes. "" then -
    close who
$ if f$search("specific_users.txt;*") .nes. "" then del specific_users.txt;*
$ if SCREW .eqs. 0 then EXIT
$ write sys$output "   ''SCREW'"
$
$ EXIT
$ !exit status
