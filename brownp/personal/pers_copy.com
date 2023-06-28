$
$
$ copy electrical$disk:[cerconeg.bbs]per.dat sys$login:per.dat
$ copy electrical$disk:[cerconeg.bbs]per.dat sys$login:per2.dat
$
$ purge sys$login:per*.dat
$ 
$exit
