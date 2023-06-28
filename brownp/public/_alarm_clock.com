!
!                      A L A R M _ C L O C K
!
!              written by Peter M Brown ULowell 1991
!
!
!REQUIREMENTS:
!
!
! Requires ESC_CODES.COM to be found in sscience$disk:[brownp.public]
! to have been called ONCE from your LOGIN.COM, otherwise garbage will
! show up on your screen instead of the flash or BELL.
!
!
! To use this program just save it as ALARM_CLOCK.COM and put this line in
! your LOGIN.COM :
!
!          
!$ ALARM :== spawn/process = "Alarm_clock" /nolog/nowait (cont on next line)
!                                     @science$disk:[brownp.public]_alarm_clock 
!
! Then to set it, do the following :
! (items in brackets are optional)
!
!          ALARM [ <time_to_go_off> ]  [BELL or FLASH or BOTH]
!
! NOTE : TIME MUST BE ENTERED IN THE 24 HOUR SCALE ex:
!
!	instead of entering 08:05 (pm) , enter 20:05
!
!
$
$ @science$disk:[brownp.public]write.file
$
$
$VARIABLES:
$
$  
$	alarm_time = p1
$	bell_text  = p2
$
$	set nocontrol = (y)
$
$SET_TIME:
$	
$	show time
$	if alarm_time .EQS. "" then inquire/nopunct alarm_time "Time to go off (hh:mm) "
$	if alarm_time .EQS. "" then goto SET_TIME
$
$SET_ALARM_TYPE:
$
$	show time
$	if bell_text .EQS."" then inquire/nopunct bell_text "BELL alarm or FLASH alarm (BELL/FLASH) ? "
$       if bell_text .EQS."" then goto SET_ALARM_TYPE
$
$ALL_SET:
$
$	show time
$	write sys$output "This program by Peter M Brown..."
$	write sys$output "Alarm Clock Has been set..."
$
$CHECK_LOOP:
$
$	time = f$time()
$	time = f$extract(12,5,time)	
$
$	if time .EQS. alarm_time then goto EXPLODE
$
$ goto check_loop
$
$EXPLODE:
$
$	if bell_text .EQS. "bell" then goto EXPLODE_BELL
$	if bell_text .EQS. "BELL" then goto EXPLODE_BELL
$
$	if bell_text .EQS. "flash" then goto EXPLODE_flash
$	if bell_text .EQS. "FLASH" then goto EXPLODE_flash
$
$	if bell_text .EQS. "BOTH" then goto EXPLODE_BOTH
$	if bell_text .EQS. "both" then goto EXPLODE_BOTH
$
$
$
$	goto EXPLODE_flash
$
$EXPLODE_BELL:
$
$	ring
$       ring
$	ring
$
$ set control = (y)
$
$exit
$
$EXPLODE_flash:
$
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$	light
$	dark
$
$ set control = (y)
$exit
$
$EXPLODE_BOTH:
$
$	dark
$	light
$	ring
$	dark
$	light
$	ring
$	dark
$
$ set control = (y)
$exit

