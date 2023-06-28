$ Clear
$ SET DEF [brownp.tools]
$ @[brownp.tools]cmdwindow.com
$ W :== write sys$output
$ W " "
$ W "The current disk quota and directory contents follow :"
$ W " "
$ SHOW QUOTA
$ W "+------------------------------------------------------------+"
$ DIR
$ W "+------------------------------------------------------------+"
