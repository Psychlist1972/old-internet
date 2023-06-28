(* Assignment Number 6 *)
(* SHIFTER.PAS         *)

(* Purpose :           *)
(* ------------------- *)
(* To use arrays to do the following :  Do bitwise shifting on a binary  *)
(* number, and to control a menu                                         *)


(* Revision History :  *)
(* ------------------- *)
(* 10-OCT-1991	    PMB		Original Coding.                         *)
(* 15-OCT-1991      PMB		Addition of OPTIONS, and various pop-ups *)
(*				to make SHIFTER more user-friendly       *)

(* Credit where credit is due *)
(* -------------------------- *)
(* Original SHIFTER code written by Peter M Brown UMass - Lowell, 1991   *)
(* VT100, UTILITIES and CONVERT written by Jesse M Heines UMass - Lowell *)
(* PAS_UTILS by Peter M Brown UMass - Lowell                             *)



[INHERIT('comp$dir:utilities',      (* logical names defined by my login.com *)
	 'comp$dir:vt100',
	 'mod$dir:pas_utils',
	 'comp$dir:convert') ]



PROGRAM shifter (INPUT,OUTPUT) ;



CONST
    most_bits	= 16 ;	    (* number of bits in our register *)
    number_elements = 6 ;   (* number of elements in the menu *)



TYPE
    sixteen_bits	= ARRAY[0..most_bits-1] OF BOOLEAN ;

    menu_record = RECORD
	option_string	: ARRAY[0..number_elements-1] OF string ;
	top_row		: INTEGER ;		    (* the top x and y coords *)
	top_column	: INTEGER ;		    (* of the entire menu     *)
	current_menu	: INTEGER ;		    (* the current option     *)
    END ; { menu record }


    option_record = RECORD
	wrap	: BOOLEAN ;		   (* Bitwise wraparound togle switch *)
	revs	: BOOLEAN ;		   (* screen mode toggle switch       *)
    END ; { option record }




VAR
    register	: sixteen_bits ;	(* The array holding the wanzanzeroes *)
    menu	: menu_record ;		(* the menu of options                *)
    c		: key_code ;		(* used by getch                      *)
    quit	: BOOLEAN := FALSE ;	(* flag for ending this session       *)
    options	: option_record ;	(* record of custom options           *)




(* The following Procedures all deal with the SHIFTING aspect of *)
(* this program                                                  *)


PROCEDURE update_screen(
	    register :  sixteen_bits ) ;

VAR
    k	 : INTEGER ;		 (* local loop index variable           *)
    bits : VARYING[16] OF CHAR ; (* the 16 registers in a string format *)
    decimal_value : INTEGER ;	 (* the 16 bits in a decimal format     *)

BEGIN	(* update_screen *) 

    bits := '' ;		    (* initialize *)
    decimal_value := 0 ;

	(* display the bit pattern on the screen *)

    FOR k := 0 TO 15 DO
	IF register[k] THEN
	    BEGIN
		bits := bits + '1' ;	
		writeat(32+k,10,'1',FALSE) ;
	    END
	ELSE
	    BEGIN
		bits := bits + '0' ; 
		writeat(32+k,10,'0',FALSE) ;
	    END ;

	(* convert the bit-pattern to a decimal and display teh result *)

    bindec(bits, decimal_value) ;
    writeat(30,12,'Decimal Value ' + (itoa(decimal_value)) + '    ',FALSE) ;

	(* show the status of OPTIONS.WRAP ( the wrap toggle switch ) *)

    IF options.wrap THEN 
	writeat(30,11,'Wraparound is enabled. ') 
    ELSE
	writeat(30,11,'Wraparound is disabled.') ;


END ;	(* update_screen *)


(* This is a screen refresh used at the beginning and after any pop-up   *)
(* windows have currupted the screen.  REFRSH is a BOOLEAN which toggles *)
(* the "drop_string" effect on and off                                   *)

PROCEDURE set_up_screen(
	    menu   : menu_record ;
	    refrsh : BOOLEAN := FALSE) ;  (* use effects or straight writelns *)

VAR
    k : INTEGER ;	    (* local loop index variable *)

BEGIN	(* set_up_screen *)
    clrscr ;

	(* reverse the screen if that option has been chosen *)

    reversescreen(options.revs) ; 

    IF refrsh THEN
	BEGIN
	    writeat(22,7,'                                    ',TRUE) ;
	    writeat(22,6,'          By The Psychlist          ',TRUE) ;
	    writeat(22,5,'  Bitwise shifting with Wraparound  ',TRUE) ;
	    writeat(22,4,'                                    ',TRUE) ;
	END
    ELSE      
	BEGIN
	    drop_string(22,7,'                                    ',TRUE) ;
	    drop_string(22,6,'          By The Psychlist          ',TRUE) ;
	    drop_string(22,5,'  Bitwise shifting with Wraparound  ',TRUE) ;
	    drop_string(22,4,'                                    ',TRUE) ;
	END ;

    box (20,3,59,20) ;
    box (19,2,60,21) ;    

	(* show the 16 bit register, its decimal value and the status of wrap *)

    update_screen(register) ;

	(* display the menu options *)

    WITH menu DO
	FOR k := 0 TO (number_elements - 1) DO
	    IF (k = current_menu) THEN
		writeat(top_column,(top_row + k), option_string[k],TRUE) 
	    ELSE
		writeat(top_column,(top_row + k), option_string[k],FALSE) ;

END ;	(* set_up_screen *)


(* shift the bit pattern to the left with wraparound if specified *)

PROCEDURE shift_left (
	VAR register :  sixteen_bits ) ;

VAR
    tmp : BOOLEAN ;	    (* for wraparound effect     *)
    k	: INTEGER ;	    (* local loop index variable *)

BEGIN	(* shift_left *)
    
    k := 0 ;

    tmp := register[0] ;
    
    FOR k := 0 TO 14 DO
	register[k] := register [k+1] ;

    IF options.wrap THEN
	register[15] := tmp 		(* wraparound *)
    ELSE 
	register[15] := FALSE ;

    update_screen(register) ;

END ;	(* shift_left *)


(* shift the bit pattern to the right with wraparound if specified *)

PROCEDURE shift_right (
	VAR register :  sixteen_bits ) ;

VAR
    tmp : BOOLEAN ;	    (* for wraparound effect     *)
    k	: INTEGER ;	    (* local loop index variable *)

BEGIN	(* shift_right *)
    
    k := 0 ;

    tmp := register[15] ;
    
    FOR k := 15 DOWNTO 1 DO
	register[k] := register [k-1] ;

    IF options.wrap THEN
	register[0] := tmp 		(* wraparound *)
    ELSE 
	register[0] := FALSE ;

    update_screen(register) ;

END ;	(* shift_right *)
 

(* develop a random bit pattern *)

PROCEDURE get_rnd_bits(
	VAR register : sixteen_bits) ;

VAR
    k : INTEGER	;	    (* local loop index variable *)

BEGIN

	(* 50/50 chance that the bit will be ON *)

    FOR k := 0 TO 15 DO
	register[k] := ((rnd*100)>50) ;
END ;


(* Enter your own bit pattern instead of using a random one *)

PROCEDURE enter_bit_pattern(
	VAR register : sixteen_bits ) ;

VAR
    k : INTEGER	;	    (* local loop index variable *)
    bit_string : string ;   (* 16 bit register entered by the user *)

    
    (* Displays message if the user enters something other than a 1 or 0 *)
    
    PROCEDURE display_help_box ;    (* procedure local to this block *)

    BEGIN
	bold(ON) ;
	box(19,6,49,13) ;
	bold(OFF) ;

	writeat(32,6,'Help',FALSE) ;

	writeat(20,7, '                             ',TRUE) ;
	writeat(20,8, '  Note: A bit is defined as  ',TRUE) ;
	writeat(20,9, '  being ON (1) or OFF (0).   ',TRUE) ;
	writeat(20,10,'  Please enter only 1s and   ',TRUE) ;
	writeat(20,11,'  0s at the prompt.          ',TRUE) ;
	writeat(20,12,'                             ',TRUE) ;
    END ;

BEGIN

	bold(ON) ;
	box(22,15,61,22) ;
	bold(OFF) ;

	writeat(23,16,'                                     ',TRUE) ;
	writeat(23,17,'  Enter your own bit pattern.  You   ',TRUE) ;
	writeat(23,18,'  have 16 registers (slots) to work  ',TRUE) ;
	writeat(23,19,'  with.  Do not hit return at the    ',TRUE) ;
	writeat(23,20,'  end of the line.                   ',TRUE) ;
	writeat(23,21,'                                      ',TRUE) ;
	writeat(30,21,'>                  ',FALSE) ; 

	    (* get the bit pattern from teh user, character by character *)

	bit_string := '' ;

	    (* show the "pseudo-cursor" *)

	writeat(32,21,'_',FALSE) ;

	    (* have the user enter 16 bits *)

	FOR k := 1 TO 16 DO
	    BEGIN
		REPEAT
		    c := getch ;

		    IF (NOT (c IN [K_0, K_1])) THEN
			BEGIN
			    beep ;
			    display_help_box ;
			END ; 

		UNTIL (c IN [K_0, K_1]) ;

		    (* concat the bit string *)

		bit_string    := bit_string + CHR(c) ;

		    (* display the "pseudo-cursor" *)

		IF k < 16 THEN
		    writeat(32,21,bit_string + '_',FALSE) 
		ELSE
		    writeat(32,21,bit_string,FALSE) ;

		register[k-1] := (bit_string[k] = '1') ;

	    END ;

END ;


(* Set up options to customize the program to your own tastes *)

PROCEDURE set_up_options(
	VAR options : option_record) ;

VAR
    key : key_code ;	    (* used by getch *)
BEGIN

    bold(ON) ;
    box(18,13,62,21) ;
    bold(OFF) ;

    writeat(19,14,'                                           ',TRUE) ;
    writeat(19,15,'  W - Toggle Wraparound                    ',TRUE) ;
    writeat(19,16,'  S - Toggle Screen Mode (reverse/normal)  ',TRUE) ;
    writeat(19,17,'  N - New Random Bit Pattern               ',TRUE) ;
    writeat(19,18,'  E - Enter your own bit pattern           ',TRUE) ;
    writeat(19,19,'                                           ',TRUE) ;
    writeat(19,20,'  [W,w,S,s,N,n,E,e] >                      ',TRUE) ;

    
    REPEAT
	
	key := getch ;
	
	CASE key OF
	    K_UP_W,K_LOW_W : options.wrap := (NOT(options.wrap)) ;
	    K_UP_S,K_LOW_S : options.revs := (NOT(options.revs)) ;
	    K_UP_N,K_LOW_N : get_rnd_bits(register) ;
	    K_UP_E,K_LOW_E : enter_bit_pattern(register) ;

	    OTHERWISE
		beep ;

	END ; { case }
	
    UNTIL ( key IN [ K_LOW_W, K_UP_W, K_LOW_S, K_UP_S, K_LOW_N, K_UP_N,
		   K_LOW_E, K_UP_E ]) ;

    set_up_screen(menu,TRUE) ;

END ;


(* The following Procedures all deal with the MENU aspect of *)
(* this program                                              *)

PROCEDURE move_bar_up(
	    VAR menu : menu_record ) ;

BEGIN
    WITH menu DO
	IF ((current_menu - 1) < 0) THEN
	    current_menu := (number_elements - 1)
 	ELSE
	    current_menu := (current_menu - 1) ;

END ;


PROCEDURE move_bar_down(
	    VAR menu : menu_record ) ;

BEGIN
    WITH menu DO
	IF ((current_menu + 1) >= (number_elements)) THEN
	    current_menu := 0
	ELSE
	    current_menu := (current_menu + 1) ;

END ;


(* Display the menu option *)

PROCEDURE highlight(
	    menu   : menu_record ;
	    switch : BOOLEAN ) ;

BEGIN
    (* Here is an explanation of the parameters of WRITEAT *)
    (* x_pos	: x position of the string		   *)
    (* y_pos	: y position of the string		   *)
    (* str	: string to print			   *)
    (* revs	: boolean switch for reversing teh string  *)

    WITH menu DO
	    writeat(top_column, (top_row+current_menu),
			    option_string[current_menu], switch)
END ;


 
(* The following procedures deal with ALL aspects of this program *)

(* initialize all variables used *)

PROCEDURE initialize_all ;

VAR
    k : INTEGER ;	(* local loop index variable *)

BEGIN	(* initialize_all *)

    WITH menu DO
	BEGIN
	    option_string[0] := ' Set up options ' ;
	    option_string[1] := ' Shift Left     ' ;
	    option_string[2] := ' Shift Right    ' ;
	    option_string[3] := ' Refresh Screen ' ;
	    option_string[4] := ' Help           ' ;
	    option_string[5] := ' (Q)uit         ' ;

	    current_menu     := 0 ;

	    top_row	     := 14 ;

		(* center the menu's x position *)

	    top_column	     := (40 - TRUNC(LENGTH(option_string[1])/2)) ;

	END ;

	get_rnd_bits(register) ;

END ;	(* initialize_all *)


PROCEDURE do_help ;

BEGIN
    gotoxy(1,22) ;
    WRITE ('Use the ') ;

    reverse(ON) ;
    WRITE ('up') ;
    reverse(OFF) ;

    WRITE (' and ') ;

    reverse(ON) ;
    WRITE ('down') ;
    reverse(OFF) ;

    WRITE (' arrow keys to move bar.  Hit the ') ;

    reverse(ON) ;
    WRITE ('space bar' ) ;
    reverse(OFF) ;

    WRITE (' or ') ;

    reverse(ON) ;
    WRITELN ('return') ;
    reverse(OFF) ;

    WRITELN ('to select option.') ;
END ;



BEGIN	(* mainline *)

    initialize_all ;

    set_up_screen(menu) ;

    REPEAT

	c := getch ;
	
	highlight(menu,FALSE) ;

	gotoxy(1,22) ;
	clreos ;

	CASE c OF
	    K_DOWN   :	move_bar_down(menu) ;
	    K_UP     :	move_bar_up(menu) ;

	    K_UP_Q,
	    K_LOW_Q  :	BEGIN
			    quit := TRUE ;
			    highlight(menu,FALSE) ;
			    menu.current_menu := 5 ;
			    highlight(menu,TRUE) ;
			END ;
	    K_RETURN,
	    K_SPACE  :	CASE menu.current_menu OF

			    0 : set_up_options(options) ;
			    1 : shift_left(register) ;
			    2 : shift_right(register) ;
			    3 : set_up_screen(menu,TRUE) ;
			    4 : do_help ;
			    5 : quit := true ;
			    
			    OTHERWISE
				BEGIN
				    WRITELN('UGH!! ',menu.current_menu:0,' !') ;
				    normalize_screen ;
				    HALT ;
				END ; (* otherwise *)
			END ; (* case *)

	    OTHERWISE
		beep ;

	END ; (* case *)

	highlight(menu,TRUE) ;

    UNTIL (quit) ;

    writeat(1,22,'One second please . . . normalizing the screen.') ;
    normalize_screen ;
    writeat(1,23,'Goodbye.') ;
END .	(* mainline *)




