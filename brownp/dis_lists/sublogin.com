$ Clear
$ SET DEF [brownp.dis_lists]
$
$ W :== write sys$output
$ W " "
$ W "The current disk quota and directory contents follow :"
$ W " "
$ SHOW QUOTA
$ W "+------------------------------------------------------------+"
$ DIR
$ W "+------------------------------------------------------------+"
