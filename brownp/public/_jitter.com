$
$ @science$disk:[brownp.public]write.file "jitter"
$
$ jitter:
$ write sys$output "[HM[23;0HD"
$ goto jitter
