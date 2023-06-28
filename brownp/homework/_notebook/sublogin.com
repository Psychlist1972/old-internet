!
! ._notebook directory sublogin.com
!
$ w :== write sys$output
$ w "Directory and quota follows: "
$ set def science$disk:[brownp.homework._notebook.physics]
$ show quota
$ show time
$ dir
