(* Program INFIX.PAS              *)
(* Assignment Numbers 10 and 11   *)
(* Peter M Brown, (The Psychlist) *)
(* UMass-Lowell Nov/Dec 1991      *)
(* -------------------------------*)

(* Program Synopsis Assignment 10 *)
(* ------------------------------ *)
(* Using the linked-list implementation of a stack, parse the parenthesis    *)
(* out of a string entered by the user, and check to see if each opening     *)
(* parenthesis has a closing parenthesis,  example:                          *)
(* ((())) () ()   would not produce an error, while  )( would.               *)


(* Program Synopsis Assignment 11 *)
(* ------------------------------ *)
(* Same as above, but with the addition of operands and numbers.  Parse a    *)
(* string entered by the user and evaluate the expression therein, example : *)
(* (((4*3)-(6/2)*4)/10)  <= would be a valid expression.                     *)


(* Revision History               *)
(* ------------------------------ *)
(* 22-NOV-1991  PMB	Original coding of Stacks.pen                        *)
(* 23-NOV-1991  PMB	Addition of DISPLAY_HEADER                           *)


[INHERIT   ('stacks' ,
	    'mod$dir:nodecont' ,
	    'mod$dir:linked1' , 
	    'mod$dir:linEditM' ,
	    'mod$dir:pas_utils' ,
	    'comp$dir:utilities' ,
	    'comp$dir:vt100' ) ]


PROGRAM infix (INPUT, OUTPUT) ;

VAR
    entry : string ;
    x_pos : INTEGER := 10 ;
    y_pos : INTEGER := 18 ;


PROCEDURE test_parens(
	entry : string ) ;

VAR
    position : INTEGER ;
    data     : CHAR ;		    (* The popped data *)
    continue : BOOLEAN := TRUE ;

BEGIN

    position := 0 ;

    WHILE (position < entry.length) AND (continue) DO
	BEGIN
	    position := position + 1 ;

	    IF entry[position] = '(' THEN
		push ( S, '(' ) 
	    ELSE IF entry[position] = ')' THEN
		IF NOT ( pop (S, data ) ) THEN
		    BEGIN
			continue := FALSE ;
			writeat(x_pos + position-1,y_pos+1,'^') ;
			writeat(1,y_pos + 3,'Too many closing parenthesis.') ;
		    END 
	    ELSE IF entry[position] = ']' THEN
		BEGIN
		    REPEAT
			IF pop (s,data) THEN
			    IF (data = '(') THEN
				continue := TRUE ;
		    UNTIL (data <> '(') OR (stack_empty (S)) ;

		    IF NOT(continue) THEN
			writeat(1,y_pos+3,'Invalid use of "]".  No open parenthesis to close.') ;
		END ;
	END ;

    IF (NOT(stack_empty(s)) AND (continue)) THEN
	BEGIN
	    writeat(x_pos + position, y_pos + 1,'^') ;
	    writeat(1,y_pos + 3,'Closing parenthesis expected.') ;
	END
    ELSE IF (stack_empty(S) AND (continue)) THEN
	writeat(1,y_pos + 3, 'Parenthesis match ok.') ;

    clear_stack (S) ;

END ;


PROCEDURE display_header ;
BEGIN
    clrscr ;

    box(34,1,46,3) ;
    graphicsOn ;
    writeat(34,2,'t') ;
    writeat(46,2,'u') ;
    graphicsOff ;

    bold(on) ;
    writeat(35,2,' I n f i x ') ;
    bold(off) ;

    WRITELN ;

    writeat(10,05,'Editing functions : ') ;
    writeat(10,07,'Backspace, Delete  - delete character to left of cursor') ;
    writeat(10,08,'Return, Escape     - signal that you are ready to have') ;
    writeat(10,09,'                     the line processed. ') ;
    writeat(10,10,'Arrow keys <- ->   - Move the cursor through the line.') ;
    writeat(10,11,'Control/B  ^B      - Move to the beginning of the line.') ;
    writeat(10,12,'Control/E  ^E      - Move to the end of the line.') ;
    WRITELN ;
END ;


BEGIN	(* mainline *)

    create_stack (S) ;

    display_header ;

    REPEAT
	gotoxy (1,y_pos) ;

	WRITELN('Expression > ') ;

	x_pos := length('expression > ') + 1 ;

	getentry (entry, x_pos ,y_pos, 255) ;

	IF (entry <> 'quit') THEN
	    BEGIN
		test_parens (entry) ;
		writeat(1,22,'Press return to continue.',TRUE) ;
		READLN ;
	    END ;

	gotoxy (x_pos,y_pos - 1) ;

	clreos ;

    UNTIL (strlwr(entry) = 'quit') ;

    clrscr ;

    WRITELN('Bye...') ;

END .	(* mainline *)
