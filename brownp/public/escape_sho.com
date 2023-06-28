$ ! Going for a spin...
$ !
$ ! Yet another in the EXTREMELY long series of escape shows by:
$ !
$ !     Ed Sutherland
$ ! (Creator of GAMES.SHO)
$ ! 
$
$
$ @science$disk:[brownp.public]write.file "esc_sho"
$
$Write :== type sys$input
$I = 0
$SPIN:
$Write
[2J
[6;38H#####
[2J
[5;38H##[6;40H#[7;41H##
[2J
[4;38H#[5;39H#[6;40H#[7;41H#[8;42H#
[2J
[4;39H#[5;39H#[6;40H#[7;41H#[8;41H#
[2J
[4;40H#[5;40H#[6;40H#[7;40H#[8;40H#
[2J
[4;41H#[5;41H#[6;40H#[7;39H#[8;39H#
[2J
[4;42H#[5;41H#[6;40H#[7;39H#[8;38H#
[2J
[5;41H##[6;40H#[7;38H##
[2J
[6;38H#####
$I =I+1
$IF I .EQS. 5 THEN GOTO END
$GOTO SPIN
$END:
$EXIT
