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

(* NOTE: This program is based heavily on the Infix Notation Parsing program *)
(*       distributed by Jesse Heines in December of 1990.                    *)

(* Revision History               *)
(* ------------------------------ *)
(* 22-NOV-1991  PMB	Original coding of Stacks.pen                        *)
(* 23-NOV-1991  PMB	Addition of DISPLAY_HEADER                           *)
(* 03-DEC-1991  PMB     Coding of Value_stacks.pen and Operator_stacks.pen   *)
(* 08-DEC=1991  PMB     Final Version.                                       *)

[INHERIT   ('value_stack' ,		(* Stack modules for values     *)
	    'operator_stack' ,		(* stack modules for operators  *)
	    'mod$dir:nodecont' ,	(* used by LinEditM and linked1 *)
	    'mod$dir:linked1' ,		(* linked list modules for next *)
	    'mod$dir:linEditM' ,	(* linked list line editor JMH  *)
	    'mod$dir:pas_utils' ,	(* pascal utilities by PMB      *)
	    'comp$dir:utilities' ,	(* pascal utilites by JMH       *)
	    'comp$dir:vt100' ) ]	(* Graphics routines etc by JMH *)


PROGRAM infix (INPUT, OUTPUT) ;

VAR
    result  : REAL ;		    (* The result of the user's entry *)
    entry   : string := '' ;	    (* The string entered by the user *)
    x_pos   : INTEGER := 10 ;	    (* The x position of the prompt   *)
    y_pos   : INTEGER := 17 ;	    (* the y position of the prompt   *)
    position: INTEGER := 1 ;	    (* the current index pos in entry *)
    error   : BOOLEAN := FALSE ;    (* flag for early termination     *)
    error_string : string ;	    (* exact type of error            *)

    opstack : opstacktype ;	    (* stack of operands *)
    valstack: valstacktype ;	    (* stack of values   *)


(* This procedure will show an error 'S' in the appropriate place *)

PROCEDURE show_error (s : string) ;
BEGIN
    beep ;
    bold(ON) ;
    writeat (x_pos+position-1,y_pos,'^') ;
    bold(OFF) ;
    writeat (1,y_pos+1,s) ;
END ;



(* This procedure will parse a number out of the entry string *)

PROCEDURE process_number
	(   entry	: string ;
	VAR position	: INTEGER ;   
	VAR number	: REAL ) ; 

VAR
    ch : CHAR ;  
    left_side : BOOLEAN := FALSE ;	(* on left or right side of dec. pt. *)
    fraction : REAL ;			(* stuffe behind decimal point *)

BEGIN
    ch 	     := entry[position] ;

    number   := (ORD(ch) - ORD('0')) ;
    position := position + 1 ;

    IF (position <= entry.length) THEN
	ch := entry[position] ;

{    error := FALSE ; }

    WHILE (position <= entry.length) AND (ch IN ['0'..'9','.']) DO
	BEGIN

		(* for parsing decimals *)

	    IF ch = '.' THEN
		left_side := TRUE
	    ELSE
		BEGIN
		    IF left_side THEN 	(* for decimals *)
			number   := ((ORD(ch) - ORD('0')) + (number * 10.0))
		    ELSE 
			fraction := ((ORD(ch) - ORD('0')) + (fraction / 10)) ; 
		END ;

	    position := position + 1 ;

	    IF (position <= entry.length) THEN
		ch := entry[position] ;
      END ;

      position := position - 1 ;

    number := number + fraction ;

END ;   


(* This procedure takes 2 values and an operand and performs a function *)

PROCEDURE compute_value
	(top_op  : CHAR ;
     VAR error   : BOOLEAN ) ;

VAR
    value1    : REAL ;	(* first value on stack        *)
    value2    : REAL ;	(* second value on stack       *)
    result    : REAL ;  (* the result of the operation *)
 
BEGIN

    error := NOT(valpop (valstack,value1)) ;  

    IF NOT error THEN
	BEGIN
	    error := NOT(valpop (valstack, value2)) ;
	    IF (NOT(error)) THEN 
		BEGIN
		    CASE top_op OF                    (* compute result *)
			'D','d' :   IF value1 <> 0 THEN
					result := TRUNC(value2) DIV TRUNC(value1) 
				    ELSE
					BEGIN
					    error := TRUE ;
					    error_string := 'divide by zero'
					END ;
			'M','m' : result := TRUNC(value2) MOD TRUNC(value1) ;
			'+'	    : result := value2 + value1 ;
			'-'	    : result := value2 - value1 ;
			'*'	    : result := value2 * value1 ;
			'/'	    : IF value1 <> 0 THEN
					result := value2 / value1
				      ELSE
					BEGIN
					    error := TRUE ;
					    error_string := 'divide by zero' ;
					END ;
			'^'	    : result := value2 ** value1 ;
		    END ;

		    valpush (valstack, result) ;

		END 
	    ELSE
		error_string := 'too many operands'
	END
    ELSE
	error_string := 'too many operands' ;
END ;   


(* This procedure parses out parenthesis from the entry *)

PROCEDURE handle_parens
	   (pareninitiated  : BOOLEAN ; 
	VAR error	    : BOOLEAN ) ;

VAR
   top_op	: CHAR ;	(* Top operator om the op stack      *)
   underflow    : BOOLEAN ;	(* error condition of stack is empty *)

BEGIN

    REPEAT
	underflow := NOT(oppop (opstack, top_op)) ;

	IF underflow THEN
	    error := pareninitiated
	ELSE IF top_op <> '(' THEN
	    compute_value (top_op, error) ;
    UNTIL ((underflow) OR (error) OR (top_op='(')) ;

    IF error THEN
	error_string := 'missing parenthesis' ;

END ;   


(* THis function returns TRUE if the priority of OP2 is greater *)
(* than the priority of operatot 1                              *)

FUNCTION greater_priority
	(op1  : CHAR ; 
	 op2  : CHAR ) : BOOLEAN ;      

BEGIN
   CASE op1 OF
	'^'	: greater_priority := (op2 IN ['*','/','D','M','+','-','(']) ;

	'*','/',
	'D','M',
	'd','m'	: greater_priority := (op2 IN ['+','-','(']) ;

	'-','+'	: greater_priority := (op2 IN ['(']) ;

	'('	: greater_priority := FALSE ;
   END ;
END ;


(* This procedure isa the core of the program *)
(* It parses out items from a atring and performs functions *)

PROCEDURE parse_entry	
	(entry      : string ;	    (* the source string         *)
     VAR position   : INTEGER ;	    (* current index             *)
     VAR result	    : REAL ;	    (* final answer              *)
     VAR error	    : BOOLEAN ) ;   (* true if anything is wrong *) 

VAR
    ch          : CHAR ;	(* entry[position] *)
    top_op      : CHAR ;	(* top operator on the stack *)
    top_val     : CHAR ;	(* top value on the stack    *)
    underflow   : BOOLEAN ;	(* true if stack underflows  *)
    value       : REAL ;	(* value to push on stack    *)

BEGIN
    error    := FALSE ;
    position := 1 ;

    WHILE (position <= entry.length) AND (NOT error) DO
	BEGIN
	    ch := entry[position] ; 

	    IF (ch IN ['0'..'9']) THEN
		BEGIN
		    process_number (entry, position, value) ;
		    valpush (valstack, value) ;
		END
	    ELSE IF ch = '(' THEN
		oppush (opstack, ch) 
	    ELSE IF (ch IN ['^','*','/','+','-','D','d','M','m'])THEN
		BEGIN

		    underflow := NOT(oppop (opstack, top_op)) ;

		    IF underflow THEN
			oppush (opstack, ch) 
		    ELSE IF greater_priority (ch, top_op) THEN
			BEGIN
			    oppush (opstack, top_op) ;
			    oppush (opstack, ch) ;
			END
		    ELSE
			BEGIN
			    compute_value (top_op, error) ;
			    oppush (opstack, ch) ;
			END ;
		END
	    ELSE IF ch = ')' THEN
		handle_parens (TRUE, error)
	    ELSE
		BEGIN
		    error := (ch <> ' ') ;

		    IF error THEN
			error_string := 'illegal operand "'+ch+'"' ;
		END ;

	 position := position + 1 ;

	END ;

    IF (NOT(error)) THEN
	handle_parens (FALSE, error) ;

    IF (NOT(error)) THEN
	error := NOT(valpop (valstack, result)) ;

    IF(error)THEN
	position := position - 1 ;

END ;   


(* Display program information and short help text *)

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
    writeat(10,13,' ') ;
    writeat(8,14,'Valid Operands : +, -, /, *, ^, (, ) "D" for Dividend, "M" for Modulus') ;

END ;


BEGIN	(* mainline *)

    create_opstack (opstack) ;
    create_valstack (valstack) ;

    display_header ;

    REPEAT
	gotoxy (1,y_pos - 1) ;

	WRITELN('Expression > ') ;

	x_pos := length('expression > ') + 1 ;

	getentry (entry, x_pos ,y_pos - 1, 255) ;

	IF (entry <> 'quit') THEN
	    BEGIN
		position := 1 ;
		error := FALSE ;
		error_string := '' ;

		parse_entry(entry,position,result,error) ;

		IF (error) THEN
		    BEGIN
			show_error ('Entry contains an error at position : '+itoa(position)) ;

			IF error_string <> '' THEN
			    WRITELN (' --> ',error_string,'.') ;

		    END
		ELSE
		    BEGIN
			gotoxy (1,y_pos + 1) ;
			WRITELN ('Expression evaluates to : ',result:0:4) ;
		    END ;

		writeat(1,22,' Press <RETURN> to continue. ',TRUE) ;
		READLN ;

	    END ;

	gotoxy (x_pos,y_pos - 1) ;

	clreos ;

    UNTIL (strlwr(entry) = 'quit') ;

    clrscr ;

    WRITELN('Bye...') ;

END .	(* mainline *)
