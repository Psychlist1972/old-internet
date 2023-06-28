$ w :== write sys$output
$ clear
$ w "#6      Cleanup 1.0"
$ w "             by P. Alberti"
$ w "             U*Mass. Lowell"
$ w "             1991"
$ w " "
$ w "This program cleans up all directories.  It purges all files and set them"
$ w "ALL equal to 1.  PLEASE NOTE THIS, SINCE YOU MAY WANT TO SAVE SOME FILES"
$ w "WITH THE SAME NAMES FOR FUTURE USE!!"
$ w " " 
$ read sys$command uh_huh/prompt = "Are you SURE you want to do this?? [N]: "
$ if uh_huh .EQS. "Y" then goto start 
$ if uh_huh .EQS. "y" then goto start 
$ if uh_huh .EQS. "YES" then goto start 
$ if uh_huh .EQS. "yes" then goto start 
$ goto no_can_do
$ start:
$ clear
$ w "#6Please wait..."
$ w "This will take a few minutes."
$ not :== "FALSE"
$ set def sys$login
$ VERIF='F$VERIFY(0)
$ ESC[0,8]=27
$ DIR=F$ENVIRONMENT("DEFAULT")
$ IF P1 .NES. "" THEN DIR=F$PARSE(P1,,,"DEVICE")+F$PARSE(P1,,,"DIRECTORY")
$ DELIMETER=F$EXTRACT(F$LENGTH(DIR)-1,1,DIR)
$ WRITE SYS$OUTPUT ""
$ COUNT=0
$ P=1
$ F'P'=0
$ C'P'=0
$ N'P'=F$SEARCH(DIR+"*.DIR;1",P)
$ LOOP:
$ IF F$PARSE(N'P',,,"NAME") .EQS. "000000" THEN N'P'=F$SEARCH(DIR+"*.DIR;1",P)
$ IF N'P' .EQS. "" THEN GOTO NEXT
$ FILESPEC=N'P'
$ N'P'=F$SEARCH(DIR+"*.DIR;1",P)
$ COUNT=COUNT+1
$ FILENAME=F$PARSE(FILESPEC,,,"NAME")
$ w "Purging '" + FILENAME + "' directory."
$ C=P+1
$ C'C'=F$LENGTH(FILENAME)+1
$ P'P'="."+FILENAME+DELIMETER
$ DIR=DIR-DELIMETER+P'P'
$ set def 'dir'
$ goto purge
$ purge_done:
$ C=0
$ L=0
$ BUILD:
$ C=C+1
$ W "F'C' = " + F'C'
$ L=L+C'C'
$ IF C .NES. P-1 .AND. P .NES. 1 THEN GOTO BUILD
$ IF N'P' .EQS. "" .AND. P .NES. 1 THEN F'P'=1
$ IF N'P' .NES. "" .AND. P .NES. 1 THEN F'P'=0
$ P=P+1
$ N'P'=F$SEARCH(DIR+"*.DIR;1",P)
$ GOTO LOOP
$ NEXT:
$ P=P-1
$ IF P .EQS. 0 THEN GOTO DONE
$ DIR=DIR-P'P'+DELIMETER
$ GOTO LOOP
$ DONE:
$ WRITE SYS$OUTPUT ESC,"(B"
$ IF COUNT .EQS. 1 THEN WRITE SYS$OUTPUT "Grand total of 1 directory purged."
$ IF COUNT .NES. 1 THEN WRITE SYS$OUTPUT "Grand total of ''COUNT' directories purged."
$ set def sys$login
$ WRITE SYS$OUTPUT "Purging Home Directory"
$ not :== "TRUE"
$ goto purge
$ EXIT:
$ clear
$ w "#6 Cleanup Completed!!"
$ w "Please note that you have been returned to your HOME directory."
$ EXIT
$ purge:
$   set prot = (o:rwed) *.*;*
$   purge
$   rename *.*;* ;1
$   write sys$output "Directory '" + DIR + "' has been purged."
$ w " "
$ if not .EQS. "TRUE" then goto exit
$ goto purge_done
$ no_can_do:
$ clear
$ w "PROGRAM ABORTED BY USER!!!"
$ exit
