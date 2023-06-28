!
!			O P T I O N S . C O M 
!
!		written by Peter M Brown ULowell 1991
!
!
! to customize, change the following constants:
!
$ 
$
$ home_dir = "[brownp]"	     ! Your top_level or main directory
$
$ com_dir = "[brownp.tools.stalkerinfo]" 
$			     ! change this to the directory where all of your
$			     ! comfiles are found
$ 
$ blast_file = "Super_blast" ! The name of the BLAST.COM file in your directory
$
$ default_process = "Your_name_here"
$                            ! The default process/name
!
! The folowing assumptions are made by the program:
!
!	1.  You have a LOGIN.COM file in your home directory
!	2.  The LOGIN.COM does not end with the word 'EXIT'
!
! ------------------------------------------------------
$
$ on error then goto ERROR
$
$ set process/name = "''default_process'"
$
$ w :== write sys$output 
$
$MAIN_MENU:
$
$ clear
$
$ w "	 1. Change Process Name"
$ w "	 2. Set term/insert"
$ w "	 3. Set term/overstrike"
$ w "	 4. Run the Clock program"
$ w "	 5. Look at a Calendar"
$ w "	 6. Check mail"
$ w "	 7. Check to see who is on the system"
$ w "	 8. n/a"
$ w "	 9. Answer phone "
$ w "	10. Set term/nobroadcast"
$ w "	11. Set term/broadcast"
$ w "	12. Get a directory listing"
$ w " "
$ w "	*13. Add a new ALAIS to your NEWCMDS.COM file"
$ w "	*14. Add a new phone number or address to your FRIENDS.DAT file"
$ w " "
$ w "	x. Exit this module"
$ w "	q. Logoff"
$
$GET_INPUT:
$
$ inquire/nopunct CHOICE "Please make a selection -> "
$
$CHECK_INPUT:
$
$ if choice .EQS. "1" then goto SET_PROCESS
$ if choice .EQS. "2" then set term/insert
$ if choice .EQS. "3" then set term/overstrike
$ if choice .EQS. "4" then goto RUN_JCLOCK
$ if choice .EQS. "5" then goto LOOK_CALENDAR
$ if choice .EQS. "6" then goto CHECK_MAIL
$ if choice .EQS. "7" then show users/full
$ if choice .EQS. "8" then goto NOT_AVAIL
$ if choice .EQS. "9" then phone answer
$ if choice .EQS. "10" then set term/overstrike
$ if choice .EQS. "11" then set term/broadcast
$ if choice .EQS. "12" then DIR/SIZE
$ if choice .EQS. "13" then goto NEWCMDS_FILE
$ if choice .EQS. "14" then goto FRIEND_FILE
$ if choice .EQS. "q" then goto LEAVE_SYSTEM
$ if choice .EQS. "x" then goto LEAVE_MODULE
$ if choice .EQS. "Q" then goto LEAVE_SYSTEM
$ if choice .EQS. "X" then goto LEAVE_MODULE
$
$ goto MAIN_MENU
$
$
$SET_PROCESS:
$
$ clear
$ w " "
$ w " "
$ w "Possible choices :"
$ w " "
$ w " 1.	* Karathonius *"
$ w " 2.	Lick Me"
$ w " 3.	Trekkies Blow"
$ w " 4.	MGD Rules"
$ w " 5.	Silverdawn!"
$ w " 6.	C Finger/full"
$ w " 7.	Snappahead"
$ w " 8.	Thank Mr_System"
$ w " 9.	Bulkie Roll!!!"
$ w "10.        The Psychlist"
$ w "11.	Calcusucks"
$ w "12.	P H Y S U C K S"
$ w "13.	You Snappahead"
$ w "14.	Ho de do de do"
$ w "15.	ZzZzZzZzzzzz"
$ w "16.	Holiday inn 103"
$ w "17.	In My Room"
$ w "18.	Oleary Library"
$ w "19.	<---17-chars--->"
$ w "20.	Make your own (will be in all caps)"
$ w " "
$ inquire/nopunct lick_me "Your choice ---> "
$
$ if lick_me .EQS. "1" then set process/name =	"* Karathonius *"
$ if lick_me .EQS.  "2" then set process/name =	"Lick Me"
$ if lick_me .EQS.  "3" then set process/name =	"Trekkies Blow"
$ if lick_me .EQS.  "4" then set process/name =	"MGD Rules"
$ if lick_me .EQS.  "5" then set process/name =	"Silverdawn!"
$ if lick_me .EQS.  "6" then set process/name =	"C Finger/full"
$ if lick_me .EQS.  "7" then set process/name =	"Snappahead"
$ if lick_me .EQS.  "8" then set process/name =	"Thank Mr_System"
$ if lick_me .EQS.  "9" then set process/name =	"Bulkie Roll!!!"
$ if lick_me .EQS. "10" then set process/name =	"The Psychlist"
$ if lick_me .EQS. "11" then set process/name =	"Calcusucks"
$ if lick_me .EQS. "12" then set process/name =	"P H Y S U C K S"
$ if lick_me .EQS. "13" then set process/name =	"You snappahead!"
$ if lick_me .EQS. "14" then set process/name =	"Ho de do de do"
$ if lick_me .EQS. "15" then set process/name =	"ZzZzZzZzzzz"
$ if lick_me .EQS. "16" then set process/name =	"Holiday Inn 103"
$ if lick_me .EQS. "17" then set process/name =	"In My Room"
$ if lick_me .EQS. "18" then set process/name =	"Oleary Library"
$ if lick_me .EQS. "19" then set process/name =	"<---17-chars--->"
$ if lick_me .EQS. "20" then goto MAKE_OWN
$ EXIT ! REMOVE THIS LATER ***************************************************
$
$ goto MAIN_MENU
$
$
$	MAKE_OWN:
$		inquire/nopunct pname "Please enter a process name > "
$		set process/name = "''pname'"
$		goto MAIN_MENU
$
$RUN_JCLOCK:
$
$  spawn/process = "Petes_Clock"/nolog/nowait run science$disk:[brownp.public]jclock
$
$LOOK_CALENDAR:
$
$ @ science$disk:[brownp.public]_calendar.com
$ inquire/nopunct ret "Press <RETURN> to continue"
$ goto MAIN_MENU
$
$CHECK_MAIL:
$
$	mail
$	goto MAIN_MENU
$
$NOT_AVAIL:
$
$	goto MAIN_MENU
$
$NEWCMDS_FILE:
$
$	inquire/nopunct yes_no "Is this your first time creating this file? (y/n) "
$	if yes_no .EQS. "n" then goto APPEND_TO
$	if yes_no .EQS. "N" then goto APPEND_TO
$	if yes_no .EQS. "y" then goto CREATE_FILE
$	if yes_no .EQS. "Y" then goto CREATE_FILE
$	goto NEWCMDS_FILE
$
$	APPEND_TO:
$
$		w "format/example:"
$		w "          ALIAS   :==  STRING TO REPRESENT"
$		w "          WHO     :==  SHOW USERS/FULL"
$
$		inquire/nopunct new "What is the alias ?            > "
$		inquire/nopunct old "What string will it represent  > "
$
$		open/append newcmds mydisk:com_dir NEWCMDS.COM
$		write newcmds "$ ",new,"   :==  ",old,"   ! from Pete Brown's menu program"
$		close newcmds
$
$		inquire/nopunct yes_no "Add another alias? (y/n) [default is NO] "
$		if yes_no .EQS. "n" then goto MAIN_MENU
$		if yes_no .EQS. "N" then goto MAIN_MENU
$		if yes_no .EQS. "y" then goto APPEND_TO
$		if yes_no .EQS. "Y" then goto APPEND_TO
$	goto MAIN_MENU
$
$
$	CREATE_FILE:
$
$		create mydisk:com_dir NEWCMDS.COM
$
$		open/append newcmds mydisk:com_dir NEWCMDS.COM
$
$		write newcmds "! This is the NEWCMDS.COM created by Pete Brown's Menu program"
$		write newcmds "! To use this, just make sure this line is in your LOGIN.COM"
$		write newcmds "! $ @NEWCMDS"
$		write newcmds "!"
$		write newcmds "!"
$
$		close newcmds
$
$!--------
$ 
$		w "Adding the call to NEWCMDS to the end of your LOGIN.COM"
$		open/append login mydisk:home_dir LOGIN.COM
$
$		write login "! the following 2 lines were added by Pete Brown's menu program"
$		write login "$ @"mydisk,":",com_dir,"newcmds.com"
$		write login "$ EXIT" 
$
$		close login 
$
$	goto APPEND_TO
$
$
$FRIEND_FILE:
$
$ write sys$output "Not done yet"
$ goto main_menu
$
$LEAVE_SYSTEM:
$
$	inquire/nopunct umm "Really Logout? (y/n) [default is Y] "
$	if umm .EQS. "n" then goto MAIN_MENU
$	if umm .EQS. "N" then goto MAIN_MENU
$	if umm .EQS. "y" then logout
$	if umm .EQS. "Y" then logout
$logout
$
$
$LEAVE_MODULE: 
$
$	w "Exiting the Module..."
$	exit
$ERROR:
$ w " "
$ w "An error has occurred, cancelling program"
$ w " "
$ exit

