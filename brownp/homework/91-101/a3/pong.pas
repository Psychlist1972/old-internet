
(* Program PONG.PAS   *)
(* ----------------   *)

(* Program purpose :	To use various graphics and screen management    *)
(*			utilities to create a game similiar but not	 *)
(*			identical to PONG.			         *)
 
(* Revision History   *)
(* ------------------ *)

(* 18-SEP-1991	    PMB	    Original Coding				 *)
(*                                                                       *)
(* ----------------------------------------------------------------------*)

(* THe following statement imports non standard Pascal statements for    *)
(* use with this program. UTILITIES and VT100 written by                 *)
(* Professor Jesse M. Heines ULowell 1991                                *)


[INHERIT ('group$disk:[compsci]utilities', (* Various procedure and functions *)
	  'group$disk:[compsci]vt100') ]   (* dealing with screen manipulation*)


PROGRAM pong (INPUT,OUTPUT) ;


CONST
    bottom_row  = 22 ;		(* The line just above the paddle *)
    top_line	= 4 ;		(* The "ceiling" for the ball     *)
    paddlepic	= '      ' ;	(* The actual paddle (reverse)    *)
    paddle_size = 6 ;		(* The size in CHARS of the paddl *)
    ballpic	= ' ' ;		(* The graphics CHAR for the ball *)

(* Mnemonics for Keypresses *)
(* to be put into a module  *)
(* at a later date          *)

    LEFT_ARROW	= 276 ;		(* These are mnemonics for the #  *)
    RIGHT_ARROW = 277 ;		(* returned by GetKBHit		  *)
    LOW_Q	= 113 ;	
    UP_Q	= 81 ;
    LOW_H	= 104 ;
    UP_H	= 72 ;
    LOW_P	= 112 ;
    UP_P	= 80 ;
    NO_INPUT	= 0 ;


TYPE
    ballrec = RECORD ;
	row	: INTEGER ;	(* The current row that the ball is in    *)
	column	: INTEGER ;	(* The current column that the ball is in *)
	direction : INTEGER ;	(* the direction that the ball is moving  *)
				(* in at the current time (see bouce_dir..*)
    END ; (* BallRec   *)


    paddlerec = RECORD ;
	column	: INTEGER ;	(* The current column of the LEFTMOST     *)
				(* character in the paddle                *)
    END ; (* PaddleRec *)


VAR
    paddle  : paddlerec ;	(* The record containing info on the pad. *)
    ball    : ballrec ;		(* The record containing info on the ball *)
    c	    : key_code ;	(* The value returned by GetKBHit         *)
    done    : BOOLEAN ;		(* decides whether to stop the game or not*)

    

(* This procedure handles the printing of the ball graphic to the screen *)

PROCEDURE draw_ball ;
BEGIN
    reverse(On) ;			(* Ball is a single reverse square *)
    gotoxy(ball.column,ball.row) ;
    WRITELN(ballpic) ;			(* ballpic is defined as a CONST   *)
    reverse(Off) ;			(* always return the screen attr.  *)
					(* back to normal in case of crash *)
END ;


(* This procedure handles the printing of the paddle graphic to the screen *)

PROCEDURE draw_paddle ;
BEGIN
    reverse(On) ;			    (* Paddle is a series of rev spcs *)
    gotoxy(paddle.column,bottom_row + 1) ;  (* Paddle is ONE above bottom row *)
    WRITELN(paddlepic) ;		    (* actually draw the paddle       *)
    reverse(Off) ;			    (* always return the screen attr. *)
					    (* back to norm in case of crash  *)
    cursorUp(1) ;			    (* dont let the screen scroll     *)
END ;


(* This procedut handles the removal of the paddle from its previous position *)
(* on the playing screen                                                      *)

PROCEDURE erase_old_paddle ;
BEGIN
    reverse(Off) ;			    (* Just in case it was left on  *)
    gotoxy(paddle.column,bottom_row + 1) ;  (* one above bottom line        *)
    WRITELN(paddlepic) ;		    (* assuming paddlepic is SPACES *)
    cursorUp(1) ;			    (* don't let the screen scroll  *)
END ;


(* This procedut handles the removal of the ball from its previous position *)
(* on the playing screen                                                    *)

PROCEDURE erase_old_ball ;
BEGIN
    attributesOff ;			(* just in case i forgot to at one pt *)
    gotoxy(ball.column,ball.row) ;	(* BALL is the record holding all info*)
    WRITELN(' ') ;			(* assuming ball is ONE CHAR wide     *)
    cursorUp(1) ;			(* dfont let screen scroll            *)
END ;


(* This procedure is called when a player presses the left arrow key *)

PROCEDURE move_paddle_left ;
BEGIN
    erase_old_paddle ;			    (* erase paddle while current pos*)
					    (* is still in memory            *)

    IF paddle.column - 3 > 2 THEN	    (* check to see if the paddle is *)
	paddle.column := paddle.column - 3  (* already all of the way left   *)
    ELSE
	beep ;    

    draw_paddle ;			    (* does actual drawing of paddle *)
    gotoxyimmediate(1,1) ;		    (* return cursor to null position*)

END ;	(* move paddle left  *)


(* This procedure is called when a player presses the right arrow key *)

PROCEDURE move_paddle_right ;

BEGIN
    erase_old_paddle ;			    (* erase paddle while current pos*)
					    (* is still in memory            *)

    IF ((paddle.column + 3) < (80 - paddle_size)) THEN	    
	paddle.column := paddle.column + 3  (* check to see if the paddle is *)
    ELSE				    (* already all of the way right  *)
	beep ;    
					        
    draw_paddle ;			    (* does actual drawing of paddle *)
    gotoxyimmediate(1,1) ;		    (* return cursor to null position*)

END ;	(* move paddle right  *)


(* ------------------------------------------------------------------------ *)
(* This function decides which of the compass directions that the ball will *)
(* bounce.  This is called if a collision is detected.                      *)
(*                                                                          *)
(*         8  1  2            This is the value of the numbers as seen on   *)
(*         7     3            a compass                                     *)
(*         6  5  4                                                          *)
(*                                                                          *)


FUNCTION ball_bounce_direction : INTEGER ;

VAR
    new_direction : INTEGER ; (* The BOUNCE BACK direction *)

BEGIN

	(* This is valid with the paddle and the ceiling only *)

    IF ((ball.row <= top_line) OR (ball.row >= bottom_row -1)) THEN
	BEGIN

	    CASE ball.direction OF
		1 : new_direction := 5 ;
		2 : new_direction := 4 ;
		3 : new_direction := 7 ;
		4 : new_direction := 2 ;
		5 : new_direction := 1 ;
		6 : new_direction := 8 ;
		7 : new_direction := 3 ;
		8 : new_direction := 6 ;

		OTHERWISE
		    BEGIN
			WRITELN('**** Bad Ball direction returned from BALL_BOUNCE_DIRECTION' ) ;
			WRITELN('**** ',ball.direction:0) ;
			attributesOff ;
			WRITELN('Bye Bye ') ;
			HALT ;	(* Oh well, how about a stack dump *)
		    END ; (* otherwise *)
	    END ; (* case *)
	END  (* IF...THEN  *)

    (* This is valid with the two side walls only *)

    ELSE
	BEGIN
	    CASE ball.direction OF
		1 : new_direction := 5 ;
		2 : new_direction := 8 ;
		3 : new_direction := 7 ;
		4 : new_direction := 6 ;
		5 : new_direction := 1 ;
		6 : new_direction := 4 ;
		7 : new_direction := 3 ;
		8 : new_direction := 2 ;

		OTHERWISE
		    BEGIN
			WRITELN('**** Bad Ball direction returned from BALL_BOUNCE_DIRECTION' ) ;
			WRITELN('**** ',ball.direction:0) ;
			attributesOff ;
			WRITELN('Bye Bye ') ;
			HALT ;	(* Oh well, how about a stack dump *)
		    END ; (* otherwise *)
	    END ;  (* case *)
	END ; (* IF...THEN...ELSE *)

    ball_bounce_direction := new_direction ;

END ;



(* This function decides whether the ball has passed by the paddle and out *)
(* of the gaming area or not                                               *)


FUNCTION ball_lost : BOOLEAN ;

VAR
    lost : BOOLEAN ;	(* has the ball passed by the paddle *)

BEGIN
    IF ball.row > bottom_row THEN
	lost := TRUE 
    ELSE
	lost := FALSE ;

    ball_lost := lost ;

END ;


(* ------------------------------------------------------------------------ *)
(* This function detects if the ball has hit an obsticle or the paddle or   *)
(* the outer 3 (bottom excluded) walls of the game area                     *)

FUNCTION collision_detected : BOOLEAN ;

VAR
    bang : BOOLEAN ;	(* collision detcted or not *)

BEGIN
    bang := FALSE ;		    
    
(* Note : I separated the bang := equations simply for clarity. *)
(* they could just as easily have been put into one equation    *)

	(* First boolean equation if for impact with the paddle *)

    bang := ((ball.row = bottom_row) AND 
	    ((ball.column >= paddle.column) AND 
	    (ball.column <= (paddle.column + paddle_size - 1)))) ;

	(* Second equation is for impact with the left wall     *)

    IF (NOT(bang)) THEN
	bang := (ball.column <= 3) ;

	(* Third equation is for impact with the right wall     *)

    IF (NOT(bang)) THEN
	bang := (ball.column >= 78) ;

	(* Fourth equation is for impact with the top wall      *)

    IF (NOT(bang)) THEN
	bang := (ball.row <= top_line) ;


	(**************************************************************)
	(* Soon to be implemented...collision equations for obstacles *)
	(**************************************************************)
    
    IF bang THEN    (* this is just for effects *)
	BEGIN
	    erase_old_ball ;	    (* this is what makes the screen *)	    
	    reversescreen(On) ;	    (* blink when a collision is     *)
	    draw_ball ; 	    (* detected                      *)
	    reversescreen(Off) ;
	END ;

    collision_detected := bang ;
END ;


(* ------------------------------------------------------------------------ *)
(* This procedure does the actual moving of the ball.  This task involves   *)
(* all of the following :                                                   *)
(*                          move ball in current direction                  *)
(*                          see if it collides with anything                *)
(*                            if so, get the bounce direction               *)
(*                          draw the ball in the new location               *)

PROCEDURE actually_move_ball ;
BEGIN

	    CASE ball.direction OF
		1 : (* UP *)
		    BEGIN
			ball.row := ball.row - 1 ;
		    END ;

		2 : (* NE *)
		    BEGIN
			ball.row := ball.row - 1 ;
			ball.column := ball.column + 1 ;
		    END ;

		3 : (* EA *)
		    BEGIN
			ball.column := ball.column + 1 ;
		    END ;

		4 : (* SE *)
		    BEGIN
			ball.column := ball.column + 1 ;
			ball.row := ball.row + 1 ;
		    END ;

		5 : (* SO *)
		    BEGIN
			ball.row := ball.row + 1 ;
		    END ;

		6 : (* SW *)
		    BEGIN
			ball.row := ball.row + 1 ;
			ball.column := ball.column - 1 ;
		    END ;

		7 : (* WE *)
		    BEGIN
			ball.column := ball.column - 1 ;
		    END ;

		8 : (* NW *)
		    BEGIN
			ball.column := ball.column - 1 ;
			ball.row := ball.row - 1 ;
		    END ;

		OTHERWISE
		    BEGIN
			attributesOff ;
			WRITELN('**** Bad ball direction in memory *****') ;
			WRITELN('--->',ball.direction:0) ;
			WRITELN('Bye Bye ') ;
			HALT ;
		    END ; (* Otherwise *)

	    END ; (* Case *)
END ;

PROCEDURE move_ball ;
BEGIN

    erase_old_ball ;

	(* figure out where the ball is, and where it is going *)

    IF (NOT(collision_detected)) THEN
	actually_move_ball 
    ELSE
	BEGIN
	    erase_old_ball ;
	    ball.direction := ball_bounce_direction ;	    
	    actually_move_ball ;
	END ;

    draw_ball ;
END ;


PROCEDURE do_help ;
BEGIN
    reverse(On) ;
    gotoxyimmediate(1,1) ;
    WRITELN('    <- Paddle Left | Paddle Right -> | Q to Quit | P to Pause | H for help     ') ;
    reverse(Off) ;
END ;



(* This procedure simply draws a box around the playing field.  As you can *)
(* see, any statement which I call more than once, or has the potential to *)
(* have more complexity added, I put in a procedure.                       *)

PROCEDURE draw_walls ;
BEGIN
    box(2, top_line - 1, 79, bottom_row + 2 ) ;
END ;


(* This procedure simply waits for the suer to press a key, and therefore *)
(* forces the program to pause in midstream.                              *)

PROCEDURE do_pause ;

VAR
    end_pause : key_code ;	(* used by get1char *)

BEGIN
    gotoxyimmediate(33,2) ;	(* move cursor to position of text line  *)
    WRITELN('P  a  u  s  e  d') ;
    end_pause := get1char('') ;	(* forces the terminal to wait for input *)    
    gotoxyimmediate(1,2) ;	(* just in case the box messes up        *)
    draw_walls ;		(* redraw the walls ane erase the text   *)
END ;


(* This procedure returns the screen to its normal state, prints an end-of *)
(* game message, and gives credit to the designer                          *)

PROCEDURE end_game ;
BEGIN
    cursor(On) ;
    reversescreen(Off) ;
    attributesoff ;
    clrscr ;
    WRITELN ;
    WRITELN ;
    WRITELN ;
    WRITELN('Goodbye...') ;
    WRITELN ;
    WRITE('  This game brought to you by ') ; 

    bold(On) ;
    WRITELN('The Psychlist.') ;
    bold(Off) ;

    WRITELN('  Look for other my other games : Nemesis , Time Riffte , Breakout') ;
    WRITELN ;
    WRITELN ;
END ;


(* This procedure sets up all of the variables and records used by PONG *)

PROCEDURE initialize_all ;
VAR
    random_number : REAL ;   (* A random number used to find the ball's *) 
			     (* direction and starting position         *)
    random_direction : INTEGER ;    (* random starting direction for    *)
				    (* the ball                         *)
    
BEGIN

    random_number := rnd ;   (* initialize the variable with a random number *)

    CASE (TRUNC(random_number * 100)) OF
	0..50	: random_direction := 6 ; (* south west *)
	51..100	: random_direction := 4 ; (* south east *)
    END ; (* Case *)

    cursor(Off) ;

    WITH ball DO
	BEGIN
	    row		:= top_line + 1 ;	
	    column	:= 40 ;		     (* change this to random later *)
	    direction	:= random_direction ;
	END ;

    WITH paddle DO
	BEGIN
	    column := ball.column ; (* This is for fairness just in case   *)
				    (* The ball were to start on the other *)
				    (* side of the screen from the paddle  *)
	END ;

    done := FALSE ;

END ;


(* This procedure simply calls several other procedures that are required *)
(* to get the game underway.  They are lumped into here just for clarity  *)

PROCEDURE start_game ; 
BEGIN
    initialize_all ;	    (* set all x and y pos.  init all variables  *)
    clrscr ;		    (* clear the screen (inherited from UTIL.    *)
    WRITELN ;		    (* dump the buffer				 *)
    draw_paddle ;	    (* draw the playing paddle at start position *)
    draw_walls ;	    (* draw a box around the playing field       *)
    do_help ;		    (* display the help bar at the top of screen *)
    gotoxyimmediate(1,1) ;  (* put the curso at the top of the screen    *)
END ;



BEGIN	(* Mainline Code *)

    start_game ;		    (* Set up variables, screen etc *)

    WHILE ((NOT(done)) and (NOT(ball_lost))) DO
	BEGIN
	    move_ball ;		    (* let the game make the first move *)
	    c := getkbhit ;	    (* get a keypress from user *)

	    CASE c OF
		LEFT_ARROW  : move_paddle_left ;
		RIGHT_ARROW : move_paddle_right ;
		LOW_Q, UP_Q : done := TRUE ;  (* player wants to quit game    *)
		LOW_H, UP_H : do_help ;	      (* redisplay help bar if erased *)
		LOW_P, UP_P : do_pause ;      (* pause the entire game        *)
		
		NO_INPUT : ;		      (* put in CASE statement to     *)
					      (* avoid beeping every second   *)

		OTHERWISE beep ;	      (* bad input alarm              *)

	    END ;(* case     *)

	END ; (* while...do  *)

    end_game ;  (* bye bye ! *)

END.	(* Mainline Code *)

