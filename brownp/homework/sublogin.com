$ Clear
$
$ set def science$disk:[brownp.homework.91-101]
$
$ W :== write sys$output
$ W " "
$ W "The current disk quota and directory contents follow :"
$ W " "
$ SHOW QUOTA
$ W "+------------------------------------------------------------+"
$ DIR
$ W "+------------------------------------------------------------+"
