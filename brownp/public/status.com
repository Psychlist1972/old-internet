$ write sys$output "Use the username "status" with no password."
$ write sys$output " "
$ write sys$output "A few checks will be made and then you will get a "
$ write sys$output "reading of the vital net stats."
$
$ telnet ulowell.ulowell.edu
$exit
