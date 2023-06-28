$ ! TREE.COM
$ ! Written by Seann Herdejurgen
$ ! 16-Oct-86
$ !
$ ! This command file displays a directory tree of the directory specified,
$ ! or if none is given,  the default  directory.  The TREE command must be
$ ! set up as a DCL command with the following line.
$ !
$ !                       $ TREE :== @COM:TREE.COM
$ !
$ ! The syntax for the TREE command is
$ !
$ !                       $ TREE directory
$ !
$ ! For example:          $ TREE DUA0:[SYS0]
$ !
$ VERIF='F$VERIFY(0)
$ ON CONTROL_Y THEN GOTO DONE
$ ESC[0,8]=27
$ DIR=F$ENVIRONMENT("DEFAULT")
$ IF P1 .NES. "" THEN DIR=F$PARSE(P1,,,"DEVICE")+F$PARSE(P1,,,"DIRECTORY")
$ DELIMETER=F$EXTRACT(F$LENGTH(DIR)-1,1,DIR)
$ IF F$PARSE(DIR) .NES. "" THEN GOTO START
$ WRITE SYS$ERROR "%TREE-E-OPENIN, error opening ",F$PARSE(DIR,"*.*;*",,,"SYNTAX_ONLY")," as input"
$ WRITE SYS$ERROR "-RMS-E-DNF, directory not found"
$ WRITE SYS$ERROR "-SYSTEM-W-NOSUCHFILE, no such file"
$ GOTO EXIT
$ START:
$ WRITE SYS$OUTPUT ""
$ WRITE SYS$OUTPUT "Directory ",DIR
$ WRITE SYS$OUTPUT ESC,"(0"
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
$ C=P+1
$ C'C'=F$LENGTH(FILENAME)+1
$ P'P'="."+FILENAME+DELIMETER
$ DIR=DIR-DELIMETER+P'P'
$ LINE:=""
$ C=0
$ L=0
$ BUILD:
$ C=C+1
$ IF C .NES. 1 .AND. F'C' .NES. 1 THEN LINE[L+C'C',L+C'C'+1]:="x"
$ L=L+C'C'
$ IF C .NES. P-1 .AND. P .NES. 1 THEN GOTO BUILD
$ IF N'P' .EQS. "" .AND. P .NES. 1 THEN LINE[L+C'P',L+C'P'+1]:="m"
$ IF N'P' .NES. "" .AND. P .NES. 1 THEN LINE[L+C'P',L+C'P'+1]:="t"
$ IF N'P' .EQS. "" .AND. P .NES. 1 THEN F'P'=1
$ IF N'P' .NES. "" .AND. P .NES. 1 THEN F'P'=0
$ LINE[L+C'P'+1,L+C'P'+1+F$LENGTH(FILENAME)]:='FILENAME'
$ IF F$SEARCH(DIR+"*.DIR;1") .NES. "" THEN -
  LINE[L+C'P'+F$LENGTH(FILENAME)+1,L+C'P'+F$LENGTH(FILENAME)+2]:="k"
$ WRITE SYS$OUTPUT LINE
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
$ IF COUNT .EQS. 1 THEN WRITE SYS$OUTPUT "Grand total of 1 accessable subdirectory"
$ IF COUNT .NES. 1 THEN WRITE SYS$OUTPUT "Grand total of ''COUNT' accessable subdirectories"
$ EXIT:
$ VERIF=F$VERIFY(VERIF)
$ EXIT
