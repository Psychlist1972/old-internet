$
$ @science$disk:[brownp.public]write.file "watcher"
$
$! This program watches to see if a person(s) log into the computer.
$! V5.1
$! This program runs as a sub-process that looks for specific users.
$! syntax> watch user1 user2 user3......user8
$! to run ex>spawn/nowait @watch smiths jonesk (etc, up to 8 users)
$! to run this you need tell.com in the same directory
$ e:== write sys$output
$ set nocontrol=(Y,T)
$ pid=f$getjpi("","pid")
$ master=F$GETJPI("","master_pid")
$ if (pid.eqs.master) then goto end_watch
$ set process/name="Watcher"
$  max = 0
$  if p1 .EQS. "" then goto begin
$  max = 1
$  if p2 .EQS. "" then goto begin
$  max = 2
$  if p3 .EQS. "" then goto begin
$  max = 3
$  if p4 .EQS. "" then goto begin
$  max = 4
$  if p5 .EQS. "" then goto begin
$  max = 5
$  if p6 .EQS. "" then goto begin
$  max = 6
$  if p7 .EQS. "" then goto begin
$  max = 7
$  if p8 .EQS. "" then goto begin
$  max = 8
$BEGIN:
$  count = 0
$  found = 0
$  if count .EQ. max then goto end_watch
$!
$DO_P1:
$  if p1 .EQS. "" then goto do_p2
$  person = p1
$  gosub findp
$  if found .EQ. 0 then goto do_p2
$  count = count + 1
$  p1 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P2:
$  if p2 .EQS. "" then goto do_p3
$  person = p2
$  gosub findp
$  if found .EQ. 0 then goto do_p3
$  count = count + 1
$  p2 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P3:
$  if p3 .EQS. "" then goto do_p4
$  person = p3
$  gosub findp
$  if found .EQ. 0 then goto do_p4
$  count = count + 1
$  p3 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P4:
$  if p4 .EQS. "" then goto do_p5
$  person = p4
$  gosub findp
$  if found .EQ. 0 then goto do_p5
$  count = count + 1
$  p4 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P5:
$  if p5 .EQS. "" then goto do_p6
$  person = p5
$  gosub findp
$  if found .EQ. 0 then goto do_p6
$  count = count + 1
$  p5 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P6:
$  if p6 .EQS. "" then goto do_p7
$  person = p6
$  gosub findp
$  if found .EQ. 0 then goto do_p7
$  count = count + 1
$  p6 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P7:
$  if p7 .EQS. "" then goto do_p8
$  person = p7
$  gosub findp
$  if found .EQ. 0 then goto do_p8
$  count = count + 1
$  p7 = ""
$  if count .EQ. max then goto end_watch
$!
$DO_P8:
$  if p8 .EQS. "" then goto do_p1
$  person = p8
$  gosub findp
$  if found .EQ. 0 then goto do_p1
$  count = count + 1
$  p8 = ""
$  if count .NE. max then goto do_p1
$!
$! Subroutine to find out if user has logged in.
$!
$FINDP:
$ wait 00:01:00
$ e "7"
$ e "[2;72H Watch"
$ e "8"
$ @science$disk:[brownp.public]tell.com
$ open/read input_file tell.dat
$FLOOP:
$  read/end=not_found input_file line
$  char = f$extract(1,f$length(person),line)
$  if char .NES. person then goto floop
$  close input_file
$  delete/nolog tell.dat;*
$  found = 1
$  e "                                                      "
$  e "    WATCH: User " + person + " is logged in.        "
$  e "                                                      " 
$  e ""
$  return
$!
$NOT_FOUND:
$  close input_file
$  delete/nolog tell.dat;*
$  found = 0
$  return
$!
$! All users found, exit from program.
$!
$END_WATCH:
$  e "                       "
$  e "       WATCH: Done   "
$  e "                       "
$  e ""
$  exit
