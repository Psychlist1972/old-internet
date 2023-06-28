$	on error then continue
$	is_verify_on = f$verify(0)
$	set noverify
$	tell :== write sys$output
$	del*ete:=""
$ assign quota.tmp sys$output
$ show quota
$ deassign sys$output
$ open/read myq quota.tmp
$ read myq lin
$ close myq
$ del quota.tmp;*
$ blks=f$element(5," ",lin)
$ avail=f$element(8," ",lin)
$ total=f$element(12," ",lin)
$	count = 50 * blks / total
$	BAR:="x    x    x    x    x    x    x    x    x    x    xx"
$	bar := "[1m[1;7m''f$extract(0,count+1,bar)'[0m''f$extract(count+1,51-count,bar)'"
$	bobl := ""
$	if count .ge. 40 then $ bobl := "[1;5m"
$	tell -
"             (B)0You currently have ''bobl'''avail'[m out of ''total' blocks available."
$	tell -
"              lwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwk"
$	tell "              x''bar'"
$	tell -
"              mvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvj"
$	tell -
"               0    10   20   30   40   50   60   70   80   90  100 %"
$	if is_verify_on then set verify
$exit:  exit
