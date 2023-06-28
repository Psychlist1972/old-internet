$
$ @science$disk:[brownp.public]write.file "cal"
$
$  ! CALENDAR.COM	inspired by unix "cal"
$  ! this version by Peter M Brown 1991
$  ! Original version by Michael Bednarek, 1986
$  !
$ 
$  Verify='F$Verify(F$TRNLNM("COMMAND_DEBUG"))
$  On Control_Y then goto Clean_up
$  Old_Msg=F$Environment("MESSAGE")	! save previous SET MESSAGE parms
$  Set Message/Nofacility/NoIdentification/Noseverity/NoText
$ 
$ ! CALENDAR.COM displays a monthly calendar
$ ! Parameters (optional):
$ !	P1=month as MON  (e.g. Aug)
$ !	P2=year  as yyyy (e.g. 1986)
$ ! ) Michael Bednarek, 1986
$ !
$ 
$  w="Write SYS$OUTPUT"
$  clear
$  sh time
$  w ""
$
$  Days="Sun Mon Tue Wed Thu Fri Sat "	! The Days of the week
$  Months=" January February March April May June " + -
	 "July August September October November December"
$ !
$ !
$ ! use only the first three characters
$
$  MMM=F$Extract(0,3,F$Edit(P1,"COLLAPSE,UPCASE"))
$  If F$Locate(" ''MMM'",F$Edit(Months,"UPCASE")).eq.F$Length(Months) -
	then goto Warning
$  Month_Year="-''MMM'-''P2'"		! combine P1 and P2 into a date format
$  A="1"+"''Month_Year'"			! Test for valid date
$  On Warning then goto WARNING		! because then an invalid date was given
$  Weekday=F$Extract(0,3,F$CVTime(A,,"WEEKDAY"))
$  Pos_WD=F$Locate(Weekday,Days)+1	! Remember the first day's weekday
$ !
$  L_Days=F$Length(Days)			! Length of array 'Days'
$  Pos_Last_WD=L_Days-2
$  Stars=F$FAO("!''L_Days'**")		! A line of asterisks
$ !
$  w Stars				! First line of asterisk
$  Month=F$CVTime(Month_Year,,"MONTH")	! Extract the month from parameters
$  Year =F$CVTime(Month_Year,,"YEAR")	! ... and the year
$ ! Translate the 2-digit month number into its name
$  Month=F$Element(F$Integer(Month)," ",Months)
$  Month=Month+" "+Year			! append a blank and the year
$  l=F$Length(Month)			! find out this string's length
$  k=(L_Days-2-l)/2			! in order to center it above the box
$  Month="*"+F$FAO("!''k'* ")+Month	! Centering 'Month Year'
$  Month['L_Days'-1,1]:="*"		! and tuck an asterisk at the end
$  w Month				! Finally, display it
$  w Stars				! and the line of asterisks again.
$ !
$  w Days				! Day Header for the Calendar Box
$ !
$  On Warning then goto n_Days		! This will tell us
$  Day=29				! how many days are there in this month
$
$
$TRY_MORE:
$
$  A="''Day'"+"''Month_Year'"	        ! Construct the string for F$CVTime
$  k=F$CVTime(A)		        ! Make a fake call to F$CVTime,
$  Day=Day+1				! when success, try next day
$  If Day.eq.32 then goto n_Days        ! No month has 32 days
$  Goto Try_more
$  n_Days: n_Days=Day-1			! Warning happened, now we know.
$ !
$  Line=""
$  Day=0					! Off we go.
$  On Warning then Exit			! We don't expect any.
$
$
$NEXT_DAY:
$
$  Day=Day+1				! increment day
$  If Day.gt.n_Days then goto EOJ	! Finished month ?
$  Day_Num=F$FAO("!2UL",Day)		! integer to string (I2)
$  Line['Pos_WD',2]:="''Day_Num'"	! insert this string into output line
$  Pos_WD=Pos_WD+4			! increment pointer
$  If Pos_WD.le.Pos_Last_WD then goto Next_Day	! Finished this week ?
$  w Line				! Yes. Print this week.
$  Line=""				! And initialize ...
$  Pos_WD=1				! ... variables for next week.
$  Goto Next_Day
$ !
$
$
$WARNING:
$
$  w "%Calendar-W-IVATIME, invalid parameter - use MON YYYY format"
$  w "\''P1' ''P2'\"
$  Goto Clean_up
$  EOJ:
$ 	If Line.nes."" then w Line	! Anything left ?
$
$
$CLEAN_UP:
$
$ 	Set Message 'Old_Msg		! Restore entry params
$ 	Verify=F$Verify(Verify)
$  w " "
$  EXIT 
