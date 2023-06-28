[INHERIT('comp$dir:utilities',
	 'comp$dir:vt100',
	 'mod$dir:pas_utils') ]


PROGRAM map_game2 (INPUT,OUTPUT) ;

CONST
    map_dir   = 'science$disk:[brownp._mithril._experiments.map_game]' ;
    level1_file  = 'level1.dat' ;
    level2_file  = 'level2.dat' ;
    level3_file  = 'level3.dat' ;
    level4_file  = 'level4.dat' ;

    max_x = 80 ;
    max_y = 40 ;


TYPE

    line      = VARYING [max_x] OF CHAR ;

    map_array = ARRAY [1..max_y] OF line ;


    player_record = RECORD 

	x_pos : INTEGER ;
	y_pos : INTEGER ;
	hp    : INTEGER ;
	maxhp : INTEGER ;
	gold  : INTEGER ;
	level : INTEGER ;

	inv   : ARRAY [1..30] OF string ;

    END ; { player_record }


VAR
    quit : BOOLEAN := FALSE ;
    dead : BOOLEAN := FALSE ;
    flee : BOOLEAN := FALSE ;
    c    : key_code ;
    map	 : map_array ;
    me	 : player_record ;



FUNCTION maze_completed : BOOLEAN ;

BEGIN
    maze_completed := map[me.y_pos,me.x_pos] = '~' ;
END ;


PROCEDURE update_stats ;

BEGIN
    writeat(60,10,'Hit points '+itoa(me.hp)+'/'+itoa(me.maxhp)+'  ', FALSE) ;
    writeat(60,11,'Wealth     '+itoa(me.gold)+' gd   ', FALSE) ;
    writeat(60,12,'Maze level '+itoa(me.level)+' ', FALSE) ;

END ;


PROCEDURE display_map(
	    x_pos : INTEGER ;
	    y_pos : INTEGER ) ;

VAR
    k : INTEGER ; (* local loop index variable *)
    x : INTEGER ; (* local loop index variable *)


BEGIN

    writeat(1,10,'Xposition =  ' + itoa(x_pos),FALSE) ;
    writeat(1,11,'Yposition =  ' + itoa(y_pos),FALSE) ;
    writeat(1,12,'Room      = "' + map[y_pos,x_pos] + '"',FALSE) ;

	(* top 4 rows of characters *)

    FOR x := 1 TO 4 DO
	BEGIN
	    FOR k := 1 TO 7 DO
		writeat(29+k,4+x,map[y_pos-1,x_pos-1],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(36+k,4+x,map[y_pos-1,x_pos],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(43+k,4+x,map[y_pos-1,x_pos+1],FALSE) ;
	END ;

    FOR x := 1 TO 4 DO
	BEGIN
	    FOR k := 1 TO 7 DO
		writeat(29+k,8+x,map[y_pos,x_pos-1],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(36+k,8+x,map[y_pos,x_pos],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(43+k,8+x,map[y_pos,x_pos+1],FALSE) ;
	END ;
    
    FOR x := 1 TO 4 DO
	BEGIN
	    FOR k := 1 TO 7 DO
		writeat(29+k,12+x,map[y_pos+1,x_pos-1],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(36+k,12+x,map[y_pos+1,x_pos],FALSE) ;

	    FOR k := 1 TO 7 DO
		writeat(43+k,12+x,map[y_pos+1,x_pos+1],FALSE) ;
	END ;

END ;


PROCEDURE do_flee ;

VAR
    y : INTEGER ;
    x : INTEGER ;
    k : INTEGER ;

BEGIN

    flee := false ;

    k := 0 ;

    k := INT(TRUNC(rnd*5)) + 1;

    IF k > 2 THEN
	REPEAT

	    y := INT(TRUNC(rnd*40)) ;
	    x := INT(TRUNC(rnd*80)) ;

	    IF map[y,x] <> '#' THEN
		BEGIN
		    flee     := TRUE ;
		    me.x_pos := x ;
		    me.y_pos := y ;
		    display_map(me.x_pos,me.y_pos) ; 
		END ;
	UNTIL (flee) 
    ELSE
	BEGIN
	    flee   := false ;
	    me.hp  := me.hp DIV 2 ;
	    writeat(1,22,'It POUNDS you as you try to escape!                                   ') ;  
	END ;
END ;



PROCEDURE choose_random_monster(
	VAR name : string ;
	VAR hp   : INTEGER ) ;

VAR
    k : INTEGER ;

BEGIN
    k := (INT(TRUNC(RND*100))) ;
    
    CASE k OF
	 0..10  : name := 'black cat' ;
	11..20  : name := 'giant rat' ;
	21..30  : name := 'slimer' ;
	31..40  : name := 'puddle o'' ooze' ;
	41..50  : name := 'mirror image of yourself' ;
	51..60  : name := 'bat' ;
	61..70  : name := 'giant bat' ;
	71..80  : name := 'really ungly thing' ;
	81..90  : name := 'calculus book' ;
	91..101 : name := 'physics book' ;
    END ; { case }

    hp := (INT(TRUNC(RND*50))) ;
END ;



FUNCTION find_monster_hit(
	    monster_hp : INTEGER ) : string ;

VAR
    k : INTEGER ;
    str : string ;

BEGIN
    k := INT((TRUNC(RND*monster_hp))) ;

    CASE k OF
	0      : str := ' and misses you.                                          ' ;
	1..5   : str := ' and scratches you.                                       ' ;
	6..10  : str := ' and hits you pretty hard.                                 ' ;
	11..15 : str := ' and hits you so hard you puke!                          ' ;
	16..20 : str := ' and gives you a good look at your internal organs.    '   ;
	21..25 : str := ' and practically rips a limb off of your body.             ' ;
	26..30 : str := ' and smashes your brains to the other side of your head!' ;
	31..50 : str := ' and pounds you so hard you are barely alive!            ' ; 
    END ; { case }

    me.hp := me.hp - k ;

    IF me.hp <=0 THEN 
	BEGIN
	    me.hp := 0 ;
	    dead  := TRUE ;
	    str   := ' and pounds you into a lifeless blob.  You are dead.                '
	END ;

    find_monster_hit := str ;
 
END ;



PROCEDURE attack_monster(
	VAR monster_hp : INTEGER ) ;

VAR
    k : INTEGER ;
    str : string ;

BEGIN
    k := INT((TRUNC(RND*me.hp))) ;

    CASE k OF
	0      : str := ' and you miss.                                        ' ;
	1..5   : str := ' and you barely scratch it.                           ' ;
	6..10  : str := ' and you hit it pretty hard.                          ' ;
	11..15 : str := ' and you hit it so hard it pukes!                     ' ;
	16..20 : str := ' and tear at its internal organs with your weapon.    ' ;
	21..25 : str := ' and you rip a limb off of its body.                  ' ;
	26..30 : str := ' and smash it so hard you put your hand through it!   ' ;
	31..50 : str := ' and pound it so hard it is barely living!            ' ; 
    END ; { case }

    monster_hp := monster_hp - k ;

    IF monster_hp <=0 THEN 
	str := ' and pound it into a lifeless blob.  It is dead.                 ' ;

{    gotoxy(1,21) ;
    clreos ;
}
    writeat(1,23,'You attack'+str) ;

END ;


PROCEDURE fight_monster ;

VAR
    monster_name : string ;
    monster_hp   : INTEGER ;
    key		 : key_code ;

BEGIN
    choose_random_monster(monster_name,monster_hp) ;
    writeat(1,21,'As you venture forward you are attacked by a '+monster_name+'!                          ',FALSE) ;       
    
    WHILE ((NOT(dead)) AND (monster_hp > 0)) AND (NOT(flee)) DO
	BEGIN
	    writeat(1,22,'It attacks'+find_monster_hit(monster_hp),FALSE) ;
	    update_stats ;
{	    gotoxy(1,21) ; 
	    clreos ;  }
    
	    IF (NOT(dead)) AND (NOT(flee)) THEN
		BEGIN
		    gotoxy(1,20) ;
		    WRITELN ;
		    key := get1char('[(f)ight (r)un]>       ') ; 
	    
		    IF NOT((key = K_UP_R) OR (key = K_LOW_R)) THEN
			attack_monster(monster_hp)
		    ELSE
			do_flee ;

		END
	    ELSE
		writeat(33,3,' Game over pal ! ',TRUE)
	END ;


	(* give the user some random gold *)
	(* I used monster_hp to avoid allocating another variable *)

    IF (not(dead)) THEN
	BEGIN
	    monster_hp := (INT(TRUNC(rnd*100))) ;   (* reuse of the variable *)
	    me.gold    := me.gold + monster_hp ;
	END ;

    update_stats ;
END ;


PROCEDURE get_treasure ;

BEGIN
    update_stats ;
END ;


PROCEDURE check_special_room ;

VAR
    k : INTEGER ;

BEGIN

    k := INT(TRUNC(rnd*100)) ;

    IF k > 90 THEN
	map[me.y_pos,me.x_pos] := 'M' ;

    CASE map[me.y_pos,me.x_pos] OF

	'M','m' : fight_monster ;
	'T','t' : get_treasure ;

    END ; { case }

END ;




PROCEDURE set_up_screen ;

BEGIN
    clrscr ;
    box (29,4,51,17) ;
    display_map(me.x_pos,me.y_pos) ;
END ;


PROCEDURE move_north ;

BEGIN
    IF ((me.y_pos - 1) <= 1) OR (map[me.y_pos-1,me.x_pos] = '#') THEN
	beep
    ELSE
	BEGIN
	    me.y_pos := me.y_pos - 1 ;
	    display_map(me.x_pos,me.y_pos) ;
	END ;
END ;



PROCEDURE move_south ;

BEGIN
    IF ((me.y_pos + 1) >= max_y) OR (map[me.y_pos+1,me.x_pos] = '#') THEN
	beep
    ELSE
	BEGIN
	    me.y_pos := me.y_pos + 1 ;
	    display_map(me.x_pos,me.y_pos) ;
	END ;

END ;


PROCEDURE move_east ;

BEGIN
    IF ((me.x_pos + 1) >= max_x) OR (map[me.y_pos,me.x_pos+1] = '#') THEN
	beep
    ELSE
	BEGIN
	    me.x_pos := me.x_pos + 1 ;
	    display_map(me.x_pos,me.y_pos) ;
	END ;

END ;


PROCEDURE move_west ;

BEGIN
    IF ((me.x_pos - 1) <= 1) OR (map[me.y_pos,me.x_pos-1] = '#') THEN
	beep
    ELSE
	BEGIN
	    me.x_pos := me.x_pos - 1 ;
	    display_map(me.x_pos,me.y_pos) ;
	END ;
END ;


PROCEDURE save_game ;
BEGIN
END ;


PROCEDURE read_map(
	lev : INTEGER) ;

VAR
    root    : string ;
    fileid  : TEXT ;
    counter : INTEGER := 1 ;
    str	    : string ;

BEGIN
    
    CASE lev OF
	1 : root := map_dir + level1_file ;
	2 : root := map_dir + level2_file ;
	3 : root := map_dir + level3_file ;
	4 : root := map_dir + level4_file ;
    END ; { case }    


    IF valid_file(root) THEN
	BEGIN
	    OPEN (fileid, root, HISTORY := OLD) ;
	    RESET (fileid) ;

	    WHILE ((NOT(EOF(fileid))) AND (counter <= max_y)) DO
		BEGIN
		    READLN(fileid, str) ;

			(* parse out comments *)

		    standardize_string(str) ;

		    IF str <> '' THEN
			IF str[1] <> '!' THEN
			    BEGIN
				map[counter] := str ;
				counter := counter + 1 ;
			    END ;
		END ;

	    CLOSE (fileid) ;
	END 
    ELSE
	WRITELN('Cannot load next level.') ;
END ;


PROCEDURE do_help ;

BEGIN
    writeat(1,23,'Help!??! Not yet!') ;
END ;


PROCEDURE initialize_all ;

BEGIN
    me.x_pos := 3 ;
    me.y_pos := 4 ;
    me.maxhp := 100 ;
    me.hp    := 100 ;
    me.level := 1 ;

    read_map(me.level) ;	(* set up first level *)
END ;


BEGIN
    initialize_all ;
    set_up_screen ;
    update_stats ;
    
    REPEAT
	
	gotoxy(1,20) ;
	WRITELN ;

	IF (maze_completed) THEN
	    BEGIN
		me.level := me.level + 1 ;
		read_map (me.level) ;
		beep ;
		flash_screen ;
		beep ;
		gotoxy(1,23) ;
		clreos ;
		writeat(1,23,'You are transported down one more level...beware...') ;
	    END ;

	c := get1char('[n,s,e,w,h,q] > ') ;

	IF me.hp < me.maxhp THEN
	    me.hp := me.hp + 1 ;

	update_stats ;


	gotoxy(1,21) ;
	clreos ;

	CASE c OF
	    K_UP_Q, K_LOW_Q : quit := TRUE ;
	    K_UP_N, K_LOW_N : move_north ;
	    K_UP_S, K_LOW_S : move_south ;
	    K_UP_E, K_LOW_E : move_east ;
	    K_UP_W, K_LOW_W : move_west ;
	    K_UP_H, K_LOW_H : do_help ;
	 
	    OTHERWISE
		beep ;

	END ; { case }	

	check_special_room ;

    UNTIL (quit or dead) ;

    gotoxy(1,24) ;
    WRITELN ;

END .
