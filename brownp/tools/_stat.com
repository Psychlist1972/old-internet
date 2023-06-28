
$ !STAT.COM GIVES INTERSTING INFO
$ 
$  user = f$user() - "[" - "]"
$  name = ""'f$process()'"
$  dir = f$directory() - "[" - "]"
$  pid = f$getjpi("","pid")
$  node = f$logi("sys$node") - "::" - "_"
$  s:==write sys$output
$  clear
$  s "                          Status for ''user'"
$  s " "
$  sh process/sub
$  s "[5;1H                                                                          "
$  s "[6;1H                                                                               "
$  s "[7;1H                                                                               "
$  s "[5;1HCurrent Dir: ''dir'"
$  s " "
$  s "Node:        ''node'        Pid: ''pid'"
$  s " "
$  s "Process: "
$  s "[14;1H                                                                      "
$  sh quo
$  s " "
$  sh status
$  s " "
$exit     
