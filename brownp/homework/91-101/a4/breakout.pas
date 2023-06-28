
(* Program BREAKOUT.PAS   *)
(* --------------------   *)

(* Program purpose :	To use various graphics and screen management    *)
(*			utilities to create a game similiar but not	 *)
(*			identical to PONG.			         *)
 
(* Revision History       *)
(* ---------------------- *)

(* 18-SEP-1991	    PMB	    Original Coding				 *)
(* 23-SEP-1991	    PMB	    Addition of DEMO option and routine          *)
(* 24-SEP-1991	    PMB	    Addition of Obstacles, officially making     *)
(*			    this version BREAKOUT and not PONG		 *)
(*                                                                       *)
(* ----------------------------------------------------------------------*)

(* The following statement imports non standard Pascal statements for    *)
(* use with this program. UTILITIES and VT100 written by                 *)
(* Professor Jesse M. Heines ULowell 1991                                *)


[INHERIT ('brk_module',
	  'group$disk:[compsci]utilities',
	  'group$disk:[compsci]vt100') ]


PROGRAM breakout (INPUT,OUTPUT) ;


CONST
    bottom_row  = 22 ;		(* The line just above the paddle *)
    top_line	= 4 ;		(* The "ceiling" for the ball     *)
    paddlepic	= '      ' ;	(* The actual paddle (reverse)    *)
    paddle_size = 6 ;		(* The size in CHARS of the paddl *)
    ballpic	= ' ' ;		(* The graphics CHAR for the ball *)
    obstaclepic = '-' ;		(* The character for the obstacles*)



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
	catches : INTEGER ;	(* Number of times ball bounced off paddle*)
	score	: INTEGER ;	(* score achieved by hitting obstacles    *)

    END ; (* PaddleRec *)

    mob_obsticlerec = RECORD 
	size	  : INTEGER ;	(* The size in characters       *)
	direction : INTEGER ;	(* Left (7) or right (3)        *)
	row	  : INTEGER ;	(* The row it is moving in      *)
	column	  : INTEGER ;	(* column to begin drawing in   *)
	in_play	  : BOOLEAN ;	(* Whether or not to display it *) 

    END ; (* mob_obsticlerec *)

VAR
    paddle  : paddlerec ;	(* The record containing info on the pad. *)
    ball    : ballrec ;		(* The record containing info on the ball *)
    mobile_obsticle :
	      mob_obsticlerec ;	(* The moving obsticle on teh screen      *)
    c	    : key_code ;	(* The value returned by GetKBHit         *)
    done    : BOOLEAN ;		(* decides whether to stop the game or not*)
    obstacle: ARRAY[8..71,6..10] OF BOOLEAN ;
				(* on/off switches for obstacles	  *)


(* This procedure handles the printing of the ball graphic to the screen *)

PROCEDURE draw_ball
	    (ball : ballrec) ;	(* The record holding info on the ball *)
BEGIN
    reverse(On) ;
    gotoxy(ball.column,ball.row) ;
    WRITELN(ballpic) ;
    reverse(Off) ;
END ;


(* This procedure handles the printing of the paddle graphic to the screen *)

PROCEDURE draw_paddle 
	    (paddle : paddlerec) ; (* The record holding info on the paddle *)
BEGIN
    reverse(On) ;
    gotoxy(paddle.column,bottom_row + 1) ;
    WRITELN(paddlepic) ;
    reverse(Off) ;
    cursorUp(1) ;
END ;

PROCEDURE initialize_obstacles ;
VAR
    xloc : INTEGER ;	(* The x location of a single obstacle block *)
    yloc : INTEGER ;	(* The y location of a single obstacle block *)

BEGIN
    xloc := 1 ;		(* initialize the two variables *)
    yloc := 1 ;

    FOR xloc := 8 TO 71 DO	    (* columns *)
	FOR yloc := 6 TO 10 DO	    (* rows    *)
	    obstacle[xloc,yloc] := TRUE ;
END ;


(* This procedure creates a "wall" of obstacles to bounce the ball off of *)

PROCEDURE draw_obstacles ;

VAR
    xloc : INTEGER ;	(* The x location of a single obstacle block *)
    yloc : INTEGER ;	(* The y location of a single obstacle block *)

BEGIN
    xloc := 1 ;		(* initialize the two variables *)
    yloc := 1 ;

    FOR xloc := 8 TO 71 DO	    (* columns *)
	FOR yloc := 6 TO 10 DO	    (* rows    *)
	    BEGIN
		IF obstacle[xloc,yloc] THEN
		    gotoxy(xloc,yloc) ;
		    reverse(On) ;
		    WRITELN(obstaclepic) ;
		    reverse(Off) ;
	    END ;    

    gotoxyimmediate(1,1) ;

END ;



PROCEDURE erase_old_mobile_obsticle
	    ( mobile_obsticle : mob_obsticlerec ) ;
BEGIN
    gotoxy(mobile_obsticle.column, mobile_obsticle.row) ;
    reverse(Off) ;
    WRITELN(' ':mobile_obsticle.size) ;
END ;


PROCEDURE draw_mobile_obsticle 
	    ( mobile_obsticle : mob_obsticlerec ) ;

BEGIN
    gotoxy(mobile_obsticle.column, mobile_obsticle.row) ;
    reverse(On) ;
    bold(on) ;
    WRITELN(' ':mobile_obsticle.size) ;
    reverse(Off) ;
    bold(off) ;
END ;


PROCEDURE move_obsticle_left 
	    ( VAR mobile_obsticle : mob_obsticlerec ) ;
BEGIN

    erase_old_mobile_obsticle(mobile_obsticle) ;

    WITH mobile_obsticle DO
	BEGIN
	    column := column - 4 ;
	    IF column <= 3 THEN
		BEGIN
		    column := 4 ;
		    direction := 3 ; (* right *)
		END ;
	END ;   

    draw_mobile_obsticle (mobile_obsticle) ;

END ;


PROCEDURE move_obsticle_right 
	    ( VAR mobile_obsticle : mob_obsticlerec ) ;
BEGIN

    erase_old_mobile_obsticle (mobile_obsticle) ;

    WITH mobile_obsticle DO
	BEGIN
	    column := column + 4 ;
	    IF column >= (77 - size) THEN
		BEGIN
		    column := (79 - size ) ;
		    direction := 7 ; (* left *)
		END ;
	END ;   

    draw_mobile_obsticle (mobile_obsticle) ;

END ;


PROCEDURE control_mobile_obsticle 
		(VAR mobile_obsticle : mob_obsticlerec) ;
BEGIN
    IF (mobile_obsticle.in_play) THEN

	CASE mobile_obsticle.direction OF
	    7 : (* Left  *)
		move_obsticle_left (mobile_obsticle) ;

	    3 : (* Right *)
		move_obsticle_right (mobile_obsticle) ;

	END ; (* CASE *)

END ;


(* This procedut handles the removal of the paddle from its previous position *)
(* on the playing screen                                                      *)

PROCEDURE erase_old_paddle 
		(paddle : paddlerec) ;
BEGIN
    reverse(Off) ;
    gotoxy(paddle.column,bottom_row + 1) ;
    WRITELN(paddlepic) ;
    cursorUp(1) ;
END ;


(* This procedut handles the removal of the ball from its previous position *)
(* on the playing screen                                                    *)

PROCEDURE erase_old_ball 
		(ball : ballrec) ;
BEGIN
    attributesOff ;
    gotoxy(ball.column,ball.row) ;
    WRITELN(' ') ;
    cursorUp(1) ;
END ;


(* This procedure is called when a player presses the left arrow key *)

PROCEDURE move_paddle_left 
		(VAR paddle : paddlerec) ;
BEGIN
    erase_old_paddle (paddle) ;

    IF paddle.column - 3 > 2 THEN	    (* check to see if the paddle is *)
	paddle.column := paddle.column - 3  (* already all of the way left   *)
    ELSE
	beep ;    

    draw_paddle (paddle) ;
    gotoxy(1,1) ;

END ;	(* move paddle left  *)


(* This procedure is called when a player presses the right arrow key *)

PROCEDURE move_paddle_right 
		(VAR paddle : paddlerec) ;
BEGIN
    erase_old_paddle (paddle) ;

    IF ((paddle.column + 2) < (80 - paddle_size)) THEN	    
	paddle.column := paddle.column + 3  (* check to see if the paddle is *)
    ELSE				    (* already all of the way right  *)
	BEGIN
	    beep ;
	    paddle.column := (78 - paddle_size) ;
	END ;    
					        
    draw_paddle (paddle) ;

    gotoxy(1,1) ;

END ;	(* move paddle right  *)


(* ------------------------------------------------------------------------ *)
(* This function decides which of the compass directions that the ball will *)
(* bounce.  This is called if a collision is detected.                      *)
(*                                                                          *)
(*         8  1  2            This is the value of the numbers as seen on   *)
(*         7     3            a compass                                     *)
(*         6  5  4                                                          *)
(*                                                                          *)


FUNCTION ball_bounce_direction 
		(mobile_obsticle : mob_obsticlerec ;
			    ball : ballrec)	      : INTEGER ;

VAR
    new_direction : INTEGER ; (* The BOUNCE BACK direction *)

BEGIN

	(* This is valid with the paddle, the ceiling, mobile obsticle *)

    IF ((((ball.row <= top_line) OR (ball.row >= bottom_row -1)) AND 
	( ball.column < 78) AND (ball.column > 2)) OR (
	( ball.column >= mobile_obsticle.column ) AND 
	( ball.column <= mobile_obsticle.column + mobile_obsticle.size) AND 
	( ball.row = mobile_obsticle.row))) 
    THEN
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


FUNCTION ball_lost
		(ball : ballrec) : BOOLEAN ;

BEGIN
    ball_lost := (ball.row > bottom_row) ; 
END ;



PROCEDURE show_score 
		(paddle : paddlerec) ;
BEGIN
    gotoxy(64,1) ;
    reverse(on) ;
    WRITELN('Catches : ',paddle.catches:6) ;
    reverse(off) ;

    gotoxy(64,2) ;
    reverse(on) ;
    WRITELN('Points  : ',paddle.score:6) ;
    reverse(off) ;
END ;


(* ------------------------------------------------------------------------ *)
(* This function detects if the ball has hit an obsticle or the paddle or   *)
(* the outer 3 (bottom excluded) walls of the game area                     *)

FUNCTION collision_detected
		(paddle		 : paddlerec ;
		 ball		 : ballrec ;
		 mobile_obsticle : mob_obsticlerec) : BOOLEAN ;

VAR
    bang : BOOLEAN ;	(* collision detcted or not *)

BEGIN
    bang := FALSE ;	(* Initialize BANG *)
    
(* Note : I separated the bang := equations simply for clarity. *)
(* they could just as easily have been put into one equation    *)

	(* First boolean equation is for impact with the paddle *)
    bang := ((ball.row = bottom_row) AND 
	    ((ball.column >= paddle.column) AND 
	    (ball.column <= (paddle.column + paddle_size - 1)))) ;

	(* This updates the score if you indeed catch the ball *)
    IF bang THEN
	BEGIN
	    paddle.catches := paddle.catches + 1 ;
	    show_score (paddle) ;
	END ;


    (*********************************************************************)
    (* I should do a check for the four corners of the screen first      *)
    (*********************************************************************)



	(* Second equation is for impact with the left wall     *)
    IF (NOT(bang)) THEN
	bang := (ball.column <= 3) ;

	(* Third equation is for impact with the right wall     *)
    IF (NOT(bang)) THEN
	bang := (ball.column >= 78) ;

	(* Fourth equation is for impact with the top wall      *)
    IF (NOT(bang)) THEN
	bang := (ball.row <= top_line ) ;

	(**************************************************************)
	(* Soon to be implemented...collision equations for obstacles *)
	(**************************************************************)
    
	(* This one is for impact with the mobile obsticle *)
    IF ((NOT(bang)) AND (mobile_obsticle.in_play)) THEN
	bang := (((ball.row = mobile_obsticle.row - 1) OR
		  (ball.row = mobile_obsticle.row + 1) OR
		  (ball.row = mobile_obsticle.row   )) AND 
	        (((ball.column >= mobile_obsticle.column - 1) AND 
	          (ball.column <= (mobile_obsticle.column + 
		    mobile_obsticle.size + 1))))) ;

    IF bang THEN    (* this is just for effects *)
	BEGIN
	    erase_old_ball (ball) ;	    
	    reversescreen(On) ;
	    draw_ball (ball) ; 	    
	    reversescreen(Off) ;
	END ;

    collision_detected := bang ;

END ;


(* ------------------------------------------------------------------------ *)
(* These procedures do the actual moving of the ball.  This task involves   *)
(* all of the following :                                                   *)
(*                          move ball in current direction                  *)
(*                          see if it collides with anything                *)
(*                            if so, get the bounce direction               *)
(*                          draw the ball in the new location               *)

PROCEDURE actually_move_ball
		(VAR ball : ballrec) ;
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


(* see documentation above *)

PROCEDURE move_ball 
	    (VAR ball : ballrec);
BEGIN

    erase_old_ball (ball) ;

	(* figure out where the ball is, and where it is going *)

    IF (NOT(collision_detected (paddle,ball,mobile_obsticle) )) THEN
	actually_move_ball (ball) 
    ELSE
	BEGIN
	    erase_old_ball (ball) ;
	    ball.direction := ball_bounce_direction (mobile_obsticle,ball) ;
	    actually_move_ball (ball) ;
	END ;

    draw_ball (ball) ;

END ;



PROCEDURE draw_walls ;
BEGIN
    box(2, top_line - 1, 79, bottom_row + 2 ) ;
END ;


PROCEDURE do_help ;
BEGIN
    reverse(On) ;
    gotoxy(1,1) ;
    bold(on) ;
    WRITE(' <- Left | (Q)uit | (P)ause | (H)elp | (D)emo | Right -> ') ; 
    bold(off) ;

    reverse(on) ;
    WRITELN('                      ') ;
    reverse(Off) ;

    reverse(on) ;
    gotoxy(1,2) ;
    WRITELN(' Written By   Peter M Brown - The Psychlist  Ulowell 1991                      ') ;
    reverse(Off) ;
    
END ;


PROCEDURE do_pause ;
VAR
    end_pause : key_code ;	(* used by get1char *)

BEGIN
    gotoxyimmediate(33,2) ;
    WRITELN('P  a  u  s  e  d') ;
    end_pause := get1char('') ;	(* forces the terminal to wait for input *)    
    gotoxyimmediate(1,2) ;
    draw_walls ;
END ;


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

    WRITELN('  Look for other my other games : Nemesis, Pong, and Time Riffte') ;
    WRITELN ;
    WRITELN ;
END ;


(* This is a little 4:30 in the morning brainstorm of mine.  This procedure *)
(* plays the game.  No user input, and it will never lose.  It will is      *)
(* quite quick at it as well, no 1 second wait from GETKBHIT.               *)

(* THis is quite useful for testing, and I have notices several ANNOYING bugs *)
(* that are giving me a hard time.  See notes                               *)

(* This procedure shows the use of putting all things, no matter how small  *)
(* into procedures.  Without procedures, I wopuld have to copy the mainline *)
(* into here and remove the GETKBHIT.  Have fun.                            *)


PROCEDURE demo_game
	    (maximum_moves : INTEGER ) ; (* Number of moves before game ends *)

VAR
    counter : INTEGER ; (* Counter to keep track of how many moves have *)
			(* been made.  Used to stop game.               *)

BEGIN
    counter := 0 ;
    maximum_moves := maximum_moves + 1 ;

    WHILE ((NOT(done)) AND (NOT(ball_lost(ball))) 
	    AND (counter <maximum_moves)) DO

	BEGIN
	    counter := counter + 1 ;
	    move_ball (ball) ;
	    control_mobile_obsticle (mobile_obsticle) ;
	    erase_old_paddle (paddle) ;

	    CASE ball.column OF
		1..6   : paddle.column := 4 ;
		7..71  : paddle.column := ball.column - 3 ;
		72..80 : paddle.column := ( 77 - paddle_size ) ;
	    END ; (* CASE *)

	    draw_paddle (paddle) ;

	END ;

    done := TRUE ;

END ;



PROCEDURE initialize_all ;
VAR
    random_number : REAL ;	    (* A random number used to find the ball's*)
				    (* direction and starting position        *)
    random_direction : INTEGER ;    (* random starting direction for the ball *)
    random_column    : INTEGER ;    (* Rabdom startinf position for the ball  *)
    
BEGIN

    initialize_obstacles ;

    random_number := rnd ;   (* initialize the variable with a random number *)

    CASE (TRUNC(random_number * 100)) OF
	0..50	: random_direction := 6 ; (* south west *)
	51..100	: random_direction := 4 ; (* south east *)
    END ; (* Case *)

    random_number := rnd ;  (* re-initialize the number for use with COLUMN *)

    CASE (TRUNC(random_number * 100)) OF
	0..10   : random_column := 10 ;
	11..69  : random_column := (TRUNC(random_number * 100)) ;
	70..80  : random_column := 70 ;
	81..100 : random_column := (TRUNC(random_number * 50)) ;
    END ; (* case *)

    cursor(Off) ;

    WITH ball DO
	BEGIN
	    row		:= top_line + 7 ;	
	    column	:= random_column ;
	    direction	:= random_direction ;
	END ;

    WITH paddle DO
	BEGIN
	    column := ball.column ; (* This is for fairness just in case   *)
				    (* The ball were to start on the other *)
				    (* side of the screen from the paddle  *)

	    catches := 0 ;	    (* no catches as of yet                *)
	    score   := 0 ;	    (* no score as of yet                  *)
	END ;

    WITH mobile_obsticle DO
	BEGIN
	    size	:= 6 ;
	    direction	:= 3 ;
	    row		:= 16 ;
	    column	:= 30 ;
	    in_play	:= TRUE ;   (* Change this afterwards *)  
	END ;

    done := FALSE ;

END ;


PROCEDURE start_game ; 
BEGIN
    initialize_all ;	    (* set all x and y pos.  init all variables  *)
    clrscr ;		    (* clear the screen (inherited from UTIL.    *)
    WRITELN ;		    (* dump the buffer				 *)
    draw_paddle (paddle) ;  (* draw the playing paddle at start position *)
    draw_walls ;	    (* draw a box around the playing field       *)
    draw_obstacles ;	    (* horizontal obstacles which are worth pts  *)
    do_help ;		    (* display the help bar at the top of screen *)
    show_score (paddle) ;   (* Display the score at top right of screen  *)
    home ;		    (* put the curso at the top of the screen    *)
END ;



PROCEDURE show_help_screen ;
BEGIN
    clrscr ;
    bold(on) ;
    WRITELN(' The following is a description of the different keys and their ') ;
    WRITELN(' functions in "BREAKOUT!".') ;
    bold(off) ;
    WRITELN ;
    WRITELN('     <-  (left arrow)   -  Move the paddle left 3 spaces.') ;
    WRITELN('     ->  (right arrow)  -  Move the paddle right 3 spaces.') ;
    WRITELN('     D   (letter d)     -  Run the demonstration game.') ;
    WRITELN('     P   (letter p)     -  Pause the game (hit any key to resume.') ;
    WRITELN('     H   (letter h)     -  Show the help bar at top of screen.') ;
    WRITELN('     Q   (letter q)     -  Quit the game. ') ;
    WRITELN ;
    bold(on) ;
    WRITELN(' The object of the game is to use the ball to remove all of the ') ;
    WRITELN(' highlighted blocks on the screen, while avoiding moving obstacles') ;
    WRITELN(' and without letting the ball fall to the very bottom.') ;
    WRITELN ;
    WRITELN ;
    WRITELN('Breakout for VAX/VMS by The Psychlist - Peter M Brown - ULowell 1991') ;
    bold(off) ;
    WRITELN ;
    WRITELN ;
    
    reverse(on) ;
    c := get1char('Press any key when you are ready.') ;
    attributesOff ;

END ;


PROCEDURE neato_keen_intro_screen ;
BEGIN
    demo_game(50) ;	    (* short 50 move demonstration game *)

    gotoxy(30,16) ;
    bold(on) ;
    WRITELN   (' B r e a k o u t ! ') ;
    bold(off) ;

    gotoxy(27,17) ;  
    WRITELN(' Press any key to begin ') ;

    c:= getch ;
    show_help_screen ;
    start_game ;    
END ;


BEGIN	(* Mainline Code *)

    start_game ;    

    neato_keen_intro_screen ;

    WHILE ((NOT(done)) and (NOT(ball_lost (ball) ))) DO
	BEGIN

	    move_ball (ball) ;

	    control_mobile_obsticle (mobile_obsticle) ;

	    c := getkbhit ;	    (* get a keypress from user *)

	    CASE c OF
		LEFT_ARROW  : move_paddle_left (paddle) ;
		RIGHT_ARROW : move_paddle_right (paddle) ;
		LOW_Q, UP_Q : done := TRUE ;  (* player wants to quit game    *)
		LOW_H, UP_H : do_help ;	      (* redisplay help bar if erased *)
		LOW_P, UP_P : do_pause ;      (* pause the entire game        *)
		
		LOW_D, UP_D : demo_game(500) ;(* game plays a 500 move demo   *)

		511	    : demo_game(maxint - 2) ; (* for me ONLY *)

		NO_INPUT : ;		      (* put in CASE statement to     *)
					      (* avoid beeping every second   *)

		OTHERWISE beep ;	      (* bad input alarm              *)

	    END ;(* case     *)
	
	END ; (* while...do  *)

    end_game ;  (* bye bye ! *)

END.	(* Mainline Code *)
