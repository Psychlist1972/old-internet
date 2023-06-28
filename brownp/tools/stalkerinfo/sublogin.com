$ Clear
$ @[brownp.tools]cmdwindow.com
$ set def [brownp.tools.stalkerinfo]
$ W :== write sys$output
$ W " "
$ W "The current disk quota and directory contents follow :"
$ W " "
$ SHOW QUOTA
$ W "+------------------------------------------------------------+"
$ DIR
$ W "+------------------------------------------------------------+"







