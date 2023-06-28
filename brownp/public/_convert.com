!
!                        C o n v e r t . c o m 
!
!        written by Peter M Brown University of Lowell 1991
!
!
!
!
$ON error THEN GOTO ERROR
$
$
$ @science$disk:[brownp.public]write.file "convert"
$
$ wso :== write sys$output
$
$INRODUCTION:
$	clear
$	wso "This program will convert a text file to a .COM file so that"
$	wso "You may run it by typing @<filename>"
$	wso "OR to a pascal program using WRITELN('...'); format"
$	wso "You may run those by typing RUN <filename>"
$	wso "(this program compiles and links them as well..."
$	wso " "
$
$
$START:
$
$
$BEGIN:
$	inquire/nopunct filename "Text file to Convert   > "
$	if filename .EQS. "" then goto BEGIN
$
$BEGIN1:
$	inquire/nopunct kind "Convert to (p)ascal or (c)omfile  > "
$	kind = f$edit (kind,"trim,upcase")
$	if kind .EQS. "P" then goto PASCAL_CONVERT 
$	if kind .EQS. "C" then goto BEGIN2
$	goto BEGIN1
$
$BEGIN2:
$	inquire/nopunct newfile  "Name of converted file (without .COM) > "
$	if newfile .EQS. "" then goto BEGIN2
$	newfile = newfile + ".COM"
$
$CREATE_FILE:
$
$
$	create 'newfile'
$
$	time = f$time()
$	open/write nfile 'newfile'
$		write nfile "! Converted to a .COM file by Peter M Brown"
$		write nfile "!  -- ", time
$		write nfile "!"
$		write nfile "$ CLEAR"
$		write nfile "$ w :== write sys$output"
$		write nfile "$"
$	close nfile
$
$
$	open/read ofile 'filename'
$	open/append nfile 'newfile'
$LOOP:	
$
$		read/end_of_file=ENDIT ofile text_line
$		text_line = "$ w """+text_line
$		write nfile text_line
$	goto LOOP
$
$
$
$!===========================================================================
$!===========================================================================
$!===========================================================================
$
$
$
! The following is relevant ONLY for the PASCAL conversion:
$
$PASCAL_CONVERT:
$	inquire/nopunct newfile  "Name of converted file (without .PAS) > "
$	if newfile .EQS. "" then goto BEGIN2
$	prog_name = newfile
$	newfile = newfile + ".PAS"
$
$	wso " "
$	wso "This may take a while, the program removes all ' from the text"
$	wso "If they were to be left in, the program would not compile"
$
$	time = f$time()
$
$	create 'newfile'
$	wso "New file created... "+newfile	
$
$	open/write nfile 'newfile'
$		write nfile "(* Converted from TXT to Pascal by Peter M Brown *)"
$		write nfile "(*  -- ", time, " --  *)"
$		write nfile " "
$		write nfile "PROGRAM MYPROG_"+prog_name+"(OUTPUT);"
$		write nfile " "
$		write nfile "BEGIN"
$		write nfile " "
$	close nfile
$
$
$	open/read ofile 'filename'
$	open/append nfile 'newfile'
$LOOP2:	
$
$		read/end_of_file=ENDIT2 ofile text_line
$		max_count = f$length(text_line)
$		low = 0
$
$	LOOP3:                       ! This removes any single quotes
$		check = f$extract(low,1,text_line)
$		if check .EQS. "'" then goto REMOVE_QUOTE
$	goto CONTINUE_SEARCH	
$	
$! the following removes the ' from the line:
$REMOVE_QUOTE:		
$		left = f$extract(0,low,text_line)		
$		right = f$extract(low+1,max_count,text_line)
$		text_line = left + right	
$
$CONTINUE_SEARCH:
$		low = low +1
$		if low .EQS. max_count then goto WRITE_IT
$		if low-1 .EQS. max_count then goto WRITE_IT
$		if low-2 .EQS. max_count then goto WRITE_IT
$
$	goto LOOP3
$
$WRITE_IT:	
$		text_line = "     WRITELN('" + text_line + "');"
$		wso text_line
$		write nfile text_line
$	goto LOOP2
$
$ENDIT2:
$	write nfile "END."
$	close nfile
$	close ofile
$	wso "Conversion finished...compiling and linking..."
$	
$	pascal 'prog_name'
$	link 'prog_name'
$
$ exit
$
$ENDIT:
$	close nfile
$	close ofile
$	type 'newfile'
$
$	wso "Conversion finished"
$
$ exit
$
$
$ERROR:
$	close nfile
$	close ofile
$	wso "ERROR...program aborted"
$ exit
