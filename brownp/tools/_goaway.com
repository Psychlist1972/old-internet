!  Goaway.com
!
!  This program sends a message to everyone on the system 
!  The symbol saywhat contains the text of the message.
!  It uses a slightly modifed version of message.com which
!  I have called mess2.com.
!
!  
!  Dump the who list to the file list.out
$whom type
$Open List_input: whom.dat 
!  Skip over the heading garbage.
$read List_input: line
$read List_input: line
$read List_input: line
$read List_input: line
$read List_input: line
$read List_input: line
!  Put message to send in the global symbol table.
$saywhat == """ Olsen will be closing in 45 min.Please finish up."""
$Loop:
$read/End_of_File=Endit List_input: line
$show symb line
$node = f$extract(3, 5, line)
$node = f$edit(node, "trim")
$name = f$extract(10, 14, line)
$name = f$edit(name, "trim")
$uname == node + "::" + name
$show symbol uname
$talk 'uname 'saywhat
$Goto Loop
$Endit:
$Close List_input:
$delete list.out;*
