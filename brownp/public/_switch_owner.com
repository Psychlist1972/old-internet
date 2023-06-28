
$ !WILL SWITCH OWNERSHIP ON FILES
$ ON ERROR THEN CONTINUE
$
$
$ @science$disk:[brownp.public]write.file "switch"
$
$  s:==write sys$output
$ if p1 .nes. "" then goto START
$  inquire/nopunc p1 "File to be reowned: "
$START:
$  inquire/nopunc all "Delete other versions? [y] "
$ if f$search("''p1'") .eqs. "" then s "File ''p1' not found."
$ if f$search("''p1'") .eqs. "" then exit
$  copy 'p1 test.test
$  delete 'p1;
$  if all .eqs. "Y" then del 'p1;*
$  if all .eqs. "Y" then s "all versions deleted"
$  rename test.test 'p1
$  set prot = (w:werd) 'p1
$  user = f$user()
$  s "   ''p1' now under ownership of ''user'."
$exit

