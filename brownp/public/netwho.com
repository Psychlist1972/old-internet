$ !
$ ! NETWHO.COM -- Shows the logged in users on a remote DECnet node 
$ !               by asking the PHONE object for a list.
$ !
$ if p1 .eqs. "" then inquire p1 "_Node"
$ if p1 .eqs. "?" then goto help
$ p1 = p1-":"-":"
$ if p1 .eqs. "" then exit
$ say = "write sys$output"
$ num = 0
$ cmd[0,8] = 15
$ open/read/write/error=exit phn 'p1'::"29="
$ say "Users on "+p1+" at "+f$time()+"."
$ say "Process Name    User Name       Terminal        Phone Status"
$ say ""
$lupe:
$ write phn cmd
$ read/error=close phn str
$ if f$length(str).eq.0 then goto close
$ say str
$ num = num+1
$ goto lupe
$close:
$ close phn
$ say ""                  
$ say f$fao("!SL person!%S listed.",num)
$exit:
$ if .not. $status then say f$message($status)
$ exit !1+0*f$verify(ver)  ! What a kludge!!!
$ help:
$ wr = "write sys$output"
$ wr ""
$ wr " NETWHO.COM -- Shows the logged in users on a remote DECnet node "
$ wr "               by asking the PHONE object for a list.  "
$ wr ""
$ exit
