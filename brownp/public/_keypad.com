

! Keypad definition module by Peter M Brown
! This is called by my login.com
$
$ on severe_error then continue
$
$ @science$disk:[brownp.public]write.file "keypad"
$  
$SET TERMINAL/APPLICATION
$SET KEY/STATE=KEYPAD/NOLOG
$DEFINEKEY :=DEFINE/KEY/IF_STATE=KEYPAD/NOLOG/ERASE
$DEFINEKEY :=DEFINE/KEY/IF_STATE=KEYPAD/NOLOG/ERASE/NOECHO
$DEFINEKEY PF4 "INFO" /TERMINATE                      
$DEFINEKEY PF3 "WORK"/TERMINATE                       
$DEFINEKEY PF2 "TOOLS" /TERMINATE                     
$DEFINEKEY PF1 "MAIN" /TERMINATE               
$DEFINEKEY KP3 "LSE" /TERMINATE
$DEFINEKEY KP2 "PHONE" /TERMINATE
$DEFINEKEY KP7 "PURGE" /TERMINATE
$DEFINEKEY KP8 "GTRADE" /TERMINATE           
$DEFINEKEY KP9 "MONSTER2" /TERMINATE               
$DEFINEKEY KP4 "@sublogin.com" /TERMINATE                  
$DEFINEKEY KP5 "PHONE ANS" /TERMINATE                  
$DEFINEKEY KP6 "SET DEF [heinesj.public.91-101]" /TERMINATE           
$!DEFINEKEY MINUS "SET TERM/ NOBROADCAST" /TERMINATE 
$!DEFINEKEY COMMA "SET TERM/ BROADCAST" /TERMINATE 
$DEFINEKEY KP1 "MAIL" /TERMINATE
$DEFINEKEY KP0 "@[brownp.tools]info.com  " /TERMINATE        
$DEFINEKEY ENTER "" /TERMINATE                
$DEFINEKEY PERIOD "monster3" /TERMINATE      
$ 
$EXIT
