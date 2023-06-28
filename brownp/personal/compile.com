$! define/nolog mod$dir "science$disk:[brownp.homework.91-101.modules]"
$! define/nolog comp$dir "group$disk:[compsci]"
$
$ write sys$output "Compiling TEST.PAS"
$ pas/optimize test
$
$ write sys$output "Linking TEST.EXE"
$ link test, comp$dir:vt100, comp$dir:utilities, mod$dir:pas_utils
