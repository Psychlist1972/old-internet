$ @science$disk:[brownp.public]write.file "mkdir"
$
$! This DCL file makes a directory.
$  if P1 .EQS. "" then inquire/nopunc p1 "WELL??? Name the damn thing! "
$  dirname1 = "." + P1
$  create/dir ['dirname1']
$  dirname = P1 + ".dir"
$  set prot=(S:rwed,O:rwed,G,W) 'dirname
$  write sys$output "MKDIR-I-DIR, Directory " + P1 + " has been created."
$  exit
