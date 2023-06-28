$	on error then continue
$	is_verify_on = f$verify(0)
$	set noverify
$	tell := write sys$output
$	del*ete:=""
$	open/write quota sys$scratch:quota.tmp
$	write quota "$ show quota"
$	close quota
$	@sys$scratch:quota.tmp/output=sys$scratch:quota.tmp
$	open/read quota sys$scratch:quota.tmp
$	read quota rec
$	close quota
$	delete/nolog/nocon sys$scratch:quota.tmp.*
$	pos = f$locate("has ",rec)+4
$	rec := "''f$extract(pos,80,rec)'"
$	pos = f$locate(" ",rec)
$	blks = f$integer('f$extract(0,pos,rec)')-1
$	pos = f$locate("used, ",rec)+6
$	rec := "''f$extract(pos,80,rec)'"
$	pos = f$locate(" ",rec)
$	aval = f$integer('f$extract(0,pos,rec)')+1
$	total = aval + blks
$	count = 50 * blks / total
$	BAR:="x    x    x    x    x    x    x    x    x    x    xx"
$	bar := "[1m[1;7m''f$extract(0,count+1,bar)'[0m''f$extract(count+1,51-count,bar)'"
$	bobl := ""
$	if count .ge. 40 then $ bobl := "[1;5m"
$	tell -
"             (B)0You currently have ''bobl'''aval'[m out of ''total' blocks available."
$	tell -
"              lwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwqqqqwk"
$	tell "              x''bar'"
$	tell -
"              mvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvqqqqvj"
$	tell -
"               0    10   20   30   40   50   60   70   80   90  100 %"
$	if is_verify_on then set verify
$exit:  exit
