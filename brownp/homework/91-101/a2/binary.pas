
(* Program BINARY.PAS *)
(* ------------------ *)

(* Program purpose : To convert from a decimal number to a binary number *)
(*                   and from a binary number to a decimal number        *)

(* Revision History   *)
(* ------------------ *)

(* 10-SEP-1991	    PMB	    Original Coding				 *)
(* 16-SEP-1991	    PMB	    Addition of help, and information menus	 *)
(*                                                                       *)
(* ----------------------------------------------------------------------*)

(* THe following statement imports non standard Pascal statements for    *)
(* use with this program. CONVERT, UTILITIES and VT100 written by        *)
(* Professor Jesse M. Heines ULowell 1991                                *)

[INHERIT ('group$disk:[compsci]convert',
	  'group$disk:[compsci]utilities',
	  'group$disk:[compsci]vt100') ]

PROGRAM binary (INPUT,OUTPUT) ;

CONST
    
	(* These are mnemonics for keypresses *)

    KEY_UP	= 274 ;
    KEY_DOWN	= 275 ;

    KEY_Q = 113 ;	    
    KEY_B = 98 ;
    KEY_D = 100 ;
    KEY_H = 104 ;
    KEY_QUESTION = 63 ;
    KEY_I	 = 105 ;
    KEY_RETURN	 = 13 ;

    CONTROL_R = 18 ;
    CONTROL_W = 23 ;

    number_menus = 5 ;	(* number of elements in the menu *)


TYPE

    menu_rec =	RECORD
		    menu_string : ARRAY [1..number_menus] OF string ;
		    top_line	: INTEGER ; (* top line of the menu *)
		    bot_line	: INTEGER ; (* bottom line of menu  *)
		END ; (* menu_rec *)


VAR

    x		    : INTEGER ;	    (* global loop index variable	*)
    c		    : key_code ;    (* the result of GET1CHAR		*)
    menu	    : menu_rec ;    (* The actual menu			*)
    result	    : INTEGER ;	    (* Computed number			*)
    bin_string	    : string ;      (* binary number			*)
    dec_integer	    : INTEGER ;	    (* decimal number			*)
    input_string    : string ;	    (* string to be ATOI'd		*)
    current_menu    : INTEGER ;	    (* the currently highlighted menu	*) 
    old_menu	    : INTEGER ;	    (* the previously higfhlighted menu *)
    reverseBOOL	    : BOOLEAN ;	    (* control bit for screen toggling  *)


(* The following procedure sets up the record holding the menu options *)
(* and the position of the menu on the screen                          *)

PROCEDURE set_up_records ;

BEGIN

    reverseBOOL	    := FALSE ;

    current_menu    := 1 ;
    old_menu	    := number_menus ;
    
    
    WITH menu DO
	BEGIN

	    top_line := 10 ;
	    bot_line := top_line + number_menus ;
	    
	    menu_string[1] := ' b   Convert from binary to decimal ' ;
	    menu_string[2] := ' d   Convert from decimal to binary ' ;
	    menu_string[3] := ' i   Information about this program ' ;
	    menu_string[4] := ' h,? Help ' ;
	    menu_string[5] := ' q   Quit ' ;

	END ; (* with menu do *)

END ;	(* set up records *)


PROCEDURE highlight ;

BEGIN

    gotoxyimmediate ( 1, menu.top_line + current_menu ) ;
    reverse(On) ;
    WRITELN(menu.menu_string[current_menu]) ;
    reverse(Off) ;

END ;	(* highlight	*)


PROCEDURE unhighlight ;

BEGIN

    gotoxyimmediate ( 1, menu.top_line + old_menu ) ;
    reverse(Off) ;
    WRITELN(menu.menu_string[old_menu]) ;

END ;	(* unhighlight	*)

(* this procedure takes care of the housekeeping needed to run bindec *)

PROCEDURE pre_bindec ;

BEGIN
    gotoxyimmediate (1,17) ;
    clreos ;
				
    WRITE ('Binary number to convert > ') ;
    READLN(bin_string) ;
				
    bindec(bin_string,dec_integer) ;
				
    WRITELN('The result is > ',dec_integer:0) ;

END ;


(* this procedure takes care of the housekeeping needed to run decbin *)

PROCEDURE pre_decbin ;

BEGIN
    gotoxyimmediate (1,17) ;
    clreos ;				
    WRITE ('Decimal number to convert > ') ;
    READLN(input_string) ;

    dec_integer := atoi(input_string) ;
				
    decbin(dec_integer,bin_string) ;
				
    WRITELN('The result is > ',bin_string) ;
END ;


PROCEDURE header ;

BEGIN

    WRITELN ;
    WRITELN(' B i n a r y   to   D e c i m a l ') ;
    WRITELN(' D e c i m a l   to   B i n a r y ') ;
    WRITELN ;
    WRITELN(' Conversion program VAX/VMS Version') ;

END ;	(* header	*)


(* "refresh_screen" Called by the Control-W                            *)

PROCEDURE refresh_screen ;

VAR
    x : INTEGER := 1 ; (* Local loop index variable *)

BEGIN

    clrscr ;

    header ;
    
    gotoxy(1,menu.top_line + 2) ;

    FOR x := 1 TO number_menus DO
	WRITELN(menu.menu_string[x] ) ;

    highlight ;

END ;


(* "toggle_screen" is called by CONTROL_R                          *)

PROCEDURE toggle_screen ;

BEGIN
    IF reverseBOOL THEN
	BEGIN
	    reverseBOOL := FALSE ;
	    reversescreen(OFF) ;
	END
    ELSE
	BEGIN
	    reverseBOOL := TRUE ;
	    reversescreen(ON) ;
	END ;

    refresh_screen ;

END ;


PROCEDURE show_information ;

BEGIN
    gotoxy(1,17) ;
    clreos ;
    
    WRITELN('                                                                 ') ;
    WRITELN('Written by Peter M Brown, University of Massachusetts at Lowell ') ;
    WRITELN('September 1991.' ) ;

END ;


(* The following procedure is called by the HELP menu option *)

PROCEDURE do_help ;

BEGIN

    gotoxy(1,17) ;
    clreos ;

    WRITELN ('                                                               ') ;
    WRITELN(' Use the up and down arrow keys, and hit return to select a ') ;
    WRITELN(' menu option, or press the letter preceding the menu option to ') ;
    WRITELN(' select that menu.') ; 
    WRITELN ;
    WRITELN('<ctrl> W               -  Refresh the screen. ') ;
    WRITELN('<ctrl> R               -  Toggle the Screen reverse/normal. ') ;

END ;	(* do_help	*)


		    (* Mainline Code *)

BEGIN

    cursor(Off) ;

    set_up_records ;

    refresh_screen ;
    
    REPEAT

	old_menu := current_menu ;

	c := getch ;		(* get a single character from the user *)
	

	CASE c Of

	    KEY_UP	:  BEGIN
				    (* scroll up wraparound *)

				IF current_menu - 1 < 1 THEN
				    current_menu := number_menus 
				ELSE
				    current_menu := current_menu - 1 ;

				unhighlight ;
				highlight ;

			    END ;


	    KEY_DOWN	:   BEGIN
				    (* scroll down wraparound *)

				IF current_menu + 1 > number_menus THEN
				    current_menu := 1
				ELSE
				    current_menu := current_menu + 1 ;

				unhighlight ;
				highlight ;

			    END ;


	    KEY_B	:   BEGIN
				current_menu := 1 ;
				unhighlight ;
				highlight ;

				cursor(On) ;
				pre_bindec ;
				cursor(Off) ;

			    END ;


	    KEY_D	:   BEGIN
				current_menu := 2 ;
				unhighlight ;
				highlight ;

				cursor(On) ;
				pre_decbin ;
				cursor(Off) ;

			    END ;


	    KEY_H,KEY_QUESTION
			:   BEGIN
				current_menu := 4 ;
				unhighlight ;
				highlight ;
				do_help ;
			    END ;


	    KEY_I	:   BEGIN
				current_menu := 3 ;
				unhighlight ;
				highlight ;
				show_information ;
			    END ;


	    KEY_Q	:   BEGIN
				current_menu := 5 ;
				highlight ;
				unhighlight ;
			    END ;

	    KEY_RETURN	:   BEGIN
				cursor(On) ;

				CASE current_menu OF
				    1 : pre_bindec ;
				    2 : pre_decbin ;
				    3 : show_information ;
				    4 : do_help ;
				    5 : c := ORD('q') ;
				END ; (* case *)

				cursor(Off) ;
			    END ;

	    CONTROL_R : toggle_screen ;

            CONTROL_W : refresh_screen ;


	    OTHERWISE beep ;

	END ; (* case *)

    UNTIL ((c = ORD('q')) OR (c = ORD('Q'))) ;

    attributesOff ;
    gotoxy(1,24) ;
    cursor(On) ;
    reversescreen(OFF) ;
    
END.		    (* Mainline Code *)

