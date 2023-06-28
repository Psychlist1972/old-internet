!
!
! Unix  CD  emulator for the VAX VMS systems
! Written by Peter M Brown
!    University of Lowell, December 1990
!
! This version: V2.0
!
!
! This program allows the user to type :
!       cd tools.wordprocessor instead of set def [.tools.wordprocessor]
!
!       cd                     instead of set def sys$login
!
!       cd ..                  instead of set def [-]
!
!	cd to a non-existant directory path will set default at 
!		the one you were just in
!
!       cd disk                set default to a specific disk
!
!
!  just put this line in your login.com
!
!              cd :== @science$disk:[brownp.public]_set_def.com
!
! 
$
$ @science$disk:[brownp.public]write.file "cd"
$
$ old_directory = f$directory()
$ on error then goto ERROR
$
$  set :== set
$  def :== def
$
$  dest  = p1
$
$  if dest .eqs. ".." then goto BACKUP
$
$  if dest .eqs. ""   then goto TOPLEVEL
$
$  if dest .eqs. "disk"  then goto SELECT_DISK
$
$  
$MAIN_LINE:
$  dest = "." + dest
$  path = "[" + dest + "]"
$   set def 'path'
$   dir
$   on error then goto ERROR
$ exit
$
$TOPLEVEL:
$   set def sys$login
$   dir
$ exit
$
$BACKUP:
$   set def [-]
$   on error then goto ERROR
$   dir
$ exit
$
$SELECT_DISK:
$   write sys$output "   1.  Science$disk"
$   write sys$output "   2.  Music$disk"
$   write sys$output "   3.  Engineering$disk"
$   write sys$output "   4.  Electrical$disk"
$   write sys$output "   5.  Management$disk"
$   write sys$output "   6.  Libarts$disk"
$   write sys$output "   7.  Other..."
$   
$   inquire/nopunct number "Please enter a number (1-7) "
$   if number .eqs. "1" then disk = "science$"
$   if number .eqs. "2" then disk = "music$"
$   if number .eqs. "3" then disk = "engineering$"
$   if number .eqs. "4" then disk = "electrical$"
$   if number .eqs. "5" then disk = "management$"
$   if number .eqs. "6" then disk = "libarts$"
$   if number .eqs. "7" then goto SELECT_OTHER
$   if number .eqs. "" then exit
$
$SELECT_OTHER:
$
$  inquire/nopunct "Please enter the name of the disk (no $disk) " disk
$  inquire/nopunct "Please enter the directory name" dname
$  set def 'disk' + "$disk:[" + dname + "]" 
$exit  
$
$ERROR:
$   write sys$output " "
$   write sys$output " "
$   write sys$output "[ You see no '" + p1 + "' here. ]"
$   write sys$output " "
$
$   set def 'old_directory'
$   dir
$ 
$ exit
