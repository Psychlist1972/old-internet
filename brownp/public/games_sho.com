$ ! SAVE THE GAMES!!!! An original program by:
$ !             Ed Sutherland
$ !
$ ! Recently, the system managers have banned the use of all games on the
$ ! VAX system through the entire year.  They have claimed that, if a player
$ ! is found playing games more than once, his/her account will be locked for
$ ! days, even weeks.  This program puts into words the feelings of all affected
$ ! by this decree.
$ !
$ ! To use this program, extract GAMES.SHO, then enter @GAMES.SHO to run it.
$ ! And remember... SAVE THE GAMES!!!
$ !
$set process/name:"Games.sho #1!!!"
$Write :== type sys$input
$Write
 [2J
 [10;31HSave The Games!!!
$Wait 00:00:01
$Write
 [2J
 [10;11H#6Save The Games!!!
$wait 00:00:01
$Write
 [2J
 [10;11H#3Save The Games!!!
 [11;11H#4Save The Games!!!
$wait 00:00:01
$Write
 [10;11H[7m#3Save[0m The Games!!!
 [11;11H[7m#4Save[0m The Games!!!
$wait 00:00:01
$Write
 [10;11H#3Save [7mThe[0m Games!!!
 [11;11H#4Save [7mThe[0m Games!!!
$wait 00:00:01
$Write
 [10;11H#3Save The [7mGames[0m!!!
 [11;11H#4Save The [7mGames[0m!!!
$wait 00:00:01
$Write
 [10;11H#3Save The Games!!!
 [11;11H#4Save The Games!!!
$wait 00:00:01
$Write
 [2J
 (0
 [4;25Hlqqqqqqqqqqqqqqqqqqqqqqqqqqqk
 [5;25Hxlqqqqqqqqqqqqqqqqqqqqqqqqqkx
 [6;25Hxx                         xx
 [7;25Hxx                         xx
 [8;25Hxx                         xx
 [9;25Hxx                         xx
 [10;25Hxx                         xx
 [11;25Hxx                         xx
 [12;25Hxx                         xx
 [13;25Hxx                         xx
 [14;25Hxmqqqqqqqqqqqqqqqqqqqqqqqqqjx
 [15;25Hmqqqqqqqqqqwqqqqqqwqqqqqqqqqj
 [16;25H           x      x
 [17;20Hlqqqqqqqqqqqqqqqvqqqqqqvqqqqqqqqqqqqqqk
 [18;20Hx lk lk lk        lqqqqqqqk lqqqqqqqk x
 [19;20Hx mj mj mj        xqqwqwqqx xqqwqwqqx x
 [20;20Hx                 mqqvqvqqj mqqvqvqqj x
 [21;20Hxxxxxxxxxxxx             GAME-PLAYER  x
 [22;20Hx                           2000      x
 [23;20Hmqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj[H
 (B
$wait 00:00:02
$Write
 [7;31HSave
$wait 00:00:00.20
$Write
 [7;36HThe
$wait 00:00:00.20
$Write
 [7;40HGames!!!!
$wait 00:00:01
$Write
 [9;28HMonster
$wait 00:00:00.20
$Write
 [9;37HGtrade
$wait 00:00:00.20
$Write
 [9;46HQix
$wait 00:00:00.20
$Write
 [10;28HTank
$wait 00:00:00.20
$Write
 [10;37HMoria
$wait 00:00:00.20
$Write
 [10;46HDoom
$wait 00:00:00.20
$Write
 [11;28HTetris
$wait 00:00:00.20
$Write
 [11;37HAlien
$wait 00:00:00.20
$Write
 [11;46HBucks
$wait 00:00:00.20
$Write
 [12;28HBattleship
$wait 00:00:00.20
$Write
 [12;41HMillipede
$wait 00:00:01
$Write
 [1;7HRead these names carefully,
$wait 00:00:01
$Write
 [1;35Hfor they have been banned from use by:
$wait 00:00:01
$Write
 [2;13H[7m#6THE SYSTEM!!!![0m
$wait 00:00:03
$Write
 [1J
 [1;18HWe could accept this...
$wait 00:00:01
$Write
 [1;43HBut we SHOULDN'T!!!!
$wait 00:00:03
$Write
 [1J
 [1;32HWe should try to
$wait 00:00:01
$Write
 [2;11H[4m#6SAVE[0m 
$wait 00:00:00.20
$Write
 [2;16H[4mTHE[0m 
$wait 00:00:00.20
$Write
 [2;20H[4mGAMES[0m!!!!
