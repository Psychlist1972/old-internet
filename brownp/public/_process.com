$! PROC_NAME.COM
$! This file will change your process name depending on how many times
$! you're logged in.  Inspired by ideas from Mike Cook.  TRW 3/29/91
$! Documentation that follows by Mike Cook.
$! Make a names.txt file in a subdirectory (as noted below, mine is in
$! my text: subdirectory).  For every process name, put the name in quotes
$! in the names.txt file.  If you don't put it in quotes, the program won't
$! work.
$! To use the file, add this line to your login.com:
$! @science$disk:[weissingt.cmd]proc_name <directory where names.txt is located>
$ user = f$user() - "[" - "]"
$ sh u/f/output=sys$login:temp.txt 'user'
$ open/read temp sys$login:temp.txt
$ read temp line
$ read temp line
$ close temp
$ delete sys$login:temp.txt;
$ num_proc = f$extract (54, 1, line)
$ count = 0
$ open/read temp ['user'.'p1']names.txt
$SUB:
$ count = count + 1
$ read temp name
$ if count .nes. num_proc then goto SUB
$ close temp
$ set process/name='name'
$ exit
