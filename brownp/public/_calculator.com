! Peter M Brown ULowell 1991
!
!
! This com file will execute the INFIX CALCULATOR program in the .PUBLIC
! directory.
!
!
$ @science$disk:[brownp.public]write.file "calcu"
$
$ w:== write sys$output
$ w "This is an example of infix notation : "
$ w " "
$ w "                     (((3*2)/6+4-3)+9.99)/2"
$ w " "
$ w " This CALCULATOR.EXE program will recognize this format and calculate"
$ w " The result appropriately."
$ w " "
$ w " "
$ w "Source code compliments of Prof. Jesse Heines (credit where credit is due)"
$ w "Thanks you for using this program - Peter M Brown"
$ w " "
$ w " TYPE 'run science$disk:[brownp.public]_calculator.exe'"
$ exit
