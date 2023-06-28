$ ! Keypad definition module by Peter M Brown
$ ! This is called by my login.com
$  
$SET TERMINAL/APPLICATION
$SET KEY/STATE=KEYPAD/NOLOG
$DEFINEKEY :=DEFINE/KEY/IF_STATE=KEYPAD/NOLOG!/noerase
$DEFINEKEY :=DEFINE/KEY/IF_STATE=KEYPAD/NOLOG
$DEFINEKEY PF4 "lsd" /TERMINATE                      
$DEFINEKEY PF3 "Work"/TERMINATE                       
$DEFINEKEY PF2 "Tools" /TERMINATE                     
$DEFINEKEY PF1 "Main" /TERMINATE               
$DEFINEKEY KP3 "Set term/noecho" /TERMINATE
$DEFINEKEY KP2 "Set term/echo" /TERMINATE
$DEFINEKEY KP7 "Purge" /TERMINATE
$DEFINEKEY KP8 "Players" /TERMINATE           
$DEFINEKEY KP9 "Willow" /TERMINATE               
$DEFINEKEY KP4 "@sublogin.com" /TERMINATE                  
$DEFINEKEY KP5 "Phone ans" /TERMINATE                  
$DEFINEKEY KP6 "SET DEF group$disk:[compsci]" /TERMINATE           
$DEFINEKEY MINUS "Set term/nobroadcast" /TERMINATE 
$DEFINEKEY COMMA "Set term/broadcast" /TERMINATE 
$DEFINEKEY KP1 "Mail" /TERMINATE
$DEFINEKEY KP0 "@[brownp.tools]info.com" /TERMINATE        
$DEFINEKEY ENTER "Fuck You!!!!" /TERMINATE                
$DEFINEKEY PERIOD "phone rej" /TERMINATE      
$ 
$EXIT
