(* Program GETAKEY.PAS *)

(* This program demonstrates the use of procedures and functions in modules *)

(* Revision History                                       *)
(* ----------------                                       *)
(* 30-AUG-1990   JMH   original coding by Jesse M. Heines *)
(* 14-AUG-1991   JMH   updated for 1991                   *)
(* 04-SEP-1991   PMB   addition oif various typos         *)


   (* The following statement imports non-standard functions from module  *)
   (* UTILITIES.PAS, which, when compiled, creates the Pascal ENvironment *)
   (* file UTILITIES.PEN.                                                 *)

[INHERIT ('group$disk:[compsci]utilities',
	  'group$disk:[compsci]vt100')]


PROGRAM getakey (INPUT,OUTPUT) ;

CONST
    max_keys = 64 ;

TYPE
    keys =  record
		code1 : key_code ; (* lowercase key code *)
		code2 : key_code ; (* shifted key code   *)
		topx  : INTEGER  ; (* top left hand corner of the box xpos  *)
		topy  : INTEGER  ; (* top left hand corner of the box ypos  *)
		botx  : INTEGER  ; (* bottom right x position *)
		boty  : INTEGER  ; (* bottom right y position *)
	    end ; (* record of keys *) 
    

VAR	(* Global variable *)
    c		: Key_code ;	    (* a numeric key code for the key pressed *)
    keyboard	: array[1..max_keys] of keys ; 
				    (* information on individual keys         *)
    old_key	: INTEGER ;	    (* previously pressed key                 *)
    current_key : INTEGER ;	    (* the key you just pressed               *)


PROCEDURE display_keyboard ; 

BEGIN
 
    clrscr ;

     WRITELN ;
     WRITELN ;
     WRITELN('       P1  P2  P3  P4  UP  DN  LT  RT  HOME   ');
     WRITELN ; 
     WRITELN(' ESC   1   2   3   4   5   6   7   8   9   0   -   =   `   BS ');
     WRITELN ;
     WRITELN(' TAB   Q   W   E   R   T   Y   U   I   O   P   [   ]  DEL');
     WRITELN ;
     WRITELN('       A   S   D   F   G   H   J   K   L   ;   ''  RET  \');
     WRITELN ; 
     WRITELN('       Z   X   C   V   B   N   M   ,   .   /   LF');
     WRITELN ;
     WRITELN('                             SPACE BAR         ');
     WRITELN ;
     WRITELN ;
END ; 


(* the following function takes the key_code C and looks up the *)
(* the appropriate record in the KEYBOARD[x] array.  The index  *)
(* the array is returned as the function result                 *)

FUNCTION lookup_key : INTEGER ;

VAR
    x	: INTEGER := 1;		(* local loop index variable    *)
    ok	: BOOLEAN := FALSE ;	(* is the key on the keyboard ? *)

BEGIN

    REPEAT

	WITH keyboard[x] DO

	    IF (code1 = c) or (code2 = c) then
		ok := TRUE
	    ELSE
		x := x + 1 ; 

    UNTIL (ok) or (x = max_keys) ;

    IF ok THEN 
	lookup_key := x
    ELSE
	lookup_key := 64 ;

END ;



(* This procedure based upon procedure BOX written by JMH   *)
(* This procedure drows a "box" of blank spaces given the   *) 
(* same parameters as the BOX command                       *)

(* NOTE : This procedure is definately a hack.  It does a   *)
(*   work than is really necessary because I simply         *)
(*   substituted spaces for the grafix characters in the    *)
(*   box procedure when I translated it  ;)                 *)

PROCEDURE unbox 
   (leftcolumn  : INTEGER ;     (* column number for left boundary  *)
    topline     : INTEGER ;     (* line number for top boundary     *)
    rightcolumn : INTEGER ;     (* column number for right boundary *)
    bottomline  : INTEGER ) ;   (* line number for bottom boundary  *)
    
VAR k    : INTEGER ;   (* local loop index                         *)
    temp : INTEGER ;   (* for swapping parameters if necessary     *)

BEGIN

      (* swap left and right columns if necessary *)

   IF leftcolumn > rightcolumn THEN
       BEGIN
	  temp := leftcolumn ;
	  leftcolumn := rightcolumn ;
	  rightcolumn := temp ;
       END ;
      
      (* adjust left and right columns if necessary *)

   IF leftcolumn = 0 THEN leftcolumn := 1 ;
   IF leftcolumn > 80 THEN leftcolumn := 80 ;

   IF rightcolumn = 0 THEN rightcolumn := 1 ;
   IF rightcolumn > 80 THEN rightcolumn := 80 ;

      (* swap top and bottom lines if necessary *)

   IF topline > bottomline THEN
       BEGIN
	  temp := topline ;
	  topline := bottomline ;
	  bottomline := temp ;
       END ;
      
      (* adjust top and bottom lines if necessary *)

   IF topline = 0 THEN topline := 1 ;
   IF topline > 24 THEN topline := 24 ;

   IF bottomline = 0 THEN bottomline := 1 ;
   IF bottomline > 24 THEN bottomline := 24 ;

      (* draw top horizontal line *)

   GotoXY (leftcolumn, topline) ;
   WRITE (' ') ;
   FOR k := leftcolumn+1 TO rightcolumn-1 DO WRITE (' ') ;
   WRITELN (' ') ;

      (* draw left vertical line *)

   GotoXY (leftcolumn, topline+1) ;
   FOR k := topline+1 TO bottomline-1 DO
      BEGIN
	 WRITE (' ') ; CursorLeft (1) ; CursorDown (1) ;
      END ;
   GotoXY (leftcolumn, topline+1) ;
   WRITELN ;

      (* draw right vertical line *)

   GotoXY (rightcolumn, topline+1) ;
   FOR k := topline+1 TO bottomline-1 DO
      BEGIN
	 WRITE (' ') ; 
	 IF rightcolumn <> 80 THEN
	    BEGIN
	       CursorLeft (1) ; CursorDown (1) ;
	    END
	 ELSE
	    GotoXY (rightcolumn, k+1) ;
      END ;
   GotoXY (rightcolumn, topline+1) ;
   WRITELN ;

      (* draw bottom horizontal line *)

   GotoXY (leftcolumn, bottomline) ;
   WRITE (' ') ;
   FOR k := leftcolumn+1 TO rightcolumn-1 DO WRITE (' ') ;
   IF (bottomline < 24) OR (rightcolumn < 80) THEN
      WRITE (' ') ; 
   GotoXY (leftcolumn, topline) ;
   WRITELN ;

END ;


(* This procedure shows the current date and time. *)

PROCEDURE showtime ;

VAR	(* Local Variables *)

    now	    : string ;  (* the current time in hours and minutes  *)
    timesig : string ;	(* time signature for the current time	  *)
    today   : string ;	(* today's date			          *)

BEGIN
    
	(* call the procedure in PROF_HEINES.PAS to get the current date *)
	(* and time							 *)

    dateandtime (today, now, timesig) ;

	(* display the date and time *)
    
    WRITELN ;
    WRITELN ;
    WRITELN ('  Today is ',today,' and it is now ',now,' ',timesig) ;
    
END ;	(* Showtime *)


(* This procedure shows the program's directions *)

PROCEDURE showdirections ;

BEGIN
    

    WRITELN ;
    WRITELN ('  Press any key other than F1 through F6 to demonstrate ') ;
    WRITELN ('  single character input.') ;
    WRITELN ;
    WRITELN ('  A box icon will highlight the appropriate key on the screen. ') ;
    WRITELN ;
    WRITELN ('  Press "H" for help (these directions), and "Q" to quit.') ;
    WRITELN ;
    WRITELN ;

END ;	(* showdirections *)



	(* the following procedure handles the assignment of locations *)
	(* of the keys to an array of records                          *)

PROCEDURE set_up_records ;

VAR
    x : integer ; (* local loop index variable *)
    y : integer ; (* local loop index variable *)

BEGIN
    old_key := 64 ;
    current_key := 64 ;
    
{ pf1 } keyboard[1].code1 := 256 ;
	keyboard[1].code2 := 256 ;
{ pf2 } keyboard[2].code1 := 257 ;
	keyboard[2].code2 := 257 ;
{ pf3 } keyboard[3].code1 := 258 ;
	keyboard[3].code2 := 258 ;
{ pf4 } keyboard[4].code1 := 259 ;
	keyboard[4].code2 := 259 ;
{ lft } keyboard[5].code1 := 274 ;
	keyboard[5].code2 := 274 ;
{ rgt } keyboard[6].code1 := 275 ;
	keyboard[6].code2 := 275 ;
{ up  } keyboard[7].code1 := 276 ;
	keyboard[7].code2 := 276 ;
{ dwn } keyboard[8].code1 := 277 ;
	keyboard[8].code2 := 277 ;
{ esc } keyboard[9].code1 := 511 ;
	keyboard[9].code2 := 511 ;
{ hom } keyboard[10].code1 := 511 ;
	keyboard[10].code2 := 511 ;
{ 1 ! } keyboard[11].code1 := 49 ;
	keyboard[11].code2 := 33 ;
{ 2 @ } keyboard[12].code1 := 50 ;
	keyboard[12].code2 := 64 ;
{ 3 # } keyboard[13].code1 := 51 ;
	keyboard[13].code2 := 35 ;
{ 4 $ } keyboard[14].code1 := 52 ;
	keyboard[14].code2 := 36 ;
{ 5 % } keyboard[15].code1 := 53 ;
	keyboard[15].code2 := 37 ;
{ 6 ^ } keyboard[16].code1 := 54 ;
	keyboard[16].code2 := 94 ;
{ 7 & } keyboard[17].code1 := 55 ;
	keyboard[17].code2 := 38 ;
{ 8 * } keyboard[18].code1 := 56 ;
	keyboard[18].code2 := 42 ;
{ 9 ( } keyboard[19].code1 := 57 ;
	keyboard[19].code2 := 40 ;
{ 0 ) } keyboard[20].code1 := 48 ;
	keyboard[20].code2 := 41 ;
{ - _ } keyboard[21].code1 := 45 ;
	keyboard[21].code2 := 95 ;
{ = + } keyboard[22].code1 := 61 ;
	keyboard[22].code2 := 43 ;
{ ` ~ } keyboard[23].code1 := 96 ;
	keyboard[23].code2 := 126 ;
{ bsp } keyboard[24].code1 := 8 ;
	keyboard[24].code2 := 8 ;
{ tab } keyboard[25].code1 := 9 ;
	keyboard[25].code2 := 9 ;
{ Q q } keyboard[26].code1 := 113 ;
	keyboard[26].code2 := 81 ;
{ W w } keyboard[27].code1 := 119;
	keyboard[27].code2 := 87 ;
{ E e } keyboard[28].code1 := 101;
	keyboard[28].code2 := 69 ;
{ R r } keyboard[29].code1 := 114;
	keyboard[29].code2 := 82 ;
{ T t } keyboard[30].code1 := 116;
	keyboard[30].code2 := 84 ;
{ Y y } keyboard[31].code1 := 121 ;
	keyboard[31].code2 := 89 ;
{ U u } keyboard[32].code1 := 117 ;
	keyboard[32].code2 := 85 ;
{ I i } keyboard[33].code1 := 105 ;
	keyboard[33].code2 := 73 ;
{ O o } keyboard[34].code1 := 111 ;
	keyboard[34].code2 := 79 ;
{ P p } keyboard[35].code1 := 112 ;
	keyboard[35].code2 := 80 ;
{ [   } keyboard[36].code1 := 91 ;
	keyboard[36].code2 := 91 ;
{ ]   } keyboard[37].code1 := 93 ;
	keyboard[37].code2 := 93 ;
{ del } keyboard[38].code1 := 127 ;
	keyboard[38].code2 := 127 ;
{ A a } keyboard[39].code1 := 97 ;
	keyboard[39].code2 := 65 ;
{ S s } keyboard[40].code1 := 115 ;
	keyboard[40].code2 := 83 ;
{ D d } keyboard[41].code1 := 100 ;
	keyboard[41].code2 := 68 ;
{ F f } keyboard[42].code1 := 102 ;
	keyboard[42].code2 := 70 ;
{ G g } keyboard[43].code1 := 103 ;
	keyboard[43].code2 := 71 ;
{ H h } keyboard[44].code1 := 104;
	keyboard[44].code2 := 72;
{ J j } keyboard[45].code1 := 106 ;
	keyboard[45].code2 := 74 ;
{ K k } keyboard[46].code1 := 107 ;
	keyboard[46].code2 := 75 ;
{ L l } keyboard[47].code1 := 108 ;
	keyboard[47].code2 := 76 ;
{ ; : } keyboard[48].code1 := 59 ;
	keyboard[48].code2 := 58 ;
{ ' " } keyboard[49].code1 := 39 ;
	keyboard[49].code2 := 34 ;
{ ret } keyboard[50].code1 := 13 ;
	keyboard[50].code2 := 13 ;
{ | \ } keyboard[51].code1 := 92 ;
	keyboard[51].code2 := 124 ;
{ Z z } keyboard[52].code1 := 122;
	keyboard[52].code2 := 90 ;
{ X x } keyboard[53].code1 := 120 ;
	keyboard[53].code2 := 88 ;
{ C c } keyboard[54].code1 := 99 ;
	keyboard[54].code2 := 67 ;
{ V v } keyboard[55].code1 := 118 ;
	keyboard[55].code2 := 86 ;
{ B b } keyboard[56].code1 := 98 ;
	keyboard[56].code2 := 66 ;
{ N n } keyboard[57].code1 := 110 ;
	keyboard[57].code2 := 78 ;
{ M m } keyboard[58].code1 := 109 ;
	keyboard[58].code2 := 77 ;
{ , < } keyboard[59].code1 := 44 ;
	keyboard[59].code2 := 60 ;
{ . > } keyboard[60].code1 := 46 ;
	keyboard[60].code2 := 62 ;
{ / ? } keyboard[61].code1 := 47 ;
	keyboard[61].code2 := 63 ;
{ lfd } keyboard[62].code1 := 10 ;
	keyboard[62].code2 := 10 ;
{ spc } keyboard[63].code1 := 32 ;
	keyboard[63].code2 := 32 ;


	(* keyboard[64] is the resting place for the box icon when a key *)
	(* which is not on our diagram is pressed                        *)

    keyboard[64].topx := 1 ;
    keyboard[64].topy := 8 ;
    keyboard[64].botx := 4 ;
    keyboard[64].boty := 10 ;

	(* the following maps out the positions of the keys on the display *)

    y := 7 ;

    FOR x := 1 to 8 DO
	BEGIN
	    keyboard[x].topy := 1 ;
	    keyboard[x].boty := 3 ;
	    keyboard[x].topx := y ;
	    keyboard[x].botx := y + 4 ; 
	    y := y + 4 ;
	END ;

    y := 6 ;

    FOR x := 11 to 24 DO
	BEGIN
	    keyboard[x].topy := 3 ;
	    keyboard[x].boty := 5 ;
	    keyboard[x].topx := y ;
	    keyboard[x].botx := y + 4 ; 
	    y := y + 4 ;
	END ;

    y := 6 ;

    FOR x := 26 to 38 DO
	BEGIN
	    keyboard[x].topy := 5 ;
	    keyboard[x].boty := 7 ;
	    keyboard[x].topx := y ;
	    keyboard[x].botx := y + 4 ; 
	    y := y + 4 ;
	END ;

    y := 6 ;

    FOR x := 39 to 51 DO
	BEGIN
	    keyboard[x].topy := 7 ;
	    keyboard[x].boty := 9 ;
	    keyboard[x].topx := y ;
	    keyboard[x].botx := y + 4 ; 
	    y := y + 4 ;
	END ;

    y := 6 ;

    FOR x := 52 to 62 DO
	BEGIN
	    keyboard[x].topy := 9 ;
	    keyboard[x].boty := 11 ;
	    keyboard[x].topx := y ;
	    keyboard[x].botx := y + 4 ; 
	    y := y + 4 ;
	END ;

{ esc }

    keyboard[9].topx := 1 ;
    keyboard[9].topy := 3 ;
    keyboard[9].botx := 5 ;
    keyboard[9].boty := 5 ;

{ tab }

    keyboard[25].topx := 1 ;
    keyboard[25].topy := 5 ;
    keyboard[25].botx := 5 ;
    keyboard[25].boty := 7 ;

{ home }

    keyboard[10].topx := 38 ;
    keyboard[10].topy := 1 ;
    keyboard[10].botx := 44 ;
    keyboard[10].boty := 3 ;

{ space bar }

    keyboard[63].topx := 28 ;
    keyboard[63].topy := 11 ;
    keyboard[63].botx := 40 ;
    keyboard[63].boty := 13 ;

END ;   (* set up records *)



	(* the following procedure handles the actual movement of the *)
	(* highlighted boxes                                          *)

PROCEDURE move_box ;

BEGIN

	(* remove the box around the old selected key *)

    with keyboard[old_key] do
	unbox(topx,topy,botx,boty) ;


	(* draw a box around the newly selected key   *)

    with keyboard[current_key] do
	box (topx,topy,botx,boty) ;

	(* make the new key the old key in prep. for a new keypress *)

    old_key := current_key ;


END ; (*  move box *)



PROCEDURE help ;

VAR
    return: string ;

BEGIN
    clrscr ;
    showtime ;
    showdirections ;
    WRITELN ;
    WRITE ('Hit return to continue.') ;
    READLN (return) ;
    display_keyboard ;

END ;

BEGIN	(* mainline code *)

	(* initialize all of the records containing information *)
	(* on each of the keys on our keyboard diagram          *)

    set_up_records ;

	(* Clear the screen, show the current date and time, and *)
	(* show the directions				         *)

    help ;

	(* get key presses until the user presses "x" *)

    REPEAT
    	    (* prompt the user to press a key *)
	    (* then move the box to the appropriate place on the screen *)
    	
	gotoxyimmediate(1,16) ;

	WRITELN ;

	c := get1char ('Press a key >> ') ;
	

	gotoxyimmediate(1,14) ;

	clreos ;

		current_key := lookup_key ;
		move_box ;

	IF current_key = 64 THEN
	    BEGIN
		gotoxyimmediate(1,15) ;
		WRITELN('Key is not on keyboard map displayed. ') ;
	    END ;
    

	    (* analyze the keypress and clear the screen if it's an "h" *)

	IF ((c = ORD('h')) OR (c = ORD('H'))) THEN
	    help

	    (* otherwise show the key's code if it isn't a "q" *)

	ELSE IF ((c <> ORD('q')) AND (c <> ORD ('Q'))) THEN
	    BEGIN
		gotoxyimmediate(1,14) ;
		WRITE ('The key you pressed is ') ;
		IF ((c >= 32) AND (c <= 127)) THEN
		    WRITE ('"', CHR(c),'", which') 
		ELSE
		    WRITE ('unprintable, but') ;
		WRITELN (' has a key code of ', c:0) ;
		WRITELN ;
	    END ;

    UNTIL ((c = ORD('q')) OR (c = ORD('Q'))) ;

	(* Confirm normal exit *)

    clrscr ;

    WRITELN ;
    WRITELN ('Done.') ;
    WRITELN ;

END.	(* mainline code *)
