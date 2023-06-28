!
! RENAME.com written By Peter F. Alberti Ulowell 1990
! This program will place a file in a new directory
!
$
$ @science$disk:[brownp.public]write.file "mover"
$
$ begin:= "true"
$ file:= "false"
$ START:
! 
$ same := "false"
$ if begin .EQS. "false" then goto T_OR_F
$ clear
$ on error then goto ERROR
$ write sys$output "                FILVEMOVER 1.0"
$ write sys$output "   written by Peter F. Alberti     ULowell  1991"
$ write sys$output " "
$ write sys$output "This program will place a file in a new specified directory."
$ write sys$output " "
$ write sys$output "BE SURE to put the extension (.com, .exe, .txt, etc...)"
$ write sys$output "after the filename at the '_Filename :' prompt." 
$ write sys$output " "
$ write sys$output "TYPE "END" in CAPITAL LETTERS TO CANCEL AT ANY TIME."
$ write sys$output " "
$ write sys$output " "
$ read sys$command username -
/error=error/end=exit/prompt = "_Username : "
$ if username .EQS. "END" then goto ABORT
$ write sys$output " "
$ write sys$output " Enter your disk (Music, engineering, science, etc.)
$ write sys$output " WITHOUT a $ sign or the word DISK."
$ read sys$command disk -
/error=error/end=exit/prompt = "_Disk: "
$ if disk .EQS. "END" then goto ABORT
$ T_OR_F:
$ if begin .EQS. "false" then goto DIR_CHECK
$ if begin .EQS. "true" then goto DIRE
$ DIR_CHECK:
$ read sys$command same/prompt = "Do you wish to move another file to the SAME DIRECTORY? "
$ if same .EQS. "Y" then file := "true"
$ if same .EQS. "y" then file := "true"
$ if same .EQS  "YES" then file := "true"
$ if same .EQS. "yes" then file := "true"
$ if same .EQS. "Yes" then file := "true"
$ if file .EQS. "true" then goto FILENAMES
$ if file .EQS. "false" then goto DIRE
$ DIRE:
$ write sys$output " "
$ clear
$ dir
$ write sys$output " "
$ write sys$output " Enter directory to move file to.  NOTE: To move a file from a "
$ write sys$output " subdirectory to your MAIN directory, type a hyphen (-)."
$ write sys$output " "
$ read sys$command directory -
/error=error/end=exit/prompt = "_Directory: "
$ if directory .EQS. "END" then goto ABORT
$ FILENAMES:
$ if file .EQS. "true" then clear
$ if file .EQS. "true" then dir
$ file := "false"
$ read sys$command filename -
/error=error/end=exit/prompt = "_Filename : "
$ if filename .EQS. "END" then goto ABORT
$ if directory .EQS. "-" then goto MAIN
$ rename 'filename' 'disk'$disk:['username'.'directory']*
$ goto MOVED
$ MAIN:
$ set prot = (g:wred,w:wred,o:wred,s:wred)'filename'
$ rename 'filename' ['username']*
$ PROTECT:
$ clear
$ write sys$output "WARNING!  File " + filename + " is now unprotected!   WARNING!
$ read sys$command prot -
/error=error/end=exit/prompt = "Protect it? (Y/N): "
$ if prot .EQS. "Y" then set prot 'disk'$disk:['username']'filename'
$ if prot .EQS. "N" then goto MOVED
$ if prot .EQS. "y" then set prot  'disk'$disk:['username']'filename'
$ if prot .EQS. "n" then goto MOVED else goto PROTECT
$ MOVED:
$ begin := "false"
$ clear
$ write sys$output "File moved."
$ write sys$output " "
$ write sys$output " "
$ write sys$output " "
$ ANOTHER:
$ read sys$command another -
/error=error/end=exit/prompt = "Another? (Y/N) : "
$ if another .EQS. "Y" then goto START 
$ if another .EQS. "N" then exit
$ if another .EQS. "y" then goto START
$ if another .EQS. "n" then exit 
$ABORT:
$ clear
$ write sys$output "PROGRAM ABORTED!"
$ exit
$ERROR:
$   clear
$   write sys$output "%ABORT-NO-MVE Error: Program aborted"
$   write sys$output " " 
$ write sys$output "An error has occurred.  Chances are that you entered either"
$ write sys$output "a directory or a file that does not exist."
$   exit
