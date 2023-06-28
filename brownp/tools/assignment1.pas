!
!
!<* SEND.COM__________________________________________________________________
!** 12-Mar-1984 - Author Unknown
!** This version modified by Peter M Brown
!**========================================================================*>!
!
$MAIL_BEGIN:
$ Net_Link_Open = 0			! Set status flag to check later.
!
!<* Open the link to the mail task, and handle errors.			    *>!
!
$ inquire Node_Name "To Node"
$ open/read/write/error=MAIL_NET_ERROR mail$link 'Node_Name'::"27="
$ Net_Link_Open = 1
!
!<* Obtain and send the FROM information for MAIL.			    *>!
!
$ read/prompt="From: "/end=MAIL_DONE sys$command Mail_Text
$ WRITE/ERROR=mail_net_error mail$link Mail_Text
$ Node_Name = 0
$ Receivers = 0
!
!<* Inform them of what gives and set up return location.		    *>!
!
$ write sys$output "Enter Recipients (No Nodename) - Terminate With ^Z"
$ Return_Location := "MAIL_RECIPIENTS"
$
$MAIL_RECIPIENTS:
$ inquire Mail_Text "To"
$ if Mail_Text .eqs. "" then goto END_OF_LINE
$ write/error=MAIL_NET_ERROR  mail$link Mail_Text
$ goto ERRCHK
!
!<* Send the message which states who should receive the text on the other **!
!** side, ALWAYS CHECK what status object 27 gives back.		    *>!
!
$END_OF_LINE:
$ Null[0,7] = 0
$ write/error=MAIL_NET_ERROR mail$link Null
$ if Receivers .eq. 0 then goto NO_RECEIVERS
!
!<* Terminate the list of Receivers with a one byte null record.	    *>!
!
$HEADERS:
!
!<* Write what shows up in the TO: field of message.			    *>!
!
$ read/prompt="To (What Shows Up): "/end=MAIL_DONE sys$command Mail_Text
$ write/error=MAIL_NET_ERROR mail$link Mail_Text
!
!<* Write the subject line to the DECnet link.				    *>!
!
$ read/prompt="Subject: "/end=MAIL_DONE sys$command Mail_Text
$ write/error=MAIL_NET_ERROR mail$link Mail_Text
!
!<* Give message informing of text collection.				    *>!
!
$ write sys$output "Text - Terminate With ^Z"
$
$LOAD_MAIL_BUFFER:
$ read/prompt=">"/end=END_OF_BUFFER sys$command Mail_Text
$ write/error=MAIL_NET_ERROR mail$link Mail_Text
$ goto LOAD_MAIL_BUFFER
$
$
!
!<* Read in each line of text and send it across line by line.  This can   **!
!** be optimized to send one long chunk (I hope).			    *>!
!
$END_OF_BUFFER:
!
!<* Write end of text message.						    *>!
!
$ write/error=MAIL_NET_ERROR mail$link Null
$ Save_Count = Receivers
$ Index = 0
$ Return_Location := "CHECK_DELIVERY" 
!
!<* Loop through and receive the status code for all users it was sent to. *>!
!
$DELIVERY_CHECK:
$ goto ERRCHK
$
$CHECK_DELIVERY:
$ Index = Index + 1
$ if Index .ne. Save_Count then goto DELIVERY_CHECK
$ goto MAIL_DONE
$
$ERRCHK:
!
!<* Message received OK, continue.					    *>!
!
$ read/error=MAIL_NET_ERROR mail$link Mail_Status
$ if f$cvsi(0,1,Mail_Status) .eq. -1 then goto MSG_VALID
$
$ERRMSG:
$ read/error=MAIL_NET_ERROR mail$link Mail_Status
$ if f$length(Mail_Status) .ne. 1 then goto WRITE_MESSAGE
$ if f$cvsi(0,8,Mail_Status) .eq. 0 then goto 'Return_Location'
$
$WRITE_MESSAGE:
$ write sys$output Mail_Status
$ goto ERRMSG
$
$MSG_VALID:
$ Receivers = Receivers + 1
$ goto 'Return_Location'
$
$MAIL_NET_ERROR:
$ write sys$error "%SEND-F-TOUGHLUCK, Network communications error."
$ goto MAIL_DONE
$
$NO_RECEIVERS:
$ write sys$error "%SEND-F-WTF, Must specify a recipient!"
$ goto MAIL_DONE
$
$MAIL_DONE:
$ if Net_Link_Open .ne. 0 then close mail$link
$ exit
