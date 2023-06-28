!
!
!			S U P E R   B L A S T . C O M 
!
!		          Written by Peter M Brown
!			      Ulowell 1990-91
!
!
!
! To customize this program, you must change the following lines:
$
$     myname = "Pete B."
$     myhis  = "his" ! for girl      myhis = "hers"
$     myhim  = "him" ! for girl      myhim = "her"
$     mygeni = "rod" ! for girl, use "twat" or "snatch" or "box" or whatever
$
$ if myname .EQS. "Your name here" then goto NO_ONE
$
!-----------------------------------------------------------------------
$
$ status = 1
$ cr[0,8] = 13
$ bell[0,8] = 7
$ of:="                                                                       "
$ null_byte[0,8] = 0		! set up phone protocol values
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
$ wso :== write sys$output
$
$ CTRLS[0,8] =  19
$ CTRLT[0,8] =  20
$ CTRLY[0,8] =  25
$ ESC[0,8]   =  27
$ CURSUP     =  ESC+"[A"
$ CURSDOWN   =  ESC+"[B"
$ SAVESC     =  ESC+"7"
$ RESTESC    =  ESC+"8"
$ BELLESC    =  BELL+CURSUP
$ RINGESC    =  BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+BELL+CURSUP
$ REVESC     =  ESC+"[7m"+CURSUP
$ NORMESC    =  ESC+"[m"+CURSUP
$ GRONESC    =  ESC+"(0"+CURSUP
$ GROFFESC   =  ESC+"(B"+CURSUP
$ JUMPESC    =  ESC+"[?4l"+CURSUP
$ SCROLLESC  =  ESC+"[?4h"+CURSUP
$ WHINESC    =  ESC+"[163q"
$ REPESC     =  ESC+"[2;9y"
$ RESETESC   =  ESC+"c"
$ CLRESC     =  ESC+"[2J"+ESC+"[f"
$ LIGHTESC   =  ESC+"[?5h"+CURSUP
$ DARKESC    =  ESC+"[?5l"+CURSUP
$ FLASHESC   =  ESC+"[?5h"+ESC+"[?5l"+CURSUP
$ L1ESC      =  ESC+"[1q"+CURSUP
$ L2ESC      =  ESC+"[2q"+CURSUP
$ L3ESC      =  ESC+"[3q"+CURSUP
$ L4ESC      =  ESC+"[4q"+CURSUP
$ ALLESC     =  ESC+"[1;2;3;4q"+CURSUP
$ OFFESC     =  ESC+"[q"+CURSUP
$ WIDESC     =  ESC+"#6*"
$
$
$
$
$ DEFAULT_MSG = myname + " doesnt really have anything interesting to say.             "
$ FART_MSG   = "The ground rumbles as "+myname+" blows a fart through your terminal!"
$ SNEEZE_MSG = "You are covered in yellow schmegma from "+myname+"'s sneeze.              "
$ BOOGER_MSG = "A great big booger lands on your screen from "+myname+".             "
$ BULKIE_MSG = "You notice your mutha sliding down a hill on a bulkie roll."
$ SAMBA_MSG  = myname + " asks, 'Wanna Samba???'                                "
$ LUNCH_MSG  = myname + " asks, 'When and where are you people going to lunch?'"       
$ SUPPER_MSG = myname + " asks, 'When and where are you people going to supper??'"
$ ASSHOLE_MSG = myname + " shouts, 'Y O U   A S S H O L E ! ! !'                      "
$ TUNA_MSG   = "Is that YOUR mutha on a tuna melt over there??                         "
$ WHERE_MSG  = myname + " asks, 'Where are you right now?'                          "
$ LICK_MSG   = myname + " says to 'Lllllllllllick me!'                              "
$ TONIGHT_MSG = myname + "asks, 'What is going on tonight??'                                  "
$ CPU_MSG    =  "%CPU-S-TIMEXP CPU time limit expired.                                                     "
$ SHUTDOWN2_MSG = "Node will be shutting down in 2 minutes.                            "+BELL+BELL
$ SHUTDOWNNOW_MSG = "Node will be shutting down immediately.                                      "+BELL+BELL
$ WEDGE_MSG  =  myname + " tells you to pick " + myhis + " wedge.                               "
$ SUCKMY_MSG =  myname + " tells you to suck " + myhis + " " + mygeni+ ".           "
$
$ BENCH_MSG  = myname + " asks you if you can benchpress an 18 wheeler with that.        "
$ TONGUE_MSG = "A giant slimy tongue comes out of the screen and licks you!              "
$ ANUS_MSG   = myname + "'s "+ mygeni+" shoves itself up your anal opening.                                        "
$ POOCH_MSG  = "A huge wet glob of alien pooch cum lands on your face.                     "
$ WETBED_MSG = myname + " say 'Wet bed, live longer.'                                           "
$ CRUST_MSG  = myname + " tells you to eat " + myhis + " crusty dingleberries.                                            "
$ CHUNKS_MSG = myname + " blows chunks through your terminal screen.                                          "
$ BENDOVER_MSG = myname + " tells you to bend over and smile.                                       "
$ REDSNAPPA_MSG = myname + " asks, '...and what will you do with your red snappa?'     " 
$ BISCUIT_MSG  = myname + " floats a nice juicy air-buiscuit in your general direction."
$ AUNTY_MSG  = myname + " waves " + myhis + " private parts at your aunties.       "
$ BACK_MSG = myname + " tells you to lick the back of " +myhis+ " "+mygeni+" from across the room."
$ HYDRANT_MSG = myname + " asks you if you can blow a fire hydrant with those lips...  "
$ 
$ !
$ !
$ !
$
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
    /error=error/end=exit/prompt="Player whos screen is to be messed up : "
$ remote_user = f$edit(remote_user,"trim,upcase,uncomment")
$ remote_node = f$parse(remote_user,,,"node") - "_"
$ remote_user = remote_user - remote_node
$ if remote_user .eqs. "" then goto no_one
$ if remote_node .eqs. "" then remote_node = f$logi("sys$node") - "_"
$
$
$MESS_UP:
$
$ clear
$ show time
$ show symbol remote_node
$ show symbol remote_user
$
$ wso " "
$ message = DEFAULT_MSG
$ show symbol DEFAULT_MSG
$ wso " "
$ wso "Possible ways to spice up their poor life: "
$ wso " "
$ wso " 1. RESET their terminal.                           n/a"
$ wso " 2. CLEAR their screen.                             n/a" 
$ wso " 3. Set their screen to Graphics ON mode.           n/a"
$ wso " 4. Turn OFF their Graphics mode.                   n/a"
$ wso " 5. Set their screen to FLASH.                      n/a"
$ wso " 6. Set their screen back to NORMAL TEXT.           n/a"
$ wso " 7. Make their terminal WHINE.                      n/a"
$ wso " 8. Make their terminal RING.     (is working)" 
$ wso " 9. Make their screen JUMP.                         n/a"
$ wso "10. Set their text to REVERSE.                      n/a"
$ wso "11. -----------------------------------------------------"
$ writs sys$output " "
$ wso "12. Send a TEXT message.          (is working)"
$ wso "13. EXIT this program.            (is working)"
$
$ inquire/nopunct garbage "Please make a choice (1-13) :  "
$
$ 
$ if garbage .EQS. "1" then message =  RESETESC
$ if garbage .EQS. "2" then message =  CLRESC
$ if garbage .EQS. "3" then message =  GRONESC
$ if garbage .EQS. "4" then message =  GROFFESC
$ if garbage .EQS. "5" then message =  FLASHESC
$ if garbage .EQS. "6" then message =  NORMESC
$ if garbage .EQS. "7" then message =  WHINESC
$ if garbage .EQS. "8" then message =  RINGESC
$ if garbage .EQS. "9" then message =  JUMPESC
$ if garbage .EQS. "10" then message = RECESC
$ if garbage .EQS. "11" then message = " "
$ if garbage .EQS. "12" then goto SELECT_MESSAGE
$ if garbage .EQS. "13" then goto EXIT
$ if garbage .EQS. "" then goto MESS_UP
$ goto SEND_IT
$
$SELECT_MESSAGE:
$ 
$ clear
$
$ wso "Please select a message :"
$ wso " " 
$ wso " 1. Fart...                              18. Bench an 18 wheeler..."
$ wso " 2. Sneeze...                            19. 'Lick me' comeback message"
$ wso " 3. Booger...                            20. Shoved up your anus..."
$ wso " 4. Bulkie Roll...                       21. Alien pooch cum..."
$ wso " 5. Samba...                             22. Wet bed, live longer."
$ wso " 6. Lunchtime...                         23. Eat my crusty dingleberries..."
$ wso " 7. Suppertime...                        24. Blows chunks..."
$ wso " 8. Tuna melt...                         25. Bendover and smile..."
$ wso " 9. Asshole...                           26. Your red snappa...?"
$ wso "10. Where are you...                     27. Float an air buscuit..." 
$ wso "11. Lick me...                           28. Wave my privates..."
$ wso "12. What are you doing tonight...        29. Lick the back of my..."
$ wso "13. CPU time limit...                    30. Blow a fire hydrant..."
$ wso "14. Shut down in 2 mins...               31.    --default"
$ wso "15. Shut down in 0 mins...               32.    --default"
$ wso "16. Pick my wedge...                     33.    --default"
$ wso "17. Suck my...                           34.    --default"
$ wso "---------------------------------------------------------------------- "
$ wso "98. Enter you own blast message (no name attached.)"
$ wso "99. Enter your own 'I SAY' message."
$
$ wso " "
$
$ inquire/nopunct wanna_say "Please make a selection : " 
$
$ if wanna_say .EQS. "1" then message =  FART_MSG
$ if wanna_say .EQS. "2" then message =  SNEEZE_MSG
$ if wanna_say .EQS. "3" then message =  BOOGER_MSG
$ if wanna_say .EQS. "4" then message =  BULKIE_MSG
$ if wanna_say .EQS. "5" then message =  SAMBA_MSG
$ if wanna_say .EQS. "6" then message =  LUNCH_MSG
$ if wanna_say .EQS. "7" then message =  SUPPER_MSG
$ if wanna_say .EQS. "8" then message =  TUNA_MSG
$ if wanna_say .EQS. "9" then message =  ASSHOLE_MSG
$ if wanna_say .EQS. "10" then message = WHERE_MSG
$ if wanna_say .EQS. "11" then message = LICK_MSG
$ if wanna_say .EQS. "12" then message = TONIGHT_MSG
$ if wanna_say .EQS. "13" then message = CPU_MSG
$ if wanna_say .EQS. "14" then message = SHUTDOWN2_MSG
$ if wanna_say .EQS. "15" then message = SHUTDOWNNOW_MSG
$ if wanna_say .EQS. "16" then message = WEDGE_MSG
$ if wanna_say .EQS. "17" then message = SUCKMY_MSG
$ if wanna_say .EQS. "18" then message =  BENCH_MSG
$ if wanna_say .EQS. "19" then message =  TONGUE_MSG
$ if wanna_say .EQS. "20" then message =  ANUS_MSG
$ if wanna_say .EQS. "21" then message =  POOCH_MSG
$ if wanna_say .EQS. "22" then message =  WETBED_MSG
$ if wanna_say .EQS. "23" then message =  CRUST_MSG
$ if wanna_say .EQS. "24" then message =  CHUNKS_MSG
$ if wanna_say .EQS. "25" then message =  BENDOVER_MSG
$ if wanna_say .EQS. "26" then message =  REDSNAPPA_MSG
$ if wanna_say .EQS. "27" then message =  BISCUIT_MSG
$ if wanna_say .EQS. "28" then message =  AUNTY_MSG
$ if wanna_say .EQS. "29" then message =  BACK_MSG
$ if wanna_say .EQS. "30" then message =  HYDRANT_MSG
$ if wanna_say .EQS. "31" then message =  DEFAULT_MSG
$ if wanna_say .EQS. "32" then message =  DEFAULT_MSG
$ if wanna_say .EQS. "33" then message =  DEFAULT_MSG
$ if wanna_say .EQS. "34" then message =  DEFAULT_MSG
$ if wanna_say .EQS. "98" then goto BLAST_SOMEONE
$ if wanna_say .EQS. "99" then goto TELL_SOMEONE
$
$ wso "Sending this message: "
$ show symbol message
$ 
$ inquire/nopunct mmmmm "Send this message ? (y/n) [Y] "
$ if mmmmm .eqs. "n" then goto select_message
$ if mmmmm .eqs. "N" then goto select_message
$ 
$ wso " " 
$
$ goto SEND_IT
$
$
$TELL_SOMEONE:
$
$ wso " "
$ inquire/nopunct message "Message> "
$ if message .EQS. "" then message = " ' ho de do de do deo do dodo de do...'                        "
$ message = myname +" says, '"+ message + "'                               "
$ 
$ wso "Sending this message: "
$ show symbol message
$ wso " " 
$ inquire/nopunct mmmmm "Send this message ? (y/n) [Y] "
$ if mmmmm .eqs. "n" then goto select_message
$ if mmmmm .eqs. "N" then goto select_message
$ 
$ goto SEND_IT
$
$BLAST_SOMEONE:
$
$ wso " "
$ inquire/nopunct message "Message> "
$ if message .EQS. "" then message = " ' ho de do de do deo do dodo de do...'                        "
$ message = message + ".                "
$
$ wso "Sending this message: "
$ show symbol message
$ wso " " 
$ inquire/nopunct mmmmm "Send this message ? (y/n) [Y] "
$ if mmmmm .eqs. "n" then goto select_message
$ if mmmmm .eqs. "N" then goto select_message
$ 
$ goto SEND_IT
$
$SEND_IT:
$
$  
$ annoiance = "b"
$ if annoiance .eqs. "b" then message = "''cr'''bell'''bell'''f$edit(message,"compress")'''of'''bell'''bell'" + null_byte
$
$
$ on error then  goto BAD_STATUS
$
$ open/read/write link 'remote_node'"29=" 
$ write /error=error link id_rmt_user,message,remote_user
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .ne. status_success then goto bad_status
$ write /error=error link ring_rmt_user,message,true_byte
$ read link ans /end=error/error=error
$ if f$cvui(0,8,ans) .eq. status_success then goto exit
$
$
$BAD_STATUS:
$
$ status_code = f$cvui(0,8,ans)
$ if status_code .gt. 9 then status_code= 10
$ status_message = status_'status_code'
$ close link
$ wso "''f$fao("Bad status recieved = !2ZB - ",status_code)'''status_message'"
$
$
$ERROR:
$
$ status = $status
$ wso "An error has occured."
$ close link
$ exit
$
$
$EXIT:
$
$ if f$logi("link") .nes. "" then -
    write link slave_exit,message
$ if f$logi("link") .nes. "" then -
    close link
$ wso "Hope that user has a sense of humor."
$ exit status
$NO_ONE:
$ close link
$ wso " " 
$exit
